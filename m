Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5200A4772BE;
	Fri,  7 Aug 2026 15:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114809; cv=none; b=HRO7wq8hCtF9nRI8xH/BgSjYqpBjxV+di1AQKQRTyR2wl4Ghc8t0j7S5JnRA9BvMsPx9mbXGVvQiVEQmEpGKMkhQppg21P2pfQWGKmjyQE/R+iUjcnppqYaN/BVVo7w97kTTIPQ9FelqTAABUgDicfvF7ECl7B9xUDW6AAyifuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114809; c=relaxed/simple;
	bh=bCaaWvp3mXU3gxCxjmfoPGwrzQyFzYZBBdNy2w1PnCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMdq4gnHFXols8DQLvpbNW8wJKovDXv2E/iybrNj5Pnzb+hjqNkWNcp3TpW+7HAqsd97agqOP3Dy3a8EqMng15NZ200fqnYFrWIVhpTgO+pTmFCbazvqrv8uttzGW2otYMEbOmovsfi6n9DD7El4hYHf4n0IufLQOzaXQayGpAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOP6krlk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOP6krlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCD61F000E9;
	Fri,  7 Aug 2026 15:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114808;
	bh=g2w20/SUpJ0ogKeJya14VHZmkVO+3OdwXQgQ7gVpsgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kOP6krlkeyTKYDr/Jj+JBkZ/hEKIsb71gW2L/vTy3G6dhiFFfwCwCsYSjzjhXgqj3
	 5uWoxq37TbDzb/XdS0nrF52GR++eRKFG3+Msvrau7QTW+lpt0xBzZc1+lr3QDjtUWO
	 B28kCs2w6k+Dlyjg4y+WnXb9bqL1irhR8Rz4kwEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ericson <mail@johnericson.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 056/396] af_unix: fix listen() succeeding on sockets in the wrong state
Date: Fri,  7 Aug 2026 16:33:36 +0200
Message-ID: <20260807143425.479634359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ericson <mail@johnericson.me>

[ Upstream commit f0d9c3ffc2b5fc2ffacb56b3036155ce7a940a12 ]

Commit fd0a109a0f6b ("net, pidfs: prepare for handing out pidfds for
reaped sk->sk_peer_pid") inserted a prepare_peercred() call between err
= -EINVAL and the socket-state check in unix_listen(). Since
prepare_peercred() leaves err at 0 on success, listen() on an AF_UNIX
socket that is not in TCP_CLOSE or TCP_LISTEN state (e.g. one that is
already connected) now silently returns success without doing anything,
instead of failing with EINVAL as it did before.

Fixes: fd0a109a0f6b ("net, pidfs: prepare for handing out pidfds for reaped sk->sk_peer_pid")
Signed-off-by: John Ericson <mail@johnericson.me>
Link: https://patch.msgid.link/20260718182903.2295560-1-John.Ericson@Obsidian.Systems
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index b65479a738f4c..52b17331e9d51 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -835,6 +835,7 @@ static int unix_listen(struct socket *sock, int backlog)
 	if (err)
 		goto out;
 	unix_state_lock(sk);
+	err = -EINVAL;
 	if (sk->sk_state != TCP_CLOSE && sk->sk_state != TCP_LISTEN)
 		goto out_unlock;
 	if (backlog > sk->sk_max_ack_backlog)
-- 
2.53.0



