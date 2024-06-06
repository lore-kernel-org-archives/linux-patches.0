Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F0F1993B9;
	Thu,  6 Jun 2024 14:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683240; cv=none; b=e/0hMLAyKqQkS5kYN/zqCaYYhkBomWXEf4dhFJrZeLCmXCEjMFJikZWd/QO6F6RdY4P56ZzM92wmY5RXOaqLHkpxqjNPBA6ftQjyb1VXhWa8CWXrsj8Fod8IZwGcNB8m0VEz3pLy2OabQ9Tft2gZlYSqxksPkpPfyAx71lKeY3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683240; c=relaxed/simple;
	bh=L0q7LFrDeyfO4qh6RdV8IeX+BrmWIxU/5EQaUTO8fHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGrXtBPVzzwu9eRpPaQ93OKQrj+/erf98npbpXFPTOLjZ/U5LGtkCMmbEc8tjeB+4mKF1KXRN/Wg07t7tsMK9JDjfJsgYnjhvXK6QK0T85BhiKVroZvc0W0I6p3WCjreBOOEoLoF9oetDtGqnalSQxPEQsj64Ii/+XUHPZfmYPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1d5GNB8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1d5GNB8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053A6C32781;
	Thu,  6 Jun 2024 14:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683240;
	bh=L0q7LFrDeyfO4qh6RdV8IeX+BrmWIxU/5EQaUTO8fHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1d5GNB8PkkKU5e9NdDSYvGs6Naq/fk0a/cYg+nofsEM5NicUvUOM46D5Kkc0ajcfL
	 7RPQHzyIfXMKaD5/1YGu9IaoHTw/vutuGthPwLESMsN00Sr1DDZGCOpBHeeY3p6qf8
	 5Qx6+CVjhqeE24VFQmXGKicRNJ3erceqC3g6iGtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/473] gfs2: Fix "ignore unlock failures after withdraw"
Date: Thu,  6 Jun 2024 16:00:46 +0200
Message-ID: <20240606131703.814306886@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 5d9231111966b6c5a65016d58dcbeab91055bc91 ]

Commit 3e11e53041502 tries to suppress dlm_lock() lock conversion errors
that occur when the lockspace has already been released.

It does that by setting and checking the SDF_SKIP_DLM_UNLOCK flag.  This
conflicts with the intended meaning of the SDF_SKIP_DLM_UNLOCK flag, so
check whether the lockspace is still allocated instead.

(Given the current DLM API, checking for this kind of error after the
fact seems easier that than to make sure that the lockspace is still
allocated before calling dlm_lock().  Changing the DLM API so that users
maintain the lockspace references themselves would be an option.)

Fixes: 3e11e53041502 ("GFS2: ignore unlock failures after withdraw")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 4 +++-
 fs/gfs2/util.c  | 1 -
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 235a0948f6cc6..95353982e643a 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -855,11 +855,13 @@ __acquires(&gl->gl_lockref.lock)
 	}
 
 	if (sdp->sd_lockstruct.ls_ops->lm_lock)	{
+		struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+
 		/* lock_dlm */
 		ret = sdp->sd_lockstruct.ls_ops->lm_lock(gl, target, lck_flags);
 		if (ret == -EINVAL && gl->gl_target == LM_ST_UNLOCKED &&
 		    target == LM_ST_UNLOCKED &&
-		    test_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags)) {
+		    test_bit(DFL_UNMOUNT, &ls->ls_recover_flags)) {
 			finish_xmote(gl, target);
 			gfs2_glock_queue_work(gl, 0);
 		} else if (ret) {
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 7a6aeffcdf5ca..48c69aa60cd17 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -359,7 +359,6 @@ int gfs2_withdraw(struct gfs2_sbd *sdp)
 			fs_err(sdp, "telling LM to unmount\n");
 			lm->lm_unmount(sdp);
 		}
-		set_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags);
 		fs_err(sdp, "File system withdrawn\n");
 		dump_stack();
 		clear_bit(SDF_WITHDRAW_IN_PROG, &sdp->sd_flags);
-- 
2.43.0



