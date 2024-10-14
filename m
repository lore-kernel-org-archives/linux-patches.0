Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593CA1C3021;
	Mon, 14 Oct 2024 14:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917337; cv=none; b=muUEqZV6FTxlAUTpJxhqjaW/PPrfYNMw2WagNM+jTIwg5k7T2UcA5MzFv0YWjr4RTAqznbgh+Uzu7rFIUGd0fZ/ZVLyq+s3HfszeeAktEGXJOh83N76U7vflLMUh5Wlj1CDAXMo/glPpAliDQT5NrPTdl38pO3Gli1+Hvi7YTOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917337; c=relaxed/simple;
	bh=1DURJ1DSMnS6UgxLHs3OefAx1HOc2P1KKzgDQbzTBbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c39ljMnYByskpOpkh1G/BY59FxgGrYKwBVgOsD7GLIYxXJk4AIeHlnXSd7A8g6u9HMDDAzh4XNmYPILiOpVH4dE8rL4VWOmY3ueuUObjcOHRNE8mP+HyMa2hr617xCCg5+iZ3Y7SPikTs4nuOz6uib04fOJYSRXhLbP5PrJob5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ty97VGh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ty97VGh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF778C4CEC3;
	Mon, 14 Oct 2024 14:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917337;
	bh=1DURJ1DSMnS6UgxLHs3OefAx1HOc2P1KKzgDQbzTBbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ty97VGh3475Fo5A6iXf5pMlo4JTXZC9YHYws9m57X/QNunql4QfXq2pfX8YLLZkl1
	 Ux7+qz1/13VZkixbtMyJEdVZq0hEy2JIvZB0nldh4BD7fC3Lpp7ds0JrTBxOk8cQKb
	 pNTG4FTwHlGRQor3PpbEyBNIxqszuRPJLrqzydMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Stefani <luca.stefani.ge1@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 207/213] btrfs: split remaining space to discard in chunks
Date: Mon, 14 Oct 2024 16:21:53 +0200
Message-ID: <20241014141051.040525697@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Luca Stefani <luca.stefani.ge1@gmail.com>

commit a99fcb0158978ed332009449b484e5f3ca2d7df4 upstream.

Per Qu Wenruo in case we have a very large disk, e.g. 8TiB device,
mostly empty although we will do the split according to our super block
locations, the last super block ends at 256G, we can submit a huge
discard for the range [256G, 8T), causing a large delay.

Split the space left to discard based on BTRFS_MAX_DISCARD_CHUNK_SIZE in
preparation of introduction of cancellation points to trim. The value
of the chunk size is arbitrary, it can be higher or derived from actual
device capabilities but we can't easily read that using
bio_discard_limit().

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219180
Link: https://bugzilla.suse.com/show_bug.cgi?id=1229737
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Luca Stefani <luca.stefani.ge1@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |   19 +++++++++++++++----
 fs/btrfs/volumes.h     |    6 ++++++
 2 files changed, 21 insertions(+), 4 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1303,13 +1303,24 @@ static int btrfs_issue_discard(struct bl
 		bytes_left = end - start;
 	}
 
-	if (bytes_left) {
+	while (bytes_left) {
+		u64 bytes_to_discard = min(BTRFS_MAX_DISCARD_CHUNK_SIZE, bytes_left);
+
 		ret = blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
-					   bytes_left >> SECTOR_SHIFT,
+					   bytes_to_discard >> SECTOR_SHIFT,
 					   GFP_NOFS);
-		if (!ret)
-			*discarded_bytes += bytes_left;
+
+		if (ret) {
+			if (ret != -EOPNOTSUPP)
+				break;
+			continue;
+		}
+
+		start += bytes_to_discard;
+		bytes_left -= bytes_to_discard;
+		*discarded_bytes += bytes_to_discard;
 	}
+
 	return ret;
 }
 
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -15,6 +15,12 @@
 
 #define BTRFS_MAX_DATA_CHUNK_SIZE	(10ULL * SZ_1G)
 
+/*
+ * Arbitratry maximum size of one discard request to limit potentially long time
+ * spent in blkdev_issue_discard().
+ */
+#define BTRFS_MAX_DISCARD_CHUNK_SIZE	(SZ_1G)
+
 extern struct mutex uuid_mutex;
 
 #define BTRFS_STRIPE_LEN		SZ_64K


