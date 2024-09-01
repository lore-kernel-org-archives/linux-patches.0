Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA17183CBB;
	Sun,  1 Sep 2024 16:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207789; cv=none; b=Q2vm5aWDyclhIrPktzzHjXgHcKvEPapJvjoFkZNEDhhNYY4lh/oM4s5nnilXOz9S/QZf72HittJpuodAIZCStXaVySrnCTKZm3m6SQvhiCdUOf8Nur+zXd7GEw4fhj0cpygVYPmIKIF2lYQiquFj38TV5IE0MzEFzQV7H8k5yhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207789; c=relaxed/simple;
	bh=ScagkBn3WHobzkp2qdnKzYdT+2W+Tv6FedL6cvfv6tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUYgoZ+IWIENVr3awcgayggl8Sz/bFB7zEO3TojngWcgXdc8axKTUY7J9DDaKAIQQ84bbnlJdJi0Nx/WJmSK1Jq9fS+ChlXzYhvWoAFOX3T5+7OJj/rw9VYF2jzl2InV8bKyQlOA1fYbVFkzXgBr+veU8jFv3Q9H1mWU3IkXVSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iY1zrksA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iY1zrksA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0ABC4CEC3;
	Sun,  1 Sep 2024 16:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207788;
	bh=ScagkBn3WHobzkp2qdnKzYdT+2W+Tv6FedL6cvfv6tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iY1zrksAqk7bikdpuLXw+5JcRORtTgNHTcEoGI+f2ModJdOLFnoQX7ragWEuMjw19
	 kPH0yfBi/k9Izk71409w00+KT0f/IkoQ2wosjFbCAw3sU4M5gQwKZ7fjbbD+oQ05fJ
	 7trk4Fg/Nfap9fBZkJb3INSsm6m+9oH8n5hF7iJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>
Subject: [PATCH 4.19 77/98] filelock: Correct the filelock owner in fcntl_setlk/fcntl_setlk64
Date: Sun,  1 Sep 2024 18:16:47 +0200
Message-ID: <20240901160806.599918977@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

From: Long Li <leo.lilong@huawei.com>

The locks_remove_posix() function in fcntl_setlk/fcntl_setlk64 is designed
to reliably remove locks when an fcntl/close race is detected. However, it
was passing in the wrong filelock owner, it looks like a mistake and
resulting in a failure to remove locks. More critically, if the lock
removal fails, it could lead to a uaf issue while traversing the locks.

This problem occurs only in the 4.19/5.4 stable version.

Fixes: a561145f3ae9 ("filelock: Fix fcntl/close race recovery compat path")
Fixes: d30ff3304083 ("filelock: Remove locks reliably when fcntl/close race is detected")
Cc: stable@vger.kernel.org
Signed-off-by: Long Li <leo.lilong@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/locks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2313,7 +2313,7 @@ int fcntl_setlk(unsigned int fd, struct
 		f = fcheck(fd);
 		spin_unlock(&current->files->file_lock);
 		if (f != filp) {
-			locks_remove_posix(filp, &current->files);
+			locks_remove_posix(filp, current->files);
 			error = -EBADF;
 		}
 	}
@@ -2443,7 +2443,7 @@ int fcntl_setlk64(unsigned int fd, struc
 		f = fcheck(fd);
 		spin_unlock(&current->files->file_lock);
 		if (f != filp) {
-			locks_remove_posix(filp, &current->files);
+			locks_remove_posix(filp, current->files);
 			error = -EBADF;
 		}
 	}


