Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3013D2FF6;
	Thu, 15 Jan 2026 17:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499396; cv=none; b=tCf1rRpxSmkCqp6N/m+M4cSFkGHP4gleTSkqcwksJyWBvWQV0WC4NFl3Aw4kZKvrsioFdX125a7tbzsy7wi3r6W3agT1o7FQMK1o4ryE7DJkCnWhDt4FvZc1vZcyxr+hcyywmg2WeV3+9UCZeNNeG/+TT2X1v/TaUlXzGszA3DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499396; c=relaxed/simple;
	bh=D5myioN0lJ1u06TBCrzOIz4eTeAvXGaT28+AIUl1U+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLl4l23RwHv2pwJhcJCR/UigCnKYwurPSCIbif99TqmGfqO8GhYeTga+bS59B8GEHbktlJ0wdln9lYmBbNyuPc/qJmGCaY0XXRgCBxHLT9pMxEfzz8Mh7lf6SXyABBE6x5dAOUUET1ETO+XMabhGyG5uVgijVf2nzhkr0ox9lI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6fk9zPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6fk9zPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58433C16AAE;
	Thu, 15 Jan 2026 17:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499396;
	bh=D5myioN0lJ1u06TBCrzOIz4eTeAvXGaT28+AIUl1U+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6fk9zPcUGEZHBjyI7FKpKaAGihiklm47auuduesjoDBcxRGS+vMFMh2XT4MfXo+g
	 HmfNKi9kSgR5u4eyfyZ9a2JfyXRGbwmaVuz5XitoG9pZJanUbFltBkdxBma1BAmYxc
	 lqYvMAo2qfrUfB2WCo7tEmPAPVOiLbMLnJkSVifw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 213/451] exfat: fix remount failure in different process environments
Date: Thu, 15 Jan 2026 17:46:54 +0100
Message-ID: <20260115164238.604788140@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 51fc7b4ce10ccab8ea5e4876bcdc42cf5202a0ef ]

The kernel test robot reported that the exFAT remount operation
failed. The reason for the failure was that the process's umask
is different between mount and remount, causing fs_fmask and
fs_dmask are changed.

Potentially, both gid and uid may also be changed. Therefore, when
initializing fs_context for remount, inherit these mount options
from the options used during mount.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202511251637.81670f5c-lkp@intel.com
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/super.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index dfe298bc3782..b8ddb6fb50e9 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -757,10 +757,21 @@ static int exfat_init_fs_context(struct fs_context *fc)
 	ratelimit_state_init(&sbi->ratelimit, DEFAULT_RATELIMIT_INTERVAL,
 			DEFAULT_RATELIMIT_BURST);
 
-	sbi->options.fs_uid = current_uid();
-	sbi->options.fs_gid = current_gid();
-	sbi->options.fs_fmask = current->fs->umask;
-	sbi->options.fs_dmask = current->fs->umask;
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE && fc->root) {
+		struct super_block *sb = fc->root->d_sb;
+		struct exfat_mount_options *cur_opts = &EXFAT_SB(sb)->options;
+
+		sbi->options.fs_uid = cur_opts->fs_uid;
+		sbi->options.fs_gid = cur_opts->fs_gid;
+		sbi->options.fs_fmask = cur_opts->fs_fmask;
+		sbi->options.fs_dmask = cur_opts->fs_dmask;
+	} else {
+		sbi->options.fs_uid = current_uid();
+		sbi->options.fs_gid = current_gid();
+		sbi->options.fs_fmask = current->fs->umask;
+		sbi->options.fs_dmask = current->fs->umask;
+	}
+
 	sbi->options.allow_utime = -1;
 	sbi->options.iocharset = exfat_default_iocharset;
 	sbi->options.errors = EXFAT_ERRORS_RO;
-- 
2.51.0



