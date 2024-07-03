Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F31E181D17;
	Wed,  3 Jul 2024 11:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004792; cv=none; b=X22uNRg4FeMrAJCv2rUMxay/z4YBNtBj1FQbQwNYkMap620oOU9E813kUkSw4bCYP0HHfl1zemxvjIwUX2CChfWgRTtmbTM85EIFPzoyoHxiipCVAVHBUK807UmicpMlivyCig5xkIi9MFEoaz1w8hflaei1Ijk5VdrMgZe/eu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004792; c=relaxed/simple;
	bh=BQIpY7MUJpHd2H5iUEGUcOfzVuXAbKF+rTdaqImjMHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opfaGXEv3guPe40rryX2AQJ1zl+onG8FhUztHetilk9yTBSnND5wJMTM2SrgVX1ZrsBDnoK9DdOrOpCIeLVMx6eP5+V9Mr+T/THBFehPW2HrMeXnqnwSKnsWu2txuSdz2Oo81mcANQPbhDbm7WS613/+fjYFrFFrmwTLhNTTVJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCaKaAQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCaKaAQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12C3C2BD10;
	Wed,  3 Jul 2024 11:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004792;
	bh=BQIpY7MUJpHd2H5iUEGUcOfzVuXAbKF+rTdaqImjMHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCaKaAQhTq4cPpJAYt1PetBc+WAZTcX+RWlbntB7lpeUX2v/Q8hqHNZmaknlol5It
	 hQiAiIvTe+wYT8Me49sAagSGihVIUREEco/NusTmdsC5hsB2cjC7LORuUf2H6iFGEB
	 SvrnjJ7P/NNV7eZBVOpiF4POQvlHIGMgW18B1vrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunlei He <heyunlei@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/290] f2fs: remove clear SB_INLINECRYPT flag in default_options
Date: Wed,  3 Jul 2024 12:38:30 +0200
Message-ID: <20240703102909.058803817@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1281b59da6a2a..9fed42e7bb1d2 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1745,8 +1745,6 @@ static void default_options(struct f2fs_sb_info *sbi)
 	F2FS_OPTION(sbi).compress_mode = COMPR_MODE_FS;
 	F2FS_OPTION(sbi).bggc_mode = BGGC_MODE_ON;
 
-	sbi->sb->s_flags &= ~SB_INLINECRYPT;
-
 	set_opt(sbi, INLINE_XATTR);
 	set_opt(sbi, INLINE_DATA);
 	set_opt(sbi, INLINE_DENTRY);
-- 
2.43.0



