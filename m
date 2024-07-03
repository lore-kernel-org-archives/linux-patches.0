Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733B11799F;
	Wed,  3 Jul 2024 11:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005280; cv=none; b=LFWWqgLMJzNBMYm9XShuuLPdaAg0hSv2PukcGf8oBeW9S/Tx/BPtIkwsRdec6i8+aAWXXms9cHnZ9A1Sc7NaCiTBaappNFFb8bqKfJTmIGdTWHq1YN9FQaWzxLQK6XQBA6wq0EsUe4fgBBb5Gzkcf3S5XH3JNZkiaCopClhPpw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005280; c=relaxed/simple;
	bh=uezQwvujZgsbWSr4/nUfYYGasPR+U88LEXR6KSECpow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWHKyhEBmUmkDAqUtCkLCrMkbHigMapVNqJkES4xaPXarzGCTeRyDELiczm1zBNbpC9cezG5GcRPMDNj5W3nPsh59upvM2WTzkj6Eh9TPftwehh177CN5XFJVZLBk79zEf918r/D2WJF2Qlz+VSftGYRjge0J7lnWR3xNE+O/Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i22aMBox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i22aMBox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0A4C2BD10;
	Wed,  3 Jul 2024 11:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005280;
	bh=uezQwvujZgsbWSr4/nUfYYGasPR+U88LEXR6KSECpow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i22aMBoxVOKoDckJnNwuYzwCrMZBSLrUjaFfwXcmozPUQ3iE8iKpDDveDaEPL0Xeq
	 2ohS4wh62I0+ZAlHBYzqovdAVyXzN0ghKYIYjG0PtzbT9x/4JYNUuKt40r94wJsON4
	 H/nJDJap1H/TxBjJ3rLzYeVj1rHTqZBUAG+KQszM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/356] af_unix: Annotate data-race of sk->sk_state in unix_stream_read_skb().
Date: Wed,  3 Jul 2024 12:36:04 +0200
Message-ID: <20240703102914.164263825@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit af4c733b6b1aded4dc808fafece7dfe6e9d2ebb3 ]

unix_stream_read_skb() is called from sk->sk_data_ready() context
where unix_state_lock() is not held.

Let's use READ_ONCE() there.

Fixes: 77462de14a43 ("af_unix: Add read_sock for stream socket types")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2600,7 +2600,7 @@ static struct sk_buff *manage_oob(struct
 static int unix_stream_read_sock(struct sock *sk, read_descriptor_t *desc,
 				 sk_read_actor_t recv_actor)
 {
-	if (unlikely(sk->sk_state != TCP_ESTABLISHED))
+	if (unlikely(READ_ONCE(sk->sk_state) != TCP_ESTABLISHED))
 		return -ENOTCONN;
 
 	return unix_read_sock(sk, desc, recv_actor);


