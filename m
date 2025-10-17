Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDFB3328F5;
	Fri, 17 Oct 2025 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714640; cv=none; b=NrYtarA5JUuEDCqNoxUGTxDtb0/LYftvMFxPM/c6xD55+kas/k2cyJf1jaY+TmCT+8XxOUojYaIa2wjarpLtibi5yfjjjlOfqG+NijborakSOULiMIgqcV0BV+YPKz6TdaSwmNzc8Vf0x1OG7DG/gvlbOfx3Z77bRrf7ZucgdfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714640; c=relaxed/simple;
	bh=8VpkkCZutAVLxCL4Fq6u5hokSDgeidODHFtUktqSbSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEbNd4QAT87FpVlZTFuoY8afg/SLFI9wAwkpWxEwTyWrlFDH8k4+idWFmlX56SKOl63jEQYSM4chB126nqx5dG5GZJ6XVsqhdA+qh005nB6/GCo7ELWFyt0W6eOU7p9Uggi1mRJi/QyOcBmwGgg2zqBkc5PJCaC7trmCLB8p+Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFIeVWGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFIeVWGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29247C4CEE7;
	Fri, 17 Oct 2025 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714640;
	bh=8VpkkCZutAVLxCL4Fq6u5hokSDgeidODHFtUktqSbSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BFIeVWGwEOdsaFGu4lrgkcOVACAJrPPIK4mdSkiqo4z7ef7bQouWA2te6vv/l2UDT
	 TD7F4OmwIBwDw0LCq/GUDiUGFVAvUXvMnHmReKtLcfRUk7WQSHGzMNVGHZuicTAthY
	 /STQbxTGKq9p/gL78H8kXYM+gFqtF/I2a6HjIlVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.12 216/277] ext4: avoid potential buffer over-read in parse_apply_sb_mount_options()
Date: Fri, 17 Oct 2025 16:53:43 +0200
Message-ID: <20251017145155.017120126@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2493,7 +2493,7 @@ static int parse_apply_sb_mount_options(
 					struct ext4_fs_context *m_ctx)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	char *s_mount_opts = NULL;
+	char s_mount_opts[65];
 	struct ext4_fs_context *s_ctx = NULL;
 	struct fs_context *fc = NULL;
 	int ret = -ENOMEM;
@@ -2501,15 +2501,11 @@ static int parse_apply_sb_mount_options(
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
@@ -2541,11 +2537,8 @@ parse_failed:
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
 


