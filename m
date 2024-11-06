Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767D51DF26B;
	Wed,  6 Nov 2024 12:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895496; cv=none; b=Hclni6/Qb7ItFzb7c5S/VauaXbm1tKf48bg0Nb06lSVfyE5NsGNezqTmX8VcMQeOczQODyPz4ttpeL2oIHMFDCF6jSyXGu/eD2Jxv8VZR0viPf/jxl3Zhb+v/0MastOlz8WSivvlxaoApNs8679dPBuS6Udha+it3maWXoeAMyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895496; c=relaxed/simple;
	bh=+bC58XwPsgNLZw729qNnECxDmU5Eev6pMVUXq+YxS+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCWrviVL3k6s/MQe2KfL18aTIB5fiTyw6FrFweGccbg12kSOh9OTWmrRZ6FaeIHKZ5kLrOpcMM2UojhNW9T9IL6/JW0Rimki3qGSElEikZK39MrIVRl0l/XN1EOXD3Ybk+mpBgLwZTRJQF8Kz1lIMUDdtcBDbA3q9zkBJD3LBWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAmPaOxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAmPaOxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E5EC4CECD;
	Wed,  6 Nov 2024 12:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895496;
	bh=+bC58XwPsgNLZw729qNnECxDmU5Eev6pMVUXq+YxS+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAmPaOxk/hY8DVkEgAttTfb2HTQ3lwcK55V6hChGlY3rWHNt0JEHSwWf+tU6k25pI
	 bn9Eh/Sg/eHbbFnM+5hSQCSXSI5ebKsw1iANNK/b0HKDznl4Vwf+ONov0b9pwLzY1X
	 inEoil6Vc35cABAz7K3yoRpvHsGZzgiFNgL69AEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alfred Agrell <blubban@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 4.19 210/350] tomoyo: fallback to realpath if symlinks pathname does not exist
Date: Wed,  6 Nov 2024 13:02:18 +0100
Message-ID: <20241106120326.177404036@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -701,10 +701,13 @@ int tomoyo_find_next_domain(struct linux
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


