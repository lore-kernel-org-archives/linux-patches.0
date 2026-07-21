Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC39E40803D;
	Tue, 21 Jul 2026 20:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664757; cv=none; b=ThxDkNurZe0ix5+YOZUYcLvQsMJC7pP59+0nOmVbmZ53rx9Tg+Z2IbJD7GKzaYlQO/gBcGp8jNusSmD94wn7XoVkPzMf9Ex/vStfMI7NGfmtBlkV0GqCz3TMrDfw13jCCWzuzSOEzPPqqZnXA7EXtkiKjhnVnchp954OT6LYFTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664757; c=relaxed/simple;
	bh=BYEfmCUAOA5NrzxVADdhytzRFx55okYeB85DPIfxz0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gtb7n/ek7+vT9d8rxVrlWUfoi4ysONBGEbUvyUz3FnqOdnsIMQJVY5xzRUp4vN/zjbqoGve7iuvI6NvgCqXDekvJIp+9b8xLzfq7pr5qTYmuaTcU2quvhwsakuj+JOkrmS91/R366BXd9xBN0501rV/UjRlztcClltGRydmdwuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDwvfuJ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDwvfuJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3AA1F000E9;
	Tue, 21 Jul 2026 20:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664756;
	bh=c9CTXh1mAJhvP/wcr1cc77Ddr+S22AjjppHO7z3Rsi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDwvfuJ85YrSls6WxE56uziuE5mHOvn2FyTClNGuRIdwA7Lietvvf+wB0WKJpP2ue
	 f15jt0TACzLXsjYSbqB2SfpVNDF7lAUroeZD1gvx7wUHCmAcE23lK0UeIRjF7kUNnK
	 mu2rndSvItxiC2YoDdZqOdYDOSSKYXnhhvl3rCX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0003/1266] nfsd: reset write verifier on deferred writeback errors
Date: Tue, 21 Jul 2026 17:07:20 +0200
Message-ID: <20260721152441.869713222@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ cel: 6.6.y predates the commit_reset_write_verifier() helper (v6.7);
  open-coded nfsd_reset_write_verifier() and the reset tracepoint at
  both sites, matching the other reset paths in these functions ]
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ae1f43eb515a81..6658c92340f20b 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1185,8 +1185,11 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
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
@@ -1330,6 +1333,10 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
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



