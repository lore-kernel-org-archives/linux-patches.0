Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6B73FB1B;
	Mon, 23 Jun 2025 21:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715756; cv=none; b=spO2X0m1An+TWqKm/5uKwSiYTQyZ0TxoYqAh/cHNU4v87+g3f3/JWA03ysjymW+A5TVTmNSTTK8dV55h4EIEjIiy07XwX5KlylAU86S8yRraI0gH6iVF4pmJjtbB+BrbAdzwSU/9qnMs/dhS9rpY/I0vwEzu/YUU2QWY1C0Zj64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715756; c=relaxed/simple;
	bh=qtbesaYpnjHqh1An9KtbgwI6h8dKoS4DyGuP/upngXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QN6yZ8Lejnf0QuQKcyTjiXMIh7At0qrUja87t5U114kyVRE8wZ3L8//3gzaba1iddlO6q10A4kykBL75QnN6jQlplmoIJ/UR5RbQXV+OIedRYPjOlOyM9R3zoqGOIyYo4xHtJ53HHWBis7etrhiNlO5jnqg9sb5Ub5CXv6QSMzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONUMpYJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONUMpYJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C6AC4CEEA;
	Mon, 23 Jun 2025 21:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715756;
	bh=qtbesaYpnjHqh1An9KtbgwI6h8dKoS4DyGuP/upngXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONUMpYJRnU7ygmPGtlgSY3DQe/PMDDYnP3UPkD+HmEdGO6c7vnO0astEndwUC/z4u
	 tTOed/ZeIePURwHbDv+LGwooo4vYDGIB544u9Lrh7foYK6ay/Ybo3V5jf/gNvdDTwh
	 Lho2az5cluE6eh1EfOLF0k6Tf1zv0pyCw8MRbkaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Malat <oss@malat.biz>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 205/414] sctp: Do not wake readers in __sctp_write_space()
Date: Mon, 23 Jun 2025 15:05:42 +0200
Message-ID: <20250623130647.131360971@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 53725ee7ba06d..b301d64d9d80f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9100,7 +9100,8 @@ static void __sctp_write_space(struct sctp_association *asoc)
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



