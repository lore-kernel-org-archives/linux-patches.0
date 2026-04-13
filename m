Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63BD311C2F;
	Mon, 13 Apr 2026 16:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097321; cv=none; b=FkH011e0W2qTciPckXJHru+9OoBXaBWL7xvO+POuIdBERrW7YnRrRTx6uF6s6JvGFrO2v7lfFN2eAhooSThg9UfErlI8uyMLQT2F7upqoFIhE+h8VRbfTNfL1o//71EoZdOdEvdpiV2euZCBQXUqFpxK8NzEXHD+gB2z0HmMVbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097321; c=relaxed/simple;
	bh=T4BvUH5Gi84tiqDCtjs5z/54i+NCdgXhgyk40H9waKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gx7HBLHrajyV/W+wlhceGiVdFoEfP+AhMzADMBeksVmxW7PEkBw+eZKhFLCXwFRuI48xEY0w7vw4sW3vUx9n8vdipwwodgXJhOBDpxfWQjfEKZB97FL9mUWnm3/OUouWri4e6VrM90FA60wnY8kVDGIK8lCNYuwXpkYIub4KEak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDJuBXRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDJuBXRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAA2C2BCAF;
	Mon, 13 Apr 2026 16:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097321;
	bh=T4BvUH5Gi84tiqDCtjs5z/54i+NCdgXhgyk40H9waKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDJuBXRuneM1Cjm/aYTw+To3a42MBxE/nzeWmAYuSUuU9Ng4gf6ira+hIRxve9E9R
	 IA+7HNxrtb0e8qG1uh/xW9nPVLV9viYNlZinshmKIdwzAfA7OjipREpUXG96CgTL/o
	 zBq3kuqTAZS0bVcVsagh6BP05GKnZM52l/cl5bf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a9747fe1c35a5b115d3f@syzkaller.appspotmail.com,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 059/570] Squashfs: check metadata block offset is within range
Date: Mon, 13 Apr 2026 17:53:10 +0200
Message-ID: <20260413155832.652624386@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phillip Lougher <phillip@squashfs.org.uk>

commit fdb24a820a5832ec4532273282cbd4f22c291a0d upstream.

Syzkaller reports a "general protection fault in squashfs_copy_data"

This is ultimately caused by a corrupted index look-up table, which
produces a negative metadata block offset.

This is subsequently passed to squashfs_copy_data (via
squashfs_read_metadata) where the negative offset causes an out of bounds
access.

The fix is to check that the offset is within range in
squashfs_read_metadata.  This will trap this and other cases.

Link: https://lkml.kernel.org/r/20260217050955.138351-1-phillip@squashfs.org.uk
Fixes: f400e12656ab ("Squashfs: cache operations")
Reported-by: syzbot+a9747fe1c35a5b115d3f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/699234e2.a70a0220.2c38d7.00e2.GAE@google.com/
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/cache.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -340,6 +340,9 @@ int squashfs_read_metadata(struct super_
 	if (unlikely(length < 0))
 		return -EIO;
 
+	if (unlikely(*offset < 0 || *offset >= SQUASHFS_METADATA_SIZE))
+		return -EIO;
+
 	while (length) {
 		entry = squashfs_cache_get(sb, msblk->block_cache, *block, 0);
 		if (entry->error) {


