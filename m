Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E081E1A05;
	Mon, 23 Jun 2025 21:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715117; cv=none; b=iW39lqwYMNVLsQgTKW5qH1rT9tRkOBsgLtSRwKxqmMI1WsNH7XstRIazM1AJC4x2uOLpxnRr5MKQqG7A5qxuacncTJ4EBW7fiz9eD3/6ca8weyloDSJXv+fm9rWpDGOKO76pzLaZrE1jTn9YKSYnj6RWTQ6i+Rn7NmcDyL6ltMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715117; c=relaxed/simple;
	bh=S/RnSST8mWOiqg4ik+WJOtxBu9qBGdI2hvZZLIsop+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYGjYr5Z0a03PzaSx6VZWM50pEHhMYJsClhd9SU/o8JNLJ3yuMfJYt+5CZDylYf/2Ljs01v6E1OcVPPlAm3PXsj4p4gWEWx0vYMGIxscuv/RQ6AytIB+o0oktokxUrlPJOuzk9LA0xbT9f8HeBJxthcrt1dj7obd0Yyd9t/urgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nY7sOFz/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nY7sOFz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09744C4CEEA;
	Mon, 23 Jun 2025 21:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715115;
	bh=S/RnSST8mWOiqg4ik+WJOtxBu9qBGdI2hvZZLIsop+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nY7sOFz/DCdtbdBJOSSrBbf6s11jfRUdZe0UTrdD8hCEhv3isQJaEIS/d/mEax9DF
	 /zEWw90e5Y97WYpLIYlbMLKndNJGaEfX6ICd7ABIa7OMlGkudzd1OqnpPgGM7Fpm/F
	 zT7RSjhP3CYbOcp/eJvHNB8Qx+uwA5CpES3MuuTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Malat <oss@malat.biz>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 253/355] sctp: Do not wake readers in __sctp_write_space()
Date: Mon, 23 Jun 2025 15:07:34 +0200
Message-ID: <20250623130634.357620009@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Malat <oss@malat.biz>

[ Upstream commit af295892a7abbf05a3c2ba7abc4d81bb448623d6 ]

Function __sctp_write_space() doesn't set poll key, which leads to
ep_poll_callback() waking up all waiters, not only these waiting
for the socket being writable. Set the key properly using
wake_up_interruptible_poll(), which is preferred over the sync
variant, as writers are not woken up before at least half of the
queue is available. Also, TCP does the same.

Signed-off-by: Petr Malat <oss@malat.biz>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20250516081727.1361451-1-oss@malat.biz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 3d6c9e35781e9..196196ebe81a9 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8849,7 +8849,8 @@ static void __sctp_write_space(struct sctp_association *asoc)
 		wq = rcu_dereference(sk->sk_wq);
 		if (wq) {
 			if (waitqueue_active(&wq->wait))
-				wake_up_interruptible(&wq->wait);
+				wake_up_interruptible_poll(&wq->wait, EPOLLOUT |
+						EPOLLWRNORM | EPOLLWRBAND);
 
 			/* Note that we try to include the Async I/O support
 			 * here by modeling from the current TCP/UDP code.
-- 
2.39.5



