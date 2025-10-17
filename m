Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808AB330B0C;
	Fri, 17 Oct 2025 15:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715892; cv=none; b=S84s2ete6Usy4Ig/DjfoVLzxEc9q5yRbCF6JbbGeYUgF1/0HCexZ7lydK9A3SPmc4X3VXyYGrBnwd6H9gKZ7qpPc1HnP15z9L3ObOI3lPrUzqG0VymKvQ6UYO7ZqBhsxpUy/mBTZmd27cVTdbGhhgjjD6lBi+No9Tqg9LSWDJ+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715892; c=relaxed/simple;
	bh=13osy5OuIN9wROrH3u5QoCJ8O+XCKY8gGb5LtXm9+a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8A5P5VPC1c8N1NYUMOcFkEW3zDwq161uDMZYMc+00UOoIWPJc0paWNVK72ebIBYFq/Tlso7DS6dQkJveBDfJph2eLqdLH5l0gAWzx+sX8JVzLIl/5cuP8t4bLJC1Vidr1heVv0C3ywzkDUQ2ajqU9XC4Kxs0366ADP4jB7WsCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFXGU1ee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFXGU1ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B98C113D0;
	Fri, 17 Oct 2025 15:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715892;
	bh=13osy5OuIN9wROrH3u5QoCJ8O+XCKY8gGb5LtXm9+a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFXGU1eepqgUJcoQAA+NEtGmz6Fe0PqtPCoYt30SsFHr9vOAfS1RpVYJS0g4jLqkw
	 fYVHyAMDxBtFs39xqMye9rIy72Mt2ePvsL1/X6ObFwOu/1e42tRdzn20ffAlrhuf73
	 Ff4NqMGCXwi00w/BUsiYZBFc5tWSwuYikWC5S79c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.17 343/371] ext4: avoid potential buffer over-read in parse_apply_sb_mount_options()
Date: Fri, 17 Oct 2025 16:55:18 +0200
Message-ID: <20251017145214.490866811@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 8ecb790ea8c3fc69e77bace57f14cf0d7c177bd8 upstream.

Unlike other strings in the ext4 superblock, we rely on tune2fs to
make sure s_mount_opts is NUL terminated.  Harden
parse_apply_sb_mount_options() by treating s_mount_opts as a potential
__nonstring.

Cc: stable@vger.kernel.org
Fixes: 8b67f04ab9de ("ext4: Add mount options in superblock")
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20250916-tune2fs-v2-1-d594dc7486f0@mit.edu>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2469,7 +2469,7 @@ static int parse_apply_sb_mount_options(
 					struct ext4_fs_context *m_ctx)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	char *s_mount_opts = NULL;
+	char s_mount_opts[65];
 	struct ext4_fs_context *s_ctx = NULL;
 	struct fs_context *fc = NULL;
 	int ret = -ENOMEM;
@@ -2477,15 +2477,11 @@ static int parse_apply_sb_mount_options(
 	if (!sbi->s_es->s_mount_opts[0])
 		return 0;
 
-	s_mount_opts = kstrndup(sbi->s_es->s_mount_opts,
-				sizeof(sbi->s_es->s_mount_opts),
-				GFP_KERNEL);
-	if (!s_mount_opts)
-		return ret;
+	strscpy_pad(s_mount_opts, sbi->s_es->s_mount_opts);
 
 	fc = kzalloc(sizeof(struct fs_context), GFP_KERNEL);
 	if (!fc)
-		goto out_free;
+		return -ENOMEM;
 
 	s_ctx = kzalloc(sizeof(struct ext4_fs_context), GFP_KERNEL);
 	if (!s_ctx)
@@ -2517,11 +2513,8 @@ parse_failed:
 	ret = 0;
 
 out_free:
-	if (fc) {
-		ext4_fc_free(fc);
-		kfree(fc);
-	}
-	kfree(s_mount_opts);
+	ext4_fc_free(fc);
+	kfree(fc);
 	return ret;
 }
 


