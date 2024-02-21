Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD5338398;
	Wed, 21 Feb 2024 13:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523474; cv=none; b=jsXomNNyyAw3fdyspXYSg9MtVLBg4abUIyGF3A3+9GVrr+zT2HX6TSAW02WOeeEUvmOYlCnj63IQunYMoBa9ThWjCiUByY/ubj/bU9A5aHA4Bpg1I3OBipg/eNnesd2VJPQ96Z5kEhYWJDzg3mTC72SMNwuRhjDFGnqHufYzCeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523474; c=relaxed/simple;
	bh=GanLoMuCQY/Ji0alC5JRXo/QaiOQWm7UHliD7uktXQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7dm5S7G2MRTKL2cCmJyJ2IWS6ib+F+3zVH+a/tbIk7ZNLr0WXwdejEohr1IC+Jscx+7M5tjClGUfTvKrI9OaVoDAZobiwD7UBmdRozkb/Kwn60bigosmmzFuy7J/VtV6zY3hlCU7jXctK5x75Hu8WMgFJ62/Xif4ssj//7a3Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAOgVcXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAOgVcXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8C0C433F1;
	Wed, 21 Feb 2024 13:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523473;
	bh=GanLoMuCQY/Ji0alC5JRXo/QaiOQWm7UHliD7uktXQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAOgVcXGu/mBskj2sHdvfI1/RqQ0kekMZkJ2NSpsDDUS2Pq2/wYvEtFEhyiUuxIwp
	 S6JJ34vL9Lrna3hZacOCdsu28s+rowr4vvaiLlSZOlrSDxSRGQApvzHgdWz5v40qAQ
	 6WAkS2PCzWOf9qbOSzUuxNzX0CECKl0JyBpv4yGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 446/476] fbdev/defio: Early-out if page is already enlisted
Date: Wed, 21 Feb 2024 14:08:17 +0100
Message-ID: <20240221130024.519467424@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 105a940416fc622406653b6fe54732897642dfbc ]

Return early if a page is already in the list of dirty pages for
deferred I/O. This can be detected if the page's list head is not
empty. Keep the list head initialized while the page is not enlisted
to make this work reliably.

v2:
	* update comment and fix spelling (Sam)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220211094640.21632-2-tzimmermann@suse.de
Stable-dep-of: 33cd6ea9c067 ("fbdev: flush deferred IO before closing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fb_defio.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
index 0708e214c5a3..95264a621221 100644
--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -59,6 +59,7 @@ static vm_fault_t fb_deferred_io_fault(struct vm_fault *vmf)
 		printk(KERN_ERR "no mapping available\n");
 
 	BUG_ON(!page->mapping);
+	INIT_LIST_HEAD(&page->lru);
 	page->index = vmf->pgoff;
 
 	vmf->page = page;
@@ -118,17 +119,24 @@ static vm_fault_t fb_deferred_io_mkwrite(struct vm_fault *vmf)
 	 */
 	lock_page(page);
 
+	/*
+	 * This check is to catch the case where a new process could start
+	 * writing to the same page through a new PTE. This new access
+	 * can cause a call to .page_mkwrite even if the original process'
+	 * PTE is marked writable.
+	 *
+	 * TODO: The lru field is owned by the page cache; hence the name.
+	 *       We dequeue in fb_deferred_io_work() after flushing the
+	 *       page's content into video memory. Instead of lru, fbdefio
+	 *       should have it's own field.
+	 */
+	if (!list_empty(&page->lru))
+		goto page_already_added;
+
 	/* we loop through the pagelist before adding in order
 	to keep the pagelist sorted */
 	list_for_each_entry(cur, &fbdefio->pagelist, lru) {
-		/* this check is to catch the case where a new
-		process could start writing to the same page
-		through a new pte. this new access can cause the
-		mkwrite even when the original ps's pte is marked
-		writable */
-		if (unlikely(cur == page))
-			goto page_already_added;
-		else if (cur->index > page->index)
+		if (cur->index > page->index)
 			break;
 	}
 
@@ -190,7 +198,7 @@ static void fb_deferred_io_work(struct work_struct *work)
 
 	/* clear the list */
 	list_for_each_safe(node, next, &fbdefio->pagelist) {
-		list_del(node);
+		list_del_init(node);
 	}
 	mutex_unlock(&fbdefio->lock);
 }
-- 
2.43.0



