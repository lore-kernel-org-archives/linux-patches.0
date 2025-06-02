Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C4622A814;
	Mon,  2 Jun 2025 14:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875876; cv=none; b=hg9fyPEaFHgsjlVP9rMCO6cBbEjNdRfO9BY+2dCkzln6LQoWQ8P/UH6efsq6HDCvYBxPIYdR+fGUrtQE+4De0AHRPEr8kwd8fCXA6Iv3aWVR3NHVzRIFzZ/GUCKSO7gfNajX8RPsLMlVyZ+0JD6Njht8Ld4nqh6vlchifqdc6YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875876; c=relaxed/simple;
	bh=AnHG3IWuW5vXJ/nlfocQB1u0unT4W19BaDcafdEVZ+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGUSpEFpm1n79fTFD9IGDb3zdbH8nVGoE1KT3gDSS7bqtMjfjyOJnP4S1OOEgUuIeE45+ZsU1thWTWPByP6kYhYTJQzf5NboKAHHKrAgOp4Y9xWBTz5oXncz0Jp+IEcsCWLddzuv5hGoT/txcErUHGCZJTlJesMlXi2Lw1GbflI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IosZDPC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IosZDPC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421D1C4CEEB;
	Mon,  2 Jun 2025 14:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875876;
	bh=AnHG3IWuW5vXJ/nlfocQB1u0unT4W19BaDcafdEVZ+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IosZDPC6Q2L6qHT2Y2YJuvFvcQLWCDTiM2MltKTIUK9fESc0uF+EPwEYfZo7lJyYq
	 NVm33gAA+m+k88QDE9AzK6EAKep7tHNvkJEZe+MK7nje89NGHgjO3b7PT82RpIaJ9T
	 NAoia72sI9r7j97GCFLUghVht11ryK3SZiiT76KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 259/270] fork: use pidfd_prepare()
Date: Mon,  2 Jun 2025 15:49:04 +0200
Message-ID: <20250602134317.920368252@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit ca7707f5430ad6b1c9cb7cee0a7f67d69328bb2d upstream.

Stop open-coding get_unused_fd_flags() and anon_inode_getfile(). That's
brittle just for keeping the flags between both calls in sync. Use the
dedicated helper.

Message-Id: <20230327-pidfd-file-api-v1-2-5c0e9a3158e4@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2238,21 +2238,12 @@ static __latent_entropy struct task_stru
 	 * if the fd table isn't shared).
 	 */
 	if (clone_flags & CLONE_PIDFD) {
-		retval = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+		/* Note that no task has been attached to @pid yet. */
+		retval = __pidfd_prepare(pid, O_RDWR | O_CLOEXEC, &pidfile);
 		if (retval < 0)
 			goto bad_fork_free_pid;
-
 		pidfd = retval;
 
-		pidfile = anon_inode_getfile("[pidfd]", &pidfd_fops, pid,
-					      O_RDWR | O_CLOEXEC);
-		if (IS_ERR(pidfile)) {
-			put_unused_fd(pidfd);
-			retval = PTR_ERR(pidfile);
-			goto bad_fork_free_pid;
-		}
-		get_pid(pid);	/* held by pidfile now */
-
 		retval = put_user(pidfd, args->pidfd);
 		if (retval)
 			goto bad_fork_put_pidfd;


