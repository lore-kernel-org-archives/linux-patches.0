Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E056156222;
	Mon, 16 Sep 2024 12:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488559; cv=none; b=SPV0WconTMWUm/rziWjR6s7ZFJbNLWHtX7SoTvsGKzcVOufaOrIvEjAlkRK64QZg/tFNe4RruIZhhf1AdrVf3hkdlAaBLi3kxfaSoeD62TaNIkKN734zFQpls87h4bcOMWqYg5dd1vqaKmnRU9fdhsOBkrDxNf1L74qXqYLS4ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488559; c=relaxed/simple;
	bh=ZL/sLatXinr9DessbpTwzpw9w/cdOb4GGhdnPHCthkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kw9UpCn+fMfkwaFHGsVdzvSdAL0IWyVWX6JeUqGHSHGqXIpqgRot2fORE7lfwlgszzehrUETUNXe63zAhehJdym0py60q95bpNrUQZru0o3QvIKRwIvwk+Y7C4S7NOeYGd40lmnIpluhtvUL/+0SwA2kP5UAz74ezDDOTNVaaq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iOilcW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iOilcW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD1AC4CEC4;
	Mon, 16 Sep 2024 12:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488559;
	bh=ZL/sLatXinr9DessbpTwzpw9w/cdOb4GGhdnPHCthkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iOilcW3LzoLFoL7YbqCFd2LoGfxw8P5n4DB4y072qFuNmaKtVQhe2UZfUX8IZTOt
	 sVf/bGBkyZ1zvIe8hzajvESu6vnKwErN0EasfsEUAnDQ2iZXZwA86CS34x6w7Xqnrs
	 10qZotZv8dVraMjb4wOdazhrjVcEwKfi5vVEh3tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 34/91] NFSv4: Fix clearing of layout segments in layoutreturn
Date: Mon, 16 Sep 2024 13:44:10 +0200
Message-ID: <20240916114225.636756523@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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
index e7ac249df1ad..299ea2b86df6 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -9845,13 +9845,16 @@ static void nfs4_layoutreturn_done(struct rpc_task *task, void *calldata)
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
index 664d3128e730..3d1a9f8634a9 100644
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



