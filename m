Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11D81078F;
	Mon, 27 May 2024 19:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836776; cv=none; b=Dyv7NfsqRRD+JaZQcfo5bncnurT3FCcHrtykekMkBYIqxRpsIlxEqGhB+GXyqZI1SMewj6bcjt7+5d19/hNGaaZR+tuuvVss2ny7GrqekveBYbg4PqXNOCODAtiSQegqp3/2M8x3EDlKiTK7p47LfhGVthSpUCBRyqs9jhx3rpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836776; c=relaxed/simple;
	bh=V/vcQke4KTZQm9tzOQxmSRxHsfnueQR2+WCcC1OEHDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LR/ANZxPzJjXklLZ+mgLKjZ3mmSmGVHfSSbPfXwE341ifvt0JUbaDrpsqdjr8I2HsonFNwGc4gaDSnqzxlCf6Xej7Qjy0KI8LnRwVdY9a11ljOmf0Rfv6ARyVJd1Png9FVLPNyrOweMdE1Q1oE0eSiXqbYPtiha0idMQMp3GKUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOZxfNAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOZxfNAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F31C2BBFC;
	Mon, 27 May 2024 19:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836775;
	bh=V/vcQke4KTZQm9tzOQxmSRxHsfnueQR2+WCcC1OEHDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOZxfNAA/uufHT/6EG/c/0hWpD0S7VzJ++7Vi95RYpFGT9kiFOtP37yyBt2ExixFc
	 BQZRa+z53Igtud4xpjNgefvR9KPsaTY/Huurk9aSJ0x24TP+SFlMa5oOobu6esPTYg
	 gsUEgfxfOzbwlGwJm65zP2UAEWgxODhN341miZkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 141/427] gfs2: Fix "ignore unlock failures after withdraw"
Date: Mon, 27 May 2024 20:53:08 +0200
Message-ID: <20240527185615.048988898@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



