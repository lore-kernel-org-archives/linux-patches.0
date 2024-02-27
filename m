Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E7313B2B4;
	Tue, 27 Feb 2024 14:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043683; cv=none; b=fjyGxVpS++PRliLyh77f3M0001gjvuT9rNKe4FW4/BJvEF705E4yuK+ZIsWaSK8VTspc8CX56fxlzJD9dCM0cDot14hTg+3SvwVTZLA4/AlQjUYRoJMKzhAB0CnRtKQMXEkKHvWNRHGYlswguYF81GiO3KgcSS9MQcE656/wi+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043683; c=relaxed/simple;
	bh=d3Gffi38sYjoe5nikW5XxpYm+pECgG0wvP3AesnwZEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EL4FRT7T+/VV7UNSFS/ORfmYdjwAHWSt6InbrP3/50/Wav+lxgT0Z2PezaDKVjf6mGS3yKSAEqZHvf910fyeOiSdqfwPYE20qdlKpeRzh23hqOtFFUEH9vYNqYBaDITf9rRiwV8lpIEQBR09B0iMNlTXxDEKuVBsNVm494IIEb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WykhyDsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WykhyDsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751D9C433C7;
	Tue, 27 Feb 2024 14:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043682;
	bh=d3Gffi38sYjoe5nikW5XxpYm+pECgG0wvP3AesnwZEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WykhyDsA9Qhd9LV3l1fu1i8d/FKo+NbEcybAQGYR9tuyO+nrzhEQ2jfVMiYfVzNKK
	 ILZOQXnGxORHP8zytR9AKCeZk/mYBS54MELuKypTAnrLJmTRr88xZqMrbOxzU+MY2s
	 tTcfjLi9FH0eN7acpuY3arCK/Gvw0tdz1An95OVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/195] tls: dont skip over different type records from the rx_list
Date: Tue, 27 Feb 2024 14:27:09 +0100
Message-ID: <20240227131615.956938413@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 20d2877bf22ad..93e1bfa72d791 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1845,7 +1845,8 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 			   u8 *control,
 			   size_t skip,
 			   size_t len,
-			   bool is_peek)
+			   bool is_peek,
+			   bool *more)
 {
 	struct sk_buff *skb = skb_peek(&ctx->rx_list);
 	struct tls_msg *tlm;
@@ -1858,7 +1859,7 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 
 		err = tls_record_content_type(msg, tlm, control);
 		if (err <= 0)
-			goto out;
+			goto more;
 
 		if (skip < rxm->full_len)
 			break;
@@ -1876,12 +1877,12 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 
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
@@ -1917,6 +1918,10 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 
 out:
 	return copied ? : err;
+more:
+	if (more)
+		*more = true;
+	goto out;
 }
 
 static bool
@@ -2020,6 +2025,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	int target, err;
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
 	bool is_peek = flags & MSG_PEEK;
+	bool rx_more = false;
 	bool released = true;
 	bool bpf_strp_enabled;
 	bool zc_capable;
@@ -2039,12 +2045,12 @@ int tls_sw_recvmsg(struct sock *sk,
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
@@ -2203,10 +2209,10 @@ int tls_sw_recvmsg(struct sock *sk,
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



