Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5086111710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0EFC433C7;
	Mon, 11 Sep 2023 15:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445799;
	bh=ZWH2zTdKQq7V0tat9QXhFCoJLDU7NxPsqZYVTLwdtrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zI3vcZW9ZGQNg2TaFPAu6TRFIeMX5uid31gpO2kKX5++Bv6QVEpv5i/AJK+YOFgmE
	 aG8wdoJRQZz/wZ59D0PqPu8s3RKIakI2EMYJK0T1/z7VkKNTjN1iV5pMPtJLibtT7M
	 tH9SCFvECmA4l83i26X8E3ejjHojRTVxOSNyN31A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 475/600] f2fs: judge whether discard_unit is section only when have CONFIG_BLK_DEV_ZONED
Date: Mon, 11 Sep 2023 15:48:28 +0200
Message-ID: <20230911134647.665642114@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit b5a711acab305e04278c136c841ba37c589c16a1 ]

The current logic, regardless of whether CONFIG_BLK_DEV_ZONED
is enabled or not, will judge whether discard_unit is SECTION,
when f2fs_sb_has_blkzoned.

In fact, when CONFIG_BLK_DEV_ZONED is not enabled, this judgment
is a path that will never be accessed. At this time, -EINVAL will
be returned in the parse_options function, accompanied by the
message "Zoned block device support is not enabled".

Let's wrap this discard_unit judgment with CONFIG_BLK_DEV_ZONED.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 2bd4df8fcbc7 ("f2fs: Only lfs mode is allowed with zoned block device feature")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index b6dad389fa144..d616ce3826e7a 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1285,19 +1285,18 @@ static int parse_options(struct super_block *sb, char *options, bool is_remount)
 	 * zone alignment optimization. This is optional for host-aware
 	 * devices, but mandatory for host-managed zoned block devices.
 	 */
-#ifndef CONFIG_BLK_DEV_ZONED
-	if (f2fs_sb_has_blkzoned(sbi)) {
-		f2fs_err(sbi, "Zoned block device support is not enabled");
-		return -EINVAL;
-	}
-#endif
 	if (f2fs_sb_has_blkzoned(sbi)) {
+#ifdef CONFIG_BLK_DEV_ZONED
 		if (F2FS_OPTION(sbi).discard_unit !=
 						DISCARD_UNIT_SECTION) {
 			f2fs_info(sbi, "Zoned block device doesn't need small discard, set discard_unit=section by default");
 			F2FS_OPTION(sbi).discard_unit =
 					DISCARD_UNIT_SECTION;
 		}
+#else
+		f2fs_err(sbi, "Zoned block device support is not enabled");
+		return -EINVAL;
+#endif
 	}
 
 #ifdef CONFIG_F2FS_FS_COMPRESSION
-- 
2.40.1



