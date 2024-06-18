Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335B71ACE60;
	Tue, 18 Jun 2024 13:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716709; cv=none; b=neNkG/JniqiNZ4+DeXVfVyFqT7CS0wsrTQAjcNcgCqcGpJ4dnsgPigPxZvIr5765a+hsDhxdcMvzAm0bogORYiMJ8idMXy8n5ZIbJ8b0wFPyNV+yccGEjQteozeQXQCrgCGWOv6sYbF6sPNkjTGD0epfFHdxbRFAeEZ6iDCKCF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716709; c=relaxed/simple;
	bh=Q5+aI9x5BbSDqOGV/y4A1bDbfknabmRZ+UZtsmxzPsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzcZieZUOnan7/F75Ye2MUjGhfKph7xB3eIl6soG++blXBfG1CSxyXxaKUjGa3YeHF+JrCDax+/f0hSWdY+7n6ja6j9QzerTQTSZMVr/ZiWNpJuFV3+fttb50ey4kfzWXKNtF71T5CGEBGATsIFt+TiYfn0TRwwImF8U7c26100=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bne+EG0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bne+EG0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CDFC3277B;
	Tue, 18 Jun 2024 13:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716709;
	bh=Q5+aI9x5BbSDqOGV/y4A1bDbfknabmRZ+UZtsmxzPsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bne+EG0rLyDkcK2hNz8tmh1Y0i4L2QaCW/TwXmqguZG7MJ9A/E6nXJvV8RakoDpIB
	 B+XMJzqrm/Z5pj0U2/oTRpdm8QW9qZsys3Mneopb0IlrphCgmeMpeCrha6WPRWZrRy
	 DZ80FXAvP0ntCsazS3SmvvVdQljHoHKqrOtkkWGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 719/770] NFSD: Use only RQ_DROPME to signal the need to drop a reply
Date: Tue, 18 Jun 2024 14:39:32 +0200
Message-ID: <20240618123435.023005908@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 9315564747cb6a570e99196b3a4880fb817635fd ]

Clean up: NFSv2 has the only two usages of rpc_drop_reply in the
NFSD code base. Since NFSv2 is going away at some point, replace
these in order to simplify the "drop this reply?" check in
nfsd_dispatch().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c | 4 ++--
 fs/nfsd/nfssvc.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 3777b5be4253a..c32a871f0e275 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -211,7 +211,7 @@ nfsd_proc_read(struct svc_rqst *rqstp)
 	if (resp->status == nfs_ok)
 		resp->status = fh_getattr(&resp->fh, &resp->stat);
 	else if (resp->status == nfserr_jukebox)
-		return rpc_drop_reply;
+		__set_bit(RQ_DROPME, &rqstp->rq_flags);
 	return rpc_success;
 }
 
@@ -246,7 +246,7 @@ nfsd_proc_write(struct svc_rqst *rqstp)
 	if (resp->status == nfs_ok)
 		resp->status = fh_getattr(&resp->fh, &resp->stat);
 	else if (resp->status == nfserr_jukebox)
-		return rpc_drop_reply;
+		__set_bit(RQ_DROPME, &rqstp->rq_flags);
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 429f38c986280..325d3d3f12110 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -1060,7 +1060,7 @@ int nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp)
 	svcxdr_init_encode(rqstp);
 
 	*statp = proc->pc_func(rqstp);
-	if (*statp == rpc_drop_reply || test_bit(RQ_DROPME, &rqstp->rq_flags))
+	if (test_bit(RQ_DROPME, &rqstp->rq_flags))
 		goto out_update_drop;
 
 	if (!proc->pc_encode(rqstp, &rqstp->rq_res_stream))
-- 
2.43.0



