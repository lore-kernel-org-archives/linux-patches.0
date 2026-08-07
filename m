Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582B747278C;
	Fri,  7 Aug 2026 15:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116861; cv=none; b=BjklXStMoJN7GP1WlN+cxb2tuxEW6UlyLwTdpLvh3YEQvnYxB/ObivZSkCm0KFbzbrZGVtHqPTEZraEHQuVPMaTCsUuzcS0l8QuVvnv5XMRu+WTz9gOst0smNy2W9txwi3hM1Xmz2DUpWC3REIGnUYkcWAq3IGQzHKcCoPMCWHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116861; c=relaxed/simple;
	bh=t160CjPKutJ7ysGYEmR8XvAwk+idUppjKX+qz0nBk6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csJuXrbKHqL8TnA21lNEJsaXyPyjNHb6qmXobA9dGCWhmXt5k8P7ar67hrfNukqVUBeia76QT1hzC9qWoKcVORUVlomGUD7J8CFZ2Tlyt46Z7lDV1bNaVOfJfUyRSleRlDzoxvfpiJMzs83tdDI/vxWRiNmU8RZSf87EZjh5ilc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ywh8kxll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ywh8kxll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779BC1F00A3A;
	Fri,  7 Aug 2026 15:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116860;
	bh=wloUCSkIiMLfeitwhg5BQdZUysVJAIigpxs7URRtHvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ywh8kxll3H9/JCKgw8jAfJ5f4QDLSFP5LsNrmqv6WFSuTa8cDOaHI5WBJItJZUwov
	 yuPGXNGzoPsLypPjc3QKioWVKL6h6/ySlnR+0OoT3lPo9F3Bsfse06+zrAnFpNI3+e
	 rUgJGkztrTuKwQd8eVqnqSC78OxoiNKcGdzMjd1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ericson <mail@johnericson.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 071/438] af_unix: fix listen() succeeding on sockets in the wrong state
Date: Fri,  7 Aug 2026 16:34:27 +0200
Message-ID: <20260807143429.501248788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0d9cd977c7b78..bb01d5371dc85 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -823,6 +823,7 @@ static int unix_listen(struct socket *sock, int backlog)
 	if (err)
 		goto out;
 	unix_state_lock(sk);
+	err = -EINVAL;
 	if (sk->sk_state != TCP_CLOSE && sk->sk_state != TCP_LISTEN)
 		goto out_unlock;
 	if (backlog > sk->sk_max_ack_backlog)
-- 
2.53.0



