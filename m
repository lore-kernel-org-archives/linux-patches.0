Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58F52210D5;
	Thu, 12 Dec 2024 15:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018053; cv=none; b=kYtZRD0+LMsAeboUXDW9NXTyTSi3L5C3FTJaU6W4PHnF/jGQXBMr44Y+Uf/9T4PhXv9mkAOPLPBMS8c4/XsLb8zQmYFnvEe1RVVHVpaM77BvUmrvxiiENpAumLoJtZchOIQotvt1rXzLslbUMRRGQNC065QHzk1wbmFvwvwOhO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018053; c=relaxed/simple;
	bh=xzCpKEO9pdP6tofcEUof7P5zkhL/+TwzRQjhEagoOCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LnjdM/n0AhsmE1puWte9vi2SOE9KxVBxSjfxil72z4lXjqB3ULh4WwNjeaB4pS71BaSzUMQQCQEFRRNs+qtOzfZwXdYB1PHTaFi9CEBkrWr2t7XOD4fgZUCnMloCtbyCiPntfNOfv46FyPj/9Zg0Gbgw6DcThautIb0LYRBNEQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvvTnbAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvvTnbAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B54C4CECE;
	Thu, 12 Dec 2024 15:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018053;
	bh=xzCpKEO9pdP6tofcEUof7P5zkhL/+TwzRQjhEagoOCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvvTnbAPUqTzNoh+Z/+e96GvXk+Tbt9cBbZnElF3xBFwyE8C+Su3rddaH7qOsz16z
	 7iFD9/7AEKc6rf9SSc3I3UAntWpOm3uRqM0IKraYj6Kb+pJIEC1h/rmlluZTBvQuSU
	 kZwQpn2WWC3Lu31Rj6iybu7vA1zuXXaTFcEqssyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	syzbot+3b6b32dc50537a49bb4a@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/356] epoll: annotate racy check
Date: Thu, 12 Dec 2024 15:58:23 +0100
Message-ID: <20241212144251.899211347@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0ed73bc7d4652..bcaad495930c3 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -741,7 +741,8 @@ static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
 	to_free = NULL;
 	head = file->f_ep;
 	if (head->first == &epi->fllink && !epi->fllink.next) {
-		file->f_ep = NULL;
+		/* See eventpoll_release() for details. */
+		WRITE_ONCE(file->f_ep, NULL);
 		if (!is_file_epoll(file)) {
 			struct epitems_head *v;
 			v = container_of(head, struct epitems_head, epitems);
@@ -1498,7 +1499,8 @@ static int attach_epitem(struct file *file, struct epitem *epi)
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



