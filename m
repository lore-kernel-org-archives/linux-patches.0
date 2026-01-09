Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5485C33D50F;
	Fri,  9 Jan 2026 12:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960303; cv=none; b=m7DHThrAfuk1zLswoYUOR+zakdzN/R0p8tl2Ih2tREN1KMXYBcpevHi91LXcZHOHp/PnlI6pSrM8uWuJRF4+SEx7fFDh5mFUJvu8ftVkahoxBRuiCkhmsHa8bsPv1vscXjkrqjV2OmFYtWjCsgin/8KsaU2MAXEaiZwDWFs74aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960303; c=relaxed/simple;
	bh=5KBJt7nqAMNDchb4528VJHS9YCD5x9/STsK/vttw8RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDq3KbqMCdMd4T+rB1m3hWYu/1FJW0VQMbwAxAdQKCtUQD0SclhJPPK83McLImsuYYBavjB7x/t0gSFn0V17kq7h9v4LREtCoNBiIZ6K/GaTmIYKnclmTs3a4piyevWRXedLTULQhUctqI93F61JPqzSKzjt0+Xzpkg4PoqDBS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXDbux7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXDbux7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DF2C4CEF1;
	Fri,  9 Jan 2026 12:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960303;
	bh=5KBJt7nqAMNDchb4528VJHS9YCD5x9/STsK/vttw8RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXDbux7R3Yg/9YX4LprlBW6s3h82npVoQ//1Fu8c/QzC7hfNo48yPRlvVJ7aXVfxG
	 DpPu7cpnKC4Aw/JHtqiH0bZQtouhvJbi+hcy58DCEYxJ8c11GRh6e1/ArEmh3IS489
	 wcEffm1nb6noWbh4k/RKnMdOATY0avxPntrB1XK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 324/737] gfs2: fix remote evict for read-only filesystems
Date: Fri,  9 Jan 2026 12:37:43 +0100
Message-ID: <20260109112146.186162760@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 64c10ed9274bc46416f502afea48b4ae11279669 ]

When a node tries to delete an inode, it first requests exclusive access
to the iopen glock.  This triggers demote requests on all remote nodes
currently holding the iopen glock.  To satisfy those requests, the
remote nodes evict the inode in question, or they poke the corresponding
inode glock to signal that the inode is still in active use.

This behavior doesn't depend on whether or not a filesystem is
read-only, so remove the incorrect read-only check.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 1c854d4e2d491..4a169c60bce65 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -640,8 +640,7 @@ static void iopen_go_callback(struct gfs2_glock *gl, bool remote)
 	struct gfs2_inode *ip = gl->gl_object;
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 
-	if (!remote || sb_rdonly(sdp->sd_vfs) ||
-	    test_bit(SDF_KILL, &sdp->sd_flags))
+	if (!remote || test_bit(SDF_KILL, &sdp->sd_flags))
 		return;
 
 	if (gl->gl_demote_state == LM_ST_UNLOCKED &&
-- 
2.51.0



