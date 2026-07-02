Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5433093DD;
	Thu,  2 Jul 2026 16:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011447; cv=none; b=tNL1GOChK5UhtQnC5CmGUZVset1soZBoNCZ5kGOin4Wp9vBtgqEEzIjKVi69/QwHH3NUTYlQbwNozKmdFExC2kCV8yBBmEbqRmbRNFqKmK2ewsRbEup1J2tnYvxRbNqOochHXqu6N+9qA982x3px/PrxGgFnpeLOmX9EAkSXeT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011447; c=relaxed/simple;
	bh=JWLTWmk2xzpIblbjaUROqmyz1qT0Bq50dJCEEAuNdrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kmC5CjvtYgHV72MDdtw386WKu4/0zI8ANm05BnHd7ehWLqtXa2FAA6DGq4sEe+G2jcf39syScLJcJBYL7fRSv8Uu/kfcOWEt5XvzgdeolcBH/nYKFFuV9RNW7hEryHvRyotigPqfoi3IYg1fIIYZiG2kGPBthYpnBmBHIYIcvJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmtMafBm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmtMafBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C0B1F000E9;
	Thu,  2 Jul 2026 16:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011446;
	bh=UbGWYiFd2aUaSzhUyWpdBi4+S+6oLzsJGrEi7PYC7NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FmtMafBmp5731ELy4xoUGG8r2kFX3+NLEHK4VGtHczEVOM5SNezVM/wy5I80hU68J
	 JlroQsFBAsm/Oa5e4C5RQFccxavnjRx/g2TbLmIBgEorgW8ihgNuBViJmUxMKhrKoE
	 PHtIzqhIcNIVYKzPyxymYBZqB0fnASBxjbP/vUTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 100/108] nfsd: reset write verifier on deferred writeback errors
Date: Thu,  2 Jul 2026 18:21:37 +0200
Message-ID: <20260702155114.185190421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1264,8 +1264,10 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 	nfsd_stats_io_write_add(nn, exp, *cnt);
 	fsnotify_modify(file);
 	host_err = filemap_check_wb_err(file->f_mapping, since);
-	if (host_err < 0)
+	if (host_err < 0) {
+		commit_reset_write_verifier(nn, rqstp, host_err);
 		goto out_nfserr;
+	}
 
 	if (stable && fhp->fh_use_wgather) {
 		host_err = wait_for_concurrent_writes(file);
@@ -1445,6 +1447,8 @@ nfsd_commit(struct svc_rqst *rqstp, stru
 			nfsd_copy_write_verifier(verf, nn);
 			err2 = filemap_check_wb_err(nf->nf_file->f_mapping,
 						    since);
+			if (err2 < 0)
+				commit_reset_write_verifier(nn, rqstp, err2);
 			err = nfserrno(err2);
 			break;
 		case -EINVAL:


