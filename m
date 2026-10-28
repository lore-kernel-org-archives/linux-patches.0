Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216637;
	b=EJ2lfKJG/xLY4DSX//BUEBWRQtnu80U0a2cscEUyRfv6L199GrjI6zjkGXjFLgKDH4Dv
	 dQbYQQNRvkc+AzQGtAbUwuyuxkTIXSEnxX2ABMxG+NKQa/C/eLNG4T2XY72SecdFuMwF5
	 o9K/gUU9qlJb8qqf83Xj20vTzflDGJfeSQVYYH0Wmx7uDO5e+G/nPWn5kuBSoz4R9K5G4
	 W/68X7NvAJSpzXAAuCj4WTT6Mv/wLwEvwVz0WrZsTnKv3cxQjHcXez0b5K0VmpUmXHXlU
	 CkVWeWYYuLqmN9jiLzUwMrLgU/X1CMc7m6O0KBBSPskdhqpFEKBQzqhjpx/dqSeu1Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iF9+nHPmvgHuKbAlCDqElPbFe58vx7wb1nyP8mOH/QM=;
	b=ZyXhpiVreg1ztRbksrksqoflZ8TyovvyswN1BCpOR31bDKvqzD3GosUywzFlDM064/nZ
	 hnhX3vAifJyPE2G+lRMn0+9zGNZ5UUmebFM/jYkJ5Io9hLFE8PZsUiPnmFbmV0PZ9G2Mx
	 dwQKI/I6hGsr5wQR1FZFlRfbjW1jgMxOsHxXeRU7DIcBmpSCJgZQ7fAReEg+dDQgXKg1a
	 Yo2gkbMie1EnGBN6EX6Q0zeS4O92ASwtZHIDV5vCzsqAM98xS8bhkTDzXxAN9d3AW2M6M
	 YzCepJfh8xDb79IywmZScGS9PIo/1EDrjVZR0hD8+dTaamOtPjKXZPOqxpXV2Noh7lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AM6NMkSn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F0A606A31A;
	Wed, 28 Oct 2026 19:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AM6NMkSn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A3D1F01825;
	Wed, 28 Oct 2026 19:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216637;
	bh=iF9+nHPmvgHuKbAlCDqElPbFe58vx7wb1nyP8mOH/QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AM6NMkSnE3GnmU/YnJV66NEy2a6l4+jt4bduQzlJ9R/iY8hIvsJylx4zWhcsv7Hxe
	 IVP7Pc34hoQ1ydi3dWsCEQ4iaNglffQ/svPSXARSYEqS7DLAedvlE745avpOtMri2w
	 eQh0LDFbnrXu1lYihVtquZIrtFub4/SLxPjI6RiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Azzouzi <maherazz04@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1626/1887] esp: do not unref managed frag pages in esp_ssg_unref()
Date: Wed, 28 Oct 2026 18:02:02 +0100
Message-ID: <20261028170536.468256898@linuxfoundation.org>
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

From: Maher Azzouzi <maherazz04@gmail.com>

[ Upstream commit 21697720ff43b8dfa25b8e8d9ca7f56f4597fc80 ]

esp_ssg_unref() releases the page references held on the source
scatterlist after the AEAD operation completes.  It calls
skb_page_unref() on every frag page for an out-of-place transform
(req->src != req->dst), and in the error path of esp_output_tail()
(already_unref == true) on the request's own scatterlist.

This is wrong when the skb carries managed frags
(SKBFL_MANAGED_FRAG_REFS).  Managed frags are owned by a zerocopy ubuf
and the skb does not hold a per-frag page reference; io_uring SEND_ZC
with a registered buffer attaches the bvec pages this way via
io_sg_from_iter().  The rest of the stack honours this invariant:
skb_release_data() skips the per-frag unref when SKBFL_MANAGED_FRAG_REFS
is set, and skb_zcopy_managed() is the guard used at the other unref
sites.

esp_ssg_unref() is missing that guard, so for a managed-frag skb it
drops a page reference the skb never acquired.  This can underflow the
page reference count and free a page that is still in use.

Guard the function with skb_zcopy_managed() so both unref paths are
skipped for managed-frag skbs, matching skb_release_data().

Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
Fixes: 03e2a30f6a27 ("esp6: Avoid skb_cow_data whenever possible")
Signed-off-by: Maher Azzouzi <maherazz04@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c | 7 +++++++
 net/ipv6/esp6.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 55b5c890b15a8..908775cdb8fc6 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -103,6 +103,13 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb)
 	struct aead_request *req;
 	struct scatterlist *sg;
 
+	/* Managed frags are owned by the zerocopy ubuf; the skb holds no
+	 * per-frag page reference, so we must not drop one here.  Mirrors
+	 * the SKBFL_MANAGED_FRAG_REFS handling in skb_release_data().
+	 */
+	if (skb_zcopy_managed(skb))
+		return;
+
 	if (x->props.flags & XFRM_STATE_ESN)
 		extralen += sizeof(struct esp_output_extra);
 
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 72490d27d15f5..a90c9f4c5fd02 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -120,6 +120,13 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb)
 	struct aead_request *req;
 	struct scatterlist *sg;
 
+	/* Managed frags are owned by the zerocopy ubuf; the skb holds no
+	 * per-frag page reference, so we must not drop one here.  Mirrors
+	 * the SKBFL_MANAGED_FRAG_REFS handling in skb_release_data().
+	 */
+	if (skb_zcopy_managed(skb))
+		return;
+
 	if (x->props.flags & XFRM_STATE_ESN)
 		extralen += sizeof(struct esp_output_extra);
 
-- 
2.53.0



