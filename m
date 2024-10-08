Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9021DFE1C;
	Tue,  8 Oct 2024 13:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393940; cv=none; b=NqVZ07ykLY8G3imNiuCv47rkjf0udbkOUIJLLP4GkmC95VP5qVOWP1MbL8iiKGbenmg6U0KqlaMc/st709zFW1Esa+AxBqRqhdA/8EPzvZsuqORZXJwJQ1n5RU6yOi7XNZSVhjDV/y5WDBLJhT2Dx2Ppx5RFtWsLmvmrRLiALU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393940; c=relaxed/simple;
	bh=M04d52ePR9YJEWjm21gzKnDeYJ0XcArOvW1p70UMd8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4kzcGRmGih+niBznNuNDCAxXLfkQu5JbrLgFwbm/fXVExvC5E2csqbsQ/+PUqUR5WM1v/Q5eOaAF5gFwEsYMK+SMD9SptzOADeiRLeIPSRLd+3Df9N4aB19H7TyQVJhr92iTVU/sgHCWXbaP1lYWnZmsLpWEPf0vFQVf1jzgAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJFe5NJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJFe5NJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075AEC4CEC7;
	Tue,  8 Oct 2024 13:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393940;
	bh=M04d52ePR9YJEWjm21gzKnDeYJ0XcArOvW1p70UMd8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJFe5NJrZJUcbb9jh3mSPgn+DKuM/UTMIy/ULacAvxg7VQ9Zkwrb4NGanv4dO/7SQ
	 MFITwsaxWJurFSVM8PUhEtwLgI887+i7SsHrlaeog1UozRgCUxFsYJrmrqLvSxg9zi
	 zt5O/es2oNuywp9XfiplRNokda2jGlscclP58d0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alfred Agrell <blubban@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 6.6 300/386] tomoyo: fallback to realpath if symlinks pathname does not exist
Date: Tue,  8 Oct 2024 14:09:05 +0200
Message-ID: <20241008115641.190183683@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -723,10 +723,13 @@ int tomoyo_find_next_domain(struct linux
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


