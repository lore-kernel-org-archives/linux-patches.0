Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F98356A12;
	Sat, 17 Oct 2026 18:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260382; cv=none; b=btpN7wSOpF/lC3/Z0XiFqpfM4lsGOzKgHfIr6Rwvwip009J75JGowQeo7ws/3KdLcNDULmonCZK+JUSvNlFwu/W9H/rliDJgtPR8S7JqgvV2m+uXd+YgfgxT9u72zHrnz0Ji+nMbEZBCMRSllk1gv8zmpAy22Ae1qpBAAaLH28E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260382; c=relaxed/simple;
	bh=vcK5Gl2orK2BE3X12AHO1STMbqdPQT//AOB5T0zudtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejoXA5nl/tvXLcvLYNz8Bq7yvMHi1smOSrvvoegNqPE0qStGam5Nx4ReIvGkGbR53NfajHcIesIozOlTaVfo6EVjVlbMVq3rvnE5PNiHitZiUNO9OF0fwJ+Wbc+41OGL8R028fS8BCBvpgM+tMNf45dyh9Khm7OyQNLXnbMfkA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFPubzTJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFPubzTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A90B1F000C4;
	Sat, 17 Oct 2026 18:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260380;
	bh=WzavxffMZ0OupDvVQt0i82udKfRfmq7Q/dJ2GYkD6/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FFPubzTJg2yN3le8vvMiHmpvdlcQQIivfx59ZnrhlPdYPqEoDuJkZJxRymyywPDC5
	 RtFsNn31wLUiH1iSe95urn+80Xc7S6mJuW9evd+xp4DqjP4ty1sdFX7XkVI4F3Lkz4
	 8XRlgLhMc65UHZNYZDOH7nsDIrHIJj7OmIG/2Wgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Timber <dxdt@dev.snart.me>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1525/1674] exfat: fix handling of damaged volume in exfat_create_upcase_table()
Date: Sat, 17 Oct 2026 18:03:17 +0200
Message-ID: <20261017160510.263815528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Timber <dxdt@dev.snart.me>

[ Upstream commit 20dd3185d13865214ff25b0bf7b931e8d73be1ac ]

When the size of the upcase table is set to zero in the dentry for any
reason(e.g. corrupted media or misbehaving device), an integer overflow
causes the module to loop indefinitely.

If the size of the upcase table is read zero, do not attempt to load the
table. Instead, fallback to loading the default upcase table. If the
size of the upcase table is zero or no upcase table is found, raise
exfat_fs_error() to mark the volume read-only.

Signed-off-by: David Timber <dxdt@dev.snart.me>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/nls.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c
index e027b34356969..4bfe807716deb 100644
--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -778,13 +778,18 @@ int exfat_create_upcase_table(struct super_block *sb)
 
 			tbl_clu  = le32_to_cpu(ep->dentry.upcase.start_clu);
 			tbl_size = le64_to_cpu(ep->dentry.upcase.size);
-
-			sector = exfat_cluster_to_sector(sbi, tbl_clu);
-			num_sectors = ((tbl_size - 1) >> blksize_bits) + 1;
-			ret = exfat_load_upcase_table(sb, sector, num_sectors,
-				le32_to_cpu(ep->dentry.upcase.checksum));
-
+			if (tbl_size) {
+				sector = exfat_cluster_to_sector(sbi, tbl_clu);
+				num_sectors = ((tbl_size - 1) >> blksize_bits) + 1;
+				ret = exfat_load_upcase_table(sb, sector, num_sectors,
+					le32_to_cpu(ep->dentry.upcase.checksum));
+			} else {
+				exfat_fs_error(sb,
+					       "bad upcase table size (0 bytes). Please run fsck");
+				ret = -EINVAL;
+			}
 			brelse(bh);
+
 			if (ret && ret != -EIO) {
 				/* free memory from exfat_load_upcase_table call */
 				exfat_free_upcase_table(sbi);
@@ -799,6 +804,8 @@ int exfat_create_upcase_table(struct super_block *sb)
 			return -EIO;
 	}
 
+	exfat_fs_error(sb, "no upcase table entry. Please run fsck");
+
 load_default:
 	/* load default upcase table */
 	return exfat_load_default_upcase_table(sb);
-- 
2.53.0



