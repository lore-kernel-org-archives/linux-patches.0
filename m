Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABC17BAFE;
	Mon,  8 Apr 2024 13:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584623; cv=none; b=oMxah97AAgUmfFFWWM+qAnXrHPPsktgngqz39j5KH0RgkBWrXWljbhIgYCXTU8YKsFHakqR1qUDK4coKJTKyoalWhhPdT+C0648qD23A751PZyRw0T1innL53gkxGd/6g/G7ee6D59EzhX38fmMVIyHjLDYW5md0TG3x+0btMgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584623; c=relaxed/simple;
	bh=rMj+tYBoCSqX8l+0/igWeTEQg8pKn0V9C5YXppJUOSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKEDn45lrRAc3Ij62cq//R+PVfDzNSj1q6furBmt2/ZyF9zoU5Lrb08li+/qEtx4B9NovaELuy/OnvzKEM+yPnJS/qxvproIwxhyZFm1vMOHKwy57mK5FeVHncguvbtWFxo3tssbzdGHMe9sG7QjqWC3jf1QMj2/eQAL/8CwogY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FF5m6hti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FF5m6hti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D59C433F1;
	Mon,  8 Apr 2024 13:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584623;
	bh=rMj+tYBoCSqX8l+0/igWeTEQg8pKn0V9C5YXppJUOSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FF5m6htinvlXqmtjHI4MdjmgMDytzmwdRKHggi7GbR9njJHpu180kDWlLvxN8enfj
	 cuCejgb/zZjEnwlQwQ/13Fj5ODw69ngJMhhEnIT5lucJcFHROimGC/Us2cSFcuO5lA
	 YNNEon+bfDIp+O5J9DTSeYekcS80U+WBAUlFOySY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 501/690] lockd: fix file selection in nlmsvc_cancel_blocked
Date: Mon,  8 Apr 2024 14:56:07 +0200
Message-ID: <20240408125417.790384633@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 9f27783b4dd235ef3c8dbf69fc6322777450323c ]

We currently do a lock_to_openmode call based on the arguments from the
NLM_UNLOCK call, but that will always set the fl_type of the lock to
F_UNLCK, and the O_RDONLY descriptor is always chosen.

Fix it to use the file_lock from the block instead.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/lockd/svclock.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index 9eae99e08e699..4e30f3c509701 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -699,9 +699,10 @@ nlmsvc_cancel_blocked(struct net *net, struct nlm_file *file, struct nlm_lock *l
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
-- 
2.43.0



