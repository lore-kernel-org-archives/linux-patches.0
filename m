Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBB8143894;
	Sun,  1 Sep 2024 16:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209030; cv=none; b=PNWVAa6zq+P/JGMzSRW8twQBKcP+ySVoU4/vY+B3twUqnR6htyNtJFKO02enlajHPFlHTXHtq9aB/meBmNIPiqbLYBbjW544VV2Sm17yvr4e/nVOQOlLnE+xNDNY6m4Oawf5VHFnhlRRvKoKG3jdJtbeGLKQ4kMKJe7ff7ILZS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209030; c=relaxed/simple;
	bh=2LEuaxnDMDC4TK61jtJpPzUenybka5bW+/O7Y8T92uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OU+F1yQW6vt7m2+RzHQ7f7VsLIaI9kmT+eGNxWxUa6axesNzEPILAofWt2UVi4ADy9QyXVD+lJzDSW02cNcmmyDkbPCPP0XqM3hsp7g51XclsBPg4sUgulgqgvarQugnSA55ZCJPh5g0Jdm/PgBFTvr0ka5gJPynF5w8nKh9IfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5PruflA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5PruflA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AD6C4CEC3;
	Sun,  1 Sep 2024 16:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209030;
	bh=2LEuaxnDMDC4TK61jtJpPzUenybka5bW+/O7Y8T92uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5PruflAfabxdv54gAjOKHI5vF/DIClNvQlPEbvaCVJb3blzhRx4O341ry8mMUB+I
	 HHse/yc05UafMOVqLjL4jbvE8PMuf+PyLUFqeCdL6z6+twnsrPZinPohtfWI4xyUex
	 hU3j6Ex1j/Jszia9MmcJvbo9ll2UmmWov7z9VLYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>
Subject: [PATCH 5.4 112/134] filelock: Correct the filelock owner in fcntl_setlk/fcntl_setlk64
Date: Sun,  1 Sep 2024 18:17:38 +0200
Message-ID: <20240901160814.298614121@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

From: Long Li <leo.lilong@huawei.com>

The locks_remove_posix() function in fcntl_setlk/fcntl_setlk64 is designed
to reliably remove locks when an fcntl/close race is detected. However, it
was passing in the wrong filelock owner, it looks like a mistake and
resulting in a failure to remove locks. More critically, if the lock
removal fails, it could lead to a uaf issue while traversing the locks.

This problem occurs only in the 4.19/5.4 stable version.

Fixes: 4c43ad4ab416 ("filelock: Fix fcntl/close race recovery compat path")
Fixes: dc2ce1dfceaa ("filelock: Remove locks reliably when fcntl/close race is detected")
Cc: stable@vger.kernel.org
Signed-off-by: Long Li <leo.lilong@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/locks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2542,7 +2542,7 @@ int fcntl_setlk(unsigned int fd, struct
 		f = fcheck(fd);
 		spin_unlock(&current->files->file_lock);
 		if (f != filp) {
-			locks_remove_posix(filp, &current->files);
+			locks_remove_posix(filp, current->files);
 			error = -EBADF;
 		}
 	}
@@ -2672,7 +2672,7 @@ int fcntl_setlk64(unsigned int fd, struc
 		f = fcheck(fd);
 		spin_unlock(&current->files->file_lock);
 		if (f != filp) {
-			locks_remove_posix(filp, &current->files);
+			locks_remove_posix(filp, current->files);
 			error = -EBADF;
 		}
 	}


