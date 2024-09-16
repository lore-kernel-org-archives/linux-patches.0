Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F9115624D;
	Mon, 16 Sep 2024 12:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488307; cv=none; b=ieQ/4SK0z7Fuvjj2jKekF867rgl7GYt62Ug6VRBNzP6TTsfs2WIrsQjBaEmo/YM3d448pr6BIK/pd7DKrI6sWqBbIztU8DLUcewPabZ06So6s6D8bRoqL2FHlV/YmZvw9mggRHXU33PmU0f6psLr53IqDCpvM3MNE4DOtbsUS2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488307; c=relaxed/simple;
	bh=FjSLexsYbkpRIBLLpc0XZWh9rkYlT8G8juacxiFHz/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTcdXegtgVGYHrvFhKRwkvPp8N7nlvp0CaNTsmLV/Z1d2ure2VP3389inSL7Jjc7SSqhSl02LsSmSX25jww4iUTWpGkykLsLbPAwZsNQhxoScVHkVObK4VFHdpjth6JsuUGK4Slvuf8zUTyLlfTPL8pltOIdF0hfAbvzBXybUNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahJtROz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahJtROz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0284DC4CEC4;
	Mon, 16 Sep 2024 12:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488307;
	bh=FjSLexsYbkpRIBLLpc0XZWh9rkYlT8G8juacxiFHz/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahJtROz8Hf32TbG1o4Au+GHrljTgehjVBHVJjMGrd+HwHNcbvV9rH5eGmMldLNkhr
	 3Sq2OegjOsVhyrT0JlIgJhDtoshdh78nw+lQJtwopGeQ2+piHNMf6ZB5cGiH/UB4Dt
	 Of4eZJt87eIErrk22Xr6Akn2V7mPvLUzM9UnKawk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 041/121] NFSv4: Fix clearing of layout segments in layoutreturn
Date: Mon, 16 Sep 2024 13:43:35 +0200
Message-ID: <20240916114230.492886265@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit d72b7963115bea971a28eaa2cb76722c023f9fdf ]

Make sure that we clear the layout segments in cases where we see a
fatal error, and also in the case where the layout is invalid.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 9 ++++++---
 fs/nfs/pnfs.c     | 5 ++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index bff9d6600741..3b76e89b6d02 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -9873,13 +9873,16 @@ static void nfs4_layoutreturn_done(struct rpc_task *task, void *calldata)
 		fallthrough;
 	default:
 		task->tk_status = 0;
+		lrp->res.lrs_present = 0;
 		fallthrough;
 	case 0:
 		break;
 	case -NFS4ERR_DELAY:
-		if (nfs4_async_handle_error(task, server, NULL, NULL) != -EAGAIN)
-			break;
-		goto out_restart;
+		if (nfs4_async_handle_error(task, server, NULL, NULL) ==
+		    -EAGAIN)
+			goto out_restart;
+		lrp->res.lrs_present = 0;
+		break;
 	}
 	return;
 out_restart:
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index b5834728f31b..d1e3c17dcceb 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1172,10 +1172,9 @@ void pnfs_layoutreturn_free_lsegs(struct pnfs_layout_hdr *lo,
 	LIST_HEAD(freeme);
 
 	spin_lock(&inode->i_lock);
-	if (!pnfs_layout_is_valid(lo) ||
-	    !nfs4_stateid_match_other(&lo->plh_stateid, arg_stateid))
+	if (!nfs4_stateid_match_other(&lo->plh_stateid, arg_stateid))
 		goto out_unlock;
-	if (stateid) {
+	if (stateid && pnfs_layout_is_valid(lo)) {
 		u32 seq = be32_to_cpu(arg_stateid->seqid);
 
 		pnfs_mark_matching_lsegs_invalid(lo, &freeme, range, seq);
-- 
2.43.0



