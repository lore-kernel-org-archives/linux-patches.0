Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D84139568;
	Tue, 14 May 2024 10:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682937; cv=none; b=c3PWOlia31h75xvsedU9dhfFUoc/9M8160ljg/X4/xqz0eOmyIY9g6JvJF3oKkvRieF8r60ABVZxMjghH+FZEo0GCoFu1TvVn+ZyW28v7HgfpDowwirHDpz5/qQ3WR5TK2XHaNEzVqeXrfldgX/5regZw6xQq5n7/RmoIhD9d44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682937; c=relaxed/simple;
	bh=s0W4/atVywLXUuSz4lbQpzVK21icb4uu9m8e12wmoh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3YJih+BrCjiaJVb86WC6oSsVxln4z+E2aNzqdrJgi9DAOy6lMD3EbwZnPfA2rx0VRmhHoNGaTMntGY+7Hw0Skt+hJrYwRMJFYsOZ1BW98QSlAo16SUKXnwrwFK58MzwVVoNht2OZkUn0F58+RzBpVsxxrSSKja14Silq2J6hgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jv3Pbrbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jv3Pbrbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42372C2BD10;
	Tue, 14 May 2024 10:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682937;
	bh=s0W4/atVywLXUuSz4lbQpzVK21icb4uu9m8e12wmoh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jv3PbrbcfeAA17et+2SzE/7Y7LVrAy+dmLvax6oV+jYFfrR/erNW6ddI7/nAmbziu
	 44IuWvu1e2JSmz07ESCHj4PgGPMJuAzD4PqBNZKF8FDbFic3lQ6ZJ6LfBCGZpp8OT5
	 EDszwlZFtk195nuT5MeFjYi0IfLCa4wDemGHRrXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linke li <lilinke99@qq.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 110/336] net: mark racy access on sk->sk_rcvbuf
Date: Tue, 14 May 2024 12:15:14 +0200
Message-ID: <20240514101042.757450610@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: linke li <lilinke99@qq.com>

[ Upstream commit c2deb2e971f5d9aca941ef13ee05566979e337a4 ]

sk->sk_rcvbuf in __sock_queue_rcv_skb() and __sk_receive_skb() can be
changed by other threads. Mark this as benign using READ_ONCE().

This patch is aimed at reducing the number of benign races reported by
KCSAN in order to focus future debugging effort on harmful races.

Signed-off-by: linke li <lilinke99@qq.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 9cf404e8038a4..599f186fe3d3a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -482,7 +482,7 @@ int __sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	unsigned long flags;
 	struct sk_buff_head *list = &sk->sk_receive_queue;
 
-	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf) {
+	if (atomic_read(&sk->sk_rmem_alloc) >= READ_ONCE(sk->sk_rcvbuf)) {
 		atomic_inc(&sk->sk_drops);
 		trace_sock_rcvqueue_full(sk, skb);
 		return -ENOMEM;
@@ -552,7 +552,7 @@ int __sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 
 	skb->dev = NULL;
 
-	if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
+	if (sk_rcvqueues_full(sk, READ_ONCE(sk->sk_rcvbuf))) {
 		atomic_inc(&sk->sk_drops);
 		goto discard_and_relse;
 	}
-- 
2.43.0



