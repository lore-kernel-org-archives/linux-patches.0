Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E94619D89C;
	Thu, 25 Jul 2024 14:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918514; cv=none; b=lXiAwBjCwYWuQX/qFuhrQZy1tLntgw9M9QRmbxi8NA4Bb03C+OD150tgrrKuxa//BA2pMccMmGAQ5UdV+Yl0FdBEttLZyL4k+PWm8SdBO966AK+O3v96CPp/UUprtqFHHDW6UZfvsDcgpzqi2LwUvaS5RIYQ+aKeRsBZUR1RnCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918514; c=relaxed/simple;
	bh=J0/dNcvsU9UHX8tfoFHNKTipjg+JHlIG7R3/cg4UJ9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxTc+wHGgG2LypNg0j7gQWJWIXv83fQTwBiYAMUHImcVQCUm87lqfefTRh4zqGunPdhk1Q46oLHu/ITnxf24inabIDP6wKf+Xq1jYA57GdFo4oiV+/dHqCvhsH8hKthu8L7Ktbg9F57aTYT+btdUVRNuKbHzef+8E1+0zF1K2AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHxFKzGg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHxFKzGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27E8C32782;
	Thu, 25 Jul 2024 14:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918514;
	bh=J0/dNcvsU9UHX8tfoFHNKTipjg+JHlIG7R3/cg4UJ9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHxFKzGgX4fAprcqKwdV9VQ5pEj4sNygSlO3qAg+1SkEHh9nXN9hbQa8flih9/wVX
	 oulgCTltS5x9XqZNZBBUJ7QDxZm81y7/dTXIHLXllcbH1oM6/PF+AAxyooo6DBX96m
	 nTESE+vvVZlTllrqNfPrm0f81HWjP/MsnsaEE1iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 4.19 33/33] filelock: Fix fcntl/close race recovery compat path
Date: Thu, 25 Jul 2024 16:36:56 +0200
Message-ID: <20240725142729.759663258@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit f8138f2ad2f745b9a1c696a05b749eabe44337ea upstream.

When I wrote commit 3cad1bc01041 ("filelock: Remove locks reliably when
fcntl/close race is detected"), I missed that there are two copies of the
code I was patching: The normal version, and the version for 64-bit offsets
on 32-bit kernels.
Thanks to Greg KH for stumbling over this while doing the stable
backport...

Apply exactly the same fix to the compat path for 32-bit kernels.

Fixes: c293621bbf67 ("[PATCH] stale POSIX lock handling")
Cc: stable@kernel.org
Link: https://bugs.chromium.org/p/project-zero/issues/detail?id=2563
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20240723-fs-lock-recover-compatfix-v1-1-148096719529@google.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/locks.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2427,8 +2427,9 @@ int fcntl_setlk64(unsigned int fd, struc
 	error = do_lock_file_wait(filp, cmd, file_lock);
 
 	/*
-	 * Attempt to detect a close/fcntl race and recover by releasing the
-	 * lock that was just acquired. There is no need to do that when we're
+	 * Detect close/fcntl races and recover by zapping all POSIX locks
+	 * associated with this file and our files_struct, just like on
+	 * filp_flush(). There is no need to do that when we're
 	 * unlocking though, or for OFD locks.
 	 */
 	if (!error && file_lock->fl_type != F_UNLCK &&
@@ -2442,9 +2443,7 @@ int fcntl_setlk64(unsigned int fd, struc
 		f = fcheck(fd);
 		spin_unlock(&current->files->file_lock);
 		if (f != filp) {
-			file_lock->fl_type = F_UNLCK;
-			error = do_lock_file_wait(filp, cmd, file_lock);
-			WARN_ON_ONCE(error);
+			locks_remove_posix(filp, &current->files);
 			error = -EBADF;
 		}
 	}


