Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135C0374C4;
	Tue,  8 Apr 2025 11:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110740; cv=none; b=sznJYQLe2unWSAx1KskrKodRFsHccEpTlcMFVXyoLJAsSmJOyDnK5IxEx0An+jnPwxai3eqn6XjaPOgGUAYoH/HSTBmlXiC8prYBob8SLfrvbKq+utYZ20o3XEBB8Jlf8BAHcPUdJQPZoHddrd4BiVRWSa7g9BwSqZbRE+UFR9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110740; c=relaxed/simple;
	bh=js//+UoZ4WiJVSLtkFJPR22ojIdYahIupPUzEOD7/0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+uQNwY6uo4i+MBb/d4kMoUu7uD9ccNhcghKrF/1YC/xFhE4/6QGEi9JZIp0gzy+ss5mWEcORuU2UiUNGK+vClrHZvkg8arjtsHu/rFYaEMLa+TO397d/eDONw/+X4RJFAn4CaXjr8qgSReo6zh3hetrMZATflKaoNP0AmgLn+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOdRz02u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOdRz02u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349AAC4CEE7;
	Tue,  8 Apr 2025 11:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110737;
	bh=js//+UoZ4WiJVSLtkFJPR22ojIdYahIupPUzEOD7/0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MOdRz02uHmq2T8GEMh+BZQxI4RCrL5nZLEJRQZtFC8Q34iuMaunStoTwVAnYvCXGS
	 +AjjDV38mvMWwOF4zXNnvnWcAzsqboj6aL7zezL74mb19RTKu5HmUlAFKLNijsF70u
	 n5Lh7CAoNkQKuh3e6+w23/rU3kmkj3RgmrBhGS7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 168/731] gfs2: minor evict fix
Date: Tue,  8 Apr 2025 12:41:05 +0200
Message-ID: <20250408104918.184478619@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit e9e38ed7250f8ef6b2928216156c09df8b4834b3 ]

In evict_should_delete(), when gfs2_upgrade_iopen_glock() fails, we
detach the iopen glock from the inode without calling
glock_clear_object().  This leads to a warning in glock_set_object()
when the same inode is recreated and the glock is reused.
Fix that by only detaching the iopen glock in gfs2_evict_inode().

In addition, remove the dequeue code from evict_should_delete(); we
already perform a conditional dequeue in gfs2_evict_inode().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 41a8e04c94b8 ("gfs2: skip if we cannot defer delete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 92a3b6ddafdc1..ff8fdc6134ff5 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1338,12 +1338,8 @@ static enum evict_behavior evict_should_delete(struct inode *inode,
 
 	/* Must not read inode block until block type has been verified */
 	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, GL_SKIP, gh);
-	if (unlikely(ret)) {
-		glock_clear_object(ip->i_iopen_gh.gh_gl, ip);
-		ip->i_iopen_gh.gh_flags |= GL_NOCACHE;
-		gfs2_glock_dq_uninit(&ip->i_iopen_gh);
+	if (unlikely(ret))
 		return EVICT_SHOULD_DEFER_DELETE;
-	}
 
 	if (gfs2_inode_already_deleted(ip->i_gl, ip->i_no_formal_ino))
 		return EVICT_SHOULD_SKIP_DELETE;
@@ -1363,15 +1359,8 @@ static enum evict_behavior evict_should_delete(struct inode *inode,
 
 should_delete:
 	if (gfs2_holder_initialized(&ip->i_iopen_gh) &&
-	    test_bit(HIF_HOLDER, &ip->i_iopen_gh.gh_iflags)) {
-		enum evict_behavior behavior =
-			gfs2_upgrade_iopen_glock(inode);
-
-		if (behavior != EVICT_SHOULD_DELETE) {
-			gfs2_holder_uninit(&ip->i_iopen_gh);
-			return behavior;
-		}
-	}
+	    test_bit(HIF_HOLDER, &ip->i_iopen_gh.gh_iflags))
+		return gfs2_upgrade_iopen_glock(inode);
 	return EVICT_SHOULD_DELETE;
 }
 
-- 
2.39.5



