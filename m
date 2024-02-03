Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BE910A21;
	Sat,  3 Feb 2024 04:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933861; cv=none; b=SkdYEyDg8XA4jpW/kALU4nNAz0hH8T6W9wuXyW+nJzxxkcBihAnegmySfmmA4oxxD8s+1bNMrXmBgTU7TDj4cteu0WIKacKulzeoWlsISsx0VsLLB0dLWl7+GdzE+rGm9yuvLlHJfy08dkUe0o7QpT5iBp+Hmy0EXzIvWJYXuV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933861; c=relaxed/simple;
	bh=1LmhcRjwEqDjn4I/24BxWzG1dOQsPabfexHVZ/7mqAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mX3W/SCknGfg++Y4eN2zMG/V3kke9UTbTJ921BR8+5m0IHyOrtS6uooD61NfgIkxqDnoSq51XBLHUdgs/eaHRx9guL63VGsDugTc/pHNVx9p9nECztwX/qkYxk3xQYEE1Fni+zOEb/Xhr7WT58XV6+15xTR+I6/WsEUitlMWYpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mv5sZ+Bm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mv5sZ+Bm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515DAC43390;
	Sat,  3 Feb 2024 04:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933861;
	bh=1LmhcRjwEqDjn4I/24BxWzG1dOQsPabfexHVZ/7mqAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mv5sZ+BmIoWakCuMiL3XtZw6/e/9ImBDRMUe8gyLOBvvPZLRX88+B+Y2LolwTZXJE
	 fs65G7JTQiloiKiCfuzLfmDPWFZeJA3TUaEFMxDHpFyP05SNxLiyVfPsvwmfACkhWg
	 NfOug1Jt1ErXaoxM8HbW9x0wXp+OdPewWBcuDYjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 172/353] f2fs: fix write pointers on zoned device after roll forward
Date: Fri,  2 Feb 2024 20:04:50 -0800
Message-ID: <20240203035409.079434575@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 16415c770b45..d0f24ccbd1ac 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -917,6 +917,8 @@ int f2fs_recover_fsync_data(struct f2fs_sb_info *sbi, bool check_only)
 	if (!err && fix_curseg_write_pointer && !f2fs_readonly(sbi->sb) &&
 			f2fs_sb_has_blkzoned(sbi)) {
 		err = f2fs_fix_curseg_write_pointer(sbi);
+		if (!err)
+			err = f2fs_check_write_pointer(sbi);
 		ret = err;
 	}
 
-- 
2.43.0



