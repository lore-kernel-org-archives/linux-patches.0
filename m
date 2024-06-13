Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55361849;
	Thu, 13 Jun 2024 12:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281830; cv=none; b=tsVOVB7ueTr2tiEHEuEhKpYj/qzZc5itPPacB1TXNBISGrzeszKNXGh9fa5teFmNYONZa6gXyuRFlbfCP8+DWrg9+fqQmgVHcxygHGjfTJikSt2PAwXrHNRYf5jeni86L5xyl71TRr44T7ML/61awFgmbBuMRybTOr/kh6hgwvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281830; c=relaxed/simple;
	bh=3khPvwX6WhdTgTdmtMjzV6mzS2yvGDhn9qve3qL/ARo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnwPxVNnTRo50i05/wqHuaEzkdb4Qw5WYREZs1h/b1qyO7LPGfj8ieH4YjWxlYWQT4VM5NuCEfpNvEFd2ED4rQKpYBZNfCWJHHC46i2qc8MamXkKkcqnKTZfrrKSesI9fx5IXzdAy5O+1Ni3u1JQQi5eJI9l006PixiaScSxkX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0R701yLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0R701yLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2C7C2BBFC;
	Thu, 13 Jun 2024 12:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281830;
	bh=3khPvwX6WhdTgTdmtMjzV6mzS2yvGDhn9qve3qL/ARo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0R701yLbirlFsxKTTJXnikB0OQPtkDSVQH/dN81qVeLr3c3p0OdUwGzkTGrixoAjo
	 L8kqoTY/skLCOGHI59z2HYa3Cp44FaQxKOhyjc6vAh8ZZbLbgmz5Qcw+qVZaoxnMbr
	 MZ30SBYYp2XSBQ0sLCpmBx+6m5cxnw2DcPnisxQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/402] gfs2: Fix "ignore unlock failures after withdraw"
Date: Thu, 13 Jun 2024 13:30:27 +0200
Message-ID: <20240613113304.868894560@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e85ef6b14777d..7fed3beb5e80c 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -807,11 +807,13 @@ __acquires(&gl->gl_lockref.lock)
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
index cf345a86ef67b..9cdece4928454 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -351,7 +351,6 @@ int gfs2_withdraw(struct gfs2_sbd *sdp)
 			fs_err(sdp, "telling LM to unmount\n");
 			lm->lm_unmount(sdp);
 		}
-		set_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags);
 		fs_err(sdp, "File system withdrawn\n");
 		dump_stack();
 		clear_bit(SDF_WITHDRAW_IN_PROG, &sdp->sd_flags);
-- 
2.43.0



