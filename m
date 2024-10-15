Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95091EBFF1;
	Tue, 15 Oct 2024 11:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992133; cv=none; b=rgsdn1/7n2hW1aTRPkubL0pco+3OSuHC41gXOGFpC21XbiE8J2ITxuD/NhS0327WEFL34IsMpw3Tm/7hsnX1GU2fJDsKX1BjKpwPkDaIvRQQt2YxuaD4Mh47q1bjcvSfuyjGYcAy9UME6jDE5DhbnYeuDEHTv6JT6nNesTVUuqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992133; c=relaxed/simple;
	bh=r0nT14xTc4nwEHEkDql0gwBB9frjgzORyij4VrzhVxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOM1CHtKfikrCAVCJKMWusFNncdlLZivSfHmDztscUgMkap7KlybkKrh1oZ4BtpHXx+6RiqDAr9QWjS03pKL8S88YxneI02M10x37aMaoPtdnksWE5KvcZUH0UxBpNGSgH0ktXYaTXdsI2I/lNCS7c3PoCdEbbc9Jz7zSZFTtLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7jWEp2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7jWEp2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59BCC4CECE;
	Tue, 15 Oct 2024 11:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992132;
	bh=r0nT14xTc4nwEHEkDql0gwBB9frjgzORyij4VrzhVxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7jWEp2p69b2NEFY00/g1jBlVZwJ5hKkuEwPLD3f4wHeSVByaMBZ2fQ7NQWp46rPU
	 OkNVH0p6oUBuJKx5AviO4hjyk8SIOhsx0Leie4biRt9rQbjbkSLFI9Tjf4heAOnoms
	 gs1KblfP9VfZ3utkTpAcLtlHF92oihz3GjeqMoHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/691] NFSv4: Fix clearing of layout segments in layoutreturn
Date: Tue, 15 Oct 2024 13:19:35 +0200
Message-ID: <20241015112441.411866439@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 770fa1cb112d..f1c351e40c7a 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -9755,13 +9755,16 @@ static void nfs4_layoutreturn_done(struct rpc_task *task, void *calldata)
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
 	dprintk("<-- %s\n", __func__);
 	return;
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index e13f1c762951..fb12a2193884 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1169,10 +1169,9 @@ void pnfs_layoutreturn_free_lsegs(struct pnfs_layout_hdr *lo,
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



