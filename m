Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C4B13AD07;
	Tue, 18 Jun 2024 12:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714920; cv=none; b=LVrDf8VcmaEWx6zJSbcVhTdEOGCyNvUMkDLanr6GhZiLq74GISxh8Tz3z9Jb9Dt4+TCQOUc4ZADSTuRsqCKOQ6cQdSfDP4MOK6gXGCAFki4KUYWD2lr7MKcAy35GBBs1OdmunUQUpQgY/hs9WmmkHQ63aYr5SytF/OEUV17uTkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714920; c=relaxed/simple;
	bh=GbZBBqjYE7tHq+Rq503gNjuB/aQBTfSqsLonPdjBPRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IC7aIipoYVC128wgcuhNcDWZ1pOZ8O3LMCwbZ9ptAU2al/x52BKmhILU8VZAYZKEN13VRAkrVvfXE2hBKfhDCQ4aWWKSztBUmUVZwyzbL+h9F/qB6vy0/1PwlmLaMRiaKsOW/xn5o/22rzMht/mmfcCwD57wOYwQqf+iaK0btBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rf1mJtZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rf1mJtZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF2DC32786;
	Tue, 18 Jun 2024 12:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714920;
	bh=GbZBBqjYE7tHq+Rq503gNjuB/aQBTfSqsLonPdjBPRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rf1mJtZsMf7jayicVcO4DcFWkJpe6XVjJ1BHNM7ChD0hAn9gOpyNrTOv402F2AfwH
	 h5VvbrqlAQLkgbAgAwT/NqCIl6TeZJ/ywPbGRFxYvKIQfiZKe7RfyicSlC2SANl3NV
	 mPM8SMpR+XuVBvJxKHDT2W9spbXCa+M3by/P0NoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@ftp.linux.org.uk>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/770] exec: Dont open code get_close_on_exec
Date: Tue, 18 Jun 2024 14:29:19 +0200
Message-ID: <20240618123411.365823026@linuxfoundation.org>
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

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 878f12dbb8f514799d126544d59be4d2675caac3 ]

Al Viro pointed out that using the phrase "close_on_exec(fd,
rcu_dereference_raw(current->files->fdt))" instead of wrapping it in
rcu_read_lock(), rcu_read_unlock() is a very questionable
optimization[1].

Once wrapped with rcu_read_lock()/rcu_read_unlock() that phrase
becomes equivalent the helper function get_close_on_exec so
simplify the code and make it more robust by simply using
get_close_on_exec.

[1] https://lkml.kernel.org/r/20201207222214.GA4115853@ZenIV.linux.org.uk
Suggested-by: Al Viro <viro@ftp.linux.org.uk>
Link: https://lkml.kernel.org/r/87k0tqr6zi.fsf_-_@x220.int.ebiederm.org
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index ebe9011955b9b..fb8813cc532d0 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1821,8 +1821,7 @@ static int bprm_execve(struct linux_binprm *bprm,
 	 * inaccessible after exec. Relies on having exclusive access to
 	 * current->files (due to unshare_files above).
 	 */
-	if (bprm->fdpath &&
-	    close_on_exec(fd, rcu_dereference_raw(current->files->fdt)))
+	if (bprm->fdpath && get_close_on_exec(fd))
 		bprm->interp_flags |= BINPRM_FLAGS_PATH_INACCESSIBLE;
 
 	/* Set the unchanging part of bprm->cred */
-- 
2.43.0



