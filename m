Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EDE1AA1F4;
	Fri,  4 Sep 2026 05:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498842; cv=none; b=ZbF8ZkTeC7bGdwOmLezowXjYsp3psq8+H/Oinbj141Q/xobuWs/UfIpEpFg2q9Rvp3WfZY4XCBi6n1DNhATObEU0k/vd3ONUA/DGhOSjA/8q/uhbpz8sgDUYBv1gYhK+fOxntqjOhfEzuvJLOjat7iKcQykS9nXe0nh4oaiiziA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498842; c=relaxed/simple;
	bh=RQD5ldcki1VTWWVGKGvj8fsjjIreN4btdzVSNwMvnnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7A9hK/VU9j0JCdWpDFs+GvC29PyNWYvyhr4CVmxE/WnilP7qC9fOEdCNYkHRnuaHkrYulD6OTe095dtfVLIGXHF327E04NfNnb64lrKJPu5L//KPWx9/ztSn+g21fX0LGxyfAclqLEN4mTvDy/A+CRvFXXaFQPoFuP+Xj/SHXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2gREFMa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2gREFMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2961B1F00A3D;
	Fri,  4 Sep 2026 05:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498840;
	bh=U1VhseLXz1SgXXLs0ZgMtZIaMIhe+FujjAO+9VqOoaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2gREFMacgrl8mnh4PDDTfHzqh68FAJA+4Yu1uQFXkr7HGP0odAMm1GV6DBNN/HbP
	 yt7A9mCu7dLDAV+GXx/2ZYclnFvd8Dj8fsQmV4x1z235oaNwtDLsDUnMTUqfjLppZ9
	 a8j2CX/Z/aF0Sidhca/HkaTzCLnPnbi1WfLk4hoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 205/713] nfsd: release OPEN-decoded posix ACLs via op_release
Date: Fri,  4 Sep 2026 06:52:53 +0200
Message-ID: <20260904045808.410756951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 8215892993ea9f5231da4fa9eb42428a286fce8b upstream.

nfsd4_decode_createhow4() calls nfsd4_decode_fattr4(), which allocates
refcounted struct posix_acl objects via posix_acl_alloc() and stores
them in open->op_pacl and open->op_dpacl. These pointers must be
released once the OPEN compound finishes.

When nfsd4_decode_open_claim4() returns a non-seqid-mutating error,
the dispatcher short-circuits before op_func runs:

    nfsd4_proc_compound()
      if (op->status && op->opnum == OP_OPEN)
          op->status = nfsd4_open_omfg(...)
              if (!seqid_mutating_err(ntohl(op->status)))
                  return op->status;   /* nfsd4_open() never runs */
      ...
      opdesc->op_release(&op->u)  /* must still release op_pacl/op_dpacl */

Before this change OP_OPEN had no .op_release in nfsd4_ops[], and the
release pair lived inside nfsd4_open() at its out_err: label. On the
short-circuit path nfsd4_open() is never invoked, so both posix_acl
refs leak on every malformed OPEN compound that carries valid POSIX
ACL createhow4 attributes.

Add nfsd4_open_release() and wire it as .op_release for OP_OPEN.
posix_acl_release() is NULL-safe, so the single release site covers
both the normal path and the nfsd4_open_omfg short-circuit. Remove
the matching posix_acl_release() pair from nfsd4_open()'s out_err:
label to avoid double-releasing.

The compound loop has two encoding branches: nfsd4_encode_operation()
for normal ops, and nfsd4_encode_replay() for v4.0 replayed ops.
op_release was only called from nfsd4_encode_operation(), so resources
attached to op->u leak on the replay path.

Move the op_release() call out of nfsd4_encode_operation() and the
replay branch, placing it after the if-else in nfsd4_proc_compound().
This gives a single call site in a fairly obviously-correct place,
covering both the normal encoding and replay paths.

Fixes: 5fc51dfc2eb1 ("NFSD: Add support for XDR decoding POSIX draft ACLs")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <clm@meta.com>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260601-nfsd-testing-v3-1-a31cd10bdd4f@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |   13 +++++++++++--
 fs/nfsd/nfs4xdr.c  |    3 ---
 2 files changed, 11 insertions(+), 5 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -681,8 +681,6 @@ out:
 	nfsd4_cleanup_open_state(cstate, open);
 	nfsd4_bump_seqid(cstate, status);
 out_err:
-	posix_acl_release(open->op_dpacl);
-	posix_acl_release(open->op_pacl);
 	return status;
 }
 
@@ -704,6 +702,13 @@ static __be32 nfsd4_open_omfg(struct svc
 	return nfsd4_open(rqstp, cstate, &op->u);
 }
 
+static void
+nfsd4_open_release(union nfsd4_op_u *u)
+{
+	posix_acl_release(u->open.op_dpacl);
+	posix_acl_release(u->open.op_pacl);
+}
+
 /*
  * filehandle-manipulating ops.
  */
@@ -3271,6 +3276,9 @@ encode_op:
 			status = op->status;
 		}
 
+		if (op->opdesc && op->opdesc->op_release)
+			op->opdesc->op_release(&op->u);
+
 		trace_nfsd_compound_status(args->client_opcnt, resp->opcnt,
 					   status, nfsd4_op_name(op->opnum));
 
@@ -3770,6 +3778,7 @@ static const struct nfsd4_operation nfsd
 	},
 	[OP_OPEN] = {
 		.op_func = nfsd4_open,
+		.op_release = nfsd4_open_release,
 		.op_flags = OP_HANDLES_WRONGSEC | OP_MODIFIES_SOMETHING,
 		.op_name = "OP_OPEN",
 		.op_rsize_bop = nfsd4_open_rsize,
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -6420,9 +6420,6 @@ status:
 	write_bytes_to_xdr_buf(xdr->buf, op_status_offset,
 			       &op->status, XDR_UNIT);
 release:
-	if (opdesc && opdesc->op_release)
-		opdesc->op_release(&op->u);
-
 	/*
 	 * Account for pages consumed while encoding this operation.
 	 * The xdr_stream primitives don't manage rq_next_page.


