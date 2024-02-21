Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A505C78B4F;
	Wed, 21 Feb 2024 14:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524222; cv=none; b=HoZOs/+lUrFeWluicQwUDhKdWv4urHrKVSfUPFd7mZraHoANFDgGHZ+sgIiouo1g/h7W5CnDbBonW+UpIJDlq9uhMoqzjPJIiRCCtcEExC/wbnPXH2Jjs114GfHX1rWxglKJ9gslXmznhIbDb5XjcrRzMExz/aEzjjO6QqwXY88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524222; c=relaxed/simple;
	bh=mGo0OK+XtskRMXXv7RWD7xvdPVeL6afqyrmbd5n8Ubo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OORNckMWrQPz3V/Nfd5A970zCZboSFxhwZU1rXf23MzFquZeExmtdA59U9bFVa/ZDLeh8TexTZO3Prtmjg50O+/51kE3xvlh5lAOAhoTMVYxjhpNzp0MPcx/CkmgPXt0jumcCXuS5Ni7QQMPRMHb49sNklXm1kD0vjPTEHjxWfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvwJTVpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvwJTVpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FA7C433C7;
	Wed, 21 Feb 2024 14:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524222;
	bh=mGo0OK+XtskRMXXv7RWD7xvdPVeL6afqyrmbd5n8Ubo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvwJTVpdOXMep0nnTfdesg/o7EgU8c/OPRteJao1x8EeY57hMBCz6HplVeHXZkM/T
	 m3c+IY5t3M/KneaptOo56rQsjmlEtpnnX+mcieI2E1o8jhE2/0QBWtCs+hVKVAnd56
	 zTdDot+CdwQobdRwDYMCdA7di8Owk16N9rEXVtUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 181/379] f2fs: fix write pointers on zoned device after roll forward
Date: Wed, 21 Feb 2024 14:06:00 +0100
Message-ID: <20240221130000.262412148@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 9dad4d964291295ef48243d4e03972b85138bc9f ]

1. do roll forward recovery
2. update current segments pointers
3. fix the entire zones' write pointers
4. do checkpoint

Reviewed-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/recovery.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 2700e0fdd3e0..cd56af93df42 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -855,6 +855,8 @@ int f2fs_recover_fsync_data(struct f2fs_sb_info *sbi, bool check_only)
 	if (!err && fix_curseg_write_pointer && !f2fs_readonly(sbi->sb) &&
 			f2fs_sb_has_blkzoned(sbi)) {
 		err = f2fs_fix_curseg_write_pointer(sbi);
+		if (!err)
+			err = f2fs_check_write_pointer(sbi);
 		ret = err;
 	}
 
-- 
2.43.0



