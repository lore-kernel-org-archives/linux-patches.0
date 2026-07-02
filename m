Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D10F3382DA;
	Thu,  2 Jul 2026 16:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010187; cv=none; b=EK0DegvJ61qdJGe++GtT6fS5M97BUuaZJ6I3DOILsupmg+/jgFttsECU2Eq1VgScnf5nUlpNcJxyBQNOmUdojSaQWJ/BBRf+qv2dqj3fiVf+Ccq1u1oN3sywyfzb8uiFJPEIUkesbQ+aV8fmjzZOQRWfpMiJUgpz4NmxcOsUTx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010187; c=relaxed/simple;
	bh=3FI75fv+PteERxFYfCAkyoWyRfQs02oM8+nvwnNxH1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNgpVdwMANit9W0h8N0/UGALKnOY1iDItO27k/Xun35km7aYp9HxrY2Hbd/LzB2K15Wh6CZCsExDldMm9ONqad+oTugImwpzcGjFdT7x6yKGtKvCek7zgBcujeQzZ0lOlwEeX13urXt86tZOR0aR/Ley3mpa4JU5+/3KpoSDUiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dcm/foLo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dcm/foLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6551F000E9;
	Thu,  2 Jul 2026 16:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010185;
	bh=DIhky52MxbWhvOdz1M1K+KNib0chqHVvhQ+1y+tOkiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dcm/foLowWpvChf4M27KCXTJwXpfVa9jqDcP3ux7PzmYMpgUxap4K4S+10Xx53RO7
	 s4Z8VdCoAg1UgGEEFU9VXJGUAxJ8TmFV1aOaAWCOk9oqADU+ryxwA/Rpf4BDKkObsk
	 xINRLBcrtVWwvV99rF4hPYmimgTISqxR5jgeVIpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/204] eventpoll: kill __ep_remove()
Date: Thu,  2 Jul 2026 18:17:51 +0200
Message-ID: <20260702155118.968436907@linuxfoundation.org>
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

[ Upstream commit e9e5cd40d7c403e19f21d0f7b8b8ba3a76b58330 ]

Remove the boolean conditional in __ep_remove() and restructure the code
so the check for racing with eventpoll_release_file() are only done in
the ep_remove_safe() path where they belong.

Link: https://patch.msgid.link/20260423-work-epoll-uaf-v1-3-2470f9eec0f5@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: a6dc643c6931 ("eventpoll: fix ep_remove struct eventpoll / struct file UAF")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 67 ++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 37 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 1cba4ae4a076bc..3ac8a26c3522f6 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -797,49 +797,18 @@ static void ep_free(struct eventpoll *ep)
 	kfree_rcu(ep, rcu);
 }
 
-static void __ep_remove_file(struct eventpoll *ep, struct epitem *epi, struct file *file);
-static bool __ep_remove_epi(struct eventpoll *ep, struct epitem *epi);
-
-/*
- * Removes a "struct epitem" from the eventpoll RB tree and deallocates
- * all the associated resources. Must be called with "mtx" held.
- * If the dying flag is set, do the removal only if force is true.
- * This prevents ep_clear_and_put() from dropping all the ep references
- * while running concurrently with eventpoll_release_file().
- * Returns true if the eventpoll can be disposed.
- */
-static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
-{
-	struct file *file = epi->ffd.file;
-
-	lockdep_assert_irqs_enabled();
-
-	/*
-	 * Removes poll wait queue hooks.
-	 */
-	ep_unregister_pollwait(ep, epi);
-
-	/* Remove the current item from the list of epoll hooks */
-	spin_lock(&file->f_lock);
-	if (epi->dying && !force) {
-		spin_unlock(&file->f_lock);
-		return false;
-	}
-
-	__ep_remove_file(ep, epi, file);
-	return __ep_remove_epi(ep, epi);
-}
-
 /*
  * Called with &file->f_lock held,
  * returns with it released
  */
-static void __ep_remove_file(struct eventpoll *ep, struct epitem *epi, struct file *file)
+static void __ep_remove_file(struct eventpoll *ep, struct epitem *epi,
+			     struct file *file)
 {
 	struct epitems_head *to_free = NULL;
 	struct hlist_head *head = file->f_ep;
 
 	lockdep_assert_held(&ep->mtx);
+	lockdep_assert_held(&file->f_lock);
 
 	if (hlist_is_singular_node(&epi->fllink, head)) {
 		/* See eventpoll_release() for details. */
@@ -886,7 +855,25 @@ static bool __ep_remove_epi(struct eventpoll *ep, struct epitem *epi)
  */
 static void ep_remove_safe(struct eventpoll *ep, struct epitem *epi)
 {
-	if (__ep_remove(ep, epi, false))
+	struct file *file = epi->ffd.file;
+
+	lockdep_assert_irqs_enabled();
+	lockdep_assert_held(&ep->mtx);
+
+	ep_unregister_pollwait(ep, epi);
+
+	/* sync with eventpoll_release_file() */
+	if (unlikely(READ_ONCE(epi->dying)))
+		return;
+
+	spin_lock(&file->f_lock);
+	if (epi->dying) {
+		spin_unlock(&file->f_lock);
+		return;
+	}
+	__ep_remove_file(ep, epi, file);
+
+	if (__ep_remove_epi(ep, epi))
 		WARN_ON_ONCE(ep_refcount_dec_and_test(ep));
 }
 
@@ -1118,7 +1105,7 @@ void eventpoll_release_file(struct file *file)
 	spin_lock(&file->f_lock);
 	if (file->f_ep && file->f_ep->first) {
 		epi = hlist_entry(file->f_ep->first, struct epitem, fllink);
-		epi->dying = true;
+		WRITE_ONCE(epi->dying, true);
 		spin_unlock(&file->f_lock);
 
 		/*
@@ -1127,7 +1114,13 @@ void eventpoll_release_file(struct file *file)
 		 */
 		ep = epi->ep;
 		mutex_lock(&ep->mtx);
-		dispose = __ep_remove(ep, epi, true);
+
+		ep_unregister_pollwait(ep, epi);
+
+		spin_lock(&file->f_lock);
+		__ep_remove_file(ep, epi, file);
+		dispose = __ep_remove_epi(ep, epi);
+
 		mutex_unlock(&ep->mtx);
 
 		if (dispose && ep_refcount_dec_and_test(ep))
-- 
2.53.0



