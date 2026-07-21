Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C283344AB62;
	Tue, 21 Jul 2026 21:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670890; cv=none; b=p1KlIE5Mvk/Y8jOPW4lRnGqaQP04Z71R185R5YdfboFJhCi9HLs58Pzf1ds2jeLwfYTRs2AlPHJbzTWae6f0onm55ruHn/8gHrxi/8GLjBnNtyGJ7O3rtbQp68MWbnEh0jA69qIy82eviLm1awQJiB1vn9Zca/vqIEQaQMXGCis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670890; c=relaxed/simple;
	bh=A0rwxJe7/QsLSpd/Kn3KzZeN6AvVtZFpnRozhJBwTbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yf7dvo8ilxBgeQG5JOqYW2W2lm5bdgq9Qj2+qCmSDLkfGLIlmzc+UvR/k3WACXhyFT1I1w1Qb3LIgrJWoCDv/y2o52yE6kzKpn4VE+Il4o06BBfiIIfNX2i1Y+zcKLGL3q6M2aPv2CxEnnRfmiD8Se8dFgXiLyrCDXJTa9PJtEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ewb9vzR5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ewb9vzR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341771F000E9;
	Tue, 21 Jul 2026 21:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670889;
	bh=eMZmJR7J3dCfEmbL8LztjwvKhZr+zzKn7+zPhGkdEBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ewb9vzR582SnB/yx0yFkFZdRVqLzqYdaiBBIUDPdAuUWBHFlY+b9Lw3Z0jtKvxg4x
	 VSbpQTOVS2BmevsXnkMH8rjPZjQb9ZY8CBF6gDz+BMjNcO4UmOc6iAizbR9KsnupzX
	 2f0g4uWwzOnygXtpMyL4QQzzEB9MLPJWAbAesHW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/843] nfsd: reset write verifier on deferred writeback errors
Date: Tue, 21 Jul 2026 17:13:59 +0200
Message-ID: <20260721152406.052270352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 2090b05803faab8a9fa62fbff871007862cac1b7 upstream.

nfsd_vfs_write() and nfsd_commit() both call filemap_check_wb_err() to
detect deferred writeback errors, but neither rotates the server's write
verifier (nn->writeverf) when this check fails. Every other
durable-storage-failure path in these functions calls
commit_reset_write_verifier() before returning an error.

The missing rotation means clients holding UNSTABLE write data under the
current verifier will COMMIT, receive the unchanged verifier back, and
conclude their data is durable — silently dropping data that failed
writeback. This violates the UNSTABLE+COMMIT durability contract
(RFC 1813 §3.3.7, RFC 8881 §18.32).

Add commit_reset_write_verifier() calls at both filemap_check_wb_err()
error sites, matching the pattern used by adjacent error paths in the
same functions. The helper already filters -EAGAIN and -ESTALE
internally, so the calls are unconditionally safe.

Reported-by: Chris Mason <clm@meta.com>
Fixes: 555dbf1a9aac ("nfsd: Replace use of rwsem with errseq_t")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ cel: open-code the reset; commit_reset_write_verifier() is v6.7 ]
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index e1737984e0ca11..7b0bc4507ad047 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1133,8 +1133,11 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	nfsd_stats_io_write_add(nn, exp, *cnt);
 	fsnotify_modify(file);
 	host_err = filemap_check_wb_err(file->f_mapping, since);
-	if (host_err < 0)
+	if (host_err < 0) {
+		nfsd_reset_write_verifier(nn);
+		trace_nfsd_writeverf_reset(nn, rqstp, host_err);
 		goto out_nfserr;
+	}
 
 	if (stable && use_wgather) {
 		host_err = wait_for_concurrent_writes(file);
@@ -1270,6 +1273,10 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 			nfsd_copy_write_verifier(verf, nn);
 			err2 = filemap_check_wb_err(nf->nf_file->f_mapping,
 						    since);
+			if (err2 < 0) {
+				nfsd_reset_write_verifier(nn);
+				trace_nfsd_writeverf_reset(nn, rqstp, err2);
+			}
 			err = nfserrno(err2);
 			break;
 		case -EINVAL:
-- 
2.53.0



