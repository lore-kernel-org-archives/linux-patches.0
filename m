Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC5F43CEF9;
	Thu, 30 Jul 2026 15:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425753; cv=none; b=l3pxLQvVQXBw3M+gNkOiFVsr5+UqWzzjDa92jAvxGChfeFe+qCAqWKS96ufACKffrfGLN2dpOf0afpIV6iacZ3EDQRTYWqAGtjEYZ8damEs8/4xqGOEgA7L4I70L3rzJxbrbitOKrqRY1fMZi9j8by8eYOs/4r2VxcFVgeDvDoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425753; c=relaxed/simple;
	bh=yCXKTTBo2GkZdwegzKx8QkEDEfqu/CIvLWD5+xil+No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpTGwQpyw+n1OGgTV6nlMF6kvLvr7yewf7xxb+xs5PYiOKg1CRjIoeSguc4lYcp7jGMxUxHFeGEhP/Alz7RkEBVlVIXrnKXgVI1dSVDKNTpZcGWsTRHeF6qxV85gwY+QF+A7Lyg+fCYznTKripdMjojHxtUTuOycvb9eXvh5QIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0l7uW290; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0l7uW290"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC111F000E9;
	Thu, 30 Jul 2026 15:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425752;
	bh=8dltPBakn6744HSsAYGlmr3wE05ZvjJNy2ApSfFc1kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0l7uW290ZWnYx77euf26Dzp008qc1L0w+voytkWBcGBNpBGM4vr9S8XPkliBK3ihV
	 RJjE4jIi5Kvi4lhW1hGlIjKr0EhA+/KwZeM8ST1MSrZBDSBPwfuOdApXZrcJt8T29d
	 n8Qdj4Kznfr4y7cqQofxlMblW10eMjCNFc5+Y/jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/602] dpaa2-switch: put MAC endpoint device on disconnect
Date: Thu, 30 Jul 2026 16:09:29 +0200
Message-ID: <20260730141439.686340136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4520c2788b1c56..8469ca27086994 100644
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



