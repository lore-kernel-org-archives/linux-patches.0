Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CD21553BB;
	Mon, 16 Sep 2024 11:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726487986; cv=none; b=qigIESwFpMPLEuvBl86E9MmulipvdwYX/w5P7AJQUD0Gpin0TRtH8UImFAidr28A4fb5B0PfVPzOEaYkLWc9zP5MDEuYkXKrM1p+Ok3vXaPOl9txytDw75cygSaXRZ70lU+IMIAnzlVjRmioNFKc7wi29cDCAnAmLZdYyvjGZkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726487986; c=relaxed/simple;
	bh=GaLtUpipQ4gHwOGB0eThkqcpFyLspf255Yt0t9CcLQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4ws2NvaMic9QLCEgG8fkUxDFmTkqncE5pXegdmM049XLBQSWy75+vsm3ULLP6RDwIeGWoBRSeLqOslrK2mEAIfZneqLx78Gks1Enk8o1EsC1Tnxt0JY8BSSR07QSNfxcisSEUQxRhWYKyd8CLWFABNzY/lJcGrQoLeejBCGlXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohRTTIs+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohRTTIs+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8456BC4CEC4;
	Mon, 16 Sep 2024 11:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726487985;
	bh=GaLtUpipQ4gHwOGB0eThkqcpFyLspf255Yt0t9CcLQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohRTTIs+R0emyaknjsxXlfOFsu9cEd6kmMTsgv+Go8knkjIh1bs7QyBmfRr5qoUz6
	 J8jbU8C17f6paQaBDwWx+Mm2wIqh5oWJYuHsXHvHl1HpTjMoOLDaDD8byLX2q9G7fq
	 UfqjxBEAtr0cYMLiJDMQm8J4O+g6hjfl0WzVMxaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 19/63] NFSv4: Fix clearing of layout segments in layoutreturn
Date: Mon, 16 Sep 2024 13:43:58 +0200
Message-ID: <20240916114221.748222733@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 467e9439eded..1e97de7c8c20 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -9850,13 +9850,16 @@ static void nfs4_layoutreturn_done(struct rpc_task *task, void *calldata)
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
index 8c1f47ca5dc5..c96d2e76156e 100644
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



