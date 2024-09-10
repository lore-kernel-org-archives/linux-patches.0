Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3934144D1A;
	Tue, 10 Sep 2024 10:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964847; cv=none; b=CdKz5WwR0avqzsClI1L5AWe9vFT/Uj1kuXiX47rzK7hwrG1h5Ypo5+YqQlww0a9S4qWXENL6RaLfR+lE+ZE4/SNrRhUYn/a2KX7NzT5/a8euoGV/P0i6jFt4h60tb5CJFY+bqrG1RthW277VFcizqzF5nTukb4+vrtQNwblg1m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964847; c=relaxed/simple;
	bh=up1A75a0X3TuVUrVVmU/sFH5G3Jdffe3J4dG0iFUkT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgpF/ZtLai5xmvm+s0qBtl9go9VCkwxSk71HgdE7OkWjWWe09vMdux4W877FA1oj/PF5TpZZGBjvI7GalaBc0EL7I80KuPO7NKRPowx/TJTobs4B5b3xAv0fEvN5fgfEMtKk3uBcedi0+LZiRe/fOQU2z9B1lLScztPNmLUJf8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VaCR2Gmi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VaCR2Gmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B69EC4CEC3;
	Tue, 10 Sep 2024 10:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964847;
	bh=up1A75a0X3TuVUrVVmU/sFH5G3Jdffe3J4dG0iFUkT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VaCR2GmiPQ7hGh4CSbb2hEMz/+pauPm3Ts5q5zeRvumxOYfBwW2TaUtumJwtQpJLe
	 6Yv+6uuKHRaPSQAbc5zSrl/5uMUurfvd3Gh/DigcNtjK6oZ58KS4eoBsZ9CVBEqWXe
	 DAP8kzD7j9YhXxahKapp06jDSR6Fpmor6c4D81Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 051/186] ext4: handle redirtying in ext4_bio_write_page()
Date: Tue, 10 Sep 2024 11:32:26 +0200
Message-ID: <20240910092556.604531279@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 04e568a3b31cfbd545c04c8bfc35c20e5ccfce0f upstream.

Since we want to transition transaction commits to use ext4_writepages()
for writing back ordered, add handling of page redirtying into
ext4_bio_write_page(). Also move buffer dirty bit clearing into the same
place other buffer state handling.

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221207112722.22220-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/page-io.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -493,6 +493,13 @@ int ext4_bio_write_page(struct ext4_io_s
 			/* A hole? We can safely clear the dirty bit */
 			if (!buffer_mapped(bh))
 				clear_buffer_dirty(bh);
+			/*
+			 * Keeping dirty some buffer we cannot write? Make
+			 * sure to redirty the page. This happens e.g. when
+			 * doing writeout for transaction commit.
+			 */
+			if (buffer_dirty(bh) && !PageDirty(page))
+				redirty_page_for_writepage(wbc, page);
 			if (io->io_bio)
 				ext4_io_submit(io);
 			continue;
@@ -500,6 +507,7 @@ int ext4_bio_write_page(struct ext4_io_s
 		if (buffer_new(bh))
 			clear_buffer_new(bh);
 		set_buffer_async_write(bh);
+		clear_buffer_dirty(bh);
 		nr_to_submit++;
 	} while ((bh = bh->b_this_page) != head);
 
@@ -542,7 +550,10 @@ int ext4_bio_write_page(struct ext4_io_s
 			printk_ratelimited(KERN_ERR "%s: ret = %d\n", __func__, ret);
 			redirty_page_for_writepage(wbc, page);
 			do {
-				clear_buffer_async_write(bh);
+				if (buffer_async_write(bh)) {
+					clear_buffer_async_write(bh);
+					set_buffer_dirty(bh);
+				}
 				bh = bh->b_this_page;
 			} while (bh != head);
 			goto unlock;
@@ -555,7 +566,6 @@ int ext4_bio_write_page(struct ext4_io_s
 			continue;
 		io_submit_add_bh(io, inode, page, bounce_page, bh);
 		nr_submitted++;
-		clear_buffer_dirty(bh);
 	} while ((bh = bh->b_this_page) != head);
 
 unlock:


