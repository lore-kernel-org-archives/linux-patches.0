Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63B512EBEA;
	Tue, 25 Jun 2024 09:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308291; cv=none; b=UXl5UF8scrNbAX7muBRPw5t2sMCe9xFU5g558TcmNk7dmwpXmgWvG2RY3yG3LbMQzx/l8l4qorydW6AZTBWU0AKAuHvNcFGTOp93mlj2HGB/pEKv97l/i6bIV3P2HTe20EzoEfHLO8kENa9GYVtQ+qqAq7nWNWkOSIqqNqDwiU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308291; c=relaxed/simple;
	bh=6mEhdq90ijwRj5oxsLa6jX2WTYXSkraCLUp0bwiOqt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHujKMPK21oCf1nC9s8ml6SO/EVezmWw0jJ9OEV/WNmH6NSIpmk8I7AH22MCkNEvatEs89FMxfW9LqZnd+tSYBf8ZjLdgq9rfjjcN0a90UsYgkHrydJGSt4xK0LI91KaOfgZ3s533HAaRIrVbWrj9XbeG8XDWlXyPWhylOZEzS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rn45J0nF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rn45J0nF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBDCC32789;
	Tue, 25 Jun 2024 09:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308291;
	bh=6mEhdq90ijwRj5oxsLa6jX2WTYXSkraCLUp0bwiOqt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rn45J0nF9l1TLOKrQTaHEHxlvGI5liodvpSoy8PMkazBjMnzAWCXkWwnzjoaMiJTy
	 lIBLgZihGMw6AE449sOCq3wpomj7idOT4eciKNzbLhEmStwN8nTHG8nmYvrwSz0CeO
	 pVz4U30R+g8ckghc0Wfegi2qbPUX+hkgb5sjpRNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunlei He <heyunlei@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 072/250] f2fs: remove clear SB_INLINECRYPT flag in default_options
Date: Tue, 25 Jun 2024 11:30:30 +0200
Message-ID: <20240625085550.829628209@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunlei He <heyunlei@oppo.com>

[ Upstream commit ac5eecf481c29942eb9a862e758c0c8b68090c33 ]

In f2fs_remount, SB_INLINECRYPT flag will be clear and re-set.
If create new file or open file during this gap, these files
will not use inlinecrypt. Worse case, it may lead to data
corruption if wrappedkey_v0 is enable.

Thread A:                               Thread B:

-f2fs_remount				-f2fs_file_open or f2fs_new_inode
  -default_options
	<- clear SB_INLINECRYPT flag

                                          -fscrypt_select_encryption_impl

  -parse_options
	<- set SB_INLINECRYPT again

Signed-off-by: Yunlei He <heyunlei@oppo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index a4bc26dfdb1af..e4c795a711f0f 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2132,8 +2132,6 @@ static void default_options(struct f2fs_sb_info *sbi, bool remount)
 	F2FS_OPTION(sbi).memory_mode = MEMORY_MODE_NORMAL;
 	F2FS_OPTION(sbi).errors = MOUNT_ERRORS_CONTINUE;
 
-	sbi->sb->s_flags &= ~SB_INLINECRYPT;
-
 	set_opt(sbi, INLINE_XATTR);
 	set_opt(sbi, INLINE_DATA);
 	set_opt(sbi, INLINE_DENTRY);
-- 
2.43.0



