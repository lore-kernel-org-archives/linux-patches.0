Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18992D739D;
	Mon, 27 Oct 2025 19:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593586; cv=none; b=YV2zyaU1vXIMwOHczOOjlO+h3l/m75q9uBrJM8fGrKRr3xkAqfAV6XmLNk1pnNnIhl4yBGBpDnLiffbO/42VFYGbncHl9QH5bzbK7nF1wRnNy4eNcKNQ1y0lisrvRwJQSF1Tq5mmqqwpRqWOeO5Kw9dsj5H+bA3qBcFNJqXPnxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593586; c=relaxed/simple;
	bh=/r2cxPfb9VjMDugyzL/W9D/OqvGLX950uC+8xim2PGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuOHzKG6RrH1BZWKSZMJtUAWz9+1qtIrkFCD5+M8nzbXv4gb0Wr4DlYM3wasC7L3Dw7Mz02CENjMgUWRzXIe74oumTElOaplybdok7ZnTuLk7pSOZYsyx+pt89W8Yw67HCVHLU+41Vz93C1AVJJC22ve0qZc9zbjoCkiQQGaPpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPgJMg0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPgJMg0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232FBC4CEF1;
	Mon, 27 Oct 2025 19:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593586;
	bh=/r2cxPfb9VjMDugyzL/W9D/OqvGLX950uC+8xim2PGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPgJMg0RGqAPCodxqqtbQFxAM2I1+DsVKr8A6KunnIVSdQRqu1hHObZV6IbyamCDd
	 LVn/i+vWhRkpCo46h4RzVE3p2b0/d1owkG36rzmEP4VlIiHyxy+DPUpszpp/+TidlS
	 j+SPEAMfgYhtQ6bEk2lHre45D8d2h5RkCGXVhxCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 180/184] vmw_balloon: indicate success when effectively deflating during migration
Date: Mon, 27 Oct 2025 19:37:42 +0100
Message-ID: <20251027183519.770190915@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 4ba5a8a7faa647ada8eae61a36517cf369f5bbe4 ]

When migrating a balloon page, we first deflate the old page to then
inflate the new page.

However, if inflating the new page succeeded, we effectively deflated the
old page, reducing the balloon size.

In that case, the migration actually worked: similar to migrating+
immediately deflating the new page.  The old page will be freed back to
the buddy.

Right now, the core will leave the page be marked as isolated (as we
returned an error).  When later trying to putback that page, we will run
into the WARN_ON_ONCE() in balloon_page_putback().

That handling was changed in commit 3544c4faccb8 ("mm/balloon_compaction:
stop using __ClearPageMovable()"); before that change, we would have
tolerated that way of handling it.

To fix it, let's just return 0 in that case, making the core effectively
just clear the "isolated" flag + freeing it back to the buddy as if the
migration succeeded.  Note that the new page will also get freed when the
core puts the last reference.

Note that this also makes it all be more consistent: we will no longer
unisolate the page in the balloon driver while keeping it marked as being
isolated in migration core.

This was found by code inspection.

Link: https://lkml.kernel.org/r/20251014124455.478345-1-david@redhat.com
Fixes: 3544c4faccb8 ("mm/balloon_compaction: stop using __ClearPageMovable()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/vmw_balloon.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1737,7 +1737,7 @@ static int vmballoon_migratepage(struct
 {
 	unsigned long status, flags;
 	struct vmballoon *b;
-	int ret;
+	int ret = 0;
 
 	b = container_of(b_dev_info, struct vmballoon, b_dev_info);
 
@@ -1796,17 +1796,15 @@ static int vmballoon_migratepage(struct
 		 * A failure happened. While we can deflate the page we just
 		 * inflated, this deflation can also encounter an error. Instead
 		 * we will decrease the size of the balloon to reflect the
-		 * change and report failure.
+		 * change.
 		 */
 		atomic64_dec(&b->size);
-		ret = -EBUSY;
 	} else {
 		/*
 		 * Success. Take a reference for the page, and we will add it to
 		 * the list after acquiring the lock.
 		 */
 		get_page(newpage);
-		ret = 0;
 	}
 
 	/* Update the balloon list under the @pages_lock */
@@ -1817,7 +1815,7 @@ static int vmballoon_migratepage(struct
 	 * If we succeed just insert it to the list and update the statistics
 	 * under the lock.
 	 */
-	if (!ret) {
+	if (status == VMW_BALLOON_SUCCESS) {
 		balloon_page_insert(&b->b_dev_info, newpage);
 		__count_vm_event(BALLOON_MIGRATE);
 	}


