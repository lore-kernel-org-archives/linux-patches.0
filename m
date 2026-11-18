Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027307;
	b=J8mNiXHK0onxelRyphUP/kIV/zGkZPVQnR8wQZ9s5yUdvXOdyDuT+z9Psba570kqxx4o
	 t83LyvrIBSfTmJnKgdovVkTiz1rlvaflGuRZTO00CTucZz1e5uBaTM5oLF5gOKQTl1y2K
	 Rrtsojl2lPC2r+VelXMS5rXT36Qc/5S2TycdSSOkdRDV6PTlMzyMKJUqFGMbW2uigi/Ri
	 B31L3MH8Kyq5TRYEeEidFa44T26dn+UeMIQiscuKZoNuX43uoq6DX1yeoPRB6YD36mArB
	 dtEk4yrM3c+oW2B87QZFquKrrcrmIGeWHLlm48f1CT75K6f35r32N6Nbkw9jjzf1npQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KTb+LUcO+4x6BDeCnWVcAIiAAqBYLSU+t2jYMDleo/c=;
	b=kq6Xx6U4OQ+fJ/i33Dvr0B4+fVAKQnzG+iEEgbZMQ5Qzak6n+aHZ1RrF+aQyx5SIWrD0
	 0zPTS2tVy0naYWAXUTiB1G5gbyiWni4s9WBIj3MYeKVZCnwoeu1lDsfu/WDak33fjUPTi
	 YbB9tezgUa5JApuilGE+Q4stx28mSxMQZrua50p0HM7jEa+/Z78Fi2HWYoqe1dur3lXoa
	 qeJHr7WuiEVO3og3/fD1pSfb4Tl3N0/Qhs0ttVJVeRganGN2WDzF50tZXWLatXyMGgueH
	 LM9z7f0QrkAtLJsOHLgdN6kqwokpsLiMzxOteN6gVOxCkJvllf++LyNZFH3VaI7X3GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F8dRR88N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18FE606A32A;
	Wed, 18 Nov 2026 18:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F8dRR88N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD401F000C4;
	Wed, 18 Nov 2026 18:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027307;
	bh=KTb+LUcO+4x6BDeCnWVcAIiAAqBYLSU+t2jYMDleo/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F8dRR88Nmvg+GA68KHOPUtzzlVi4G9/S1ZQoyAwGmB/YWjSxSL0JuvPDwYuQSFh9u
	 c9WEpoM79Bh5QR3O/Lv5B9qFYc9Tjha2Rc7YgvgtCK/EwZBkgpqFx7za9aNMMBpo17
	 9SI9NMd5lb126uingLF5pjJMYnntcTT7B7WupwxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1744/2151] bpf: Unclone skb head on bpf_dynptr_write to skb metadata
Date: Wed, 18 Nov 2026 15:57:59 +0100
Message-ID: <20261118150225.388141005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit f38499ff45f567c932d0911e6a30b8ca022b9b52 ]

Currently bpf_dynptr_from_skb_meta() marks the dynptr as read-only when
the skb is cloned, preventing writes to metadata.

Remove this restriction and unclone the skb head on bpf_dynptr_write() to
metadata, now that the metadata is preserved during uncloning. This makes
metadata dynptr consistent with skb dynptr, allowing writes regardless of
whether the skb is cloned.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20251105-skb-meta-rx-path-v4-3-5ceb08a9b37b@cloudflare.com
Stable-dep-of: 1c19f2b3b2f3 ("bpf: Follow the head if an skb is written from a slice")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/filter.h |  9 +++++++++
 kernel/bpf/helpers.c   |  6 ++----
 net/core/filter.c      | 18 ++++++++++++------
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 260a190634055..a11c92e104965 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1827,6 +1827,8 @@ int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u32 len);
 void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len);
 void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
 		      void *buf, unsigned long len, bool flush);
+int __bpf_skb_meta_store_bytes(struct sk_buff *skb, u32 offset,
+			       const void *from, u32 len, u64 flags);
 void *bpf_skb_meta_pointer(struct sk_buff *skb, u32 offset);
 #else /* CONFIG_NET */
 static inline int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset,
@@ -1863,6 +1865,13 @@ static inline void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off, voi
 {
 }
 
+static inline int __bpf_skb_meta_store_bytes(struct sk_buff *skb, u32 offset,
+					     const void *from, u32 len,
+					     u64 flags)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline void *bpf_skb_meta_pointer(struct sk_buff *skb, u32 offset)
 {
 	return ERR_PTR(-EOPNOTSUPP);
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 8476f9bab6bc3..31afbb74a0523 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1856,10 +1856,8 @@ int __bpf_dynptr_write(const struct bpf_dynptr_kern *dst, u32 offset, void *src,
 			return -EINVAL;
 		return __bpf_xdp_store_bytes(dst->data, dst->offset + offset, src, len);
 	case BPF_DYNPTR_TYPE_SKB_META:
-		if (flags)
-			return -EINVAL;
-		memmove(bpf_skb_meta_pointer(dst->data, dst->offset + offset), src, len);
-		return 0;
+		return __bpf_skb_meta_store_bytes(dst->data, dst->offset + offset, src,
+						  len, flags);
 	default:
 		WARN_ONCE(true, "bpf_dynptr_write: unknown dynptr type %d\n", type);
 		return -EFAULT;
diff --git a/net/core/filter.c b/net/core/filter.c
index 8eb54d7bc7325..ea3e98e2d42da 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -12099,6 +12099,18 @@ void *bpf_skb_meta_pointer(struct sk_buff *skb, u32 offset)
 	return skb_metadata_end(skb) - skb_metadata_len(skb) + offset;
 }
 
+int __bpf_skb_meta_store_bytes(struct sk_buff *skb, u32 offset,
+			       const void *from, u32 len, u64 flags)
+{
+	if (unlikely(flags))
+		return -EINVAL;
+	if (unlikely(bpf_try_make_writable(skb, 0)))
+		return -EFAULT;
+
+	memmove(bpf_skb_meta_pointer(skb, offset), from, len);
+	return 0;
+}
+
 __bpf_kfunc_start_defs();
 __bpf_kfunc int bpf_dynptr_from_skb(struct __sk_buff *s, u64 flags,
 				    struct bpf_dynptr *ptr__uninit)
@@ -12126,9 +12138,6 @@ __bpf_kfunc int bpf_dynptr_from_skb(struct __sk_buff *s, u64 flags,
  * XDP context with bpf_xdp_adjust_meta(). Serves as an alternative to
  * &__sk_buff->data_meta.
  *
- * If passed @skb_ is a clone which shares the data with the original, the
- * dynptr will be read-only. This limitation may be lifted in the future.
- *
  * Return:
  * * %0         - dynptr ready to use
  * * %-EINVAL   - invalid flags, dynptr set to null
@@ -12146,9 +12155,6 @@ __bpf_kfunc int bpf_dynptr_from_skb_meta(struct __sk_buff *skb_, u64 flags,
 
 	bpf_dynptr_init(ptr, skb, BPF_DYNPTR_TYPE_SKB_META, 0, skb_metadata_len(skb));
 
-	if (skb_cloned(skb))
-		bpf_dynptr_set_rdonly(ptr);
-
 	return 0;
 }
 
-- 
2.53.0



