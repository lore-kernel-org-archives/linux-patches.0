Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF311922EF;
	Tue, 10 Sep 2024 10:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963526; cv=none; b=KtJo/X16NdWyhO4LHyygJaVZznI2Xwh5HY1bBrGSKThHiZu0MzuMCG3eMhbzixw18CKNZzNM0DwHcf5K98LFBupCNAlGbruoYBMkLrRRYytbcmHgIoO/2r121i0gorpLXkqbPmkfG6i5JIeBSFEuOLivnGgh1xz+3F4ymILBfB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963526; c=relaxed/simple;
	bh=TpwBpkpwXdxb+227WGLut5qO9ebW2pjLlssUn46tW/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kn4NMOZ0O7vCVBRQQpfA4pgqegEjnJ3vCSVQzJCgjYL3drIQbsFQFW9DCgOrtKkcePA8K/0KeRzy+Jz3z4OYHbOv5qkTWEtjtbJSRE1qNWiPg5RBTxemByQ54L0b6bJlQEY02TePe+iB9YNCv4WXyiJDiROS8rV+UAHrW9z8uwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcIEWlV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcIEWlV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AF1C4CEC3;
	Tue, 10 Sep 2024 10:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963526;
	bh=TpwBpkpwXdxb+227WGLut5qO9ebW2pjLlssUn46tW/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcIEWlV9yh5omFLc0c8he6eSu4aciR6wYHv8doMzyCuQecOCsOSCQS57/AZcjsJS2
	 a5HmT6RHko2lREmAKeB7howgq4BudsdVUWKf+pVfthjHZaKShUQo+281grvZoVpiTf
	 PUz1fZv0qa1lDkQHkzxMD6gbfspIa1RFGF/8bkSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 060/214] ext4: handle redirtying in ext4_bio_write_page()
Date: Tue, 10 Sep 2024 11:31:22 +0200
Message-ID: <20240910092601.221786831@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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
@@ -490,6 +490,13 @@ int ext4_bio_write_page(struct ext4_io_s
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
@@ -497,6 +504,7 @@ int ext4_bio_write_page(struct ext4_io_s
 		if (buffer_new(bh))
 			clear_buffer_new(bh);
 		set_buffer_async_write(bh);
+		clear_buffer_dirty(bh);
 		nr_to_submit++;
 	} while ((bh = bh->b_this_page) != head);
 
@@ -539,7 +547,10 @@ int ext4_bio_write_page(struct ext4_io_s
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
@@ -552,7 +563,6 @@ int ext4_bio_write_page(struct ext4_io_s
 			continue;
 		io_submit_add_bh(io, inode, page, bounce_page, bh);
 		nr_submitted++;
-		clear_buffer_dirty(bh);
 	} while ((bh = bh->b_this_page) != head);
 
 unlock:


