Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C00F221DA8;
	Mon, 23 Jun 2025 21:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715885; cv=none; b=g6tx/du1N3PYnceqYcHImF7LzEUz+hLsMW4XzeQOUHyQM1+qgub1qtn9UUJEwEFO0CTgnrmJ36D77UIhh8zt6ovQv/mRauQTCvN5FSuN7IgiCArbvysboUqIDoRoSz8zf3uZWqWvLD9100GWWzGuC0iSCmpwtP6siPfiw8Hhv44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715885; c=relaxed/simple;
	bh=trYDsY2WqqIOW2xxPqg5XGq2uShNWjzmi3JikBgI6/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZIBA+atWluFYif7FtNFPuTgOWHa4xWDioaLf9rShwPDuHWwpA6kjlZlUYlDiA0M1mBBcDPjN/KtHkLHBm87GJa18QDkKz9bDnlm0ijwkf9sPHY42/6ldTj6P2im7vay5sIdxwgbgHiYTglkAohiDc9IjdsqiiQRj+aYR7HUynA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7hmwqP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7hmwqP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130F7C4CEEA;
	Mon, 23 Jun 2025 21:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715885;
	bh=trYDsY2WqqIOW2xxPqg5XGq2uShNWjzmi3JikBgI6/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7hmwqP6dLUze9XX8a7bTfAhvQG5LxWRZ/zs5bNBc8MYaGOIinb3MhJM6RJUfIeqd
	 urqW9441boEUlR0NjV1t7BeiTDooJ0t4F0t7nI3yShYhThSZJAyZRumLVkJ9Ac5qoS
	 BrvW1ccwkI3VGGcmH9lYZv7A4vBScAzhgOTexATA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Malat <oss@malat.biz>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 310/411] sctp: Do not wake readers in __sctp_write_space()
Date: Mon, 23 Jun 2025 15:07:34 +0200
Message-ID: <20250623130641.446279418@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5e84083e50d7a..0aaea911b21ef 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9092,7 +9092,8 @@ static void __sctp_write_space(struct sctp_association *asoc)
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



