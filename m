Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290FF1F668B;
	Wed,  6 Nov 2024 13:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898645; cv=none; b=BnCxQVhjXDt0h1j/3m5UtVqm733iKjFHIgx32wYJdX/8VMQkGkF+k75cyD63KH4hZOD3RzGNIYR/+CUzWO8JTjBQ7Hx12jmwAyzpEme1bIgbJ7gteLuzCY+eELB4zcrnjM/ayzfszBaOc0coHVVXoazerI3jXjgZ0ddh8gP1LBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898645; c=relaxed/simple;
	bh=QklQ2wDUPqGwHIYjrYtBlfy6sDo7Kyhp0SpGuOhrC0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIj4hAaxecCzrXp4VYToccy+25F0HlDTpVyZ0THl/l9hykTygtGHJAGuHAeC3YVi/bvLJFcES6cq3MuDTiY7DJiuoJVgs+q6PESXFykQk46sETGyZTVMcD5E2pTIQQMapeiWN8pym5oQ7SpUr96hl+VxzVMLkvozRJJ5Iw/wxA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rl0YT/ST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rl0YT/ST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2178C4CECD;
	Wed,  6 Nov 2024 13:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898645;
	bh=QklQ2wDUPqGwHIYjrYtBlfy6sDo7Kyhp0SpGuOhrC0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rl0YT/STsfszadTpkO/Qof4JkGh6eN1rzOqPgLIFy2a3s/RM+kERQrqMMn1Zs38Gm
	 2so3dXuPIfT5ioio7M42iGNpCG591VbWInDa8iazi1UMWCPGFInzpYVrbA7465h0VP
	 2NF3oGcwpVSht32+n82Z0KpW2BZuC2QChDIuNt3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alfred Agrell <blubban@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 5.4 272/462] tomoyo: fallback to realpath if symlinks pathname does not exist
Date: Wed,  6 Nov 2024 13:02:45 +0100
Message-ID: <20241106120338.244725739@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


