Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829DB38B14D;
	Thu, 30 Jul 2026 16:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427375; cv=none; b=NyDRObnKpEaWEgnMpcTBzSG3j6tdLhATdn3jhNkmWZn6oUaiZnK8KrGWpdUEn2ptZD0UrF2tz9d2Q+muhUufbKiMuYpIHcat5yzXAc+UlTy6rgcAP/ORCl1FuVxpoydZ96ZEvBd9TkjmiMTdoowf8zBFnVer8VMlF21G2BnalSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427375; c=relaxed/simple;
	bh=Cah8MvW74+oJFZk5hyJ2b8f/GflfR08/5DUwsoxqsII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwJ3CdK4tCSY6ntti+bKa/wOGaF/2ypDyLOjOcb5PiNkgVb2HoAMNCAnPGGrtEO7McWpTj7qidZlXPLb78YxYKBAF35Ey13P5h6tdgZZTniFQGDJbY7lL84AAnfJFbNSBQTVsQuqqIC290EyS3ybWPnKuVaVjASHD3HDSHGqhu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2Z93O2F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2Z93O2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8781F000E9;
	Thu, 30 Jul 2026 16:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427374;
	bh=w3AKlzRw1kw6OWTmRIWu/jioRvNaCyj8A84ghKCGV/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2Z93O2F4kCKrIqygmDDiYgMf0bxCxcCZ0873ClVchd6uRZURq8uINPQxwAaU/+ti
	 SNh3Au75/hreWu12DxL1NUGOdDP2YJ8JcpZOvBagZjWoOcG7GxO1fnJLMOQjppQg+D
	 BwGslY/MxOKf8V5nGO2nZ+e5Mc6ZZmSkE7fF74W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/484] dpaa2-switch: put MAC endpoint device on disconnect
Date: Thu, 30 Jul 2026 16:10:46 +0200
Message-ID: <20260730141426.700585145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 4c1eabbef7a1707635652e956e39db1269c3af2b ]

fsl_mc_get_endpoint() returns the MAC endpoint device with a reference
taken through device_find_child(). The switch port connect path stores
that device in mac->mc_dev and keeps it for the lifetime of the connected
MAC object.

However, the disconnect path only closes the MAC and frees the dpaa2_mac
object. It does not drop the endpoint device reference stored in
mac->mc_dev, so every successful connect leaks that device reference when
the MAC is later disconnected.

Drop the endpoint device reference before freeing the dpaa2_mac object.

Fixes: 84cba72956fd ("dpaa2-switch: integrate the MAC endpoint support")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260708111025.749311-1-lgs201920130244@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 0f8b46dccc0971..501e86e9fd487c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1510,6 +1510,7 @@ static void dpaa2_switch_port_disconnect_mac(struct ethsw_port_priv *port_priv)
 		dpaa2_mac_disconnect(mac);
 
 	dpaa2_mac_close(mac);
+	put_device(&mac->mc_dev->dev);
 	kfree(mac);
 }
 
-- 
2.53.0



