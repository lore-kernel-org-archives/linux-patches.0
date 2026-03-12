Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E0A3242AC;
	Thu, 12 Mar 2026 20:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347142; cv=none; b=uxvdvR9dpAoj7iju0gpuuqHxAASnPvnglmFjDG//2afb2q4lG6aO1xK1WtYNowIWwKXzFpWn6Vmvivt49fzFYc6tE9x9vlcTQtp7A1Y+Rmh3TPuxWnL90exqo8VWytgjHQg8kvxQYcTtll39vYz9d5jFVChW/UHi3wDqmvjY4xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347142; c=relaxed/simple;
	bh=FM49YhMbfB1jtvVZ9xGX/hDJNPx6O1EMSZNR2c7ZCzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEkNDhGS2DnSuQ24WtGaOSm73xE8gI71xfhqwc608EJNUDNqkS0S38bbLpWM7oUmVHCy6nR6qnbdnEwp9aZUKWrIBaxrlb2A4yGSKk8TxrkERMDTtTZ2iVYRdrxJ4i/MiHc0TSKlJ5LgaLTRqjfLZdS/Yr2ugyIxzI86yLpwoSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwnATqXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwnATqXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE649C4CEF7;
	Thu, 12 Mar 2026 20:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347142;
	bh=FM49YhMbfB1jtvVZ9xGX/hDJNPx6O1EMSZNR2c7ZCzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwnATqXNWnbg/p/SW3CZcOrdBfRhTQ20KQK1U+4ieHSzwN5VF3zmoEakhVDDnjq4W
	 CzeIIeZQc2Snen+5vFZqj4x/Qud135Fa40Hf0obP7u5dUDiR8uho99RLW5KzQAHofj
	 eGvOIBPW0vH7O7Xh/h4RoCtI6Ug/HbemA/UxVEis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 215/265] smb/client: fix buffer size for smb311_posix_qinfo in smb2_compound_op()
Date: Thu, 12 Mar 2026 21:10:02 +0100
Message-ID: <20260312201026.086863434@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit 12c43a062acb0ac137fc2a4a106d4d084b8c5416 ]

Use `sizeof(struct smb311_posix_qinfo)` instead of sizeof its pointer,
so the allocated buffer matches the actual struct size.

Fixes: 6a5f6592a0b6 ("SMB311: Add support for query info using posix extensions (level 100)")
Reported-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 1c65787657ddc..cac14c7b3fbc2 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -315,7 +315,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 							  cfile->fid.volatile_fid,
 							  SMB_FIND_FILE_POSIX_INFO,
 							  SMB2_O_INFO_FILE, 0,
-							  sizeof(struct smb311_posix_qinfo *) +
+							  sizeof(struct smb311_posix_qinfo) +
 							  (PATH_MAX * 2) +
 							  (sizeof(struct smb_sid) * 2), 0, NULL);
 			} else {
@@ -325,7 +325,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 							  COMPOUND_FID,
 							  SMB_FIND_FILE_POSIX_INFO,
 							  SMB2_O_INFO_FILE, 0,
-							  sizeof(struct smb311_posix_qinfo *) +
+							  sizeof(struct smb311_posix_qinfo) +
 							  (PATH_MAX * 2) +
 							  (sizeof(struct smb_sid) * 2), 0, NULL);
 			}
-- 
2.51.0



