Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C71533D51A;
	Tue, 12 May 2026 18:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609084; cv=none; b=JBPTikjcH7HVyxsFY/pMCRahUVkumEGtTy8eqGFQSy8hwwVF8FeCnXi1GRjUIioXvzBwNZmeNg/cNYHJxGXoARudcg8F7vV1q6I4rAP2MZQJE/7jlRRcHEX6/sxBG5geBqHXe9MoBBaAcKqKJaZz8jjjVNdDgwQHcxHn4aAJZfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609084; c=relaxed/simple;
	bh=2qzGy5r/s0Kq+IA3l1u1flcb5tDdyv8ujki1aB31ySY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsK+DqCe8Z9B8HDmIPITVCw+4LCX0G04OK75Ev52nB/ZyY1h32aI7jgDrdqGyxUQ9V26HARsJPDXafTlcAXUcsOwrndFMdRlH+cgVMh9Jb8fMDtK4hJPZYjsLamETmTciOXlCaPCU+8BcunUAHSs1pmnKH5FRBP1N9K4Eh0YalU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZqAEPCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZqAEPCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F1AC2BCB0;
	Tue, 12 May 2026 18:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609084;
	bh=2qzGy5r/s0Kq+IA3l1u1flcb5tDdyv8ujki1aB31ySY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZqAEPCF82ignObxdfxhGEdNESErbxwuMeGIZHVECUh81HWurWh0JXCHjk5aBKOr4
	 P1i7VU2nATZsc12osvqK1opJ8MMe+Ku9SoUuiHqvel/D5RR4jInTOpaATTvhANxzTz
	 ZLI4WTYxeQDS/KAdS/DUPuQFdlZhGskDsfFW/Jm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.0 058/307] selinux: fix avdcache auditing
Date: Tue, 12 May 2026 19:37:33 +0200
Message-ID: <20260512173941.347243362@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Smalley <stephen.smalley.work@gmail.com>

commit f92d542577db878acfd21cc18dab23d03023b217 upstream.

The per-task avdcache was incorrectly saving and reusing the
audited vector computed by avc_audit_required() rather than
recomputing based on the currently requested permissions and
distinguishing the denied versus allowed cases. As a result,
some permission checks were not being audited, e.g.
directory write checks after a previously cached directory
search check.

Cc: stable@vger.kernel.org
Fixes: dde3a5d0f4dce ("selinux: move avdcache to per-task security struct")
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
[PM: line wrap tweaks]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c          |   31 +++++++++++++------------------
 security/selinux/include/objsec.h |    4 +---
 2 files changed, 14 insertions(+), 21 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3207,15 +3207,13 @@ static inline int task_avdcache_search(s
  * @tsec: the task's security state
  * @isec: the inode associated with the cache entry
  * @avd: the AVD to cache
- * @audited: the permission audit bitmask to cache
  *
- * Update the AVD cache in @tsec with the @avdc and @audited info associated
+ * Update the AVD cache in @tsec with the @avd info associated
  * with @isec.
  */
 static inline void task_avdcache_update(struct task_security_struct *tsec,
 					struct inode_security_struct *isec,
-					struct av_decision *avd,
-					u32 audited)
+					struct av_decision *avd)
 {
 	int spot;
 
@@ -3227,9 +3225,7 @@ static inline void task_avdcache_update(
 	spot = (tsec->avdcache.dir_spot + 1) & (TSEC_AVDC_DIR_SIZE - 1);
 	tsec->avdcache.dir_spot = spot;
 	tsec->avdcache.dir[spot].isid = isec->sid;
-	tsec->avdcache.dir[spot].audited = audited;
-	tsec->avdcache.dir[spot].allowed = avd->allowed;
-	tsec->avdcache.dir[spot].permissive = avd->flags & AVD_FLAGS_PERMISSIVE;
+	tsec->avdcache.dir[spot].avd = *avd;
 	tsec->avdcache.permissive_neveraudit =
 		(avd->flags == (AVD_FLAGS_PERMISSIVE|AVD_FLAGS_NEVERAUDIT));
 }
@@ -3250,6 +3246,7 @@ static int selinux_inode_permission(stru
 	struct task_security_struct *tsec;
 	struct inode_security_struct *isec;
 	struct avdc_entry *avdc;
+	struct av_decision avd, *avdp = &avd;
 	int rc, rc2;
 	u32 audited, denied;
 
@@ -3271,23 +3268,21 @@ static int selinux_inode_permission(stru
 	rc = task_avdcache_search(tsec, isec, &avdc);
 	if (likely(!rc)) {
 		/* Cache hit. */
-		audited = perms & avdc->audited;
-		denied = perms & ~avdc->allowed;
-		if (unlikely(denied && enforcing_enabled() &&
-			     !avdc->permissive))
+		avdp = &avdc->avd;
+		denied = perms & ~avdp->allowed;
+		if (unlikely(denied) && enforcing_enabled() &&
+			!(avdp->flags & AVD_FLAGS_PERMISSIVE))
 			rc = -EACCES;
 	} else {
-		struct av_decision avd;
-
 		/* Cache miss. */
 		rc = avc_has_perm_noaudit(sid, isec->sid, isec->sclass,
-					  perms, 0, &avd);
-		audited = avc_audit_required(perms, &avd, rc,
-			(requested & MAY_ACCESS) ? FILE__AUDIT_ACCESS : 0,
-			&denied);
-		task_avdcache_update(tsec, isec, &avd, audited);
+					  perms, 0, avdp);
+		task_avdcache_update(tsec, isec, avdp);
 	}
 
+	audited = avc_audit_required(perms, avdp, rc,
+				     (requested & MAY_ACCESS) ?
+				     FILE__AUDIT_ACCESS : 0, &denied);
 	if (likely(!audited))
 		return rc;
 
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -32,9 +32,7 @@
 
 struct avdc_entry {
 	u32 isid; /* inode SID */
-	u32 allowed; /* allowed permission bitmask */
-	u32 audited; /* audited permission bitmask */
-	bool permissive; /* AVC permissive flag */
+	struct av_decision avd; /* av decision */
 };
 
 struct cred_security_struct {


