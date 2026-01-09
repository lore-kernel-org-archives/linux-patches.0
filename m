Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1815A335083;
	Fri,  9 Jan 2026 12:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961683; cv=none; b=hX+boPnN3hfMy+sMl5+KVI7iPCysbGwFSoKfDvgAp6t9TwxzE0A9h8V5Rt7OhkW+uJx7K9sWH4O0mjs5zsVZ+GCDWRnCmPPzhzl9fgx8n/Y6dxk3ke0Bx8Z7iXeNzTrAGRRLNHRERl2ZRAxRn5SCreTTtXliB4TIEg5ri4kvuNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961683; c=relaxed/simple;
	bh=9Uw1cIqodQK7d4IpCgrLU1sXKYnroQxCZt1Xwhgu69c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ki+A76KiLWTLRWHOrrZeJUP3E6TGTdaC23Tdpm+ZKvpa3jD+z7itgvpSIdP5/s/42yzY1goEg7KeruaB32FW2nUuPNaJfjc0l9HlnzQDZdwm5gnS11GwlFb8ydr3WR8WvT9S6I3JvxJoYp0cOiDdxFNPCoZF9D8cHTv9IrgRKXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WG02OLA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WG02OLA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A9AC19421;
	Fri,  9 Jan 2026 12:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961683;
	bh=9Uw1cIqodQK7d4IpCgrLU1sXKYnroQxCZt1Xwhgu69c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WG02OLA8TK5UQh4BKADXZ/MWUB48viDFwlst5mk5s2w3kJK83JkhUOwO8DaP+fctf
	 Tn4X1DoV5B7fP/yTmm+fMy4OmOFKBhjzAPfIJX5RboM2+LIjiE/w0NGMzaKLDRaS7m
	 75FqUX7gtYp7Lfe/JVAIzZh1i8rTDpJZH19WsyIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/634] sctp: Defer SCTP_DBG_OBJCNT_DEC() to sctp_destroy_sock().
Date: Fri,  9 Jan 2026 12:35:45 +0100
Message-ID: <20260109112119.967245124@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 622e8838a29845316668ec2e7648428878df7f9a ]

SCTP_DBG_OBJCNT_INC() is called only when sctp_init_sock()
returns 0 after successfully allocating sctp_sk(sk)->ep.

OTOH, SCTP_DBG_OBJCNT_DEC() is called in sctp_close().

The code seems to expect that the socket is always exposed
to userspace once SCTP_DBG_OBJCNT_INC() is incremented, but
there is a path where the assumption is not true.

In sctp_accept(), sctp_sock_migrate() could fail after
sctp_init_sock().

Then, sk_common_release() does not call inet_release() nor
sctp_close().  Instead, it calls sk->sk_prot->destroy().

Let's move SCTP_DBG_OBJCNT_DEC() from sctp_close() to
sctp_destroy_sock().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20251023231751.4168390-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 8a8a5cf8d8e65..090a2fadf4bb3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1552,8 +1552,6 @@ static void sctp_close(struct sock *sk, long timeout)
 	spin_unlock_bh(&net->sctp.addr_wq_lock);
 
 	sock_put(sk);
-
-	SCTP_DBG_OBJCNT_DEC(sock);
 }
 
 /* Handle EPIPE error. */
@@ -5105,9 +5103,12 @@ static void sctp_destroy_sock(struct sock *sk)
 		sp->do_auto_asconf = 0;
 		list_del(&sp->auto_asconf_list);
 	}
+
 	sctp_endpoint_free(sp->ep);
+
 	sk_sockets_allocated_dec(sk);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
+	SCTP_DBG_OBJCNT_DEC(sock);
 }
 
 /* Triggered when there are no references on the socket anymore */
-- 
2.51.0



