Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0805D14A4D1;
	Tue, 25 Jun 2024 09:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309515; cv=none; b=nO4BB0lU7pE4opzmUaENCimZPlMJP2JIT4144jp9NdMYxaRhroKYb6jAiudxf48zpD53ApexMzsi9VRwg87Avyi3pQkZmlrPo1I5bnS2QXtNEknUX9imRDaXFpTU+xnns098KfltMtHH/vMVHiyytAUfoMK874VhgwmvQWdsrkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309515; c=relaxed/simple;
	bh=VkQ5vmY5TxJ6hAqRr2SMvSpaQJWz0EzoMlppJ0i1THA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpyoNQPoOATUvODsic6mSN+nZ+zZs9U/7BJnp4AbVb9WZE8DKmomfQ9ILo2Xc80wEf2JxIVkoR5EGke4LI55d029O+GaLZiVm8hyLnpvSb1uLGb6lfDVf/mcPAEzMLr9mqyRI/jMVudJo8MvI97cFtNPOAsw7he7iUIieFe8HhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxxNN3kV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxxNN3kV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7589BC32789;
	Tue, 25 Jun 2024 09:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309514;
	bh=VkQ5vmY5TxJ6hAqRr2SMvSpaQJWz0EzoMlppJ0i1THA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AxxNN3kV1R6xdNf9rNKbkfwuJGr1FqMoTg+ff/MXBYrjHiv4OguuZDgCMaT5F/4NR
	 uojcaK0+Wgl6qLztAK8RgWmB+S1p8FEIzZRsNwofWoa0BA025+u88owP1TAcXmPLGG
	 YlZwQ4Qf6E3hjO+sbKN3ulq+IukQxMV/UUZMG+zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunlei He <heyunlei@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/131] f2fs: remove clear SB_INLINECRYPT flag in default_options
Date: Tue, 25 Jun 2024 11:33:09 +0200
Message-ID: <20240625085527.248120075@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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
index c529ce5d986cc..f496622921843 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2092,8 +2092,6 @@ static void default_options(struct f2fs_sb_info *sbi)
 	F2FS_OPTION(sbi).bggc_mode = BGGC_MODE_ON;
 	F2FS_OPTION(sbi).memory_mode = MEMORY_MODE_NORMAL;
 
-	sbi->sb->s_flags &= ~SB_INLINECRYPT;
-
 	set_opt(sbi, INLINE_XATTR);
 	set_opt(sbi, INLINE_DATA);
 	set_opt(sbi, INLINE_DENTRY);
-- 
2.43.0



