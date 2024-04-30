Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB17412CDAE;
	Tue, 30 Apr 2024 11:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475556; cv=none; b=cyu9Ce0U5TSGNO0zcTlA33yp4KAyo/VvQ7ipsbFls++KA/uo3+9Rn6N7zmSaTI1LVc4v5i3QFxOE1SH9BD4Rn5OoPw1FEqfo4FQGLj6GJ9lhRVVhNH+38UrCFRcfYlVAiCx5kuYokKcoF/VjnaRkukDRsYlwbQUko/Be0BdaiB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475556; c=relaxed/simple;
	bh=Ghssd5D9AYThsk4qoJ6xnTJnKLUVtoS6zOjnvFou/kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=py5baVR7UJcnYHx6gMOt21NY/gWJhCw8qQlzWWww2eOcucaGGIYzo/RJ98YykbwezW2qzIhhKDmNRAZPJxKQ/OxNwCzvA3t9d2qBteqXBPFNEkSbTUG8hvjg7PvZe1s+m1hSpOSK9ZucUnJLQymrJJ8ZkgJkEyr1GUBhBVod3H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m34S6+a7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m34S6+a7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1712AC2BBFC;
	Tue, 30 Apr 2024 11:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475556;
	bh=Ghssd5D9AYThsk4qoJ6xnTJnKLUVtoS6zOjnvFou/kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m34S6+a7UZJpvqVjmNbR9gdD/Rw+bdMtroGFctlxpTnzW6Qop4unbcm/1u8qLVx1i
	 ydNaDTmdfkeluDBWzC7iaG9x6QmwB15PWdTYEYdxHvJ9xIeKeVt84XWn8BwbkpwAtG
	 J18j5nvP5Qsj/7f1O1J9B4vEbvw7aEg//8H1huW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 133/186] btrfs: scrub: run relocation repair when/only needed
Date: Tue, 30 Apr 2024 12:39:45 +0200
Message-ID: <20240430103101.892312292@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 7192833c4e55b26e8f15ef58577867a1bc808036 upstream.

When btrfs scrub finds an error, it reads mirrors to find correct data. If
all the errors are fixed, sctx->error_bitmap is cleared for the stripe
range. However, in the zoned mode, it runs relocation to repair scrub
errors when the bitmap is *not* empty, which is a flipped condition.

Also, it runs the relocation even if the scrub is read-only. This was
missed by a fix in commit 1f2030ff6e49 ("btrfs: scrub: respect the
read-only flag during repair").

The repair is only necessary when there is a repaired sector and should be
done on read-write scrub. So, tweak the condition for both regular and
zoned case.

Fixes: 54765392a1b9 ("btrfs: scrub: introduce helper to queue a stripe for scrub")
Fixes: 1f2030ff6e49 ("btrfs: scrub: respect the read-only flag during repair")
CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/scrub.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1013,6 +1013,7 @@ static void scrub_stripe_read_repair_wor
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	int num_copies = btrfs_num_copies(fs_info, stripe->bg->start,
 					  stripe->bg->length);
+	unsigned long repaired;
 	int mirror;
 	int i;
 
@@ -1079,16 +1080,15 @@ out:
 	 * Submit the repaired sectors.  For zoned case, we cannot do repair
 	 * in-place, but queue the bg to be relocated.
 	 */
-	if (btrfs_is_zoned(fs_info)) {
-		if (!bitmap_empty(&stripe->error_bitmap, stripe->nr_sectors))
+	bitmap_andnot(&repaired, &stripe->init_error_bitmap, &stripe->error_bitmap,
+		      stripe->nr_sectors);
+	if (!sctx->readonly && !bitmap_empty(&repaired, stripe->nr_sectors)) {
+		if (btrfs_is_zoned(fs_info)) {
 			btrfs_repair_one_zone(fs_info, sctx->stripes[0].bg->start);
-	} else if (!sctx->readonly) {
-		unsigned long repaired;
-
-		bitmap_andnot(&repaired, &stripe->init_error_bitmap,
-			      &stripe->error_bitmap, stripe->nr_sectors);
-		scrub_write_sectors(sctx, stripe, repaired, false);
-		wait_scrub_stripe_io(stripe);
+		} else {
+			scrub_write_sectors(sctx, stripe, repaired, false);
+			wait_scrub_stripe_io(stripe);
+		}
 	}
 
 	scrub_stripe_report_errors(sctx, stripe);


