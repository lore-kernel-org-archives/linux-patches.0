Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020940;
	b=mxmZ3fGHidDHpyChOs7I2zDWdmQRuUTuVur2H6fDr6a0P3RVkgXekMs2kpIFECSNMVuw
	 P3exo1mBlMgg/vQ79MVVFnQpQz0sQLLU/Cn8T7QwoHwRJuWkJ8shP3uTVmf7rl7ZeA2vk
	 wfrzDQY5joE7l8zFmhX7cm8JK2ykJQMFWVC/bHjnYspCtvlLZRslOmzi67tOmHgW3PMcX
	 E8s1O4mOMsxxG6OUu0WkRJy7RcOkJT9cK7+LCkdIUTW0z4JnQMgpEynR2UZZxjv6/5/1f
	 I48fJiXXu4lTVmS4YJ+X8F9zUt66K0Pzm1gpviQHwmKrtSH7Mdq+i2qknY9CCYTlI4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BsiLffQc0qrWkczI1FoSVuVLwg/w9YQDbWqSZkkhyDk=;
	b=usxQ6IqmsQgQE9s2kV9Cj8voV6uClbWo7jxSM7ZrQfTOKJb13JxG+HuKhF3SlGT6u6JI
	 zQC7PVkVQnzAfXo3c9xrWYCBZrbARKDw8uN3yu1AzPhhX+YKJZyrxCJuz4QDgVlSi4ybk
	 nmR+0772N+BWody5eyHaj3nQvk5Mwj9fnZdmIG0tp4qs3gQg1+vXCVt2xFTs65zdpb816
	 Ds5pWYXHo8ohJOVYsz1e2ShJIknXwhIjRpezfCljdi62JuWG41K68gJlrErSCoxCrQgTM
	 XRTVYaqoq85sKKW5L2opX7A3V5jTsAVNPUQnw0T2kErpBwDnOFiW4X6auD9y478vFVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2K+k732P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C8B606B582;
	Wed, 18 Nov 2026 16:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2K+k732P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6919A1F000C8;
	Wed, 18 Nov 2026 16:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020939;
	bh=BsiLffQc0qrWkczI1FoSVuVLwg/w9YQDbWqSZkkhyDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2K+k732PdvfaMUtaQo6qUUIXCiDtYBCPWakW6XsNhhVIsSgCB+DkcrwvjRjl5/uEW
	 Y0l7KfUe1gaqMVV/oS5MR5V7sTGOw5/pOfIAZOkCMiLtQR2EZsWIq5MYEKjjaZlJqn
	 Uo+h3eXYHq2Q1raSDyZ2eOsuxzzmjenooYg3x67w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2129/2651] bpf: Follow the head if an skb is written from a slice
Date: Wed, 18 Nov 2026 15:56:09 +0100
Message-ID: <20261118150402.547137505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 1c19f2b3b2f3b55c8017092257634cb8229b7d97 ]

The source of bpf_dynptr_write() may be a slice of the skb which is
written to, that is a pointer into its head. bpf_dynptr_copy() does it by
itself for a copy inside of one skb, if the source is linear and the
destination is not.

__bpf_skb_store_bytes() and __bpf_skb_meta_store_bytes() make the skb
writable first. If that reallocates the head, the source points to the old
one, and freed memory is copied into the packet.

The offsets in the head do not change when it is reallocated here. Move
the source along with the head.

Fixes: 2012c867c800 ("bpf: verifier: Accept dynptr mem as mem in helpers")
Fixes: f38499ff45f5 ("bpf: Unclone skb head on bpf_dynptr_write to skb metadata")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-14-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2e6ebfabf6deb..aa229d1ebe28a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1715,6 +1715,24 @@ static inline void bpf_pull_mac_rcsum(struct sk_buff *skb)
 		skb_postpull_rcsum(skb, skb_mac_header(skb), skb->mac_len);
 }
 
+/*
+ * The source of a write through a dynptr may be a slice of the same skb.
+ * Making the skb writable can move its head: follow the move.
+ */
+static int bpf_try_make_writable_from(struct sk_buff *skb, u32 write_len,
+				      const void **from)
+{
+	const void *head = skb->head;
+	bool in_head = *from >= head &&
+		       *from < (const void *)skb_end_pointer(skb);
+	int err;
+
+	err = bpf_try_make_writable(skb, write_len);
+	if (!err && in_head)
+		*from = skb->head + (*from - head);
+	return err;
+}
+
 BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
 	   const void *, from, u32, len, u64, flags)
 {
@@ -1724,7 +1742,7 @@ BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
 		return -EINVAL;
 	if (unlikely(offset > INT_MAX))
 		return -EFAULT;
-	if (unlikely(bpf_try_make_writable(skb, offset + len)))
+	if (unlikely(bpf_try_make_writable_from(skb, offset + len, &from)))
 		return -EFAULT;
 
 	ptr = skb->data + offset;
@@ -12422,7 +12440,7 @@ int __bpf_skb_meta_store_bytes(struct sk_buff *skb, u32 offset,
 {
 	if (unlikely(flags))
 		return -EINVAL;
-	if (unlikely(bpf_try_make_writable(skb, 0)))
+	if (unlikely(bpf_try_make_writable_from(skb, 0, &from)))
 		return -EFAULT;
 
 	memmove(bpf_skb_meta_pointer(skb, offset), from, len);
-- 
2.53.0



