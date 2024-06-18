Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AAB18040;
	Tue, 18 Jun 2024 12:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715508; cv=none; b=YUyYsBBxU+TQ555mriNkUTVES/5Nj4zlyJff2zzfY/DpsksvpRDkn0sCkAR5LWeXIhOJ9goQnJvkUnfESBO6XQ0S3jB44Dnlvtwx1vLeMUMEOanlgNX0kuOh1vxiebp3OgRgJLtNwvyRxSMr9ccbrMcl/w7rmChn3UADvFqnxJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715508; c=relaxed/simple;
	bh=5f4R7iGnBxe5xT0pPiROtLT7lSDvFUVksiIyta3NOuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnXiv4Zs8erhCy2WFJBlS2Qix8Zuiu2Z1atK4uwcag7yPIdrvGsDkwewcYH1Pe0ND8Ii1f+FbEw9+Jpvb/iqT6vzyuvzByGUg64EZOr6+70Vpu3j+F0uqfSExwJHR1wz7nJwChULlBf+eXgaZ49jYc4knpj54kKRbrTZTgryhoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qceBdBPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qceBdBPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA0BC3277B;
	Tue, 18 Jun 2024 12:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715508;
	bh=5f4R7iGnBxe5xT0pPiROtLT7lSDvFUVksiIyta3NOuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qceBdBPdW3LLyWM+W5GaCzHlfhOmMVqAZ2tiC6vTWbdn6twrq/tPGqmuXmIY1tCR4
	 GW/Z58Ri12pWfixuYvRAJcnctDZJNCdLZwj8XWHhgDxB8klWGiLHiipdj1RJBWHjLT
	 Hakb12VzLoTyqw5GrWGGJAQx9S9BkoKN5XHou37E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Bobrowski <repnop@google.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 332/770] kernel/pid.c: implement additional checks upon pidfd_create() parameters
Date: Tue, 18 Jun 2024 14:33:05 +0200
Message-ID: <20240618123420.084128678@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Bobrowski <repnop@google.com>

[ Upstream commit 490b9ba881e2c6337bb09b68010803ae98e59f4a ]

By adding the pidfd_create() declaration to linux/pid.h, we
effectively expose this function to the rest of the kernel. In order
to avoid any unintended behavior, or set false expectations upon this
function, ensure that constraints are forced upon each of the passed
parameters. This includes the checking of whether the passed struct
pid is a thread-group leader as pidfd creation is currently limited to
such pid types.

Link: https://lore.kernel.org/r/2e9b91c2d529d52a003b8b86c45f866153be9eb5.1628398044.git.repnop@google.com
Signed-off-by: Matthew Bobrowski <repnop@google.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/pid.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 74f0466757cbf..0820f2c50bb0c 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -559,6 +559,12 @@ int pidfd_create(struct pid *pid, unsigned int flags)
 {
 	int fd;
 
+	if (!pid || !pid_has_task(pid, PIDTYPE_TGID))
+		return -EINVAL;
+
+	if (flags & ~(O_NONBLOCK | O_RDWR | O_CLOEXEC))
+		return -EINVAL;
+
 	fd = anon_inode_getfd("[pidfd]", &pidfd_fops, get_pid(pid),
 			      flags | O_RDWR | O_CLOEXEC);
 	if (fd < 0)
@@ -598,10 +604,7 @@ SYSCALL_DEFINE2(pidfd_open, pid_t, pid, unsigned int, flags)
 	if (!p)
 		return -ESRCH;
 
-	if (pid_has_task(p, PIDTYPE_TGID))
-		fd = pidfd_create(p, flags);
-	else
-		fd = -EINVAL;
+	fd = pidfd_create(p, flags);
 
 	put_pid(p);
 	return fd;
-- 
2.43.0



