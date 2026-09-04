Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2ED3A7F4C;
	Fri,  4 Sep 2026 05:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499115; cv=none; b=kRm0Y52LFx72MBn5UTi0CBKpd1qL8kVHoHLafT+cooN/8gPkwUO8nWeHOc2F9d+FRpdhr3R5Ufu9c4yRhDqz7ufnWVXhfbvGpqO13QgdHsygRpGCxM1U/mCWedU+2osSIBhl5maAhm8xYVIbrK3f3A6++xD/T/hb3FsBby5irl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499115; c=relaxed/simple;
	bh=9gtia8sQBCdBTODuE6tclhrJ7atQedgdGrctrAHQwtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRh7BNRMCeA0vk/p0aoFJzv4BKoKaLWbXWEeTLjawmAFm22/EebOioXAeeo6hBTYvHnWx/WOI5ariZUEbmP3vd5QKEekgwgvbxPZXyB5dnBbTP9jPtmy98ktBCQHobIusBKA3Bbhm97vngHJa5yFD9H8boZKXVMHKz6hHzURyoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHlxwmC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHlxwmC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326F31F00A3D;
	Fri,  4 Sep 2026 05:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499114;
	bh=qiQTV56UjPl3flG6zAfFmf7aFZ+VJHsVKXH2MGCTUgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JHlxwmC9nuc8XnCCeeXhlQNexGba2w9zIv9QLFysKowm2Ki4TScyyL1QcR3B4B2wa
	 xVmTdKtDSIRPK4x0ipO5QS3qJEBxgrLUX67AtszEt9e7DNdjEjxypm+37c2S3LDU8i
	 lPWw4Y4jWr95x+FCI9edm+J4phpVvFs+Dnf2k9ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.2 266/713] ntfs: reject invalid MFT LCNs from boot sector
Date: Fri,  4 Sep 2026 06:53:54 +0200
Message-ID: <20260904045809.799266832@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

commit cc9d09fef78410bcd37ac05168cbd5f6dd75d3d2 upstream.

The NTFS boot sector stores the MFT and MFTMirr locations as unsigned
64-bit LCNs, but parse_ntfs_boot_sector() decoded them into an s64.

A crafted high-bit value could therefore become negative and pass
the existing upper-bound check. The invalid value then propagated into
the MFT zone allocator and could result in an out-of-bounds access to
lcn_empty_bits_per_page.

Fixes: 11ccc9107dc4 ("ntfs: update runlist handling and cluster allocator")
Reported-by: Robert Morris <rtm@csail.mit.edu>
Closes: https://lore.kernel.org/all/57514.1787000602@localhost
Cc: stable@vger.kernel.org
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/super.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 8abe7bee4c0d..cd8fa2c13370 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -645,7 +645,7 @@ static bool parse_ntfs_boot_sector(struct ntfs_volume *vol,
 {
 	unsigned int sectors_per_cluster, sectors_per_cluster_bits, nr_hidden_sects;
 	int clusters_per_mft_record, clusters_per_index_record;
-	s64 ll;
+	u64 ll;
 
 	vol->sector_size = le16_to_cpu(b->bpb.bytes_per_sector);
 	vol->sector_size_bits = ffs(vol->sector_size) - 1;
@@ -755,23 +755,23 @@ static bool parse_ntfs_boot_sector(struct ntfs_volume *vol,
 	 * the same as it is much faster on 32-bit CPUs.
 	 */
 	ll = le64_to_cpu(b->number_of_sectors) >> sectors_per_cluster_bits;
-	if ((u64)ll >= 1ULL << 32) {
+	if (ll >= 1ULL << 32) {
 		ntfs_error(vol->sb, "Cannot handle 64-bit clusters.");
 		return false;
 	}
 	vol->nr_clusters = ll;
 	ntfs_debug("vol->nr_clusters = 0x%llx", vol->nr_clusters);
 	ll = le64_to_cpu(b->mft_lcn);
-	if (ll >= vol->nr_clusters) {
-		ntfs_error(vol->sb, "MFT LCN (%lli, 0x%llx) is beyond end of volume.  Weird.",
+	if (ll >= (u64)vol->nr_clusters) {
+		ntfs_error(vol->sb, "MFT LCN (%llu, 0x%llx) is beyond end of volume.  Weird.",
 				ll, ll);
 		return false;
 	}
 	vol->mft_lcn = ll;
 	ntfs_debug("vol->mft_lcn = 0x%llx", vol->mft_lcn);
 	ll = le64_to_cpu(b->mftmirr_lcn);
-	if (ll >= vol->nr_clusters) {
-		ntfs_error(vol->sb, "MFTMirr LCN (%lli, 0x%llx) is beyond end of volume.  Weird.",
+	if (ll >= (u64)vol->nr_clusters) {
+		ntfs_error(vol->sb, "MFTMirr LCN (%llu, 0x%llx) is beyond end of volume.  Weird.",
 				ll, ll);
 		return false;
 	}
-- 
2.55.0



