Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC40D46BA0;
	Mon,  4 Mar 2024 21:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589015; cv=none; b=ZJoB+2yTYI6SnKKNCMx4+NJN3UMrgYfh4VFqmLyqrzBzYvhKbVdkxtfdVSMm/PHQ/YCLPFeXwL4GgLZHgZjOLA+EX5ZznVPs67fw2IBzB9bNGy9jBBFLVamU/hhKAPRDZveSROlBGm34GWOCO+4lRdObV/zRN63Vh91oUM4U48E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589015; c=relaxed/simple;
	bh=xg5MlhVa0u9Qt2TJ28LKDEFq5jYLJ3ICdE8mCJpnDb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8bId9gm7ouou9VS1xBAr/rGVMGt1JFXM6T3A5e/HPVf9uK2jbI0DS2KUDvF3+uaoIXqfSz5cmijTPIXov2vv7+iOXWE/tW2T6AM+9zwHgPAAfPWqaFdxwsI3Ror01drXqzOHeKI4CnFA+m44NYgQMss3q4+hovs3JgJVrP+J+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvkzhfEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvkzhfEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45306C433F1;
	Mon,  4 Mar 2024 21:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589015;
	bh=xg5MlhVa0u9Qt2TJ28LKDEFq5jYLJ3ICdE8mCJpnDb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvkzhfExc5ngKinqEevPjcVymvCb7YkFvC/+bpTb+f2ckh82VmLT6x0kgfGcOlgsx
	 6h0v4+XUSJm7vJU35o1j8lPxINiXLyBv7z4uHILT523deKbNfc2KUfw3RgWkytsEUM
	 dxvCa96gi6NB4LPpwA5E0Wd2PzsTZu0BuLhFXm1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 168/215] lockd: fix file selection in nlmsvc_cancel_blocked
Date: Mon,  4 Mar 2024 21:23:51 +0000
Message-ID: <20240304211602.284202775@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 9f27783b4dd235ef3c8dbf69fc6322777450323c ]

We currently do a lock_to_openmode call based on the arguments from the
NLM_UNLOCK call, but that will always set the fl_type of the lock to
F_UNLCK, and the O_RDONLY descriptor is always chosen.

Fix it to use the file_lock from the block instead.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svclock.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -699,9 +699,10 @@ nlmsvc_cancel_blocked(struct net *net, s
 	block = nlmsvc_lookup_block(file, lock);
 	mutex_unlock(&file->f_mutex);
 	if (block != NULL) {
-		mode = lock_to_openmode(&lock->fl);
-		vfs_cancel_lock(block->b_file->f_file[mode],
-				&block->b_call->a_args.lock.fl);
+		struct file_lock *fl = &block->b_call->a_args.lock.fl;
+
+		mode = lock_to_openmode(fl);
+		vfs_cancel_lock(block->b_file->f_file[mode], fl);
 		status = nlmsvc_unlink_block(block);
 		nlmsvc_release_block(block);
 	}


