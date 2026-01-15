Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8497718AFD;
	Thu, 15 Jan 2026 17:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497970; cv=none; b=YwXe/bT8ocHMPABafg9DAAWbtaeb0ALqWQJVxBSJo/n5qCEV2rfhSXbGRQKzKwnkZ1wrTvL2DUzvOIPKghx9UrDG+Mg0+LSFoD44XeDgMdZ0+/zbbnVVOU+f8amYM/XOZ1Rik4rl9SPSwlelsC6wQVF3w2/w0wdMG+4rMRwnxO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497970; c=relaxed/simple;
	bh=JaSNyWtI/RyusvMqjut26DvWodHK7nF/ZBrC7a36YuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnbQ5DzI1z+Nc0/CukFTGCCrC9ZqtFbLY64pe9uQPoDPoBG1olC53g17kEwdedtchecqzxCTHutBOIq8ENmtrIPp/Ojq29iLApJddMKz3onerEjFmfilPDDXQ8KuCQSeN25ol2VPpbeF3Ayr9yjP0l9A6g9mhMhXPsQ1F9xvLjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvjekeQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvjekeQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC037C116D0;
	Thu, 15 Jan 2026 17:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497970;
	bh=JaSNyWtI/RyusvMqjut26DvWodHK7nF/ZBrC7a36YuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvjekeQWHFLiwPRkO91E/mWIcAz072O+rV4cIYrmM5R+DX9z+6WQMK8V+w10LFHeh
	 HvtJ4oOzFDOMaGmzIlCfbB0PdWHPh1oXCRYXnXJ07gZpVCjcRvu6eZYXPjhcZ0y1+R
	 RoCl3UerLC9vUuus5jBtJSolGjdo5GOjfTbC8snU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/554] exfat: fix remount failure in different process environments
Date: Thu, 15 Jan 2026 17:45:33 +0100
Message-ID: <20260115164255.895465637@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 816ba7e1607f..39e999c0de75 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -758,10 +758,21 @@ static int exfat_init_fs_context(struct fs_context *fc)
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



