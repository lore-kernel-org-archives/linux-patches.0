Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A51A221F3E;
	Mon,  2 Jun 2025 15:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876505; cv=none; b=Kiu7iU8K3AuEHMz+MRx6Z6AuRwvW4cVQUtbMcVGl8xqS5KztxFmwkYhFG37S2XIkVzUq1HqRvlRQasm9OZkjzXP1JtAMi2LT3BCjwNAsb9PwQuAcxABwyZmc6M1LrDwaC7yJwIEfikA6zmuz/maJn53nlvvxCcUwfG/7GpG5Jxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876505; c=relaxed/simple;
	bh=Op8BDVNqppNWHZucpbWGtgcP3+KXcWSGRQFBu49piXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nyqEVpV5xHllC3p9jNirdS9iRjYMv1SAP2Vf0d81qiLxqH+HPFs99oIEFarn9XWbCE1L0M64MhKbmN7YirfkgSKk9yGQtXsDH71Whz2uvOEFudWNL+BijK9wvH+LoWUGN0JuHJZJXyP4GGUfyjc4NDA3glO/jYF7vVjKiKqhOEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UL7VmBw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UL7VmBw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DDCC4CEEE;
	Mon,  2 Jun 2025 15:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876505;
	bh=Op8BDVNqppNWHZucpbWGtgcP3+KXcWSGRQFBu49piXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UL7VmBw1O1O544Re5T8MVb6nFslIs+jdnh3RF2D1/300/oHDqMGeomDl/n7vxK28M
	 EXCuwxTWQcJyTCsKRoOA1Oh6j7NE5V75eVnNUSEsHii9aVlaaQrSoi3d8u5AOJ0oOX
	 bMAxRaqtJMgsBPe4tgb2ih1UGm0gC5K+yIgn6zt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 196/207] fork: use pidfd_prepare()
Date: Mon,  2 Jun 2025 15:49:28 +0200
Message-ID: <20250602134306.451404677@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2317,21 +2317,12 @@ static __latent_entropy struct task_stru
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


