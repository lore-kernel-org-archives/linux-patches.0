Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9560A3F39EE;
	Wed, 20 May 2026 17:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299689; cv=none; b=nu52Y8vscB3+S9sN0YqHMUIoLfweEs8wbNlpQjfJiLW5E2zUq3iLcBoDet79eu9bictz+f4CP/s9UUf1XbvJGz/z1HT4Fu1zcsigLK1XdIUftCLY2q8Z9cLyWym7X/RnYHTvvSgIeMxzFtcgNttUnz5xFLoGhXXSAbysh39x9fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299689; c=relaxed/simple;
	bh=jp5SBvh6gSo+d548Fmn1s2wLN4S2HdNKqQJwZolCn+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKMjxqOpCjW/sLk8uEJrdqX64nrPtGwM1GpI5gycAgV0yBwzeeeg6i0XgjHXyD9zPs4I7yLpHXt7JwXuPy2I13rbDcbzLFRsl88pRsUFLN+tXp1HqiJZkjghPN4jtsG/b76klptDdY4vJJ+Txi89JS8uK7BO6svw5Tla85RQSwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PiHewQQf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PiHewQQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EE51F000E9;
	Wed, 20 May 2026 17:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299687;
	bh=j4XSGZjTK4rBjENL1nMNHkCnty6P5rQvTWkTozd6DWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PiHewQQfCqnqubfOF5Da6iuIupMID7HZ+/1ihP62m46/2edVbLD1mHYPqIxr5ILkG
	 oWB4Fo68Qv8zvhOovJRyHkYaz1U69M+6IpKRDR7XilWrj6mWZQCLtWnCv4wpsqK6fk
	 96nyqAaD39A6yrIEnvl1Qk6CJ+n2epSh/1aaa+y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 867/957] fuse: make sure dentry is evicted if stale
Date: Wed, 20 May 2026 18:22:30 +0200
Message-ID: <20260520162153.369620886@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 1e2c1af1beb395841743e240a59ab37edc9a7d33 ]

d_dispose_if_unused() may find the dentry with a positive refcount, in
which case it won't be put on the dispose list even though it has already
timed out.

"Reinstall" the d_delete() callback, which was optimized out in
fuse_dentry_settime().  This will result in the dentry being evicted as
soon as the refcount hits zero.

Fixes: ab84ad597386 ("fuse: new work queue to periodically invalidate expired dentries")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Link: https://patch.msgid.link/20260114145344.468856-3-mszeredi@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index b7a6a5b6bbc8a..ac5d0c305b51f 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -172,6 +172,10 @@ static void fuse_dentry_tree_work(struct work_struct *work)
 			if (time_after64(get_jiffies_64(), fd->time)) {
 				rb_erase(&fd->node, &dentry_hash[i].tree);
 				RB_CLEAR_NODE(&fd->node);
+				spin_lock(&fd->dentry->d_lock);
+				/* If dentry is still referenced, let next dput release it */
+				fd->dentry->d_flags |= DCACHE_OP_DELETE;
+				spin_unlock(&fd->dentry->d_lock);
 				d_dispose_if_unused(fd->dentry, &dispose);
 				spin_unlock(&dentry_hash[i].lock);
 				cond_resched();
-- 
2.53.0



