Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E3B82495;
	Wed, 19 Jun 2024 13:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803155; cv=none; b=mrp8QCNGqDSR4kxj/vWFhJB64mqL3weNZwluzb03VwqFuQEdy3HPqGULSnhmifS+GkIRSQH64Y5tid5eJ8oB4idec3ZhZ/HpL/8pvA15hB2yTTncvJ0Fyd5CISXBqXPh2ntXVYCDmZOYErxtOiGv1bVa7p2QukVQgib8N/ZM8MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803155; c=relaxed/simple;
	bh=kuqHDhU2W8rbBTwOwBC5tLZGdmNFYdPxet6voAEeuvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ah8A1KSZXhUAf6qRlh1Pnf8j7WAvAK6WIpG0JkujNQwYNt2KkPhSOB/WlZkCDvTEvKuHZ1onlU5CSgU8ZqinscH5TM2XVfPSSoysZK9Z3tABedixa5YnlMquuJVOFEkAyE7dT7WTcVOmgYIzz7fwyBX96C4HIb5VFCYibS73qT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1HMf7pUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1HMf7pUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E42C4AF1A;
	Wed, 19 Jun 2024 13:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803155;
	bh=kuqHDhU2W8rbBTwOwBC5tLZGdmNFYdPxet6voAEeuvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1HMf7pUgPAKiMOYA7imW12WmwB/msu8zzBDLq0NC0+AwC8nZgTtsc2va+OTRQpul+
	 bE7ez3cxAWuurPRxPyl6nqrMedwIyRCXsKpDpQDQhHMLTdnTgj6S1M/2IJ3efSJ1af
	 Cm/9CpTw4jBxjMpxqeLJdqY8s0hsZv++QnnsUFxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 144/281] af_unix: Annotate data-race of sk->sk_state in unix_accept().
Date: Wed, 19 Jun 2024 14:55:03 +0200
Message-ID: <20240619125615.382124143@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 1b536948e805aab61a48c5aa5db10c9afee880bd ]

Once sk->sk_state is changed to TCP_LISTEN, it never changes.

unix_accept() takes the advantage and reads sk->sk_state without
holding unix_state_lock().

Let's use READ_ONCE() there.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1704,7 +1704,7 @@ static int unix_accept(struct socket *so
 		goto out;
 
 	err = -EINVAL;
-	if (sk->sk_state != TCP_LISTEN)
+	if (READ_ONCE(sk->sk_state) != TCP_LISTEN)
 		goto out;
 
 	/* If socket state is TCP_LISTEN it cannot change (for now...),


