Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5743931E823;
	Sat, 12 Sep 2026 19:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240960; cv=none; b=oSXz6TyJwyZHbf/d7P8QISTqncltAPjgW+w/TmmGwOWnIUM+qksk4BoJLY9W/vArzddN48gig9zcmmTnrNM7dgH/cuujscYVUn1EPNilvYxAsg7Feou4qSaNgD7CdEOI0VvchkTjpakeEH/NV5cWP4VvwIh/4CRxRaomz3BEoho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240960; c=relaxed/simple;
	bh=4iP4vKVFA4y7Im/Bl+fqak/RHBW3obJA2fsBb3nMc88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPlXOeboFU3oW12MU/BcXx5tHGnX4+3Lv+sXtiWlD1MNm6YSOxEgY1KooUE4Eo9OqUicowUc12mMXY9T34zvmVth6sQnIWqSFKhJi9uqs3fE5pgllAbFRNtC2ADduhslyrhBg4aY//d24RRebOudZoDqf5pZVwcdDkom4WmENtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rs8DTcYN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rs8DTcYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1281F000FF;
	Sat, 12 Sep 2026 19:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240959;
	bh=W3cgisMvf5i6TLPZ8xYSSGpSg8pe3hfxSM2xutNxfzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rs8DTcYNdEip5A5Vrml5CKzLq+3cZtVBmsi2ulHURmYCSmiTPRwsUl1GpHPOwE7LH
	 0fnjU5uDIEcsc3M3rMmlxZyuVNWcV8BViO36IPPjJkp3ZE8TOI6z1q9BaNYYujfoAd
	 XeXLoUx77HOXKcNWmwdDfIO6VZcnBb/6+r5qMgEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 038/798] nfsd: block non-SAVEFH ops after FOREIGN PUTFH to prevent NULL deref
Date: Sat, 12 Sep 2026 08:54:26 +0200
Message-ID: <20260912065517.835725758@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2642,9 +2642,22 @@ nfsd4_proc_compound(struct svc_rqst *rqs
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


