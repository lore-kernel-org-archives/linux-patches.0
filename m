Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625545;
	b=Cs8U7EhBxjQ6aagGIbyqrS70ZlU9XxRtbrpeMW0ekA8N/LMXm8k+1vI/Vua8Sdt/OsGa
	 XlNSpLSnU/ncnxSCEV+RrpN5JwbSPbkGRsykzXdv+9Wcdmk48BNzZ8j56QRKjSEVO4xPP
	 QptDULsFS6JkLVVYFOW90cOpj30dKpz6wHfldy2Uuzhn1cFPB/kVdS9xzggQWTiSd8Hgw
	 9VXO0QPlOOsO5M6JdvNIUeYF08w5LqHpcTw+WFLqjLTDQlGrEExRvoHSGdOQgHo16gFSl
	 ThOKbNTUEocBAbZoIGxG3q665adxvSIrYdC0qGsfdTeB6J/9f6P44TUK+DoX3EexZKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rg5WYJsd7Z5ik0k6MlnTDt96nPSjkS0eS28oV2LcDGk=;
	b=H0iuiyJKH948uT9QZV98PQk+w31BiJmi8h32PqkvzNXrH96qkPIFsRYXfyyVshOq7/nl
	 DjIdPwimECcrlGlzS5JcMyXmovSG0jw/68iHUdmDg9YpL0J/M/e/103FiiQ3k9YQUwZx1
	 NeSOraIwfacJFloAzfyn235TJjHctaF9ugd8bidpvYohGp+Ydsk4JOIgn2PJY3D6VNcm3
	 L5FxxOuVTi+lM3qE65ur8Pjwl1jsl0QXuyAo0RV9Me5o2G7IRIYAyjwClYsDGa5noayzr
	 ugUXOlgTEbX+Tj4L88KWasK8ZahExkTmk6snqwh1ScaBJeArcwndj+RDyIloxOImZDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xKaaPUP4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FA5606A31E;
	Wed, 25 Nov 2026 16:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xKaaPUP4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E451F000C6;
	Wed, 25 Nov 2026 16:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625545;
	bh=rg5WYJsd7Z5ik0k6MlnTDt96nPSjkS0eS28oV2LcDGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xKaaPUP4X9kNe0zQKrMtJ5H9+L9lBzvHiHg/qfQNeG8K9edZuzXDKlXM9wv1zjiG6
	 O6QZh03v8fOytflhNUQc3CJwuQeWiC88G6jsU7jz1P178wBllo7Jqn8hoEvAtd0tYr
	 LnPspETSutVaXJLCrPFF4TjAr2I6Zd0Tz79quiBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 515/816] bpf: Follow the head if an skb is written from a slice
Date: Wed, 25 Nov 2026 15:34:23 +0100
Message-ID: <20261125143901.107497819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Dropped the hunk that modifies __bpf_skb_meta_store_bytes() because that function doesn't exist here, and kept the helper and the bpf_skb_store_bytes() change. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 9c53e79d87501..3b8ea2ba5c312 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1720,6 +1720,24 @@ static inline void bpf_pull_mac_rcsum(struct sk_buff *skb)
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
@@ -1729,7 +1747,7 @@ BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
 		return -EINVAL;
 	if (unlikely(offset > INT_MAX))
 		return -EFAULT;
-	if (unlikely(bpf_try_make_writable(skb, offset + len)))
+	if (unlikely(bpf_try_make_writable_from(skb, offset + len, &from)))
 		return -EFAULT;
 
 	ptr = skb->data + offset;
-- 
2.53.0



