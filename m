Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55E93D3488;
	Thu, 15 Jan 2026 17:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499933; cv=none; b=F7GONw3B1ccdHQR9vGZ79dao892c6fN68xuZu0epByHLzRzp+wlcBLpQSeon3EjaGvDIXq0T8AV9zgJsqSprygcEBMJ6cAvVKSotl4vq8da24LMOd/0D9AboU1P/E1ZSV2kZeOoiNcSja4LIwGxTHjNJMwfHQRJRrUCcTrpRAU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499933; c=relaxed/simple;
	bh=gozQfJiKhFz35rgji1RJ7xmZHzUgarPr9DwJve7UIlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XP+DFOSQqz9CvjCWC2IpFWjVbeQm1YldIioHhrM+BOsRqWnFoQF8SG3hkNIp6FVRqofj15tYPJ3+1HCbg9T8yTKpDk2P207BgQQg2wK3JaNkh+QNts/BY5IjlUlUFg7Xnyga4nCyqH3E/afla2Sq2MsIJSQe4cQsSuupgtbo0jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrkMQofW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrkMQofW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259CAC116D0;
	Thu, 15 Jan 2026 17:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499932;
	bh=gozQfJiKhFz35rgji1RJ7xmZHzUgarPr9DwJve7UIlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrkMQofWQjelfuXxY4HB14RWOBoa+kOPrr5233U16Sn665FgyF6Ipkh7L2r0ir2cP
	 XW53YZqdCVXLQvYehlzo4w5AEoQaAST6G3sEqKFabIrX/PmQOCFXh3xHwzaEZ2UGn7
	 DZSnsEzfRlxSAZmbxKs1c1uuxvuUuJZzXTyo+YCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH 5.10 399/451] btrfs: do not clean up repair bio if submit fails
Date: Thu, 15 Jan 2026 17:50:00 +0100
Message-ID: <20260115164245.371212741@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 8cbc3001a3264d998d6b6db3e23f935c158abd4d ]

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
[ Keerthana: Backported the patch to v5.10.y ]
Signed-off-by: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2655,7 +2655,6 @@ blk_status_t btrfs_submit_read_repair(st
 	bool need_validation;
 	struct bio *repair_bio;
 	struct btrfs_io_bio *repair_io_bio;
-	blk_status_t status;
 
 	btrfs_debug(fs_info,
 		   "repair read error: read error at %llu", start);
@@ -2699,13 +2698,13 @@ blk_status_t btrfs_submit_read_repair(st
 "repair read error: submitting new read to mirror %d, in_validation=%d",
 		    failrec->this_mirror, failrec->in_validation);
 
-	status = submit_bio_hook(inode, repair_bio, failrec->this_mirror,
-				 failrec->bio_flags);
-	if (status) {
-		free_io_failure(failure_tree, tree, failrec);
-		bio_put(repair_bio);
-	}
-	return status;
+	/*
+	 * At this point we have a bio, so any errors from submit_bio_hook()
+	 * will be handled by the endio on the repair_bio, so we can't return an
+	 * error here.
+	 */
+	submit_bio_hook(inode, repair_bio, failrec->this_mirror, failrec->bio_flags);
+	return BLK_STS_OK;
 }
 
 /* lots and lots of room for performance fixes in the end_bio funcs */


