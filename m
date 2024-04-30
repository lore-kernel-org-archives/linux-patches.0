Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E9212C54A;
	Tue, 30 Apr 2024 10:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474450; cv=none; b=Z5zeOtgD9fVIeK7IaQSpX5omglFnFReWFvn/iH12xC1Rczs54j52e2yfHtWRkZ3XO79UfT8R4NAjRWWA8DThtAM69WoNdtsnVKcVX0bEt2kQhnkxs0Yz1RijM6ooGnrK8A1vzdpW0R4j+gp+513NT4AFNalWCMEnavPDCv/LXo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474450; c=relaxed/simple;
	bh=OJCP4man7l7W+rqWQ12dIOIDmTS1ONRCMnVC3+Ar5Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEZ+2pFdA0n6swNj0u8h8GrTXQb80aGriZa0F5Foq5090FhZY+CyCbyw8VLZOEngxR4v+PSnbFUlpKDVk6tF+l2kkcMVJLlLEfk3N/dHPoWtUBK1rNSuc09N2VvVS4ziBmI3c5jUxpcpoO6uKqFRAke6V58+NkFMIypZlh0LZls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6u8wcX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6u8wcX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1055C2BBFC;
	Tue, 30 Apr 2024 10:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474450;
	bh=OJCP4man7l7W+rqWQ12dIOIDmTS1ONRCMnVC3+Ar5Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6u8wcX7u83vqVZTU9gVLeaNogWrEW033koBtOZcnlrWctXqJv9yu6e3hdxWolMbM
	 RbbT5pQDnRCL3fbm1kNmm+7XoAoqIhAiM6iaw5PncWKogKhSfLLSl0WIamHOp+ZzF0
	 jz7wp6fNN3llVbKdNoJs8GfaPCdSknu72QO+ktsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.8 160/228] btrfs: scrub: run relocation repair when/only needed
Date: Tue, 30 Apr 2024 12:38:58 +0200
Message-ID: <20240430103108.424173874@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1012,6 +1012,7 @@ static void scrub_stripe_read_repair_wor
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	int num_copies = btrfs_num_copies(fs_info, stripe->bg->start,
 					  stripe->bg->length);
+	unsigned long repaired;
 	int mirror;
 	int i;
 
@@ -1078,16 +1079,15 @@ out:
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


