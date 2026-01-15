Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF8A27AC5C;
	Thu, 15 Jan 2026 17:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497710; cv=none; b=lfXat5yV9ufI/9oRrV58l9gmuWleORneVVZYijO0MfCiYGutKE2YOkDSTtok1sebkquPm4Y6Gjtzpz96nZMYcUqevSJ9I79WajrF1KhFr+aNzFysgEWsfLvGjenqRIVUmRJ3WU+6Qq+uLsELQ5zDCU8NTIsLR9uIXMPxVH5Y/P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497710; c=relaxed/simple;
	bh=L8lNmek2Et6GGckIb4QQnpbMJhUsNm6+3M9pDEg30us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0V00BrqVRgtui/GZLYqeVqigOBpxH3oomJWTnjJjyJFMXkue9rfHUMgLiJ4qJDi8qrPMhzvwf/MkDDMhDtClthPZo+eL2JIYr1QZXDLf8x0dVILvd9IfWZtDdccptDgJ/XWZpWvqD5UeWRe5aKfDNvc4b+Mp2ygYk5khZ378mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzXkYNlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzXkYNlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0D6C116D0;
	Thu, 15 Jan 2026 17:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497710;
	bh=L8lNmek2Et6GGckIb4QQnpbMJhUsNm6+3M9pDEg30us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzXkYNlOZWjFgerPpQWDyWJ8xx7tpYqBlVRykVPs/rKXLTr7NPHWvkV+b1Z5RpPM5
	 +QzXkIxa+KhnKFy30qjASvAm1CxcrbNaX70wRIQQiPxEP70hrRGoWMx5FyUMC1sy7f
	 cOlFvsqnrtIIjhIygPWsy19YPL9RhIhP+bRdrqe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 177/554] Revert "nfs: ignore SB_RDONLY when remounting nfs"
Date: Thu, 15 Jan 2026 17:44:03 +0100
Message-ID: <20260115164252.675156354@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 400fa37afbb11a601c204b72af0f0e5bc2db695c ]

This reverts commit 80c4de6ab44c14e910117a02f2f8241ffc6ec54a.

Silently ignoring the "ro" and "rw" mount options causes user confusion,
and regressions.

Reported-by: Alkis Georgopoulos<alkisg@gmail.com>
Cc: Li Lingfeng <lilingfeng3@huawei.com>
Fixes: 80c4de6ab44c ("nfs: ignore SB_RDONLY when remounting nfs")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/super.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index cc70800b9a4b2..aa11a6dcf6ce7 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1017,16 +1017,6 @@ int nfs_reconfigure(struct fs_context *fc)
 
 	sync_filesystem(sb);
 
-	/*
-	 * The SB_RDONLY flag has been removed from the superblock during
-	 * mounts to prevent interference between different filesystems.
-	 * Similarly, it is also necessary to ignore the SB_RDONLY flag
-	 * during reconfiguration; otherwise, it may also result in the
-	 * creation of redundant superblocks when mounting a directory with
-	 * different rw and ro flags multiple times.
-	 */
-	fc->sb_flags_mask &= ~SB_RDONLY;
-
 	/*
 	 * Userspace mount programs that send binary options generally send
 	 * them populated with default values. We have no way to know which
-- 
2.51.0



