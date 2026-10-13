Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F964EFFCF;
	Tue, 13 Oct 2026 12:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893343; cv=none; b=U/1ZRZ1Oqrk4NeXA2HcNBUyGNT7x7E6enT+yuFsw01In9bHt3d2WPsUTmNt7g/TF8lVgyud9bda6j8QAXyg9Lq34NtJYNDuJqBCExPrNI+ytXz9tB0L+QDJ4WnGqeNbUiEcdafZhljt7e3YzEkYtLFO126xpSCaVfXoCco2yzGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893343; c=relaxed/simple;
	bh=Pp5u3+ud8MRcBxcYotWJCCWGe+HWDtjQcypP3Aq/nC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhopM1UBP+6CYiwOFCv8fCMYy6ytmUQVRqzK0zFhrEYmTQNupXfagfU6Ekvo72IJ0V1uKg3UYMI1mkyMhlm1BHZfcSA+agylmz/vYJKuYb+4IKV70t0aw6kZZ2p8lptLx3DiJ8xbVXz9BCT68XmonG/hhcEwQ2kXREgq3i0qBQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8IhUfTD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8IhUfTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03181F00893;
	Tue, 13 Oct 2026 12:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893342;
	bh=UyUI4LwxQSh/j/RxAwZP+x892M4SBte9EJogyAM0+cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H8IhUfTDkTkfACj411KCYXeKAfJ9XckjR0PYx+gTU3VRt1klxjoPAyErOZMu59erA
	 V6b7SnF4pL3TvvzytrkxnBmuK7rF8jEDeiSOagnR1Ks+02resJwIUr98fbDG3ATAjj
	 UkIyTXSxfvo+vIgjmFAPGeceDrHmiGrXe/1eGlEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 193/621] gfs2: Add clean argument to lm_unmount hook
Date: Tue, 13 Oct 2026 13:33:08 +0200
Message-ID: <20261013112925.441877640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 9334c73fb16b183a6d4af09ce1d445f7f89b8d49 ]

Add a 'clean' argument to ->lm_unmount() that indicates whether the
filesystem is clean or needs recovery.  Set clean to true for normal
unmounts, and to false for withdraws.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: da6f5bbc2e79 ("gfs2: fix memory leaks in gfs2_fill_super error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.h      |  2 +-
 fs/gfs2/lock_dlm.c   | 14 ++++++++++++--
 fs/gfs2/ops_fstype.c |  2 +-
 fs/gfs2/util.c       |  2 +-
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 2d4fd1a2bbbb8..ad0143bd30d52 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -136,7 +136,7 @@ struct lm_lockops {
 	void (*lm_first_done) (struct gfs2_sbd *sdp);
 	void (*lm_recovery_result) (struct gfs2_sbd *sdp, unsigned int jid,
 				    unsigned int result);
-	void (*lm_unmount) (struct gfs2_sbd *sdp);
+	void (*lm_unmount) (struct gfs2_sbd *sdp, bool clean);
 	void (*lm_withdraw) (struct gfs2_sbd *sdp);
 	void (*lm_put_lock) (struct gfs2_glock *gl);
 	int (*lm_lock) (struct gfs2_glock *gl, unsigned int req_state,
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 4f00af7dd256b..c18e732a04bd1 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -1438,7 +1438,15 @@ static void gdlm_first_done(struct gfs2_sbd *sdp)
 		fs_err(sdp, "mount first_done error %d\n", error);
 }
 
-static void gdlm_unmount(struct gfs2_sbd *sdp)
+/*
+ * gdlm_unmount - release our lockspace
+ * @sdp: the superblock
+ * @clean: Indicates whether or not the remaining nodes in the cluster should
+ *	   perform recovery.  Recovery is necessary when a node withdraws and
+ *	   its journal remains dirty.  Recovery isn't necessary when a node
+ *	   cleanly unmounts a filesystem.
+ */
+static void gdlm_unmount(struct gfs2_sbd *sdp, bool clean)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
 
@@ -1456,7 +1464,9 @@ static void gdlm_unmount(struct gfs2_sbd *sdp)
 release:
 	down_write(&ls->ls_sem);
 	if (ls->ls_dlm) {
-		dlm_release_lockspace(ls->ls_dlm, DLM_RELEASE_NORMAL);
+		dlm_release_lockspace(ls->ls_dlm,
+				      clean ? DLM_RELEASE_NORMAL :
+					      DLM_RELEASE_RECOVER);
 		ls->ls_dlm = NULL;
 	}
 	up_write(&ls->ls_sem);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 1a2db8053da04..f748d320fa148 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1041,7 +1041,7 @@ void gfs2_lm_unmount(struct gfs2_sbd *sdp)
 {
 	const struct lm_lockops *lm = sdp->sd_lockstruct.ls_ops;
 	if (!gfs2_withdrawing_or_withdrawn(sdp) && lm->lm_unmount)
-		lm->lm_unmount(sdp);
+		lm->lm_unmount(sdp, true);
 }
 
 static int wait_on_journal(struct gfs2_sbd *sdp)
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 56412f63f3bb9..27fdcbce2d754 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -339,7 +339,7 @@ void gfs2_withdraw(struct gfs2_sbd *sdp)
 
 		if (lm->lm_unmount) {
 			fs_err(sdp, "telling LM to unmount\n");
-			lm->lm_unmount(sdp);
+			lm->lm_unmount(sdp, false);
 		}
 		fs_err(sdp, "File system withdrawn\n");
 		dump_stack();
-- 
2.53.0



