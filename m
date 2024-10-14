Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4154A24;
	Mon, 14 Oct 2024 14:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916513; cv=none; b=de6aK9tc1T96MOHKoqgS6hpuKliPgRVZIepFGIUmU0BjuigwafAj41oBsvC9aBGT+uFfSziWHESRBg8HvPcrZgejE3yJywDJUOUccpsRILXGkOZ4JEV4KuSuRKpnTrjSRVHMRKDJw3M4jDQ93Y42sEMiemRg3nEFHfp70X4r3Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916513; c=relaxed/simple;
	bh=dKT554eqLeAoxzkpsqN8SwRKug21F6V+cRVBnYUM5Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttqEpVYvDmbOuz6Uhu/PxejOKCxevTEj1V4DYO9dcRcaOUEUw56siqTS4t+/BDL0JsiIJMIqsqTxiN4zM++Un+tRaFjZqEyKARuCvL4rN+Kfc65iZZdtcCJ4e5aqWCANlpWuCr3QPxYQ6cVami3tMEM2FK7reMnPeGLl8wcmhUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5RHpeMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5RHpeMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FFAC4CEC3;
	Mon, 14 Oct 2024 14:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916513;
	bh=dKT554eqLeAoxzkpsqN8SwRKug21F6V+cRVBnYUM5Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5RHpeMdM427YO6G+RusLZ3siLSfP5sMPfQ4LpNGlDc/0vGX1TL+HN8mLZB5fyvbw
	 Fg7cTquaJ61tKR2SGQu8kaiNaW66iMzNlWHQFL2ZWekpKgVAinVg0evpo4RXoMZ4nt
	 VtLJmwrHbwvrt40gyz0B6ovpBhoOey3DrRVd0S58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Stefani <luca.stefani.ge1@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.11 206/214] btrfs: split remaining space to discard in chunks
Date: Mon, 14 Oct 2024 16:21:09 +0200
Message-ID: <20241014141053.015034356@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1300,13 +1300,24 @@ static int btrfs_issue_discard(struct bl
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
@@ -30,6 +30,12 @@ struct btrfs_zoned_device_info;
 
 #define BTRFS_MAX_DATA_CHUNK_SIZE	(10ULL * SZ_1G)
 
+/*
+ * Arbitratry maximum size of one discard request to limit potentially long time
+ * spent in blkdev_issue_discard().
+ */
+#define BTRFS_MAX_DISCARD_CHUNK_SIZE	(SZ_1G)
+
 extern struct mutex uuid_mutex;
 
 #define BTRFS_STRIPE_LEN		SZ_64K


