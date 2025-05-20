Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D0F19F137;
	Tue, 20 May 2025 13:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749288; cv=none; b=cJ2/WWzNVsH0yiJztkCsj9C55HtdpVy6HBPKFy3GaTKtbYCWIm517g/BZwjilW2hxYnwqdgJIcv4Cuk9oAXK/IR25uCOntI2mgm6c/9Ie57zrI3YwDYxYS8GtiImGpkkq9BnxIsrKrTIAXZwhHor0qyX3O5Ko42R9phNGq5liK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749288; c=relaxed/simple;
	bh=JYVXJBlHLAmsmONZxjqIp9oCWWVU++IJ7ikq2/o//PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQO1vC8bYk2tjmzwLfql2YyOm4W/Mf6Zi09qYxKX7hykgAlem1Bt3jid0qfX3qxS0h6c1XF3R/QmZx4xDejyr4rHmzHgvZMzfOY78mbgOX0Qhg0HbaOoMATeNggmhqueyZ96Jibykvn7eXCovsLSJDcbvcRZFXr6hN8yb58trPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzVTIBbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzVTIBbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06372C4CEE9;
	Tue, 20 May 2025 13:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749288;
	bh=JYVXJBlHLAmsmONZxjqIp9oCWWVU++IJ7ikq2/o//PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzVTIBbFSguP5bfF1ZZRemPOtwR8VfLtZqDKsMJB4Lpd2pWA38dwkhjw4YuDZ9dzY
	 4knEyTFm35V7ZvLO73Wuv4/27y9+d4dRnmq45kzIg0LXeCc4ByqU/lHEjXRA7NaVpn
	 wYBDYnkGfXmZIcrxGp6crdnzmgo65gqgXnRL8eZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 55/59] btrfs: do not clean up repair bio if submit fails
Date: Tue, 20 May 2025 15:50:46 +0200
Message-ID: <20250520125756.030382239@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 8cbc3001a3264d998d6b6db3e23f935c158abd4d upstream.

The submit helper will always run bio_endio() on the bio if it fails to
submit, so cleaning up the bio just leads to a variety of use-after-free
and NULL pointer dereference bugs because we race with the endio
function that is cleaning up the bio.  Instead just return BLK_STS_OK as
the repair function has to continue to process the rest of the pages,
and the endio for the repair bio will do the appropriate cleanup for the
page that it was given.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[Minor context change fixed.]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2624,7 +2624,6 @@ int btrfs_repair_one_sector(struct inode
 	const int icsum = bio_offset >> fs_info->sectorsize_bits;
 	struct bio *repair_bio;
 	struct btrfs_io_bio *repair_io_bio;
-	blk_status_t status;
 
 	btrfs_debug(fs_info,
 		   "repair read error: read error at %llu", start);
@@ -2664,13 +2663,13 @@ int btrfs_repair_one_sector(struct inode
 		    "repair read error: submitting new read to mirror %d",
 		    failrec->this_mirror);
 
-	status = submit_bio_hook(inode, repair_bio, failrec->this_mirror,
-				 failrec->bio_flags);
-	if (status) {
-		free_io_failure(failure_tree, tree, failrec);
-		bio_put(repair_bio);
-	}
-	return blk_status_to_errno(status);
+	/*
+	 * At this point we have a bio, so any errors from submit_bio_hook()
+	 * will be handled by the endio on the repair_bio, so we can't return an
+	 * error here.
+	 */
+	submit_bio_hook(inode, repair_bio, failrec->this_mirror, failrec->bio_flags);
+	return BLK_STS_OK;
 }
 
 static void end_page_read(struct page *page, bool uptodate, u64 start, u32 len)


