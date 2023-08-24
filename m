Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1384411C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB25C433C7;
	Thu, 24 Aug 2023 14:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888771;
	bh=f3afo66SN7R/FUosIVnVZ0feA6xY8l37kcEKbWq8cBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onfpU2YSsE9eUkLtLZhyUquiNm6fuYfnQQ040J1nyXSueXt14to5ksOVZyudIl0oc
	 CS8dgXGDFvyyBhhe9o6XDsoFO38dyNK01SLjypFR2cGzYkIpW+bN0y93bzTWStvoGx
	 Kw/8bd4ZCPPaG7LkGGO/e+r6ma4B8pDCRvp5n0gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/139] fs/ntfs3: Mark ntfs dirty when on-disk struct is corrupted
Date: Thu, 24 Aug 2023 16:49:18 +0200
Message-ID: <20230824145025.123669975@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
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
index 3c823613de97d..0ae70010b01d3 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -154,7 +154,7 @@ int ntfs_fix_post_read(struct NTFS_RECORD_HEADER *rhdr, size_t bytes,
 	/* Check errors. */
 	if ((fo & 1) || fo + fn * sizeof(short) > SECTOR_SIZE || !fn-- ||
 	    fn * SECTOR_SIZE > bytes) {
-		return -EINVAL; /* Native chkntfs returns ok! */
+		return -E_NTFS_CORRUPT;
 	}
 
 	/* Get fixup pointer. */
diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 124eba7238fd5..7705adc926b86 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1112,6 +1112,12 @@ int indx_read(struct ntfs_index *indx, struct ntfs_inode *ni, CLST vbn,
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
index fc0eb93c76de1..510ed2ea1c483 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -54,6 +54,8 @@ enum utf16_endian;
 #define E_NTFS_NONRESIDENT		556
 /* NTFS specific error code about punch hole. */
 #define E_NTFS_NOTALIGNED		557
+/* NTFS specific error code when on-disk struct is corrupted. */
+#define E_NTFS_CORRUPT			558
 
 
 /* sbi->flags */
diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index 3d222b1c8f038..938fc286963f2 100644
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



