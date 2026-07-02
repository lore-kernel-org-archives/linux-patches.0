Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485E833A71B;
	Thu,  2 Jul 2026 16:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010184; cv=none; b=G9Jw8DapqBSwnW1QEHeTZZTcoFJpIg3h4yrgHEbFzxAlej1YDKsS7L7SDfzTdRhG1qVFmsD0NwUsV5fn4IMmzATFCJmtO6C4fHstqiSzB4zM3xIfpmk8KA62tAX/N8vz8BuR70plDyV2nIRF2Oi9toxz3UKvh2JSCU2e8XsYuWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010184; c=relaxed/simple;
	bh=xJZkS6XvHSFVDFEQvHqYpAqjcGQYFKMtq/oHMCh66pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzWO/jKgJhQp3KBARzG5SsmMSMv7CIkJwu+tjRKMDYbll9oRmRpqgeZCV377wm/IeIHUvS9HCbFkEhIdPVzsi7lp2jKw+8RBACeGb3IMVgfLDX3vqu0FsZRQF7SSmOIfdAqpB2G7EkK2Ks0tY1G+aL/coljFh1JZJb6b7m7w6rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJGQnFab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJGQnFab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F101F000E9;
	Thu,  2 Jul 2026 16:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010182;
	bh=+lxHR5FNE+xfppGNp+8shAdFA/2p3gKoYXz2NPRKAWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uJGQnFabtNwMMbv1aVyk9JjBHw35Y4K62wPONtJfEHPTn8uLg04C06pqcrSmWj2O1
	 ymhniTByhP3L+YxFPic1dORl+fKB/v5HX/EQsQrP4vnpOOEzkpwwBr2sGbbPmlFMya
	 UeUj7BFsM5Rl17i+mAfPWY2czy8dxwIH7IR5IWbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/204] eventpoll: split __ep_remove()
Date: Thu,  2 Jul 2026 18:17:50 +0200
Message-ID: <20260702155118.948184868@linuxfoundation.org>
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

[ Upstream commit 0f7bdfd413000985de09fc39eb9efa1e091a3ce0 ]

Split __ep_remove() to delineate file removal from epoll item removal.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://patch.msgid.link/20260423-work-epoll-uaf-v1-2-2470f9eec0f5@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: a6dc643c6931 ("eventpoll: fix ep_remove struct eventpoll / struct file UAF")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8f9dc2f4891ff5..1cba4ae4a076bc 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -797,6 +797,9 @@ static void ep_free(struct eventpoll *ep)
 	kfree_rcu(ep, rcu);
 }
 
+static void __ep_remove_file(struct eventpoll *ep, struct epitem *epi, struct file *file);
+static bool __ep_remove_epi(struct eventpoll *ep, struct epitem *epi);
+
 /*
  * Removes a "struct epitem" from the eventpoll RB tree and deallocates
  * all the associated resources. Must be called with "mtx" held.
@@ -808,8 +811,6 @@ static void ep_free(struct eventpoll *ep)
 static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
 {
 	struct file *file = epi->ffd.file;
-	struct epitems_head *to_free;
-	struct hlist_head *head;
 
 	lockdep_assert_irqs_enabled();
 
@@ -825,8 +826,21 @@ static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
 		return false;
 	}
 
-	to_free = NULL;
-	head = file->f_ep;
+	__ep_remove_file(ep, epi, file);
+	return __ep_remove_epi(ep, epi);
+}
+
+/*
+ * Called with &file->f_lock held,
+ * returns with it released
+ */
+static void __ep_remove_file(struct eventpoll *ep, struct epitem *epi, struct file *file)
+{
+	struct epitems_head *to_free = NULL;
+	struct hlist_head *head = file->f_ep;
+
+	lockdep_assert_held(&ep->mtx);
+
 	if (hlist_is_singular_node(&epi->fllink, head)) {
 		/* See eventpoll_release() for details. */
 		WRITE_ONCE(file->f_ep, NULL);
@@ -840,6 +854,11 @@ static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
 	hlist_del_rcu(&epi->fllink);
 	spin_unlock(&file->f_lock);
 	free_ephead(to_free);
+}
+
+static bool __ep_remove_epi(struct eventpoll *ep, struct epitem *epi)
+{
+	lockdep_assert_held(&ep->mtx);
 
 	rb_erase_cached(&epi->rbn, &ep->rbr);
 
-- 
2.53.0



