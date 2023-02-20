Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F15C63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9711C433D2;
	Mon, 20 Feb 2023 13:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900487;
	bh=al3tCvjaLRj9zDV2ezDrXunEd9UwZsICm0wCiVP2CsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iElDSWOZfZMGCsnvXHsgiwPuLVzROuYd4cBv9zUBl1onnYNhQik4q8AusI3k3lFb0
	 elFH7VPG69maTDxecZBE0nrqIeSZBz0YEMc1RDcCa8RLjGjojgghmiIFoU2DVVsNVc
	 DkHjumrRqTSUIRLZDpp92HXODgh0z76qi4J24RCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 43/89] btrfs: limit device extents to the device size
Date: Mon, 20 Feb 2023 14:35:42 +0100
Message-Id: <20230220133554.646256114@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josef Bacik <josef@toxicpanda.com>

commit 3c538de0f2a74d50aff7278c092f88ae59cee688 upstream.

There was a recent regression in btrfs/177 that started happening with
the size class patches ("btrfs: introduce size class to block group
allocator").  This however isn't a regression introduced by those
patches, but rather the bug was uncovered by a change in behavior in
these patches.  The patches triggered more chunk allocations in the
^free-space-tree case, which uncovered a race with device shrink.

The problem is we will set the device total size to the new size, and
use this to find a hole for a device extent.  However during shrink we
may have device extents allocated past this range, so we could
potentially find a hole in a range past our new shrink size.  We don't
actually limit our found extent to the device size anywhere, we assume
that we will not find a hole past our device size.  This isn't true with
shrink as we're relocating block groups and thus creating holes past the
device size.

Fix this by making sure we do not search past the new device size, and
if we wander into any device extents that start after our device size
simply break from the loop and use whatever hole we've already found.

CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1418,7 +1418,7 @@ again:
 			goto out;
 	}
 
-	while (1) {
+	while (search_start < search_end) {
 		l = path->nodes[0];
 		slot = path->slots[0];
 		if (slot >= btrfs_header_nritems(l)) {
@@ -1441,6 +1441,9 @@ again:
 		if (key.type != BTRFS_DEV_EXTENT_KEY)
 			goto next;
 
+		if (key.offset > search_end)
+			break;
+
 		if (key.offset > search_start) {
 			hole_size = key.offset - search_start;
 
@@ -1515,6 +1518,7 @@ next:
 	else
 		ret = 0;
 
+	ASSERT(max_hole_start + max_hole_size <= search_end);
 out:
 	btrfs_free_path(path);
 	*start = max_hole_start;


