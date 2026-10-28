Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215381;
	b=3WnkfgIxNDKsEummndsAchUFIbqCAZ6Hfqwfs6ZBcrNYvpY5qTalcpfSJpXimiWqeMee
	 neZfidpG0BQWjcUdGePbrODzxPoBSsYw7C4bxe0a8n9QObavpHPe1Ai+WbnBha2SR2DTG
	 2xOU/Gqf0sfJdqva2bJUXPDiri29q8sJMRxucQytdNb8eYpo3zEOjEgW3s7+k7Vt+/1Re
	 E0UV1RphPRxl76TCEXg2k+b0WUJ9880RuNeVZJRy5XhL5XUPhWuRn0QSrYSVdLjDv1pCx
	 Ghpqd8dyeNIvrNBQQyX+Thjw2nJ5HJKFiBd9hVlouo3VE3d9hQ+Kf8Hbdq2fGduHxVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ukASllKf1TcKG8mxvAky2npVvLCWIjfFu8E7VMNxtXM=;
	b=xhBEVTBMixN2UQC1Jjvi4YBvolNmSSI0y5CJneJOoEedFY4OaGw8EZmxFKbMoi+pL/yV
	 /7DjqP/rCBvWwVz19EhSfpkALau9CuDtr3BVMEwULNFxDVyHCld1zwQ1fu1Qy6TgI/OcX
	 Y+41j+8uT6pGjUp0dJECwbPbNW/grdQBWep5EHBLsGsYKAo5Ayjboq79MtITkH+HQaHVQ
	 oXHx3CG/S5QThMWnq/Bj4B35VYVDaB/Op7EVLmfRf3XPBvl0jeMD3+7u0zzHIerVimF5+
	 DZh8YAXdkTVtO+S7js0a+LF+y8sYmSMbm6by99EDz/apZYPUYiOSNRj+kcQpaxpbkqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLZEzE8U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC68606A31A;
	Wed, 28 Oct 2026 19:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLZEzE8U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6261F01825;
	Wed, 28 Oct 2026 19:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215381;
	bh=ukASllKf1TcKG8mxvAky2npVvLCWIjfFu8E7VMNxtXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLZEzE8UpWRbX6lAonQjMscjLRwdDMv0L411NAqzeOf01s/C7x1+WaI3GB66jpujc
	 NJqCq7M9aKTFZLiS8bLqPpn2gv5qZw/IoibFKI14XzuOZKMXLAUQrDZKJTT4XG7UxZ
	 RdEiFzd+zFEuXcR2i/6qL0IV7POXEB+SL3RYCLzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Wozniak <petr.wozniak@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1192/1887] xfrm: fix stale skb->prev after async crypto steals a GSO segment
Date: Wed, 28 Oct 2026 17:54:48 +0100
Message-ID: <20261028170526.533030100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Wozniak <petr.wozniak@gmail.com>

[ Upstream commit 3f4c3919baf0944ad96580467c302bc6c7758b00 ]

skb_gso_segment() leaves the segment list head with ->prev pointing at
the last segment, an invariant validate_xmit_skb_list() relies on when
it sets its tail pointer (tail = skb->prev).

When validate_xmit_xfrm() walks a GSO list and some segments are stolen
by async crypto (->xmit() returns -EINPROGRESS), those segments are
unlinked from the list but the head ->prev is never updated.  If the
last segment is the one stolen, the returned head still has ->prev
pointing at it, even though it is now owned by the crypto engine and may
be freed.  validate_xmit_skb_list() later does tail->next = skb, writing
through that stale pointer -- a use-after-free.

Repoint skb->prev at the last retained segment before returning.

Fixes: f53c723902d1 ("net: Add asynchronous callbacks for xfrm on layer 2.")
Signed-off-by: Petr Wozniak <petr.wozniak@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_device.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index c676ff2f21acc..b16c4657fe0fe 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -215,6 +215,14 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		pskb = skb2;
 	}
 
+	/* skb_gso_segment() set skb->prev to the last segment, but async
+	 * crypto may have stolen it above without updating ->prev.  Repoint
+	 * it at the last retained segment so validate_xmit_skb_list() does
+	 * not chain onto a segment now owned by the crypto engine.
+	 */
+	if (skb)
+		skb->prev = pskb;
+
 	return skb;
 }
 EXPORT_SYMBOL_GPL(validate_xmit_xfrm);
-- 
2.53.0



