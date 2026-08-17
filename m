Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E739939EF05;
	Mon, 17 Aug 2026 14:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976798; cv=none; b=gFOBw1yH2wy2awnmPgLwx7nveVgZTiCc0KIBfIz8ov1leUHB5xJKTZbZ9I92MewdmDEODW9l2xBORzcrSbyc8CHdYVFi8R9mwfOLZl5zJbeDjDEHxHx05v02QE46weE/0PU9PEs+GCvYIUhv/RODxP7xqy4Zp7HuORkMKC2ptVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976798; c=relaxed/simple;
	bh=RD3BUIf7zB9BhQ65Ilva4pKSkN6odrVxocVnaUq6pXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufyrIKJqaiw0dZZrj1iZzMPuT08IjdxDY85nWgus8xuaJkbUX8ZTZfM1MjBSJmcTmS5e3AS2irFxQ4Jn7Hf7uJ5vMTjMVsuyI2545vAk/8Ier10Sl4+b0aY0NeNR4pOe7rWcY114M2tuTCvNjQzbOVAoBoMr9yiDFOAIZ4q6g2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDpOgWVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDpOgWVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D33E1F000E9;
	Mon, 17 Aug 2026 14:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976796;
	bh=QrLmU+NzffqNywgEBMUnnT3x1auGtooBL9+/y/Wf/pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDpOgWVFipY5nZ/UdS0JyOPF/7oDdysz2BkVQOq43TJPvs4lJ3yFlDkSXEyBW4ozC
	 UcSLoX/igIvALrhzOZ9hmIu9nIR+E9u5rxDdbpiJY7ULtqtZ8tdv+0+wSO9+IOV8Oq
	 mg/7qpSfO0qavlJqhnlWBnNI5OGqNEWfqnuFg49c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/456] dpaa2-switch: put MAC endpoint device on disconnect
Date: Mon, 17 Aug 2026 15:28:10 +0200
Message-ID: <20260817132544.008501969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ea93144d24931b..4d596af27dc0f1 100644
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



