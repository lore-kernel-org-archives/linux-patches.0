Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B9D146592;
	Tue, 25 Jun 2024 09:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309078; cv=none; b=o5scbKX0qOVlID8nu2j6claEARZo3sHLhH007nQXADx2YC8T7TXMEdMC8e6nENV8JSVLoOPqMXVIHc7uGDJF1Qft00tpPbQTuoIIe346i4wnreROSOjbhKblYIkwJsq2UQHlaSUrW9s6idej73zEXgwEa+lPf2nLo2VI2Dw+t2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309078; c=relaxed/simple;
	bh=FfV2GWWmPj4tPiyqb9P5hTuMUGBEOMSZwycstp9i1jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7ALi/Oz4TD0oM6C44S22biAB/QX2Lsg4XoygdMURfoX05THuTZ2Iwa/mPOH4RgXUH1gojJKiCsHTvGfTPh0L1Sf8E7IH7ElSmiEt17mY15NKs/C7UPcBbcAzt71c0HimN5sFCPsKFoevPF1Q9CCwzAlLAJ6QJYDOlz8mpyZrAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxnuujMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxnuujMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E076C32781;
	Tue, 25 Jun 2024 09:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309077;
	bh=FfV2GWWmPj4tPiyqb9P5hTuMUGBEOMSZwycstp9i1jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxnuujMooQkE5pbU6bycZhVALiIdOjbanRvdIGP0azZy5TwQr/XUAcZ3Gm9HUBYFp
	 +ngM+7hZTg9crN78gaOf1uEN7O9DwS3Pd0qaRO653RN3zkY0ediOyErT0y88r8BZaF
	 XA/1k7T7oE8ggB9AYmw4wiy3NwUEjiulKvJxZ9Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunlei He <heyunlei@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/192] f2fs: remove clear SB_INLINECRYPT flag in default_options
Date: Tue, 25 Jun 2024 11:31:58 +0200
Message-ID: <20240625085538.937262054@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ce2293e13fadd..43424ca4f26c5 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2123,8 +2123,6 @@ static void default_options(struct f2fs_sb_info *sbi, bool remount)
 	F2FS_OPTION(sbi).memory_mode = MEMORY_MODE_NORMAL;
 	F2FS_OPTION(sbi).errors = MOUNT_ERRORS_CONTINUE;
 
-	sbi->sb->s_flags &= ~SB_INLINECRYPT;
-
 	set_opt(sbi, INLINE_XATTR);
 	set_opt(sbi, INLINE_DATA);
 	set_opt(sbi, INLINE_DENTRY);
-- 
2.43.0



