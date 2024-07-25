Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3495419CCF7;
	Thu, 25 Jul 2024 14:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919308; cv=none; b=Yjofqqhtt2RHRF0iKnoUwftfWiof4seBamZr9iqCX8MgURSi3aml++kUXw3Ct90aARAKFuTn49h2krgWp21Jfn+cUfoKQTqIALGBO6kJQOnjDXb7ceBGKOx9otVr397aQ96ytxIlDNB2tLrIyILR2eb+qT8gp3CGjgGRyaq7zKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919308; c=relaxed/simple;
	bh=zoEtUUu+RiqmdyQ9o4Z2z1ydHz7ItovSsHtaHe+RDZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCuvnVtfmWnpPQkSNJ+LnPON9KaHuG2TomY0OBOumSYBMKoLkNC7pFSOYeGRVEClp16wr6UhM58MGpTZ0XeW92pa68fU2+S3Nb28fvSdWDQtDtkm3QRanOtkj8lSxtbAzFAlaCzRGhnHcCN5Cz5mxWxJY5DDb2z5pVxsvvu5aUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2czUr/T8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2czUr/T8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B272BC116B1;
	Thu, 25 Jul 2024 14:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919308;
	bh=zoEtUUu+RiqmdyQ9o4Z2z1ydHz7ItovSsHtaHe+RDZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2czUr/T8nwkUU+YEJu7r+LEBze+huD3kRvrmaOef9kerV9WE00KzeZNySlhQZGYQY
	 XJjnjcq+VV7N3IC7yiJ5YAE2bHpMF6ZAdg0cAezTBwZl4Ht9Qc3b8RZk2pT4K85MXE
	 jJgFuGFesj+9g9Hq5wl/xhYPejgmw7dM1bSchsaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 87/87] filelock: Fix fcntl/close race recovery compat path
Date: Thu, 25 Jul 2024 16:38:00 +0200
Message-ID: <20240725142741.717840717@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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
@@ -2605,8 +2605,9 @@ int fcntl_setlk64(unsigned int fd, struc
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
@@ -2621,9 +2622,7 @@ int fcntl_setlk64(unsigned int fd, struc
 		f = files_lookup_fd_locked(files, fd);
 		spin_unlock(&files->file_lock);
 		if (f != filp) {
-			file_lock->fl_type = F_UNLCK;
-			error = do_lock_file_wait(filp, cmd, file_lock);
-			WARN_ON_ONCE(error);
+			locks_remove_posix(filp, files);
 			error = -EBADF;
 		}
 	}


