Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B68416124;
	Sat, 12 Sep 2026 09:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204299; cv=none; b=Fk85isqzYLzhVkvwRw0wdWJAPRv8pDsjOZLuOq/gUtt/OPwK7OwbGTkpq3n4nd9zcTCBHuMApB6DrZab6JNTc74Oeaf7yueMVuPjTQNkKDKvqI3d2tFVQpfYw//bBpRxQdqKC9SyO7h/z31eQioKKzEqr8xhu0xLm+H1WuC59vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204299; c=relaxed/simple;
	bh=uN5F93M+3JGbHFl/kFoiRoIi6c9U+mMPFMLBqHUJiVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrCSV2nySDGJad05Espy3SiKy040u6oaZ4j8fbS0oLtMVZEdGgygIHSJF8ppRFYBRaICSm3StTIkO1oPjQe/rkY5M1TNxSwJEFvbAENpvCKESw5UK7gs5+9Wv3hyLISR7XN1PefWO451BAvHxDOUc/lG4olArVbRQ9WXwk7y2TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVCQEFcO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVCQEFcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0693F1F000FF;
	Sat, 12 Sep 2026 09:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204298;
	bh=VkSBezEAI/eFvfbMe0u29olBht3gpFlBSXbJ+9zF8g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BVCQEFcOltFCMgVwtosFX0QU6MDgKQJz7/8qpW4Z3LhVxv+uu/09yQimWmD8nIDTa
	 WdvyrPgCSESTeqxxCZ6UllBOaB+1r5Xt2LL+SjiylDe3v+OEPqy7FlV/AhFPxwZx14
	 wmgXR0dFRVfAvHMaEmQLgwvj25DMrJ2OqAezbwO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1583/1815] fuse: reject a duplicate fd= mount option
Date: Sat, 12 Sep 2026 08:55:33 +0200
Message-ID: <20260912065726.150706016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun@linux.alibaba.com>

[ Upstream commit ed976994939f05ffbb6e9e5482adc788e679c0ea ]

fuse_opt_fd() stored the fuse device in ctx->fud and bumped its refcount
unconditionally:

        ctx->fud = fuse_dev_grab(file);

If fd= is given twice (two fsconfig FSCONFIG_SET_FD calls), the second
call overwrites ctx->fud and grabs the new device, while the reference
taken on the first device is never released - a permanent refcount leak
that pins the first fuse_dev until reboot.

Reject a second fd= outright.  ctx is zeroed on allocation, so a non-NULL
ctx->fud reliably means the option was already processed.

Fixes: d42eb23b2ef9 ("fuse: don't require /dev/fuse fd to be kept open during mount")
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index ce4891a04a378..a51be4221a329 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -791,6 +791,9 @@ static int fuse_opt_fd(struct fs_context *fsc, struct file *file)
 {
 	struct fuse_fs_context *ctx = fsc->fs_private;
 
+	if (ctx->fud)
+		return invalfc(fsc, "Multiple fd specified");
+
 	if (file->f_op != &fuse_dev_operations)
 		return invalfc(fsc, "fd is not a fuse device");
 	/*
-- 
2.53.0



