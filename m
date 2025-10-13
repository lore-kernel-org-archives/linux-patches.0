Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F118E30E853;
	Mon, 13 Oct 2025 15:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368803; cv=none; b=ptYzgx4STVKZAG4UJyGad0sT4CgpJLUUBDe+AC8OXXUSu9VDTQDjMnXaLmzr87LU8ou2bDmezEvTt5w9IAz6/UUqF/vUveX3gQyKSziNEHlsabpTREpbYzUUBP+bifLSR2Z+7mREdlOh+Xwvnv3FOYfo/ZT3gT3LjTSxk++0KNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368803; c=relaxed/simple;
	bh=uaMocS3TzhOzds5M8AzkxT1h10qJPjcAEvhPX/SAjC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlJAn/lGRYEdaTGsBlGZd50GizEJ24BzDduB2D17XEAJmcGChlbnpZEDoFZrTKy2xxz8Kd6FboWTr0RzuiPQNYPhwdHmYQFpeLBsuScRoZRbxBzHKj7wG5NVAcZ98uMyMYFv/jOZPI14aduHE9tb6zJw9uNzYmKyOv8avMCFSl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQvS8AFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQvS8AFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41299C4CEE7;
	Mon, 13 Oct 2025 15:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368802;
	bh=uaMocS3TzhOzds5M8AzkxT1h10qJPjcAEvhPX/SAjC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQvS8AFDH2YrCNCW4PoBJgEdSI2FkYVHabRzwKjcsa8q0HO/tN9Z36YYZWEhc4YSq
	 uXKDoerxAIXq6Cl7PRALlcC2Un1RJb8VzJfNxS/uUXdF4N53V3Vy4p61YCEud3up8u
	 wM7gHt+ZXBacTQlTXaSUCyjDjZ4dHkScC44rpIXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Price <anprice@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 017/563] gfs2: Get rid of GLF_INVALIDATE_IN_PROGRESS
Date: Mon, 13 Oct 2025 16:37:58 +0200
Message-ID: <20251013144411.915411080@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit bddb53b776fb7ce81dfba7c24884d9f2c0c68e50 ]

Get rid of the GLF_INVALIDATE_IN_PROGRESS flag: it was originally used
to indicate to add_to_queue() that the ->go_sync() and ->go_invalid()
operations were in progress, but as we have established in commit "gfs2:
Fix LM_FLAG_TRY* logic in add_to_queue", add_to_queue() has no need to
know.

Commit d99724c3c36a describes a race in which GLF_INVALIDATE_IN_PROGRESS
is used to serialize two processes which are both in do_xmote() at the
same time.  That analysis is wrong: the serialization happens via the
GLF_LOCK flag, which ensures that at most one glock operation can be
active at any time.

Fixes: d99724c3c36a ("gfs2: Close timing window with GLF_INVALIDATE_IN_PROGRESS")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c      | 16 +---------------
 fs/gfs2/incore.h     |  1 -
 fs/gfs2/trace_gfs2.h |  1 -
 3 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 93aae10d78f30..68e943e13dd53 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -703,17 +703,6 @@ __acquires(&gl->gl_lockref.lock)
 	lck_flags &= (LM_FLAG_TRY | LM_FLAG_TRY_1CB | LM_FLAG_NOEXP);
 	GLOCK_BUG_ON(gl, gl->gl_state == target);
 	GLOCK_BUG_ON(gl, gl->gl_state == gl->gl_target);
-	if ((target == LM_ST_UNLOCKED || target == LM_ST_DEFERRED) &&
-	    glops->go_inval) {
-		/*
-		 * If another process is already doing the invalidate, let that
-		 * finish first.  The glock state machine will get back to this
-		 * holder again later.
-		 */
-		if (test_and_set_bit(GLF_INVALIDATE_IN_PROGRESS,
-				     &gl->gl_flags))
-			return;
-	}
 	if (!glops->go_inval || !glops->go_sync)
 		goto skip_inval;
 
@@ -732,7 +721,7 @@ __acquires(&gl->gl_lockref.lock)
 		goto skip_inval;
 	}
 
-	if (test_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags)) {
+	if (target == LM_ST_UNLOCKED || target == LM_ST_DEFERRED) {
 		/*
 		 * The call to go_sync should have cleared out the ail list.
 		 * If there are still items, we have a problem. We ought to
@@ -747,7 +736,6 @@ __acquires(&gl->gl_lockref.lock)
 			gfs2_dump_glock(NULL, gl, true);
 		}
 		glops->go_inval(gl, target == LM_ST_DEFERRED ? 0 : DIO_METADATA);
-		clear_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags);
 	}
 	spin_lock(&gl->gl_lockref.lock);
 
@@ -2313,8 +2301,6 @@ static const char *gflags2str(char *buf, const struct gfs2_glock *gl)
 		*p++ = 'y';
 	if (test_bit(GLF_LFLUSH, gflags))
 		*p++ = 'f';
-	if (test_bit(GLF_INVALIDATE_IN_PROGRESS, gflags))
-		*p++ = 'i';
 	if (test_bit(GLF_PENDING_REPLY, gflags))
 		*p++ = 'R';
 	if (test_bit(GLF_HAVE_REPLY, gflags))
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index d4ad82f47eeea..c390f208654c1 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -319,7 +319,6 @@ enum {
 	GLF_DEMOTE_IN_PROGRESS		= 5,
 	GLF_DIRTY			= 6,
 	GLF_LFLUSH			= 7,
-	GLF_INVALIDATE_IN_PROGRESS	= 8,
 	GLF_HAVE_REPLY			= 9,
 	GLF_INITIAL			= 10,
 	GLF_HAVE_FROZEN_REPLY		= 11,
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index 26036ffc3f338..1c2507a273180 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -52,7 +52,6 @@
 	{(1UL << GLF_DEMOTE_IN_PROGRESS),	"p" },		\
 	{(1UL << GLF_DIRTY),			"y" },		\
 	{(1UL << GLF_LFLUSH),			"f" },		\
-	{(1UL << GLF_INVALIDATE_IN_PROGRESS),	"i" },		\
 	{(1UL << GLF_PENDING_REPLY),		"R" },		\
 	{(1UL << GLF_HAVE_REPLY),		"r" },		\
 	{(1UL << GLF_INITIAL),			"a" },		\
-- 
2.51.0



