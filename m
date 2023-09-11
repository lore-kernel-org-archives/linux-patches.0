Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D121170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E825C433C7;
	Mon, 11 Sep 2023 14:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441917;
	bh=DdcXTKz94rM5Ghp1BigfAPueBRD7FLCA/mff/S6hhmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DE0hvIosFFQmUCL251xZTbwZFOy811pU38hU72mnK7dld+qkMzXD76p3BPhVbZilo
	 xuYo0hXGl4na0ZW85SFjY8U2//7L9hj/PLFHtKzfxhoddqZzBgy+GMdkVL7xvG6Mre
	 Ml4VVraJU4TukvkO1M2ZbDru+vJFmM1z9pB2HfPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunhai Guo <guochunhai@vivo.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 554/739] f2fs: Only lfs mode is allowed with zoned block device feature
Date: Mon, 11 Sep 2023 15:45:53 +0200
Message-ID: <20230911134706.561551570@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunhai Guo <guochunhai@vivo.com>

[ Upstream commit 2bd4df8fcbc72f58ce3c62ed021ab291ca42de0b ]

Now f2fs support four block allocation modes: lfs, adaptive,
fragment:segment, fragment:block. Only lfs mode is allowed with zoned block
device feature.

Fixes: 6691d940b0e0 ("f2fs: introduce fragment allocation mode mount option")
Signed-off-by: Chunhai Guo <guochunhai@vivo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 30883beb750a5..26add77f90621 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -862,11 +862,6 @@ static int parse_options(struct super_block *sb, char *options, bool is_remount)
 			if (!name)
 				return -ENOMEM;
 			if (!strcmp(name, "adaptive")) {
-				if (f2fs_sb_has_blkzoned(sbi)) {
-					f2fs_warn(sbi, "adaptive mode is not allowed with zoned block device feature");
-					kfree(name);
-					return -EINVAL;
-				}
 				F2FS_OPTION(sbi).fs_mode = FS_MODE_ADAPTIVE;
 			} else if (!strcmp(name, "lfs")) {
 				F2FS_OPTION(sbi).fs_mode = FS_MODE_LFS;
@@ -1331,6 +1326,11 @@ static int parse_options(struct super_block *sb, char *options, bool is_remount)
 			F2FS_OPTION(sbi).discard_unit =
 					DISCARD_UNIT_SECTION;
 		}
+
+		if (F2FS_OPTION(sbi).fs_mode != FS_MODE_LFS) {
+			f2fs_info(sbi, "Only lfs mode is allowed with zoned block device feature");
+			return -EINVAL;
+		}
 #else
 		f2fs_err(sbi, "Zoned block device support is not enabled");
 		return -EINVAL;
-- 
2.40.1



