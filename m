Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA531B4141;
	Fri, 22 Aug 2025 12:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755866246; cv=none; b=BvV/7iZ6LrIwDi6eAkZh8nXgczRcS6AnxWSK/Z+hfUEqwuAgOWESZB2rwj1svLo2kpErTHW8u+c29hHP8tTtE5YEKH8RhJkIJ8q6b2dDqCM51+yMzYhBXEwggwGOFN2wRBcLg1pNFPafo3kzE/8OPQINOb2uC1fFxT5Fhk+EEf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755866246; c=relaxed/simple;
	bh=I5lPdpGM3sx/awOxJitW2unPpBTT5p6+6VzDkw9yLoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNGv/MXkkotTQUe2JVuwngJPNVpJa+wJsUFUtJWZx58kXYjmPMfY29PdJ4rrUr4Dqp93N/3rVBLX1QgRV467iG5Jn/miR3B4JUmZQLSd3EEc+ayQHBS6JfJHvrRNk8h6tVFU8smCCpPclZnO6LXhA1w7u7L6UXKiIyaIPcWsa3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBrgBrk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBrgBrk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C44C113D0;
	Fri, 22 Aug 2025 12:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755866245;
	bh=I5lPdpGM3sx/awOxJitW2unPpBTT5p6+6VzDkw9yLoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBrgBrk2ThaAt8/lLEa+wpYszcIrZ+YwGzC3HBSglwSnvNDv8OwEm9Imo3DjFLW5n
	 pGFh9blLItsiPXMNsc12SF6UWrGlTyA7YeQsRYqeQyyhkEjRj41cnhHDFMHg6WLGxI
	 tJ8X+T18VBjDRh+Lyp+eWw90rJMJEGfn4CTnFzLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.16 3/9] ext4: fix stale data if it bail out of the extents mapping loop
Date: Fri, 22 Aug 2025 14:37:03 +0200
Message-ID: <20250822123516.911484923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250822123516.780248736@linuxfoundation.org>
References: <20250822123516.780248736@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit ded2d726a3041fce8afd88005cbfe15cd4737702 upstream.

During the process of writing back folios, if
mpage_map_and_submit_extent() exits the extent mapping loop due to an
ENOSPC or ENOMEM error, it may result in stale data or filesystem
inconsistency in environments where the block size is smaller than the
folio size.

When mapping a discontinuous folio in mpage_map_and_submit_extent(),
some buffers may have already be mapped. If we exit the mapping loop
prematurely, the folio data within the mapped range will not be written
back, and the file's disk size will not be updated. Once the transaction
that includes this range of extents is committed, this can lead to stale
data or filesystem inconsistency.

Fix this by submitting the current processing partially mapped folio.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250707140814.542883-4-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2363,6 +2363,47 @@ static int mpage_map_one_extent(handle_t
 }
 
 /*
+ * This is used to submit mapped buffers in a single folio that is not fully
+ * mapped for various reasons, such as insufficient space or journal credits.
+ */
+static int mpage_submit_partial_folio(struct mpage_da_data *mpd)
+{
+	struct inode *inode = mpd->inode;
+	struct folio *folio;
+	loff_t pos;
+	int ret;
+
+	folio = filemap_get_folio(inode->i_mapping,
+				  mpd->start_pos >> PAGE_SHIFT);
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
+	/*
+	 * The mapped position should be within the current processing folio
+	 * but must not be the folio start position.
+	 */
+	pos = ((loff_t)mpd->map.m_lblk) << inode->i_blkbits;
+	if (WARN_ON_ONCE((folio_pos(folio) == pos) ||
+			 !folio_contains(folio, pos >> PAGE_SHIFT)))
+		return -EINVAL;
+
+	ret = mpage_submit_folio(mpd, folio);
+	if (ret)
+		goto out;
+	/*
+	 * Update start_pos to prevent this folio from being released in
+	 * mpage_release_unused_pages(), it will be reset to the aligned folio
+	 * pos when this folio is written again in the next round. Additionally,
+	 * do not update wbc->nr_to_write here, as it will be updated once the
+	 * entire folio has finished processing.
+	 */
+	mpd->start_pos = pos;
+out:
+	folio_unlock(folio);
+	folio_put(folio);
+	return ret;
+}
+
+/*
  * mpage_map_and_submit_extent - map extent starting at mpd->lblk of length
  *				 mpd->len and submit pages underlying it for IO
  *
@@ -2412,8 +2453,16 @@ static int mpage_map_and_submit_extent(h
 			 */
 			if ((err == -ENOMEM) ||
 			    (err == -ENOSPC && ext4_count_free_clusters(sb))) {
-				if (progress)
+				/*
+				 * We may have already allocated extents for
+				 * some bhs inside the folio, issue the
+				 * corresponding data to prevent stale data.
+				 */
+				if (progress) {
+					if (mpage_submit_partial_folio(mpd))
+						goto invalidate_dirty_pages;
 					goto update_disksize;
+				}
 				return err;
 			}
 			ext4_msg(sb, KERN_CRIT,


