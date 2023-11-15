Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06B33DBA8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POgHrJsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28026C433C8;
	Wed, 15 Nov 2023 19:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078338;
	bh=DTZlwoc3KxxmFR6h6hGmPv0ikStaA0A0nXGoKcE6LTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POgHrJsZqtUU+tMsz8+qjXwipeUkkhb6qPSoh48dQlduktba2I7h4IYfyZEAolIzf
	 nSPtDQCEkgPSbptGyd6JramCxaDC+GpDOJMQXS8zAUp7MTna9TMWz2r8lKnoso6+Jw
	 RLA4Kr0FYv76xHNtbbOJTW8dmqxF3QcMitPtzO5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 262/379] f2fs: compress: fix to avoid redundant compress extension
Date: Wed, 15 Nov 2023 14:25:37 -0500
Message-ID: <20231115192700.638241188@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 7e1b150fece033703a824df1bbc03df091ea53cc ]

With below script, redundant compress extension will be parsed and added
by parse_options(), because parse_options() doesn't check whether the
extension is existed or not, fix it.

1. mount -t f2fs -o compress_extension=so /dev/vdb /mnt/f2fs
2. mount -t f2fs -o remount,compress_extension=so /mnt/f2fs
3. mount|grep f2fs

/dev/vdb on /mnt/f2fs type f2fs (...,compress_extension=so,compress_extension=so,...)

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Fixes: 151b1982be5d ("f2fs: compress: add nocompress extensions support")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 2046f633fe57a..1ba85ef97cbd3 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -548,6 +548,29 @@ static int f2fs_set_test_dummy_encryption(struct super_block *sb,
 }
 
 #ifdef CONFIG_F2FS_FS_COMPRESSION
+static bool is_compress_extension_exist(struct f2fs_sb_info *sbi,
+					const char *new_ext, bool is_ext)
+{
+	unsigned char (*ext)[F2FS_EXTENSION_LEN];
+	int ext_cnt;
+	int i;
+
+	if (is_ext) {
+		ext = F2FS_OPTION(sbi).extensions;
+		ext_cnt = F2FS_OPTION(sbi).compress_ext_cnt;
+	} else {
+		ext = F2FS_OPTION(sbi).noextensions;
+		ext_cnt = F2FS_OPTION(sbi).nocompress_ext_cnt;
+	}
+
+	for (i = 0; i < ext_cnt; i++) {
+		if (!strcasecmp(new_ext, ext[i]))
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * 1. The same extension name cannot not appear in both compress and non-compress extension
  * at the same time.
@@ -1145,6 +1168,11 @@ static int parse_options(struct super_block *sb, char *options, bool is_remount)
 				return -EINVAL;
 			}
 
+			if (is_compress_extension_exist(sbi, name, true)) {
+				kfree(name);
+				break;
+			}
+
 			strcpy(ext[ext_cnt], name);
 			F2FS_OPTION(sbi).compress_ext_cnt++;
 			kfree(name);
@@ -1169,6 +1197,11 @@ static int parse_options(struct super_block *sb, char *options, bool is_remount)
 				return -EINVAL;
 			}
 
+			if (is_compress_extension_exist(sbi, name, false)) {
+				kfree(name);
+				break;
+			}
+
 			strcpy(noext[noext_cnt], name);
 			F2FS_OPTION(sbi).nocompress_ext_cnt++;
 			kfree(name);
-- 
2.42.0



