Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229C017555;
	Fri, 15 Nov 2024 07:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731654016; cv=none; b=rv2qtJoVx4CTenMR4ljP+kMoMoeeR2oQmi2KAM99IsM7NWoFPZot6625QVpxWb5suLeUrt7ht/ip2fjYvltw6AonWAbdTkxCo2GyUtZvOKj8hjZTVpeRGn6sTtcfLx9Mospt99rD4heyo1709b7EDVTEZsUy8BHVimrLESszHIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731654016; c=relaxed/simple;
	bh=p/TFXp4SuN7bTklec4jHzEd1GLqi9XLnabz5k7d6Ews=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFf6fefvAiNWmVqoaiuoLLstkJWp6Wj/5n0Q0dIAt4X/YsB55z5LJM+Fixuhgg6/hKkkDX+56V5avdpZxh+NL94rcD2UH4PilNk7OwHPL3H9AZg9sDoDPbAPwc9KmRtZuBz5jhnhnnxitrM66h3GNhV+8LPNCq8xbtRVfcyVrQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrcHF8Mr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrcHF8Mr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F79C4CECF;
	Fri, 15 Nov 2024 07:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731654015;
	bh=p/TFXp4SuN7bTklec4jHzEd1GLqi9XLnabz5k7d6Ews=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrcHF8Mr7MmFRm8aOBFKfa8yJl92HywB0NlAQpK1zZQ5kjrGiossW2iC4N7hngkgb
	 tSFnGuQxtVOsIbqjDxz35F0Xb0vwxvWg4pAMXTnCsXWQqmLAY8Qwi7nHy65mby/c/c
	 GA9vNOyG5IY45KoOL8ZCo9BKmoqQSNc3nVhplAM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jan Kara <jack@suse.cz>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5.15 20/22] udf: Allocate name buffer in directory iterator on heap
Date: Fri, 15 Nov 2024 07:39:06 +0100
Message-ID: <20241115063721.907012691@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
References: <20241115063721.172791419@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 0aba4860b0d0216a1a300484ff536171894d49d8 upstream.

Currently we allocate name buffer in directory iterators (struct
udf_fileident_iter) on stack. These structures are relatively large
(some 360 bytes on 64-bit architectures). For udf_rename() which needs
to keep three of these structures in parallel the stack usage becomes
rather heavy - 1536 bytes in total. Allocate the name buffer in the
iterator from heap to avoid excessive stack usage.

Link: https://lore.kernel.org/all/202212200558.lK9x1KW0-lkp@intel.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
[Add extra include linux/slab.h]
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/directory.c |   24 ++++++++++++++++--------
 fs/udf/udfdecl.h   |    2 +-
 2 files changed, 17 insertions(+), 9 deletions(-)

--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -19,6 +19,7 @@
 #include <linux/bio.h>
 #include <linux/crc-itu-t.h>
 #include <linux/iversion.h>
+#include <linux/slab.h>
 
 static int udf_verify_fi(struct udf_fileident_iter *iter)
 {
@@ -248,9 +249,14 @@ int udf_fiiter_init(struct udf_fileident
 	iter->elen = 0;
 	iter->epos.bh = NULL;
 	iter->name = NULL;
+	iter->namebuf = kmalloc(UDF_NAME_LEN_CS0, GFP_KERNEL);
+	if (!iter->namebuf)
+		return -ENOMEM;
 
-	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
-		return udf_copy_fi(iter);
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
+		err = udf_copy_fi(iter);
+		goto out;
+	}
 
 	if (inode_bmap(dir, iter->pos >> dir->i_blkbits, &iter->epos,
 		       &iter->eloc, &iter->elen, &iter->loffset) !=
@@ -260,17 +266,17 @@ int udf_fiiter_init(struct udf_fileident
 		udf_err(dir->i_sb,
 			"position %llu not allocated in directory (ino %lu)\n",
 			(unsigned long long)pos, dir->i_ino);
-		return -EFSCORRUPTED;
+		err = -EFSCORRUPTED;
+		goto out;
 	}
 	err = udf_fiiter_load_bhs(iter);
 	if (err < 0)
-		return err;
+		goto out;
 	err = udf_copy_fi(iter);
-	if (err < 0) {
+out:
+	if (err < 0)
 		udf_fiiter_release(iter);
-		return err;
-	}
-	return 0;
+	return err;
 }
 
 int udf_fiiter_advance(struct udf_fileident_iter *iter)
@@ -307,6 +313,8 @@ void udf_fiiter_release(struct udf_filei
 	brelse(iter->bh[0]);
 	brelse(iter->bh[1]);
 	iter->bh[0] = iter->bh[1] = NULL;
+	kfree(iter->namebuf);
+	iter->namebuf = NULL;
 }
 
 static void udf_copy_to_bufs(void *buf1, int len1, void *buf2, int len2,
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -99,7 +99,7 @@ struct udf_fileident_iter {
 	struct extent_position epos;	/* Position after the above extent */
 	struct fileIdentDesc fi;	/* Copied directory entry */
 	uint8_t *name;			/* Pointer to entry name */
-	uint8_t namebuf[UDF_NAME_LEN_CS0]; /* Storage for entry name in case
+	uint8_t *namebuf;		/* Storage for entry name in case
 					 * the name is split between two blocks
 					 */
 };


