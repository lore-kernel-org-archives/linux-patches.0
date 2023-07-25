Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E916D15AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B55EC433C8;
	Tue, 25 Jul 2023 10:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282681;
	bh=wU/4t7suADMN1Xcyh9XSUpDvdoqH7mkDeOy6VvCe3Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zn7A4yG+KEIZOL4awE+m3GYpIcB/f46oc4DQ0ZmTEJqolEyKnSeCezD4izu/NX8fg
	 6H4jnsRTXV9h3qwN8z3ju02K8esv4bBL1FxXvN89TF2BRfIcavp/iZ1ZuwitvC7/wI
	 py0Pmaypsw3LSlSPb+OSh3mh44OzzKwooQxdhBvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 216/227] tcp: annotate data-races around icsk->icsk_user_timeout
Date: Tue, 25 Jul 2023 12:46:23 +0200
Message-ID: <20230725104523.673606397@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 26023e91e12c68669db416b97234328a03d8e499 ]

This field can be read locklessly from do_tcp_getsockopt()

Fixes: dca43c75e7e5 ("tcp: Add TCP_USER_TIMEOUT socket option.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230719212857.3943972-11-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4556ba6e7d74d..c9b955d9d7ace 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3409,7 +3409,7 @@ EXPORT_SYMBOL(tcp_sock_set_syncnt);
 void tcp_sock_set_user_timeout(struct sock *sk, u32 val)
 {
 	lock_sock(sk);
-	inet_csk(sk)->icsk_user_timeout = val;
+	WRITE_ONCE(inet_csk(sk)->icsk_user_timeout, val);
 	release_sock(sk);
 }
 EXPORT_SYMBOL(tcp_sock_set_user_timeout);
@@ -3729,7 +3729,7 @@ int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		if (val < 0)
 			err = -EINVAL;
 		else
-			icsk->icsk_user_timeout = val;
+			WRITE_ONCE(icsk->icsk_user_timeout, val);
 		break;
 
 	case TCP_FASTOPEN:
@@ -4250,7 +4250,7 @@ int do_tcp_getsockopt(struct sock *sk, int level,
 		break;
 
 	case TCP_USER_TIMEOUT:
-		val = icsk->icsk_user_timeout;
+		val = READ_ONCE(icsk->icsk_user_timeout);
 		break;
 
 	case TCP_FASTOPEN:
-- 
2.39.2



