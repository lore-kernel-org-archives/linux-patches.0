Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027310;
	b=z2MydsGY8rUaOI109Nn9JsMZVt6jYVfMAzLhFNojddXOpbhCqsxb53ELC50H6hRiDRrH
	 YZQaRQD+0GhWSqPijIdSVntt/iXMbYzmF8PXN40jiX/qWHEg9/QXhOm3Aj5VMiuhLFoBZ
	 Yst3n4vCEUezKwfzBwLdw90dOPCi0tvm19GjZKAn3vg24qFV0vNGvlK4poRpA31hJWGI5
	 erxR5P7J/3YYY5AaNljXJlSrGzB3kiyv0lX3srEs28TlrWOkME6N5yBhWpCOZTtabtYVR
	 qvPn8O0WPehioiiHd5Vt8wbTLX5tSuAczMHESc/ULGANdTJd8Jb52WMTJYyEsmdxrDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D3xefLC4fmXClJpGowlHwRfdC5JrWISXVXkKheNMzJg=;
	b=2dGibAYMU1ri1y8Ia7MYG+JlrklzVyAl+pE60fDWt1lpKt/2XdwEDBoo4H653tXaMazK
	 1x5krhgt2/O7YPPObjRrlgHlop7YiZCE4ev3+lg0BBEfmFyyeQotP3NdtglJK47AirZRW
	 4niwqr69SanBKNgWVEky77VtUQMpEEbjHW+q2vYgLW9Dw85LVobDvzb3uOuZYJIqcTcQr
	 wGgxNZP4ip2vRbmXYZB55cGOMrQD8bs273lQAwQUf1NWdEywrBOneNfKGkPWuMPfcgjvM
	 vk5MvZc0+MqFPCDSC9+e7AJ4fnqseN5yFPBhQ2ZZBbSmopNqZ/2Pt2YIubU2EiUL91Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ptuu+t3d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87C8606A336;
	Wed, 18 Nov 2026 18:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ptuu+t3d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F551F000C4;
	Wed, 18 Nov 2026 18:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027310;
	bh=D3xefLC4fmXClJpGowlHwRfdC5JrWISXVXkKheNMzJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ptuu+t3d36TJ5tWvcQlAWCIj43Zb1p1tZCTeDDKdgQwwy1FB8KIwT65bprPBAD0bM
	 Lmw+oKLYe0ujrJ7kCh4GAv4a903t2PMLLhmkxnMQpw4lsUXBNDjPMl6tgJqpMeh9yL
	 IfyqCGeMnWc1liMs2KeF8neTSN+ceW1Lzdm7zjHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1745/2151] bpf: Follow the head if an skb is written from a slice
Date: Wed, 18 Nov 2026 15:58:00 +0100
Message-ID: <20261118150225.424912158@linuxfoundation.org>
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
index ea3e98e2d42da..b6780339ae857 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1717,6 +1717,24 @@ static inline void bpf_pull_mac_rcsum(struct sk_buff *skb)
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
@@ -1726,7 +1744,7 @@ BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
 		return -EINVAL;
 	if (unlikely(offset > INT_MAX))
 		return -EFAULT;
-	if (unlikely(bpf_try_make_writable(skb, offset + len)))
+	if (unlikely(bpf_try_make_writable_from(skb, offset + len, &from)))
 		return -EFAULT;
 
 	ptr = skb->data + offset;
@@ -12104,7 +12122,7 @@ int __bpf_skb_meta_store_bytes(struct sk_buff *skb, u32 offset,
 {
 	if (unlikely(flags))
 		return -EINVAL;
-	if (unlikely(bpf_try_make_writable(skb, 0)))
+	if (unlikely(bpf_try_make_writable_from(skb, 0, &from)))
 		return -EFAULT;
 
 	memmove(bpf_skb_meta_pointer(skb, offset), from, len);
-- 
2.53.0



