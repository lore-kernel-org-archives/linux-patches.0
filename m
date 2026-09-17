Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A13A5383EF;
	Thu, 17 Sep 2026 17:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664580; cv=none; b=GkMEdyFKnPSZa+1x80xAURPyqGEak74xW3qsATwfmnrE5HDNSE7yH8f1Y5tQ9F7fyK11yxyrtGWgmYC8iCw0lWevyCCLVl+M9ZDKeU9eYgTHGPgFmlOKsoDSzxWlS3KsZBvlzywySW+j9FEvIhpV6fjjfBAOB+E6LEOcveKn1vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664580; c=relaxed/simple;
	bh=KPtbPAHeo/P1rywWlw/2Tw2pFuOd+p3qI2U1VO/TLEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSuGXWUCWDMbW6eLKept8mLqaBtDO2Sn0Gd3dDkC39MRmrCBDGFRGcaE9pNcO2zUwxE98IeWtrUDG8sgX+e3CUGMlpCNa1wZ8mVr534psEsrB6JX8XjnWYZ+SJWV3eqaKnv0lKrWp+p6y3x2FXjKpHsP9pk5ZwROsUknfdQP7Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFGYyEIm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFGYyEIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31241F000FF;
	Thu, 17 Sep 2026 17:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664579;
	bh=yv9JU8FfNewdoJ+BIWubniS9BVVXErWGrrr3m2vrS5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tFGYyEIm0kFh6faiaXhe+DJUPJMQ3S8q8BzDxcwOg/XzabCzPbg5aFSiPTjnXedLa
	 jve/JdkiEAW+1vYgXA62ISGEDtJEFKrdNtghn+3KPL7N09cLh/YVrfmrJ9HLUCgSYP
	 AYXTzdJcxwCc8OOAQZOeP8S9qc6oCimz+BRryH/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Timber <dxdt@dev.snart.me>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0418/1250] exfat: fix handling of damaged volume in exfat_create_upcase_table()
Date: Thu, 17 Sep 2026 16:03:33 +0100
Message-ID: <20260917151603.351126656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 57db08a5271cf..055447edcf9a6 100644
--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -769,13 +769,18 @@ int exfat_create_upcase_table(struct super_block *sb)
 
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
@@ -790,6 +795,8 @@ int exfat_create_upcase_table(struct super_block *sb)
 			return -EIO;
 	}
 
+	exfat_fs_error(sb, "no upcase table entry. Please run fsck");
+
 load_default:
 	/* load default upcase table */
 	return exfat_load_default_upcase_table(sb);
-- 
2.53.0



