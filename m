Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B101E157493;
	Tue, 18 Jun 2024 13:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715879; cv=none; b=UFa7oZPwcKAzvbOBQH5ZLUxnnuI+L+eMu7zlkuQ+QxDi7SUlxlp0woJtwC3Bx48eGARPGmGFWGLE/+YSvgRYpUZgNIDQUyyCajgEwhH7MZAqpgtrMOgDYe9xAJnFWfdaargwfybWFP4kvsf37vNK/qseL/TwPoevzKpmfHQBAoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715879; c=relaxed/simple;
	bh=mRi4shDh53AQAu5eGNclEdVavA/m0aWl4GZOOJE5SFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pg4NowZE5tTAaTRtZS9OJcSrQCkIDAlfbqpDXvA+iwgN98NWcr0CKcA13eqfvsKOJCyXLr6bdQ0VrwrfrI41wJZLLx6pXDnrQr+99WZPmN4XzY3d21Iz9jiA9lf5JM/dRI2/fLvjtDh/9vVUewLM+Uk3GV4IwmYdIdbxQLw6hXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDMSGpat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDMSGpat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0642FC3277B;
	Tue, 18 Jun 2024 13:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715879;
	bh=mRi4shDh53AQAu5eGNclEdVavA/m0aWl4GZOOJE5SFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDMSGpatmhWRFBwTSIGt1OjjqeRnFSKDVlx6KAJh+XUHtWGbHfa6o/+/OF3ZpcT6c
	 4aJLV/fZIJxMPZudey/JpTyZlMqni3AD4dEVoe//jdgcGO8VcsN+eRA/zrd6s1om+I
	 5roSsZr8Z7X+4xnx1Gdkqs8S2BK/FkQJqvIaMD5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 458/770] NFSD: Trace boot verifier resets
Date: Tue, 18 Jun 2024 14:35:11 +0200
Message-ID: <20240618123424.990752430@linuxfoundation.org>
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

[ Upstream commit 75acacb6583df0b9328dc701d8eeea05af49b8b5 ]

According to commit bbf2f098838a ("nfsd: Reset the boot verifier on
all write I/O errors"), the Linux NFS server forces all clients to
resend pending unstable writes if any server-side write or commit
operation encounters an error (say, ENOSPC). This is a rare and
quite exceptional event that could require administrative recovery
action, so it should be made trace-able. Example trace event:

nfsd-938   [002]  7174.945558: nfsd_writeverf_reset: boot_time=        61cc920d xid=0xdcd62036 error=-28 new verifier=0x08aecc6142515904

[ cel: adjusted to apply to v5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 28 ++++++++++++++++++++++++++++
 fs/nfsd/vfs.c   | 13 ++++++++++---
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 199b485c77179..8327d1601d710 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -575,6 +575,34 @@ DEFINE_EVENT(nfsd_net_class, nfsd_##name, \
 DEFINE_NET_EVENT(grace_start);
 DEFINE_NET_EVENT(grace_complete);
 
+TRACE_EVENT(nfsd_writeverf_reset,
+	TP_PROTO(
+		const struct nfsd_net *nn,
+		const struct svc_rqst *rqstp,
+		int error
+	),
+	TP_ARGS(nn, rqstp, error),
+	TP_STRUCT__entry(
+		__field(unsigned long long, boot_time)
+		__field(u32, xid)
+		__field(int, error)
+		__array(unsigned char, verifier, NFS4_VERIFIER_SIZE)
+	),
+	TP_fast_assign(
+		__entry->boot_time = nn->boot_time;
+		__entry->xid = be32_to_cpu(rqstp->rq_xid);
+		__entry->error = error;
+
+		/* avoid seqlock inside TP_fast_assign */
+		memcpy(__entry->verifier, nn->writeverf,
+		       NFS4_VERIFIER_SIZE);
+	),
+	TP_printk("boot_time=%16llx xid=0x%08x error=%d new verifier=0x%s",
+		__entry->boot_time, __entry->xid, __entry->error,
+		__print_hex_str(__entry->verifier, NFS4_VERIFIER_SIZE)
+	)
+);
+
 TRACE_EVENT(nfsd_clid_cred_mismatch,
 	TP_PROTO(
 		const struct nfs4_client *clp,
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 8cf053b698314..77f48779210d0 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -566,14 +566,17 @@ __be32 nfsd4_clone_file_range(struct svc_rqst *rqstp,
 		if (!status)
 			status = commit_inode_metadata(file_inode(src));
 		if (status < 0) {
+			struct nfsd_net *nn = net_generic(nf_dst->nf_net,
+							  nfsd_net_id);
+
 			trace_nfsd_clone_file_range_err(rqstp,
 					&nfsd4_get_cstate(rqstp)->save_fh,
 					src_pos,
 					&nfsd4_get_cstate(rqstp)->current_fh,
 					dst_pos,
 					count, status);
-			nfsd_reset_write_verifier(net_generic(nf_dst->nf_net,
-						  nfsd_net_id));
+			nfsd_reset_write_verifier(nn);
+			trace_nfsd_writeverf_reset(nn, rqstp, status);
 			ret = nfserrno(status);
 		}
 	}
@@ -1043,6 +1046,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	host_err = vfs_iter_write(file, &iter, &pos, flags);
 	if (host_err < 0) {
 		nfsd_reset_write_verifier(nn);
+		trace_nfsd_writeverf_reset(nn, rqstp, host_err);
 		goto out_nfserr;
 	}
 	*cnt = host_err;
@@ -1054,8 +1058,10 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 
 	if (stable && use_wgather) {
 		host_err = wait_for_concurrent_writes(file);
-		if (host_err < 0)
+		if (host_err < 0) {
 			nfsd_reset_write_verifier(nn);
+			trace_nfsd_writeverf_reset(nn, rqstp, host_err);
+		}
 	}
 
 out_nfserr:
@@ -1178,6 +1184,7 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			break;
 		default:
 			nfsd_reset_write_verifier(nn);
+			trace_nfsd_writeverf_reset(nn, rqstp, err2);
 			err = nfserrno(err2);
 		}
 	} else
-- 
2.43.0



