Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C699439003;
	Tue, 21 Jul 2026 21:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668056; cv=none; b=GmCuCHwAq87Q2Inm/gFtmKBaecYxKopLaEHJkWmMe0c+8Vr7K/+ZKNesIU7ifh26b1vbfPhoPblumliqw4x/EWUoIoaIzYxqze82fo/STb0VkDt6n7vIUAuviB9fH1TYzgGmI/eh9SDRREMZRw8xCG92VXpNX3kb6DcFZv7Qg9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668056; c=relaxed/simple;
	bh=22hucOpMSnTwePKS0USMnynV19QA3Qur4Hea+edF/C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spNXc686CWtO3+I2N30S4PxaCBhFzSm2PMWlw9bxXwsP6vaGDlngEJ+300W08EsBs4wCb9Km/UWFfLdgB4Q3P2+a1XI9lU9FNVjUH4+TBvpZG3v+eRN45aWDld0PzYBJCzINXACY4Hw48gS96uwm6WanSWPNJe+HoP+tixjT6as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0IV2AHy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0IV2AHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C214F1F000E9;
	Tue, 21 Jul 2026 21:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668055;
	bh=v7XQkIdoz9bKbyPzA7+SK0ucqDE3fruy9QDeBvZYP9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N0IV2AHy3xFNwCinl3J7c/470zVY528yMJSgja/jPHou49/jxbwFzdstfuGwZKmx/
	 Bpth0PE0gAFWT7ZIBqAg/ionKDevLmDPSXZL8BxQKjhZ/oQP034vnOZuYQrAfqFU0r
	 sF1GnBbEt12OD16stKFFyG0drYzV2cuvuRQ5bTWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0031/1067] nfsd: Dont reset the write verifier on a commit EAGAIN
Date: Tue, 21 Jul 2026 17:10:32 +0200
Message-ID: <20260721152425.243990783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 1b2021bdeeca12364ad0fa7aac9ddba5cae964f3 ]

If fsync() is returning EAGAIN, then we can assume that the filesystem
being exported is something like NFS with the 'softerr' mount option
enabled, and that it is just asking us to replay the fsync() operation
at a later date.

If we see an ESTALE, then ditto: the file is gone, so there is no danger
of losing the error.

For those cases, do not reset the write verifier. A write verifier
change has a global effect, causing retransmission by all clients of
all uncommitted unstable writes for all files, so it is worth
mitigating where possible.

Link: https://lore.kernel.org/linux-nfs/20230911184357.11739-1-trond.myklebust@hammerspace.com/
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 2090b05803fa ("nfsd: reset write verifier on deferred writeback errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -334,6 +334,24 @@ out:
 	return err;
 }
 
+static void
+commit_reset_write_verifier(struct nfsd_net *nn, struct svc_rqst *rqstp,
+			    int err)
+{
+	switch (err) {
+	case -EAGAIN:
+	case -ESTALE:
+		/*
+		 * Neither of these are the result of a problem with
+		 * durable storage, so avoid a write verifier reset.
+		 */
+		break;
+	default:
+		nfsd_reset_write_verifier(nn);
+		trace_nfsd_writeverf_reset(nn, rqstp, err);
+	}
+}
+
 /*
  * Commit metadata changes to stable storage.
  */
@@ -646,8 +664,7 @@ __be32 nfsd4_clone_file_range(struct svc
 					&nfsd4_get_cstate(rqstp)->current_fh,
 					dst_pos,
 					count, status);
-			nfsd_reset_write_verifier(nn);
-			trace_nfsd_writeverf_reset(nn, rqstp, status);
+			commit_reset_write_verifier(nn, rqstp, status);
 			ret = nfserrno(status);
 		}
 	}
@@ -1126,8 +1143,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 	host_err = vfs_iter_write(file, &iter, &pos, flags);
 	file_end_write(file);
 	if (host_err < 0) {
-		nfsd_reset_write_verifier(nn);
-		trace_nfsd_writeverf_reset(nn, rqstp, host_err);
+		commit_reset_write_verifier(nn, rqstp, host_err);
 		goto out_nfserr;
 	}
 	*cnt = host_err;
@@ -1142,10 +1158,8 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 
 	if (stable && use_wgather) {
 		host_err = wait_for_concurrent_writes(file);
-		if (host_err < 0) {
-			nfsd_reset_write_verifier(nn);
-			trace_nfsd_writeverf_reset(nn, rqstp, host_err);
-		}
+		if (host_err < 0)
+			commit_reset_write_verifier(nn, rqstp, host_err);
 	}
 
 out_nfserr:
@@ -1284,8 +1298,7 @@ nfsd_commit(struct svc_rqst *rqstp, stru
 			err = nfserr_notsupp;
 			break;
 		default:
-			nfsd_reset_write_verifier(nn);
-			trace_nfsd_writeverf_reset(nn, rqstp, err2);
+			commit_reset_write_verifier(nn, rqstp, err2);
 			err = nfserrno(err2);
 		}
 	} else


