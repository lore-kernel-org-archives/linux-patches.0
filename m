Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0F8223E93;
	Thu, 12 Dec 2024 16:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021087; cv=none; b=emDuc52SB7U9MAd4ykVrzqEpyg++LH9nEaQazHpte+blC1uEJuDSM4Lgy3ceidQQjB9as5f32PIZ57pwGn1lUDnKuc7k9ah6ulaXLG5b9Hbz4oNZ1cXeDCJJuXy9CfugzYAdW4jQbyhfAapqDKkvE2yRKBBfZM57OU04KVc6t8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021087; c=relaxed/simple;
	bh=AXN+Lg+h4fZYHkVP/CM4iIU/0wZBo3C5DKlu3w7tdLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7segwDfgPoEdfIbB2eDmwlqhgeKwrffb+vttadbOBVZJ/6+M178XZHc30mXFEjdxkXTvd9Y1j5sy0T+7w/rlbkcN0OVmbgNptHNKvMVx0hq3/K0N1Jo2jLlT/JksieMT3VcUy8lOhjM7rQljE+z6d7XLEoNHPHkKGM19+eHNJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TglzQnOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TglzQnOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC45C4CECE;
	Thu, 12 Dec 2024 16:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021086;
	bh=AXN+Lg+h4fZYHkVP/CM4iIU/0wZBo3C5DKlu3w7tdLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TglzQnOOEA1IXs24m1gz1fSY5mhHBjv0XE6A/z2k14M2T1m1SufYkM9ufpVQbYDrN
	 zkprFqTP3lggjZ28i3MJDagjacVsSuEt/mlWxbpbgTKhJFsJazbY73m0zM3gE3FWmn
	 Ob/e7bTOGOoaDB2r0v6+bHL3rExDQkLhX8oD50H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	syzbot+3b6b32dc50537a49bb4a@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 641/772] epoll: annotate racy check
Date: Thu, 12 Dec 2024 15:59:46 +0100
Message-ID: <20241212144416.417384959@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 6474353a5e3d0b2cf610153cea0c61f576a36d0a ]

Epoll relies on a racy fastpath check during __fput() in
eventpoll_release() to avoid the hit of pointlessly acquiring a
semaphore. Annotate that race by using WRITE_ONCE() and READ_ONCE().

Link: https://lore.kernel.org/r/66edfb3c.050a0220.3195df.001a.GAE@google.com
Link: https://lore.kernel.org/r/20240925-fungieren-anbauen-79b334b00542@brauner
Reviewed-by: Jan Kara <jack@suse.cz>
Reported-by: syzbot+3b6b32dc50537a49bb4a@syzkaller.appspotmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c            | 6 ++++--
 include/linux/eventpoll.h | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 7221072f39fad..f296ffb57d052 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -703,7 +703,8 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 	to_free = NULL;
 	head = file->f_ep;
 	if (head->first == &epi->fllink && !epi->fllink.next) {
-		file->f_ep = NULL;
+		/* See eventpoll_release() for details. */
+		WRITE_ONCE(file->f_ep, NULL);
 		if (!is_file_epoll(file)) {
 			struct epitems_head *v;
 			v = container_of(head, struct epitems_head, epitems);
@@ -1467,7 +1468,8 @@ static int attach_epitem(struct file *file, struct epitem *epi)
 			spin_unlock(&file->f_lock);
 			goto allocate;
 		}
-		file->f_ep = head;
+		/* See eventpoll_release() for details. */
+		WRITE_ONCE(file->f_ep, head);
 		to_free = NULL;
 	}
 	hlist_add_head_rcu(&epi->fllink, file->f_ep);
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 3337745d81bd6..0c0d00fcd131f 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -42,7 +42,7 @@ static inline void eventpoll_release(struct file *file)
 	 * because the file in on the way to be removed and nobody ( but
 	 * eventpoll ) has still a reference to this file.
 	 */
-	if (likely(!file->f_ep))
+	if (likely(!READ_ONCE(file->f_ep)))
 		return;
 
 	/*
-- 
2.43.0



