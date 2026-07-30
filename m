Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260E63A6B7F;
	Thu, 30 Jul 2026 14:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421842; cv=none; b=k53REPrlVNFJzTKngVHmpL/Ta6xUcxTAbSSqWmZ/dvm+UQZM0uYhh2i43Yw79gEgoZRrv6rijKuTjhw+9ICSrhkmTN/BQyN/4cdW5K7eFdZG8G28suaFXgW0flYqJ+J+iaMGDO7xZN8FcmkvaGKiAzK/JNc9/xSaTZDimoTATiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421842; c=relaxed/simple;
	bh=SOspdgQXF55r3gzQNMCr5WuiIoW2HptsnnDIBxid0e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAP8G0BvLyqL0BCBJWN75jE0yeA/Nkdniwzd4PmbYHGuM+2bS8g5J1T6QvDI0VDE8tS0BNyhK+JqzcXX/9Pye81sfI9otnnFb+Oa0vhtGL3vZvZshv6mms7OddJ/tzrnB7m4+BYuXg2IG5Va2bU61erLOU6hvSVjs0YOO9RAYDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cd17BaXj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cd17BaXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0081F000E9;
	Thu, 30 Jul 2026 14:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421840;
	bh=Lb/pRPyCbOU/78RstnhVUi+qFnQGmXSNnaZzAtWLQeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cd17BaXj1bA+3FMYGO8ARV4R3Mnvnu32mmOOYTXUVIR+T6kquJyjeXqYgqC+Cngs8
	 RO+NilQRONqdW5hZf9KLEfoDRXbBSowle/qQP6QON82yp4/S+0hEC9Fd+KAypDNB+z
	 NPGpWXMMFamq0oMlthX9Yb6SJblrZAj5DbpxbFIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 239/744] dpaa2-switch: put MAC endpoint device on disconnect
Date: Thu, 30 Jul 2026 16:08:32 +0200
Message-ID: <20260730141449.373448411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index fa4e4f47978234..9f465033331d31 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1511,6 +1511,7 @@ static void dpaa2_switch_port_disconnect_mac(struct ethsw_port_priv *port_priv)
 		dpaa2_mac_disconnect(mac);
 
 	dpaa2_mac_close(mac);
+	put_device(&mac->mc_dev->dev);
 	kfree(mac);
 }
 
-- 
2.53.0



