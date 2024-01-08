Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928685381E;
	Mon,  8 Jan 2024 15:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rtg1SRxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F083C433CA;
	Mon,  8 Jan 2024 15:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728579;
	bh=W/lbIieRMa61fXIgGhSlxpK4ZrDmq3mCnEoe+qmu/vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rtg1SRxfkgPyTpqNlOJy6PGN//TlDrGHRuj0iKm7U9l5+AkR4TUIJida1GaGh+LVy
	 f0vdXPhJ5MDJiixgyR0Q1HCEOLCxeBjzrU9K6wjLZjOSFYCB4loyVoyFdoV4r7G3J/
	 wYUSt0DUILhbbTYB9Fp92Y/3qGzyWUSy3h2LO9QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/150] f2fs: set the default compress_level on ioctl
Date: Mon,  8 Jan 2024 16:35:44 +0100
Message-ID: <20240108153515.504151258@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit f5f3bd903a5d3e3b2ba89f11e0e29db25e60c048 ]

Otherwise, we'll get a broken inode.

 # touch $FILE
 # f2fs_io setflags compression $FILE
 # f2fs_io set_coption 2 8 $FILE

[  112.227612] F2FS-fs (dm-51): sanity_check_compress_inode: inode (ino=8d3fe) has unsupported compress level: 0, run fsck to fix

Cc: stable@vger.kernel.org
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 126c074deebdc..9b9fb3c57ec6c 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3984,6 +3984,15 @@ static int f2fs_ioc_set_compress_option(struct file *filp, unsigned long arg)
 	F2FS_I(inode)->i_compress_algorithm = option.algorithm;
 	F2FS_I(inode)->i_log_cluster_size = option.log_cluster_size;
 	F2FS_I(inode)->i_cluster_size = BIT(option.log_cluster_size);
+	/* Set default level */
+	if (F2FS_I(inode)->i_compress_algorithm == COMPRESS_ZSTD)
+		F2FS_I(inode)->i_compress_level = F2FS_ZSTD_DEFAULT_CLEVEL;
+	else
+		F2FS_I(inode)->i_compress_level = 0;
+	/* Adjust mount option level */
+	if (option.algorithm == F2FS_OPTION(sbi).compress_algorithm &&
+	    F2FS_OPTION(sbi).compress_level)
+		F2FS_I(inode)->i_compress_level = F2FS_OPTION(sbi).compress_level;
 	f2fs_mark_inode_dirty_sync(inode, true);
 
 	if (!f2fs_is_compress_backend_ready(inode))
-- 
2.43.0



