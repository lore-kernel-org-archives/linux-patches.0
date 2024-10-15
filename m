Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87D51D0492;
	Tue, 15 Oct 2024 11:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993375; cv=none; b=PzVcdwv77kRSf0VKNar5ZOsfVXxx99V3mtLW7is5stI8P4a5SqCBHvT658xLB2usWAb70SMlzbC9vBfeVc4+hBXBfI8bczEB16nSqqQHjnrzkrOqZw34Fp/+/57KKSvm5NVlOCFKDMIokuTXxlGhdd2dDwEGR9M+vLzjt2gAfN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993375; c=relaxed/simple;
	bh=OEpuJ3s59ikJz7sxXtgYhG6ZhKfdSam4MRsjCXwIUCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/5oUaLCYrY92x/PJu4ZF1JzVTWjofNl8GaPyDMoxNXJbr1MRM2DoUPCO1GiBwzlbMhH8MZIQ3GK0o9N8s09lpGj4eCaAkaHb1UxCGiDjpaSd3mSBm53o3RI8RqdvRLbIdm/YPEdaIR0kePpssQjLouK+nnG0th3NahQd7zCixo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAaR4NhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAaR4NhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D09C4CEC6;
	Tue, 15 Oct 2024 11:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993375;
	bh=OEpuJ3s59ikJz7sxXtgYhG6ZhKfdSam4MRsjCXwIUCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAaR4NhW2/9GUs1O6/zsyhTAfEmv8PWvoUcUtPXHkDL13rF3/cFXzNino71ARKA4W
	 NpnwM1OPCM7SaYkvfLOZ8+RbNqWAu5nomactNfOx1srRmGmKRioGJ8JvD70GfA9eiU
	 VB99ZCQphYguBsaKQVaXjxniSTOioqShxbv1wyZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f4e0f821e3a3b7cee51d@syzkaller.appspotmail.com,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 393/691] sctp: set sk_state back to CLOSED if autobind fails in sctp_listen_start
Date: Tue, 15 Oct 2024 13:25:41 +0200
Message-ID: <20241015112455.937342780@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 8beee4d8dee76b67c75dc91fd8185d91e845c160 ]

In sctp_listen_start() invoked by sctp_inet_listen(), it should set the
sk_state back to CLOSED if sctp_autobind() fails due to whatever reason.

Otherwise, next time when calling sctp_inet_listen(), if sctp_sk(sk)->reuse
is already set via setsockopt(SCTP_REUSE_PORT), sctp_sk(sk)->bind_hash will
be dereferenced as sk_state is LISTENING, which causes a crash as bind_hash
is NULL.

  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: 0010:sctp_inet_listen+0x7f0/0xa20 net/sctp/socket.c:8617
  Call Trace:
   <TASK>
   __sys_listen_socket net/socket.c:1883 [inline]
   __sys_listen+0x1b7/0x230 net/socket.c:1894
   __do_sys_listen net/socket.c:1902 [inline]

Fixes: 5e8f3f703ae4 ("sctp: simplify sctp listening code")
Reported-by: syzbot+f4e0f821e3a3b7cee51d@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://patch.msgid.link/a93e655b3c153dc8945d7a812e6d8ab0d52b7aa0.1727729391.git.lucien.xin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9fe13de66b272..2818cf160f3a3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8542,8 +8542,10 @@ static int sctp_listen_start(struct sock *sk, int backlog)
 	 */
 	inet_sk_set_state(sk, SCTP_SS_LISTENING);
 	if (!ep->base.bind_addr.port) {
-		if (sctp_autobind(sk))
+		if (sctp_autobind(sk)) {
+			inet_sk_set_state(sk, SCTP_SS_CLOSED);
 			return -EAGAIN;
+		}
 	} else {
 		if (sctp_get_port(sk, inet_sk(sk)->inet_num)) {
 			inet_sk_set_state(sk, SCTP_SS_CLOSED);
-- 
2.43.0



