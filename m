Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D6F197524;
	Thu,  6 Jun 2024 14:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682913; cv=none; b=apVQvVlpm3Lr1yxVaXM2SLV7kAyN+VUqquKl8hbuc+zJwx122G/hZ2n10dl3fRIvW/CqVsCaI1S0x9GawNJK/9wrAWokWoigCIHnpsl7/tqdhU+fY8RX1NcvnIEWe66dOZ/+4tNqOvyLRc89LVS3G2V0iXwLf5lHzDias5SyedI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682913; c=relaxed/simple;
	bh=Pj0W9yKLwK5zFUL4nhh2/fyyYh98/Icy/soct6kTbrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Us3uZD1F4Hh/tX4Ma9VgXvojkkDiiPL2zq0yOr0u6qIz6DuoczGwe3d697hx6kkE1fhtQ4nWB775czwAg87kAOIUi9bQi5q55+DXfrEuopdSM1YNrWWm1txr3wGtp+DBj7Ql/jz2kXvqf8FhMvs/u+7pyhAjKn0aUTTVmzQQN9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhEXOr5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhEXOr5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1BBC2BD10;
	Thu,  6 Jun 2024 14:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682913;
	bh=Pj0W9yKLwK5zFUL4nhh2/fyyYh98/Icy/soct6kTbrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhEXOr5v2I80lU9kaAFeF7rLH9/lTay058pNSuX+Mw0wZc0CcyMd0o054nb2ezJWN
	 YEqTSQMsHYfs3mr0shvQo7FZ36CggsbNr1bAtdCWmlS/mJD2Nl0F6W3ykHdnTZfnCE
	 EfYQUZaqRDW6hmQZwulKHLzpQvr0NngWpk19VFt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 043/374] f2fs: fix to check pinfile flag in f2fs_move_file_range()
Date: Thu,  6 Jun 2024 16:00:22 +0200
Message-ID: <20240606131653.258661543@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit e07230da0500e0919a765037c5e81583b519be2c ]

ioctl(F2FS_IOC_MOVE_RANGE) can truncate or punch hole on pinned file,
fix to disallow it.

Fixes: 5fed0be8583f ("f2fs: do not allow partial truncation on pinned file")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 357367e2cb337..2566dc8a777de 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2842,7 +2842,8 @@ static int f2fs_move_file_range(struct file *file_in, loff_t pos_in,
 			goto out;
 	}
 
-	if (f2fs_compressed_file(src) || f2fs_compressed_file(dst)) {
+	if (f2fs_compressed_file(src) || f2fs_compressed_file(dst) ||
+		f2fs_is_pinned_file(src) || f2fs_is_pinned_file(dst)) {
 		ret = -EOPNOTSUPP;
 		goto out_unlock;
 	}
-- 
2.43.0



