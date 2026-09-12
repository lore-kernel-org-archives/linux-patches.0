Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29C433C18B;
	Sat, 12 Sep 2026 15:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226800; cv=none; b=eVjlXNCO6i6qkVb8cyIxUBDzSgYnlzFB0oBCAfk310Qd/1Ptvd80Hu0zCZSaERB1VUN0U8PwP7aH7neKAhBGiuIf3MFwq30ffBX3KJD+KuZBwTD9U2z/c0qd16Do5Snibl4T4h5hOPZu1IWhQa4B3fp3AcIjT3Lq3/TnzupvJaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226800; c=relaxed/simple;
	bh=gYu/uGX1cMcRWtyLGaXfPFAKifEmZMHqj8HwY098vr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3xt8ssSQlxxRTdr2bNFc6EiNb5nqmMuQXl0NeRrRfEXIY6hs6LWLpv/t2N0FERBpqjz+cm3JoOQ19rHCBcnFXIbmzuv1Cdc/0j9gnkWefB5jATKw5OnMo7+4RfH+rm+rdI9AoZN2EY9Xo0PfbFCnCMW8JV38QRuJjHj/PHeRrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8ICn4t4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8ICn4t4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D6E1F000FF;
	Sat, 12 Sep 2026 15:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226798;
	bh=BNytqdyYNuUCZ5mYg4ZsZzBpnQ869Iyc+7tvevlJYEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8ICn4t4AAHgsy00RudobvSmEzgWY6QKXYnDVJUqYjadIwAQagtr/1XhWRicWfHn3
	 OXzPy12cu16fAcJK380krqJBeqnBV4GqwzgRhtLaaPRWXPNAisrgQQcznGJUg4nXVu
	 FI3u4Fp870nGIPM25PRUb/YzL7FHS6/iuagaxg1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 0049/1191] nfsd: block non-SAVEFH ops after FOREIGN PUTFH to prevent NULL deref
Date: Sat, 12 Sep 2026 08:46:17 +0200
Message-ID: <20260912065549.244684713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit c59738a00aa51b16adc1b5ceb7c80877168efb4d upstream.

When CONFIG_NFSD_V4_2_INTER_SSC is enabled, nfsd4_putfh() can return
success with fh_dentry and fh_export both NULL if fh_verify() returns
nfserr_stale and putfh->no_verify is true. The NFSD4_FH_FOREIGN flag
is set, but the compound dispatch loop only uses this flag to bypass
the nfserr_nofilehandle check -- it does not prevent subsequent ops
from running with a NULL fh_dentry.

A remote client can exploit this by crafting a COMPOUND that includes
an inter-SSC COPY (which causes check_if_stalefh_allowed() to set
no_verify=true on the saved PUTFH) with an additional op inserted
between the source PUTFH and SAVEFH. For example, SETATTR calls
fh_want_write() which dereferences fh_export->ex_path.mnt without
calling fh_verify() first, causing a NULL pointer dereference in the
nfsd kthread.

Fix this by gating the dispatch loop: when NFSD4_FH_FOREIGN is set
and fh_dentry is NULL, only OP_SAVEFH (needed for the inter-SSC flow)
and ops with ALLOWED_WITHOUT_FH (which don't need a resolved
filehandle) may proceed. All other ops receive nfserr_stale, per
RFC 7862 Section 15.2.3 which specifies that foreign filehandle
validation is deferred to the consuming operation and NFS4ERR_STALE
returned at that point.

Fixes: b9e8638e3d9e ("NFSD: allow inter server COPY to have a STALE source server fh")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260527-putfh_foreign_fh_null_deref_consumers-v1-1-1b8a5aa28c59@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2641,9 +2641,22 @@ nfsd4_proc_compound(struct svc_rqst *rqs
 				op->status = nfsd4_open_omfg(rqstp, cstate, op);
 			goto encode_op;
 		}
-		if (!current_fh->fh_dentry &&
-				!HAS_FH_FLAG(current_fh, NFSD4_FH_FOREIGN)) {
-			if (!(op->opdesc->op_flags & ALLOWED_WITHOUT_FH)) {
+		if (!current_fh->fh_dentry) {
+			if (HAS_FH_FLAG(current_fh, NFSD4_FH_FOREIGN)) {
+				/*
+				 * FOREIGN fh from inter-SSC PUTFH: only
+				 * SAVEFH may proceed with a NULL fh_dentry.
+				 * Per RFC 7862 S15.2.3, validation of a
+				 * foreign fh is deferred to the operation
+				 * that consumes it, and NFS4ERR_STALE is
+				 * returned at that point.
+				 */
+				if (op->opnum != OP_SAVEFH &&
+				    !(op->opdesc->op_flags & ALLOWED_WITHOUT_FH)) {
+					op->status = nfserr_stale;
+					goto encode_op;
+				}
+			} else if (!(op->opdesc->op_flags & ALLOWED_WITHOUT_FH)) {
 				op->status = nfserr_nofilehandle;
 				goto encode_op;
 			}


