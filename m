Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8C534104B;
	Tue, 16 Dec 2025 11:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884049; cv=none; b=VNdu/tyR8yxA7ygjnywBz6gGTPZ5oJqX2uaS3EJByhMXk1Zzt6yTvSfSG7HeAGNilaEJVhATqoIhrUW9WCwiyv0bYS9NXq1tvI6IUI0tDqR+yd1/W/rDQvpChqxZIiNi14eTAJt/VVKEWsq257gMbN+UbvxEiD2R7Fyu/UZ/5bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884049; c=relaxed/simple;
	bh=yavK9OLnosTymexrC0YSQiNr/n75mRmOeN3e2+q7L9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVEB9cjnhK7C2SQzCRz9LYpJJL+dozo2+pix8jdk9+Et4SChymAb4PcE2PpNdJUos76ynZcl+mA498LUQYaKixvRGjWptV6PzSNhwKU6akWkJxG58svJPH1dH0mDLBz5VcyaLdcFtlTAUI1q6v/a3Y6o7AQVIKJAO5G2iye+Kgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUpzpHDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUpzpHDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F11C4CEF1;
	Tue, 16 Dec 2025 11:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884049;
	bh=yavK9OLnosTymexrC0YSQiNr/n75mRmOeN3e2+q7L9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUpzpHDSI9ZLDkZfQmGPwU2d+2U32F5JopK1MYYMKY4Di9a3Y6WOCXe7JvoWtQyHb
	 cenx0yORStnPCNgs3+nOt7EwRTKrt4Ic/StZYnAMwuHheRCmLlW1f016pA2lQj8rtC
	 XL1xCMzr7nlWQJNuLhYTn1PVj9l4Cw76BI6tM07s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/354] sctp: Defer SCTP_DBG_OBJCNT_DEC() to sctp_destroy_sock().
Date: Tue, 16 Dec 2025 12:10:45 +0100
Message-ID: <20251216111323.750767958@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b301d64d9d80f..b6956b25b33d3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1554,8 +1554,6 @@ static void sctp_close(struct sock *sk, long timeout)
 	spin_unlock_bh(&net->sctp.addr_wq_lock);
 
 	sock_put(sk);
-
-	SCTP_DBG_OBJCNT_DEC(sock);
 }
 
 /* Handle EPIPE error. */
@@ -5112,9 +5110,12 @@ static void sctp_destroy_sock(struct sock *sk)
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



