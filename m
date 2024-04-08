Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E695477F1B;
	Mon,  8 Apr 2024 13:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584615; cv=none; b=S90hObs+OFgBP43LoR5dOxFZnXO0uTMqmj1+0MdAItKL4ry3Zx7qbSOQpbZRh/7aTG71ubm/Mfh6mhAnvylVWjlu0QYnxZm7lxsyLXcgZCAPVEq5XW67veg8DST7yw+h+zNno2ErjRfRLSHEDRV93SWEx8kVNcjZZ/v9aP3qI2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584615; c=relaxed/simple;
	bh=vnQ177tcC5kmzFsdEHCLlaRT/QVWJGmos4YPGE3pMwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZanMhuWNfypvySo3GJXryeFipzjMqJbja7Th+l1BjaOD/4bDg4Or71URQYOH7oJgJwIAiTC6SZFdkoKdcaGLOfksuwqwqFp+BN4c2EqN9xG99RAiOuLsl8Tb0mkcYDJ8J0WiJXfV9XQN4/TQ3+M23X/DglqPBsI+eQfk7H5Fn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMydr38S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMydr38S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67139C43390;
	Mon,  8 Apr 2024 13:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584614;
	bh=vnQ177tcC5kmzFsdEHCLlaRT/QVWJGmos4YPGE3pMwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMydr38S2nJm2uPTABoYaPbosCUnjzZnJhDBqrGIEsnyQAWtDUz1yse11VdmTKAtL
	 sobogAVIH+ckWxGDKn9u1kYRiXKZ6Dus6vaEnpv+gS6LU9IH/YVg0G8Ey42lAMgmf4
	 FPnly3jal20bNXznLqjp7ys3oNfHo9MESAF/3u3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 499/690] lockd: set missing fl_flags field when retrieving args
Date: Mon,  8 Apr 2024 14:56:05 +0200
Message-ID: <20240408125417.716176602@linuxfoundation.org>
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

[ Upstream commit 75c7940d2a86d3f1b60a0a265478cb8fc887b970 ]

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/lockd/svc4proc.c | 1 +
 fs/lockd/svcproc.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index 742b8d31d2fad..e318d55e4c0ef 100644
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -52,6 +52,7 @@ nlm4svc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 		*filp = file;
 
 		/* Set up the missing parts of the file_lock structure */
+		lock->fl.fl_flags = FL_POSIX;
 		lock->fl.fl_file  = file->f_file[mode];
 		lock->fl.fl_pid = current->tgid;
 		lock->fl.fl_start = (loff_t)lock->lock_start;
diff --git a/fs/lockd/svcproc.c b/fs/lockd/svcproc.c
index 7e25d5583c7d0..2a615032f5d0f 100644
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -77,6 +77,7 @@ nlmsvc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 
 		/* Set up the missing parts of the file_lock structure */
 		mode = lock_to_openmode(&lock->fl);
+		lock->fl.fl_flags = FL_POSIX;
 		lock->fl.fl_file  = file->f_file[mode];
 		lock->fl.fl_pid = current->tgid;
 		lock->fl.fl_lmops = &nlmsvc_lock_operations;
-- 
2.43.0



