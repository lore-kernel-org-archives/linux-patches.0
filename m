Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CCD262BE;
	Mon, 27 May 2024 19:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837960; cv=none; b=sG46G2S7Ypqm9uKdwr+dbcdVCW6aybtqFQV8HHF6MbqMqXOIlnj725bCz9kCqUuYKQeZfAAmdD6h90HmPAu2SOGkXfwKRErkFBI6XvUjLxa2/BhaEgEmwvdPYDf1W9iAhq1NFa4T597fCiupy9KogfGc5bPAdIqe2DO8Y7E8lDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837960; c=relaxed/simple;
	bh=8ns4IHBvqEb400OD6wmjDLb0dEPECXuqV9ZchUhPsKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBP34wPcPUj4/2NXkZlmHAgUeVjPccFdZkZ33k7pz4NtPrDDJ5GbBrauhXuzF8GMfh7Mq2ThxZQymNNf2ziis6RYdJZSJyM9WVoDXo5oqMDDOV4jgQ3u/9dXgtR2kPSbY3q//7Y7v/20QAr2mT3dS4/oD+uRMQ80ZB8QxHOCKdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgkqF7PG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgkqF7PG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA67C2BBFC;
	Mon, 27 May 2024 19:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837960;
	bh=8ns4IHBvqEb400OD6wmjDLb0dEPECXuqV9ZchUhPsKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgkqF7PGZhKOBbHB4gQEobMglHkLvuDGLCVioWagbWe84sSQeJUQI1FQeoJ/rdn7V
	 GSipiVR3ujtrsr/kqyzjN2/Oj7dBU7ydJTh1cGv4ykg+TZguGJAOhAzDkHNEFLk3zT
	 koPZeivTJJS6w0HKZWPLsbu85H+RxWly8jvET0aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 210/493] gfs2: Fix "ignore unlock failures after withdraw"
Date: Mon, 27 May 2024 20:53:32 +0200
Message-ID: <20240527185637.185697683@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 34540f9d011ca..385561cd4f4c7 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -802,11 +802,13 @@ __acquires(&gl->gl_lockref.lock)
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
index f52141ce94853..fc3ecb180ac53 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -350,7 +350,6 @@ int gfs2_withdraw(struct gfs2_sbd *sdp)
 			fs_err(sdp, "telling LM to unmount\n");
 			lm->lm_unmount(sdp);
 		}
-		set_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags);
 		fs_err(sdp, "File system withdrawn\n");
 		dump_stack();
 		clear_bit(SDF_WITHDRAW_IN_PROG, &sdp->sd_flags);
-- 
2.43.0



