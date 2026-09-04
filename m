Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B386E41685A;
	Fri,  4 Sep 2026 06:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502243; cv=none; b=HOkVN93lIaT+OQJUK5nbS6IrHFO4CsgIaMo44RYhcXyoePMMirtFM24B+TI/xo7U0cA2HTGT9d/NMr7u87ri8QEXwKW6xGL21MisEDUcdQb7rccjCQUo0GlUV+skdBaSPuhVItgQnb0HQmldACGpQ/jN3+gypAiI78pCh6obZaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502243; c=relaxed/simple;
	bh=AYNrDUrWniTdBP3W+sPIknfCqijXF6nDqXyGXoHkx6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urzXWmtW5axBwn18LyFzctQzrscWxOYecC0f8eSdub5mBxc8D/entQ2VFBEQH0Yiq3CB/J4SkDPurwlg2R6xR4KvHz+OeD8kTsayd41y8jPkQNCMlX5aCYMchAjKxDY1BYE6T4OE3ZMWiucaWPp7Cc2G2R6hN2z+FSCYi4RuibU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3MyLyxq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3MyLyxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BDD1F00A3D;
	Fri,  4 Sep 2026 06:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502242;
	bh=Zaa8wKBLdTod4JJsRsKxNRvzdrSMg36s5WqCKTMgDDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n3MyLyxqFYmveNa+5A2AZp1g1oC2cYOmsqWdYLzi0rGI4KVRoBcnXGu75FXxk0/L9
	 fk6mCeNhZM3KErpyIQgngst+BYV2EVGd4MS3IeQ2UgLzHupl/PDSa+1gyorbf/Wn+n
	 riEMCeI9j+ksSJ996fHVFaEMfT4TQ9D8vQlH67Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 086/403] nfsd: block non-SAVEFH ops after FOREIGN PUTFH to prevent NULL deref
Date: Fri,  4 Sep 2026 06:58:09 +0200
Message-ID: <20260904045736.789964109@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2743,9 +2743,22 @@ nfsd4_proc_compound(struct svc_rqst *rqs
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


