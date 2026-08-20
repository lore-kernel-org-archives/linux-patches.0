Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E66035DA68;
	Thu, 20 Aug 2026 17:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248236; cv=none; b=o0F9uadI2IdFvJznr6Drl9+yd72kBX6KvuhHGTq+O87kMSkB2tWvEP1Z4yc9fUidZcK+vPRZq1gascg+Z5kPx3zvd/Ns9++7snElf8lMCoeBtDdYR+Jlpr+XuWTY0cb2z8LEn+vwd0FoPZi6ME7bM82AFmHogezYWv6CBKOZOOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248236; c=relaxed/simple;
	bh=n3zuAwv3ZFd7756sXXrN0TGLB9Ltoho4eLRozUgodQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzjjMhO4v6fnd2ATYPS4aIVFjuvEEqz0hGblusQsPW7fOZTIvX4ygM47v+fM597JhpniqgX3wYuE6P5zCYySdHrfTBXYzc4AHgHRXPFAoNdiWKY2PozaSKfDf1dP0ZG8zWBJIdLudVAdR5lI+cJyVMcLui3jaijr8mXyunLLb60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AdqPhYP7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AdqPhYP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F049E1F000E9;
	Thu, 20 Aug 2026 17:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248235;
	bh=pHM0NOPCTLB9xjuEMvOALD8kIRRVRDbmLRpNP8utiqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AdqPhYP7v2h1VK+eEAbiQn8kOPecmU3qKWosfozv9GSmzdMwhCRk6Rb8RbppyP7tr
	 bn1odd5tWnid+Lg5zYuYDwzVb4ke3HV9sHoWZVtr/x7YG8MjdCZQbff7lb0QsINxGj
	 RBAeptG4O0Qsoqyu8S3mergeaOOEyH2o6IR+LLtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	David Ahern <dsahern@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/303] tcp_bpf: Inline do_tcp_sendpages as its now a wrapper around tcp_sendmsg
Date: Thu, 20 Aug 2026 16:54:54 +0200
Message-ID: <20260820145258.049053906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit ebf2e8860eea66e2c4764316b80c6a5ee5f336ee ]

do_tcp_sendpages() is now just a small wrapper around tcp_sendmsg_locked(),
so inline it.  This is part of replacing ->sendpage() with a call to
sendmsg() with MSG_SPLICE_PAGES set.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: John Fastabend <john.fastabend@gmail.com>
cc: Jakub Sitnicki <jakub@cloudflare.com>
cc: David Ahern <dsahern@kernel.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 007800408002 ("espintcp: use sk_msg_free_partial to fix partial send")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_bpf.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -92,11 +92,13 @@ static int tcp_bpf_push(struct sock *sk,
 {
 	bool apply = apply_bytes;
 	struct scatterlist *sge;
+	struct msghdr msghdr = { .msg_flags = flags | MSG_SPLICE_PAGES, };
 	struct page *page;
 	int size, ret = 0;
 	u32 off;
 
 	while (1) {
+		struct bio_vec bvec;
 		bool has_tx_ulp;
 
 		sge = sk_msg_elem(msg, msg->sg.start);
@@ -108,16 +110,18 @@ static int tcp_bpf_push(struct sock *sk,
 		tcp_rate_check_app_limited(sk);
 retry:
 		has_tx_ulp = tls_sw_has_ctx_tx(sk);
-		if (has_tx_ulp) {
-			flags |= MSG_SENDPAGE_NOPOLICY;
-			ret = kernel_sendpage_locked(sk,
-						     page, off, size, flags);
-		} else {
-			ret = do_tcp_sendpages(sk, page, off, size, flags);
-		}
+		if (has_tx_ulp)
+			msghdr.msg_flags |= MSG_SENDPAGE_NOPOLICY;
+
+		if (flags & MSG_SENDPAGE_NOTLAST)
+			msghdr.msg_flags |= MSG_MORE;
 
+		bvec_set_page(&bvec, page, size, off);
+		iov_iter_bvec(&msghdr.msg_iter, ITER_SOURCE, &bvec, 1, size);
+		ret = tcp_sendmsg_locked(sk, &msghdr, size);
 		if (ret <= 0)
 			return ret;
+
 		if (apply)
 			apply_bytes -= ret;
 		msg->sg.size -= ret;
@@ -501,7 +505,7 @@ static int tcp_bpf_sendmsg(struct sock *
 	long timeo;
 	int flags;
 
-	/* Don't let internal do_tcp_sendpages() flags through */
+	/* Don't let internal sendpage flags through */
 	flags = (msg->msg_flags & ~MSG_SENDPAGE_DECRYPTED);
 	flags |= MSG_NO_SHARED_FRAGS;
 


