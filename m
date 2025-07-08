Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308191DF74F;
	Tue,  8 Jul 2025 16:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992860; cv=none; b=uqck7hoZDjHavmSMFWFDbHCehW9tlmUN5/VlrkUTi47UquxiiRHsYvgx9UZ9nb+WXGutTXF7XoMi33h1peoBXQL7fu6sYIHQjdUa3QM+qkeixJaLCxxYvw8MljU0EFlCzPGf9V28OFeK06VqM+BYcOmDJS3F5AmHaxz6LJdY8fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992860; c=relaxed/simple;
	bh=O2otyvuhvZ/oJ0VR7DftpWN+qXWESMKkNAAtvvDSLGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0/nTooo+eB15SLtk0uuvLQn+Bse1HBlFGCi5ChOV+qw70eRfIya/6OFFrrd6qgT3CQhfZhTS8t6FqRrFZRqaEnxvLDgSzwOy+F6VYh4pSzLy9Hml1fQwIK1iPalO+w1qT8wi/Vcmjd592Cl6YQLbjFQ7v5LPAEcVW539gQTtGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHR4orSU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHR4orSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B496BC4CEED;
	Tue,  8 Jul 2025 16:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992860;
	bh=O2otyvuhvZ/oJ0VR7DftpWN+qXWESMKkNAAtvvDSLGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHR4orSU0hoFt8UCiFXptyCDD9pUupEKYp1oPMM9QN2TaQgAlH46oCVCJKLuHSDGb
	 0ZsXhbJrtX/lM88gf/hadISEPyXs/73I3sdl4lZrr1o0Z6l/OCqRSRARWlCTCEzd+F
	 5iM5wt2aaKcKauHgmuLMYnldtrS6Y7osr6RcHa+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/232] gfs2: Add GLF_PENDING_REPLY flag
Date: Tue,  8 Jul 2025 18:21:42 +0200
Message-ID: <20250708162244.214771958@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 8bbfde0875590b71f012bd8b0c9cb988c9a873b9 ]

Introduce a new GLF_PENDING_REPLY flag to indicate that a reply from DLM
is expected.  Include that flag in glock dumps to show more clearly
what's going on.  (When the GLF_PENDING_REPLY flag is set, the GLF_LOCK
flag will also be set but the GLF_LOCK flag alone isn't sufficient to
tell that we are waiting for a DLM reply.)

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 2c63986dd35f ("gfs2: deallocate inodes in gfs2_create_inode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c      | 5 +++++
 fs/gfs2/incore.h     | 1 +
 fs/gfs2/trace_gfs2.h | 1 +
 3 files changed, 7 insertions(+)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 3c70c383b9bdd..ec043aa71de8c 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -807,6 +807,7 @@ __acquires(&gl->gl_lockref.lock)
 	}
 
 	if (ls->ls_ops->lm_lock) {
+		set_bit(GLF_PENDING_REPLY, &gl->gl_flags);
 		spin_unlock(&gl->gl_lockref.lock);
 		ret = ls->ls_ops->lm_lock(gl, target, lck_flags);
 		spin_lock(&gl->gl_lockref.lock);
@@ -825,6 +826,7 @@ __acquires(&gl->gl_lockref.lock)
 			/* The operation will be completed asynchronously. */
 			return;
 		}
+		clear_bit(GLF_PENDING_REPLY, &gl->gl_flags);
 	}
 
 	/* Complete the operation now. */
@@ -1960,6 +1962,7 @@ void gfs2_glock_complete(struct gfs2_glock *gl, int ret)
 	struct lm_lockstruct *ls = &gl->gl_name.ln_sbd->sd_lockstruct;
 
 	spin_lock(&gl->gl_lockref.lock);
+	clear_bit(GLF_PENDING_REPLY, &gl->gl_flags);
 	gl->gl_reply = ret;
 
 	if (unlikely(test_bit(DFL_BLOCK_LOCKS, &ls->ls_recover_flags))) {
@@ -2360,6 +2363,8 @@ static const char *gflags2str(char *buf, const struct gfs2_glock *gl)
 		*p++ = 'f';
 	if (test_bit(GLF_INVALIDATE_IN_PROGRESS, gflags))
 		*p++ = 'i';
+	if (test_bit(GLF_PENDING_REPLY, gflags))
+		*p++ = 'R';
 	if (test_bit(GLF_HAVE_REPLY, gflags))
 		*p++ = 'r';
 	if (test_bit(GLF_INITIAL, gflags))
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 98a41c631ce10..f6aee2c9b9118 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -330,6 +330,7 @@ enum {
 	GLF_UNLOCKED			= 16, /* Wait for glock to be unlocked */
 	GLF_TRY_TO_EVICT		= 17, /* iopen glocks only */
 	GLF_VERIFY_DELETE		= 18, /* iopen glocks only */
+	GLF_PENDING_REPLY		= 19,
 };
 
 struct gfs2_glock {
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index ac8ca485c46fe..09121c2c198ba 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -53,6 +53,7 @@
 	{(1UL << GLF_DIRTY),			"y" },		\
 	{(1UL << GLF_LFLUSH),			"f" },		\
 	{(1UL << GLF_INVALIDATE_IN_PROGRESS),	"i" },		\
+	{(1UL << GLF_PENDING_REPLY),		"R" },		\
 	{(1UL << GLF_HAVE_REPLY),		"r" },		\
 	{(1UL << GLF_INITIAL),			"a" },		\
 	{(1UL << GLF_HAVE_FROZEN_REPLY),	"F" },		\
-- 
2.39.5



