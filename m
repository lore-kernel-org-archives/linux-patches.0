Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7136747DFBF;
	Sat, 12 Sep 2026 13:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219858; cv=none; b=NgpTJkY70GM1r78x26d3v7jBAUldvTJzdZPzEEMHhAFsSyrM+iuQvpRlu7u6vFjqAO1Kg9js8Sw8fY0xy0c55hd1TS6ZxLzbj5Atx0mWyq0ScUTUEie95qqHULNevLRuedf4sIT8b5dl4zx6IKsJGvvguuUOO24adA2UF9zjyb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219858; c=relaxed/simple;
	bh=7yNqVnf/ByvssSnK+awzXwog7C7U3Zv94xuN3MFQYBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdzKQiH35aQMN3FBk854sVZnDVVaY6xOxb+inAVNaXRmAV0iE8YG1+rYrqGH15afbopqnX+lJefExIK46wLaybGPwcVOvmM7BpeIp02BrWkm7Oc+v09wRXiO6hSw01NDmt7P7sdp/DhPe0dftrhXhm8ezcbaG7JWirEStATqSnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q90DhSc6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q90DhSc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113001F000FF;
	Sat, 12 Sep 2026 13:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219857;
	bh=s5N4DR+fPkcAcwXl2BAxZ8DYshuhPuSlKPcS8T8tbKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q90DhSc6TxWBiioRaKM5xIjFkl001hEb1V52H1aETzKpOwK6zld1AXcYkpd1WqEuE
	 LR5emsiyO4e//huh06qFFPSDGercH6Sa26Fob3STqFWIbWgzhTvervsxaGOX8TBSL4
	 /RM/cD6Ag02h/WwhUGXlU6pkaSyCPYPkMKoYK7J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 0058/1424] nfsd: block non-SAVEFH ops after FOREIGN PUTFH to prevent NULL deref
Date: Sat, 12 Sep 2026 08:41:30 +0200
Message-ID: <20260912065608.602205484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2688,9 +2688,22 @@ nfsd4_proc_compound(struct svc_rqst *rqs
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


