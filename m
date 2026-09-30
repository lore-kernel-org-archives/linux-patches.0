Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6355E50254F;
	Wed, 30 Sep 2026 16:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786357; cv=none; b=Fg52UHZQFeKKh2MzOCBr7m9V8DwSkLMiw0eaxn3eyHUIMRW179OFHPrBaDYRVlZn721WON/WnfXGJUICWladL1qfjz8vzkL/Z23o25qcV4E1c+B69N0S8W+i/CguY0f8rl+jAtVory3+4xb9dpddMitLLfnCU78e0oBuS+zlC/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786357; c=relaxed/simple;
	bh=eiePjgNbiZOAWrNI/zRv9bdntdqSWwpbJmrtoqt7f9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gI+OZOUSytiN4xAHrl4TKzJhpJtJNR0DMHIG0nFQGx+GKlSMG60uxXtAQe2we4Al1JvXnvpsDhqGmRzZY+1BCzBDz2uYeACAeojwZm6GrxndF/JO9/yIsRZresIjbIZc5YTDJocHvvIv7QIUC2JhyGcRWyw56uKbMU1dqcB+lUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZb67iMI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZb67iMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761B01F00893;
	Wed, 30 Sep 2026 16:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786356;
	bh=mwbCajxCI3Aifw7iCsq3d8D0ld7G9i8BE4YxQ4xqpxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZb67iMIAZKGhnvHzc9qf29jo/HZLeAlY9G+rbzpNUkfF63HH3EowJK9ZKXDqGqsF
	 Du+4lNXbaLV2NFgX8orHRaIz8M6S5rGUuyCytNxGtpREOM24GtXv115+v+jpD0dO9u
	 lgjS8nCQJxfAmHhJfQf8UigdKMT/9LWLS7vdaPho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 788/982] btrfs: dont check PageError in __extent_writepage
Date: Wed, 30 Sep 2026 17:25:24 +0200
Message-ID: <20260930152433.681012934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3e92499e3b004baffb479d61e191b41b604ece9a ]

__extent_writepage currenly sets PageError whenever any error happens,
and the also checks for PageError to decide if to call error handling.
This leads to very unclear responsibility for cleaning up on errors.
In the VM and generic writeback helpers the basic idea is that once
I/O is fired off all error handling responsibility is delegated to the
end I/O handler.  But if that end I/O handler sets the PageError bit,
and the submitter checks it, the bit could in some cases leak into the
submission context for fast enough I/O.

Fix this by simply not checking PageError and just using the local
ret variable to check for submission errors.  This also fundamentally
solves the long problem documented in a comment in __extent_writepage
by never leaking the error bit into the submission context.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

[ Backport to 6.1.y: apply the PageError-to-ret change in this tree's
  pre-btrfs_bio_ctrl __extent_writepage(). ]
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 33 +--------------------------------
 1 file changed, 1 insertion(+), 32 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 28dbac0bfab2f..aeea8930b973f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2299,38 +2299,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 		set_page_writeback(page);
 		end_page_writeback(page);
 	}
-	/*
-	 * Here we used to have a check for PageError() and then set @ret and
-	 * call end_extent_writepage().
-	 *
-	 * But in fact setting @ret here will cause different error paths
-	 * between subpage and regular sectorsize.
-	 *
-	 * For regular page size, we never submit current page, but only add
-	 * current page to current bio.
-	 * The bio submission can only happen in next page.
-	 * Thus if we hit the PageError() branch, @ret is already set to
-	 * non-zero value and will not get updated for regular sectorsize.
-	 *
-	 * But for subpage case, it's possible we submit part of current page,
-	 * thus can get PageError() set by submitted bio of the same page,
-	 * while our @ret is still 0.
-	 *
-	 * So here we unify the behavior and don't set @ret.
-	 * Error can still be properly passed to higher layer as page will
-	 * be set error, here we just don't handle the IO failure.
-	 *
-	 * NOTE: This is just a hotfix for subpage.
-	 * The root fix will be properly ending ordered extent when we hit
-	 * an error during writeback.
-	 *
-	 * But that needs a bigger refactoring, as we not only need to grab the
-	 * submitted OE, but also need to know exactly at which bytenr we hit
-	 * the error.
-	 * Currently the full page based __extent_writepage_io() is not
-	 * capable of that.
-	 */
-	if (PageError(page))
+	if (ret)
 		end_extent_writepage(page, ret, page_start, page_end);
 	if (epd->extent_locked) {
 		/*
-- 
2.53.0



