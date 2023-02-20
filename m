Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3291063B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECE5C433D2;
	Mon, 20 Feb 2023 13:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901132;
	bh=qsSyVfGk9HdlGff1u6FAHqgarxKPt7MtAhc7w8HxzUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geE/2l0r6zwrZpAfAQxU1Y0pjHgP7JY0HKFhlkzmgxPFElYmaSsFSkjOn5p/CTUc+
	 rqsNEn627KJGHaOOBGC7JCxEY27TBT2rqR4qZzVKcZT/6et1iY5kqSrwK0+CkbTBm5
	 /9WWHJ/LFgNoOByf/8ZsWSAUsOcAREYqvH9w7KIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Winter <winter@winter.cafe>,
	Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCH 5.15 42/83] tcp: Fix listen() regression in 5.15.88.
Date: Mon, 20 Feb 2023 14:36:15 +0100
Message-Id: <20230220133555.140865685@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuniyuki Iwashima <kuniyu@amazon.com>

When we backport dadd0dcaa67d ("net/ulp: prevent ULP without clone op from
entering the LISTEN status"), we have accidentally backported a part of
7a7160edf1bf ("net: Return errno in sk->sk_prot->get_port().") and removed
err = -EADDRINUSE in inet_csk_listen_start().

Thus, listen() no longer returns -EADDRINUSE even if ->get_port() failed
as reported in [0].

We set -EADDRINUSE to err just before ->get_port() to fix the regression.

[0]: https://lore.kernel.org/stable/EF8A45D0-768A-4CD5-9A8A-0FA6E610ABF7@winter.cafe/

Reported-by: Winter <winter@winter.cafe>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_connection_sock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1070,6 +1070,7 @@ int inet_csk_listen_start(struct sock *s
 	 * It is OK, because this socket enters to hash table only
 	 * after validation is complete.
 	 */
+	err = -EADDRINUSE;
 	inet_sk_state_store(sk, TCP_LISTEN);
 	if (!sk->sk_prot->get_port(sk, inet->inet_num)) {
 		inet->inet_sport = htons(inet->inet_num);


