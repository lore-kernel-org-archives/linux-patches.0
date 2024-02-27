Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75FD13AA50;
	Tue, 27 Feb 2024 13:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042369; cv=none; b=kH4cupjWwFyLrO8ZSpF8mN4ia+AyNXGVF7uU+MiKZ7v6DGTE3+vk00pwdOm7KkPAnvZ1Dfrzq2A63cuJz0K3O+rG04kFIwqmTz1l8s2lpseNZgkpIz+hMyr0Jqs8cp806/C9bkCKRuqi15fdm6oG3kPoPc4yc0NCs/M7Bjr5FHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042369; c=relaxed/simple;
	bh=CPW019nt9ho2LkIKO8U+mFT7rUfuZDsv0z3Cesby+Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSUH+CYWZNPwcjfOSn2e1FoxEKKHg7QxeBQoMdKJoEy+oa7FJzgzKTT2y9Z+cbcPlq753M3kx39gyhrid/sVQjMOS5VYdITAXeJz3ikHc+IyqMLL2LQi4WycSePk16Um6PBpCowQsi/J5uUzlhhz7a2w/C21aoUUA1JSnKBE2Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHpH3AIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHpH3AIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76002C433C7;
	Tue, 27 Feb 2024 13:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042368;
	bh=CPW019nt9ho2LkIKO8U+mFT7rUfuZDsv0z3Cesby+Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHpH3AIgOsPxEcqT503P8qezGZnTaCwzDAz7WE1NZWox2+LY8pRuM6KTu64Mq73sG
	 tPQuw8P96z+0s3I9avXKMS+1UJ7Y6yKWQ2RiVkvYQrtDd9Ee+Y6dWQ0qwyBkxu6dSm
	 cV/Fl43ip3NF9kMkblzdBstjXua3d4l7pJIQfT78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 270/299] tls: dont skip over different type records from the rx_list
Date: Tue, 27 Feb 2024 14:26:21 +0100
Message-ID: <20240227131634.370440987@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit ec823bf3a479d42c589dc0f28ef4951c49cd2d2a ]

If we queue 3 records:
 - record 1, type DATA
 - record 2, some other type
 - record 3, type DATA
and do a recv(PEEK), the rx_list will contain the first two records.

The next large recv will walk through the rx_list and copy data from
record 1, then stop because record 2 is a different type. Since we
haven't filled up our buffer, we will process the next available
record. It's also DATA, so we can merge it with the current read.

We shouldn't do that, since there was a record in between that we
ignored.

Add a flag to let process_rx_list inform tls_sw_recvmsg that it had
more data available.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/f00c0c0afa080c60f016df1471158c1caf983c34.1708007371.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index a83b6119f3826..5238886e61860 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1772,7 +1772,8 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 			   u8 *control,
 			   size_t skip,
 			   size_t len,
-			   bool is_peek)
+			   bool is_peek,
+			   bool *more)
 {
 	struct sk_buff *skb = skb_peek(&ctx->rx_list);
 	struct tls_msg *tlm;
@@ -1785,7 +1786,7 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 
 		err = tls_record_content_type(msg, tlm, control);
 		if (err <= 0)
-			goto out;
+			goto more;
 
 		if (skip < rxm->full_len)
 			break;
@@ -1803,12 +1804,12 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 
 		err = tls_record_content_type(msg, tlm, control);
 		if (err <= 0)
-			goto out;
+			goto more;
 
 		err = skb_copy_datagram_msg(skb, rxm->offset + skip,
 					    msg, chunk);
 		if (err < 0)
-			goto out;
+			goto more;
 
 		len = len - chunk;
 		copied = copied + chunk;
@@ -1844,6 +1845,10 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 
 out:
 	return copied ? : err;
+more:
+	if (more)
+		*more = true;
+	goto out;
 }
 
 static bool
@@ -1947,6 +1952,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	int target, err;
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
 	bool is_peek = flags & MSG_PEEK;
+	bool rx_more = false;
 	bool released = true;
 	bool bpf_strp_enabled;
 	bool zc_capable;
@@ -1966,12 +1972,12 @@ int tls_sw_recvmsg(struct sock *sk,
 		goto end;
 
 	/* Process pending decrypted records. It must be non-zero-copy */
-	err = process_rx_list(ctx, msg, &control, 0, len, is_peek);
+	err = process_rx_list(ctx, msg, &control, 0, len, is_peek, &rx_more);
 	if (err < 0)
 		goto end;
 
 	copied = err;
-	if (len <= copied || (copied && control != TLS_RECORD_TYPE_DATA))
+	if (len <= copied || (copied && control != TLS_RECORD_TYPE_DATA) || rx_more)
 		goto end;
 
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
@@ -2130,10 +2136,10 @@ int tls_sw_recvmsg(struct sock *sk,
 		/* Drain records from the rx_list & copy if required */
 		if (is_peek || is_kvec)
 			err = process_rx_list(ctx, msg, &control, copied,
-					      decrypted, is_peek);
+					      decrypted, is_peek, NULL);
 		else
 			err = process_rx_list(ctx, msg, &control, 0,
-					      async_copy_bytes, is_peek);
+					      async_copy_bytes, is_peek, NULL);
 	}
 
 	copied += decrypted;
-- 
2.43.0



