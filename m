Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A32711739;
	Sat,  3 Feb 2024 04:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933599; cv=none; b=P+j3iVb21kiHJxURAN6TDTxF5Vr3rMljwpjEC/SJEeTxGXwufMXjaBYlQRrLxGQ+/ZCRXgFAhGcz0i6n+SzShyaE673Jk6Hta2g3pnR0cYG5myNRpzXov/wYL6wEdWEjGXsUd3ksRs8f5T1lqnZUV20ntSaS8Po8GTVZT1daAA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933599; c=relaxed/simple;
	bh=wfAIuttZyrS6ia3CGrEzOoFd6THxwM/xYYeztnxMG7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cl+rV9FG4sGEAE9x2xo5WMGAU+fqq3nHP2l5gO5IvFfpXXnCWulaTzsxDTdk3BV7iTlyaQ6PgHeZy8e5ereL41QxHXmiOuOIjjYVctthA9dInWQsl4Dm89Lc1+IR+/R8iNxDchvsZ8KPEQ53Bt0Ca2VufWp05iCa291kgSRFRcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvBzWMtz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvBzWMtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818BAC433F1;
	Sat,  3 Feb 2024 04:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933598;
	bh=wfAIuttZyrS6ia3CGrEzOoFd6THxwM/xYYeztnxMG7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvBzWMtzsNmAGMrwqj7uKYxUDwOLoE4xAFg/e+soXL9Krw6kKtObj+2lPApih808q
	 RZUyYoFmLrxhTQyESWCs1fhPlLo20LKLYCgYQsDvLc/oKk0+nz48+LgbpvMDcxd/dN
	 DqHhJ56iejBbeg/BvJ5hzJdTXIG84NyQXbfXMgkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/322] f2fs: fix write pointers on zoned device after roll forward
Date: Fri,  2 Feb 2024 20:04:23 -0800
Message-ID: <20240203035404.597995836@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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
index f0de36ef73c2..c8ba9f1551b6 100644
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



