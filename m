Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F871171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAC5C433C8;
	Mon, 21 Aug 2023 20:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648144;
	bh=f3UGB1C5qYenYYfjc9uQ856AK/8JT23EWLibubOHF/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhYGU7osKXjtyw25I5VOk/+EOVYMohgZ7bfITvKIdbMwrHjJnFL3Qn++krxKTJjjY
	 p7zNwAAbaSBCFkjaogFO9iTyC0VYl9p6gqRBP9NRSVvY8/jmKW7r/z3rdbeJ0+Eh7L
	 2MQBvFwtaVNwMDvQA1K9RSCWe2GyLnAya9M1Cg24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 071/234] fs/ntfs3: Mark ntfs dirty when on-disk struct is corrupted
Date: Mon, 21 Aug 2023 21:40:34 +0200
Message-ID: <20230821194131.899041228@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit e0f363a98830e8d7d70fbaf91c07ae0b7c57aafe ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fsntfs.c  | 2 +-
 fs/ntfs3/index.c   | 6 ++++++
 fs/ntfs3/ntfs_fs.h | 2 ++
 fs/ntfs3/record.c  | 6 ++++++
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 28cc421102e59..21567e58265c4 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -178,7 +178,7 @@ int ntfs_fix_post_read(struct NTFS_RECORD_HEADER *rhdr, size_t bytes,
 	/* Check errors. */
 	if ((fo & 1) || fo + fn * sizeof(short) > SECTOR_SIZE || !fn-- ||
 	    fn * SECTOR_SIZE > bytes) {
-		return -EINVAL; /* Native chkntfs returns ok! */
+		return -E_NTFS_CORRUPT;
 	}
 
 	/* Get fixup pointer. */
diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 0a48d2d672198..b40da258e6848 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1113,6 +1113,12 @@ int indx_read(struct ntfs_index *indx, struct ntfs_inode *ni, CLST vbn,
 	*node = in;
 
 out:
+	if (err == -E_NTFS_CORRUPT) {
+		ntfs_inode_err(&ni->vfs_inode, "directory corrupted");
+		ntfs_set_state(ni->mi.sbi, NTFS_DIRTY_ERROR);
+		err = -EINVAL;
+	}
+
 	if (ib != in->index)
 		kfree(ib);
 
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index eb01f7e76479a..2e4be773728df 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -53,6 +53,8 @@ enum utf16_endian;
 #define E_NTFS_NONRESIDENT		556
 /* NTFS specific error code about punch hole. */
 #define E_NTFS_NOTALIGNED		557
+/* NTFS specific error code when on-disk struct is corrupted. */
+#define E_NTFS_CORRUPT			558
 
 
 /* sbi->flags */
diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index 7060f784c2d72..7974ca35a15c6 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -180,6 +180,12 @@ int mi_read(struct mft_inode *mi, bool is_mft)
 	return 0;
 
 out:
+	if (err == -E_NTFS_CORRUPT) {
+		ntfs_err(sbi->sb, "mft corrupted");
+		ntfs_set_state(sbi, NTFS_DIRTY_ERROR);
+		err = -EINVAL;
+	}
+
 	return err;
 }
 
-- 
2.40.1



