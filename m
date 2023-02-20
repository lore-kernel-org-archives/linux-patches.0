Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959EA63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADD8C433EF;
	Mon, 20 Feb 2023 13:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900301;
	bh=fRdjYOQIsq/naUQkRlYLfe2DyB7bbnLqVgAvLHCRASs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+LkCHOuo8Cw2CuSj67uHYtlNec9VimST9PtsOXeRHRYut1K2qS+auYl0SjZO90g9
	 CToZSgiphYjERSugzQnsGaiOoTG+WmKQX0J2zhx7d8Ly4E9gftYSei5lTkmuuZAf2T
	 hXZ0zxjGgVZ9mUR3Xh9Ao+JknaZJBECiHdbimJbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 26/53] btrfs: limit device extents to the device size
Date: Mon, 20 Feb 2023 14:35:52 +0100
Message-Id: <20230220133549.110342664@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
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
@@ -1397,7 +1397,7 @@ again:
 			goto out;
 	}
 
-	while (1) {
+	while (search_start < search_end) {
 		l = path->nodes[0];
 		slot = path->slots[0];
 		if (slot >= btrfs_header_nritems(l)) {
@@ -1420,6 +1420,9 @@ again:
 		if (key.type != BTRFS_DEV_EXTENT_KEY)
 			goto next;
 
+		if (key.offset > search_end)
+			break;
+
 		if (key.offset > search_start) {
 			hole_size = key.offset - search_start;
 
@@ -1494,6 +1497,7 @@ next:
 	else
 		ret = 0;
 
+	ASSERT(max_hole_start + max_hole_size <= search_end);
 out:
 	btrfs_free_path(path);
 	*start = max_hole_start;


