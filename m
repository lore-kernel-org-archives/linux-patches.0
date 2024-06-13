Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DB73209;
	Thu, 13 Jun 2024 12:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281154; cv=none; b=NRrIPOIcdrH22yD63bXzGhtw4i+GhJHnWs/4wth6H4Z5vpP7mg+PvaMHcWEkZQer3TYvTQzjyLLlD8M79ssVQcsi4n2V7vTS6Y96GAaR+r87+Sca385shHU+j4wlkqh5SgoNaxayBuIgk4rLgxzFBTya2GHU2YZaiu/xS/C0SP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281154; c=relaxed/simple;
	bh=bXVZn84L1JWQeKGeOHN2zzKHJ2Xgsm+Qm9jdR0hbeQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAVPMiPMVdDUbhVPuc/ZCaJ/xuJYHodaacab5rKoi3dg/0W+fwDv1ExyKMLOTRo0tGACcdTGhYQ6l4IMpcBIyy6B3m+IKpXix5jFjeff+16ei9hEBJJ6xKqqQA4+V9TT2DmTSE6M2XVYQcjGeOm6P3pxX6DQ/em8i++oIkg6MBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRvDUyS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRvDUyS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D078DC2BBFC;
	Thu, 13 Jun 2024 12:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281154;
	bh=bXVZn84L1JWQeKGeOHN2zzKHJ2Xgsm+Qm9jdR0hbeQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRvDUyS+e7SmiCovEuDp3oDjb9qUT5JWqRr3bJuMCNnZzChyEoC0rxAKVktqziXAk
	 +WUEdqhUmzaMxRLaU/ZvsvuX000rnx4pK95EwePb2r4oHzy7DmuC5nJy0N10eYXwxT
	 7LPuAW2QqMRgj6OchjFtVIy28d2GLu2EOOHjMBmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/317] f2fs: do not allow partial truncation on pinned file
Date: Thu, 13 Jun 2024 13:32:56 +0200
Message-ID: <20240613113253.674642500@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

[ Upstream commit 5fed0be8583f08c1548b4dcd9e5ee0d1133d0730 ]

If the pinned file has a hole by partial truncation, application that has
the block map will be broken.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 278a6253a673 ("f2fs: fix to relocate check condition in f2fs_fallocate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 02971d6b347e0..e88d4c0f71e3e 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1745,7 +1745,11 @@ static long f2fs_fallocate(struct file *file, int mode,
 		(mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE)))
 		return -EOPNOTSUPP;
 
-	if (f2fs_compressed_file(inode) &&
+	/*
+	 * Pinned file should not support partial trucation since the block
+	 * can be used by applications.
+	 */
+	if ((f2fs_compressed_file(inode) || f2fs_is_pinned_file(inode)) &&
 		(mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE |
 			FALLOC_FL_ZERO_RANGE | FALLOC_FL_INSERT_RANGE)))
 		return -EOPNOTSUPP;
-- 
2.43.0



