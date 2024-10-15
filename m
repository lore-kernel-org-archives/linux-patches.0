Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718561B219E;
	Tue, 15 Oct 2024 13:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998287; cv=none; b=rQrnO5uSBVTlYE3g1ULs9ZrxkmYfoE4MUPfpfDO1KkTVphADlO98mOzU1IprNR4GM/pvdYYrv9SQpkMptgipClHsG2w/TGVxEm1oJkzBhKVdIl4shicX3KO4/WlX5kNvivFySmR2dqAMfiuruhSG2QiSN6P9HRDAk69M95UX85g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998287; c=relaxed/simple;
	bh=OSifmnwtauMn0OYTo25xstDzu2DCeMpdnpzowxeqr5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mt9oT0vT/nd3q1yxhJrUDgXcKE3FcDjY9uv/4lqplZR0FELpG1iHB6F4bU+n24gRGkSloHXK5TJp99abfBHzBg5UfKjZPoEHjqnCJ1nR+inTvSR+9ZrPOAKjYwOqcE2S8eBKOUl1fbe3zvK/G6g+X1vlw7ctCPgtl53pzLWnyio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6yURwuj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6yURwuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AEAC4CEC6;
	Tue, 15 Oct 2024 13:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998287;
	bh=OSifmnwtauMn0OYTo25xstDzu2DCeMpdnpzowxeqr5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6yURwuj0iYbvSYcVZWzjLVON27Wyl7ztsbSEU+jnCD2zzx5bAte7j9u4KIP77xvE
	 Ul8qOi3A1Fp4OxZxBDD0yi7S0EdIbp+EkB/2+VOXZALkQq4X1GGArbobotdTFHSTgu
	 EkgKzDirNojWTW3m+ypPAOWLrk5E9UD8K0XFxli8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alfred Agrell <blubban@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 5.10 406/518] tomoyo: fallback to realpath if symlinks pathname does not exist
Date: Tue, 15 Oct 2024 14:45:10 +0200
Message-ID: <20241015123932.651987107@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit ada1986d07976d60bed5017aa38b7f7cf27883f7 upstream.

Alfred Agrell found that TOMOYO cannot handle execveat(AT_EMPTY_PATH)
inside chroot environment where /dev and /proc are not mounted, for
commit 51f39a1f0cea ("syscalls: implement execveat() system call") missed
that TOMOYO tries to canonicalize argv[0] when the filename fed to the
executed program as argv[0] is supplied using potentially nonexistent
pathname.

Since "/dev/fd/<fd>" already lost symlink information used for obtaining
that <fd>, it is too late to reconstruct symlink's pathname. Although
<filename> part of "/dev/fd/<fd>/<filename>" might not be canonicalized,
TOMOYO cannot use tomoyo_realpath_nofollow() when /dev or /proc is not
mounted. Therefore, fallback to tomoyo_realpath_from_path() when
tomoyo_realpath_nofollow() failed.

Reported-by: Alfred Agrell <blubban@gmail.com>
Closes: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1082001
Fixes: 51f39a1f0cea ("syscalls: implement execveat() system call")
Cc: stable@vger.kernel.org # v3.19+
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/tomoyo/domain.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/security/tomoyo/domain.c
+++ b/security/tomoyo/domain.c
@@ -725,10 +725,13 @@ int tomoyo_find_next_domain(struct linux
 	ee->r.obj = &ee->obj;
 	ee->obj.path1 = bprm->file->f_path;
 	/* Get symlink's pathname of program. */
-	retval = -ENOENT;
 	exename.name = tomoyo_realpath_nofollow(original_name);
-	if (!exename.name)
-		goto out;
+	if (!exename.name) {
+		/* Fallback to realpath if symlink's pathname does not exist. */
+		exename.name = tomoyo_realpath_from_path(&bprm->file->f_path);
+		if (!exename.name)
+			goto out;
+	}
 	tomoyo_fill_path_info(&exename);
 retry:
 	/* Check 'aggregator' directive. */


