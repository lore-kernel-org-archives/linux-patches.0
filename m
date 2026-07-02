Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCE733EB1A;
	Thu,  2 Jul 2026 16:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010241; cv=none; b=kHtyBf5LtMGb1M3IB+pkcZvNZGC+dhhTrpMi9fH7XyOcmeXpq/l+2KAg4pwkk74prUAhfQdGDYTfOZE6KOem/R6PAF/sfs+LpNs6WrLOY7T7+5ZZMfCnBolNvkK30RlNvKaBl2zRW+1xCzc/VqF4wkqL7T5aWUjVBIi+I+NA7lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010241; c=relaxed/simple;
	bh=tMC7hDAmUvR8GSw9Y6GOUcUadVwAXtLMZNzL+bvlDkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArON61EEt2LpQWxJLxNW0qVL8i7oH96EPBETwrA0Q3Q2Ru3OXmuM9OHNVZeoTRfEm7IBYAMnY9FRHNtksvlq4H5YdNyDfEXFK3Ht7pmKVzkDqBGBnvZoovzpiUxJ8Q+kIIrreosEhQ9wLrQwkJ39TylMWmKXtLwbqjL+V8G5eKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9M62Ux0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9M62Ux0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C9B1F000E9;
	Thu,  2 Jul 2026 16:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010240;
	bh=0Wot5yedPxjh3xpEhVuPxGXp9RZLQHmwTGdoXDO5iME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b9M62Ux0AT/0MXRrZRtcDCtkj2qhpvDvukDJfsagn6KTVgtNLtW+iF8yXB+v0bAlY
	 E3eT200qSrO7moBWy9iTMStYvy7hfrhvXNv3wdkG7ijX2NTVfiM+fbxfk+WdVppo/e
	 YxmQ0boHgfmK42EDe1dgXC7EsghkNvaR/4lPXQPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/204] eventpoll: move epi_fget() up
Date: Thu,  2 Jul 2026 18:17:54 +0200
Message-ID: <20260702155119.028908207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 86e87059e6d1fd5115a31949726450ed03c1073b ]

We'll need it when removing files so move it up. No functional change.

Link: https://patch.msgid.link/20260423-work-epoll-uaf-v1-5-2470f9eec0f5@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: a6dc643c6931 ("eventpoll: fix ep_remove struct eventpoll / struct file UAF")
[file_ref_get(&file->f_ref) from original commit left as
 atomic_long_inc_not_zero(&file->f_count) due to v6.12.y missing commit
 90ee6ed776c0 ("fs: port files to file_ref") and its dependent commit
 08ef26ea9ab3 ("fs: add file_ref")]
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 56 +++++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 27280ba4f3d5be..2993b76c21f682 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -797,6 +797,34 @@ static void ep_free(struct eventpoll *ep)
 	kfree_rcu(ep, rcu);
 }
 
+/*
+ * The ffd.file pointer may be in the process of being torn down due to
+ * being closed, but we may not have finished eventpoll_release() yet.
+ *
+ * Normally, even with the atomic_long_inc_not_zero, the file may have
+ * been free'd and then gotten re-allocated to something else (since
+ * files are not RCU-delayed, they are SLAB_TYPESAFE_BY_RCU).
+ *
+ * But for epoll, users hold the ep->mtx mutex, and as such any file in
+ * the process of being free'd will block in eventpoll_release_file()
+ * and thus the underlying file allocation will not be free'd, and the
+ * file re-use cannot happen.
+ *
+ * For the same reason we can avoid a rcu_read_lock() around the
+ * operation - 'ffd.file' cannot go away even if the refcount has
+ * reached zero (but we must still not call out to ->poll() functions
+ * etc).
+ */
+static struct file *epi_fget(const struct epitem *epi)
+{
+	struct file *file;
+
+	file = epi->ffd.file;
+	if (!atomic_long_inc_not_zero(&file->f_count))
+		file = NULL;
+	return file;
+}
+
 /*
  * Called with &file->f_lock held,
  * returns with it released
@@ -989,34 +1017,6 @@ static __poll_t __ep_eventpoll_poll(struct file *file, poll_table *wait, int dep
 	return res;
 }
 
-/*
- * The ffd.file pointer may be in the process of being torn down due to
- * being closed, but we may not have finished eventpoll_release() yet.
- *
- * Normally, even with the atomic_long_inc_not_zero, the file may have
- * been free'd and then gotten re-allocated to something else (since
- * files are not RCU-delayed, they are SLAB_TYPESAFE_BY_RCU).
- *
- * But for epoll, users hold the ep->mtx mutex, and as such any file in
- * the process of being free'd will block in eventpoll_release_file()
- * and thus the underlying file allocation will not be free'd, and the
- * file re-use cannot happen.
- *
- * For the same reason we can avoid a rcu_read_lock() around the
- * operation - 'ffd.file' cannot go away even if the refcount has
- * reached zero (but we must still not call out to ->poll() functions
- * etc).
- */
-static struct file *epi_fget(const struct epitem *epi)
-{
-	struct file *file;
-
-	file = epi->ffd.file;
-	if (!atomic_long_inc_not_zero(&file->f_count))
-		file = NULL;
-	return file;
-}
-
 /*
  * Differs from ep_eventpoll_poll() in that internal callers already have
  * the ep->mtx so we need to start from depth=1, such that mutex_lock_nested()
-- 
2.53.0



