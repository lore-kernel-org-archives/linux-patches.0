Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4FC3D0D1;
	Tue, 14 May 2024 11:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687630; cv=none; b=pmK8YWiOQgGc5khxUmW+CXczkM3DY3h1VCihNSSyjM0zvkN6p7Dkt/JxuoaJ0vqd7C5oilu+Mng83G3Db0P2csXOHH/uXr/yamqO/+zB4BwGCWNHS2RVnfPjHN70exejgzbV6RwT8mHEaQ3FrlIlN8Rg15+AzyzyfWcbl+0BgGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687630; c=relaxed/simple;
	bh=ZMIh/OewVmsji4M2ZiKPjebkPKob2W/pMEnkbU6Wttw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJlekzpyKaM6z8Av/oeE2DHcegSB0HmiNg7JappOXjQoGLzGIBU21bUQdqLss66Xq090U9AXSZ6TzL7y1mIEwAO1MVNLxwAYjMRgHUKlfZMOeCKZRsvJhBlLbgPVmFtMWiYQuFKhKg4xBMM497uGapgcxWulmdPC39j+eHpqTZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9E51umB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9E51umB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02ACC2BD10;
	Tue, 14 May 2024 11:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687630;
	bh=ZMIh/OewVmsji4M2ZiKPjebkPKob2W/pMEnkbU6Wttw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9E51umB1ZlQXxuyRomDLQyUZm7oYjmAxMmQjOp6kzzah2TshL+SxwUMEFbTP+ZBC
	 1/7z9MeWcFTjDHLcsR9hQLH29e8x0XkgwH0EVEd8guW1Ver0XtN8U+KO1zQj+BiS8S
	 hIkQBwz/UDNp6U3pcUJWEkdia1KhpUcA4pJyrl1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Paolo Abeni <pabeni@redhat.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/168] net: bridge: fix multicast-to-unicast with fraglist GSO
Date: Tue, 14 May 2024 12:19:09 +0200
Message-ID: <20240514101008.617080147@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 59c878cbcdd80ed39315573b3511d0acfd3501b5 ]

Calling skb_copy on a SKB_GSO_FRAGLIST skb is not valid, since it returns
an invalid linearized skb. This code only needs to change the ethernet
header, so pskb_copy is the right function to call here.

Fixes: 6db6f0eae605 ("bridge: multicast to unicast")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_forward.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 011bd3c59da19..0bdd2892646db 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -261,7 +261,7 @@ static void maybe_deliver_addr(struct net_bridge_port *p, struct sk_buff *skb,
 	if (skb->dev == p->dev && ether_addr_equal(src, addr))
 		return;
 
-	skb = skb_copy(skb, GFP_ATOMIC);
+	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (!skb) {
 		DEV_STATS_INC(dev, tx_dropped);
 		return;
-- 
2.43.0



