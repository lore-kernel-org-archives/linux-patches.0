Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E834D1AD493;
	Tue, 18 Jun 2024 13:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716813; cv=none; b=UfBhtPJtQ1HJTq3yOb1XvAbLpGykxKPLsE5xMWoW6Ny4wurR4uxm8JhfcKDkQDv59sdK789vZ4cuUQdLKrm1k/gcZpucELyFdm0r5Mcsw50qHfBUhIRLxkYWd7CBL3MYkR2Y7DoUqXdKmReMW3ojFykt35aY/po5D+ekOMwibHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716813; c=relaxed/simple;
	bh=fZtE8QgmZM6eArI7mjbaPkLUonmCkHjxDYMxSTw9XBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUaMzMgdgruiNSwx/DJOp2+57Hw/kIEI1FaiqZKaZUplBwTpcmPw1J2dJIniD5Hlp+n3Aw07BRQeU0frBrxgP2wrXzYkkKynhEpA5hpPTi15urfMcSXCJfPRB/2Mr0K/qUfDBPKVdDfrDWWqWFn3NRqc+A5X6Nj1Im/7O8sSWt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5ioYC5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5ioYC5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA93C4AF1D;
	Tue, 18 Jun 2024 13:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716812;
	bh=fZtE8QgmZM6eArI7mjbaPkLUonmCkHjxDYMxSTw9XBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5ioYC5zeMdayW3wGnGh66LsZ24sVkxGsX2tK8VZeufV5qMWFDC/suzetAxxamVIb
	 C4XBCTH1BVpIcs/f53x8Pr0gubNCC7OCBeTM2clOoJ8wbwlRS6Jikb2zqUYddF5Puj
	 ptPwNBaK9ORp81rLm3JidowEoHa9c5a2+O+TS/nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 754/770] NFSD: Fix problem of COMMIT and NFS4ERR_DELAY in infinite loop
Date: Tue, 18 Jun 2024 14:40:07 +0200
Message-ID: <20240618123436.373411101@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 147abcacee33781e75588869e944ddb07528a897 ]

The following request sequence to the same file causes the NFS client and
server getting into an infinite loop with COMMIT and NFS4ERR_DELAY:

OPEN
REMOVE
WRITE
COMMIT

Problem reported by recall11, recall12, recall14, recall20, recall22,
recall40, recall42, recall48, recall50 of nfstest suite.

This patch restores the handling of race condition in nfsd_file_do_acquire
with unlink to that prior of the regression.

Fixes: ac3a2585f018 ("nfsd: rework refcounting in filecache")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 6b8706f23eaf0..615ea8324911e 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1098,8 +1098,6 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	 * then unhash.
 	 */
 	if (status != nfs_ok || inode->i_nlink == 0)
-		status = nfserr_jukebox;
-	if (status != nfs_ok)
 		nfsd_file_unhash(nf);
 	clear_and_wake_up_bit(NFSD_FILE_PENDING, &nf->nf_flags);
 	if (status == nfs_ok)
-- 
2.43.0



