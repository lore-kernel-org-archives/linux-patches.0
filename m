Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A85423BD1B;
	Fri,  4 Sep 2026 05:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499053; cv=none; b=nLF03uG4gPglt3/M4GDRMaDB5Ja2clAYbcLdaFW43OtxumYEOPxz+sXftCyC97kCNl168hvclUZqksCYXK9I+myMk8hXCZYG/WTHZSuHPoRpubYZBqqNBNX3XzeGT0E0A7zLB4YRi9KuzComJr/WJZBk7atmx1g95zaLSIAO5wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499053; c=relaxed/simple;
	bh=9bLr10rzmHJf5kEkg72JXSAbaToQdZF97oeJbKWhQZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7TaaU9XXDNLuPiztL0hE5LHlZdKSqI+Zfl3LaH6prJoywnKCr+18C0BYejnZoRKU0ucmp6Hf6Oci+/GGdYkYwLgLb2yP2eXZlikJlnPJid/zkUkeyzBwzASrXgd7IMnDvQtjscfU9Cq8tEa5W7gaFU9gHW/P4/2ajVJ+HZ3p7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvPiXwpw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvPiXwpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E431F00A3D;
	Fri,  4 Sep 2026 05:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499052;
	bh=sAKLmGMdnrE4U6pB39+aDI8sD08WBbyxP7syXmn66Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uvPiXwpws/LrGUXS5En+Kx8Gq5wsOEYvwpb/lNZbttWNOHiYMELvzwv5bZHg/lOt8
	 f4VMPXbxKoGhIAeIU9ChqshaSq2yLjQ4qlkUC3aA+BaLpJsX4g1Rakw0+Hi/ozR2yW
	 e1XHtmDm5AjKROqk02ZmatXY4HvJqtXyxp82wVns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.2 264/713] ntfs: bound the free-cluster bitmap scan to the volume
Date: Fri,  4 Sep 2026 06:53:52 +0200
Message-ID: <20260904045809.755453048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 19cac7902a8ab748e15f98ddaafcf5f8882be21d upstream.

vol->lcn_empty_bits_per_page is sized from vol->nr_clusters at mount, but
ntfs_cluster_alloc() bounds its scan of that array by the size of $Bitmap.
Those are independent on-disk quantities and the mount-time check only
rejects a $Bitmap that is too small, so an image whose $Bitmap covers more
clusters than the volume has lets the scan index past the array.  A run
whose LCN lies in that gap takes the allocator straight there, since the
caller passes the file's own last LCN as its locality hint.  KASAN reports
a slab out-of-bounds read when a file on such a volume is extended.

Clamp the scan to what that array covers, mirroring the max_index
calculation the mount-time scan already uses, and reject a decoded LCN
at or beyond nr_clusters in the mapping pairs decoder.  Conforming
volumes are unaffected.

Fixes: 11ccc9107dc4 ("ntfs: update runlist handling and cluster allocator")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/lcnalloc.c | 7 ++++++-
 fs/ntfs/runlist.c  | 7 +++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/lcnalloc.c b/fs/ntfs/lcnalloc.c
index 835a041023a2..aa2e017a4384 100644
--- a/fs/ntfs/lcnalloc.c
+++ b/fs/ntfs/lcnalloc.c
@@ -298,7 +298,12 @@ struct runlist_element *ntfs_cluster_alloc(struct ntfs_volume *vol, const s64 st
 	clusters = count;
 	rlpos = rlsize = 0;
 	mapping = lcnbmp_vi->i_mapping;
-	i_size = i_size_read(lcnbmp_vi);
+	/*
+	 * lcn_empty_bits_per_page is sized from nr_clusters, but $Bitmap can
+	 * cover more clusters than that; bound the scan by the array.
+	 */
+	i_size = min_t(s64, i_size_read(lcnbmp_vi),
+		       ((s64)vol->nr_clusters + 7) >> 3);
 	while (1) {
 		ntfs_debug("Start of outer while loop: done_zones 0x%x, search_zone %i, pass %i, zone_start 0x%llx, zone_end 0x%llx, bmp_initial_pos 0x%llx, bmp_pos 0x%llx, rlpos %i, rlsize %i.",
 				done_zones, search_zone, pass,
diff --git a/fs/ntfs/runlist.c b/fs/ntfs/runlist.c
index 8e0fd400e7f7..17eb275a21ff 100644
--- a/fs/ntfs/runlist.c
+++ b/fs/ntfs/runlist.c
@@ -884,6 +884,13 @@ struct runlist_element *ntfs_mapping_pairs_decompress(const struct ntfs_volume *
 					ntfs_error(vol->sb, "lcn == -1");
 			}
 #endif
+			/* Check lcn is within the volume. */
+			if (unlikely(lcn >= (s64)vol->nr_clusters)) {
+				ntfs_error(vol->sb,
+						"LCN >= nr_clusters in mapping pairs array.");
+				goto err_out;
+			}
+
 			/* Check lcn is not below -1. */
 			if (unlikely(lcn < -1)) {
 				ntfs_error(vol->sb, "Invalid s64 < -1 in mapping pairs array.");
-- 
2.55.0



