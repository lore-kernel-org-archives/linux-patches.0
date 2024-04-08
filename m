Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BC27C080;
	Mon,  8 Apr 2024 13:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584617; cv=none; b=J3s3VgnxH+9KMw1cSCKetul1mdBx2eCzxmrtSbVk1ciJeJXGRabnxVchyUlxGRCvh8U9fS2HKtW+XKvhwUfs2bilVofdudvwQ2rMAH1XyJtqSRYbRBOYTjT8ZRvuIg40RwNLNfceGvLxKcc/WXvS7w3uEMDpO0RJZY7fiCc8LsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584617; c=relaxed/simple;
	bh=bdh9z2PWL+H9CoYy+TUDDJbTPc/zA4BIQ45bJqH56H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVuJH93oDRkhk+a5SrLZPj2niZhrmJZa0BKSJE3+m7U48HLIRDOkpRXeeL4icVKeucgS0L2r62/bI4feg3oLVQiFopXetnLCjVB1ksguzNhEbwMQXNwvPuPvpXZKe+5d/8bdVpinmLukJOTK9iPS9xlfdy0Yc1GZsnuKygz5hIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgqlwrgo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgqlwrgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3F3C433C7;
	Mon,  8 Apr 2024 13:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584617;
	bh=bdh9z2PWL+H9CoYy+TUDDJbTPc/zA4BIQ45bJqH56H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgqlwrgoUmmffXwrC7t2DgXTCNnzZVyV1bfC2Ko42AmMmMyIhtSM4jh5I/ZV3fgaM
	 rDykW0wSB131TLXGyVI3O2iNnJJu3YsEIXXMeOGMYDlTxhhTH2JPxz3b/w+5B5l1qF
	 jSp9t9CvVN0aOkG2hCySY/9ADbaXbM7ldse8uAzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 500/690] lockd: ensure we use the correct file descriptor when unlocking
Date: Mon,  8 Apr 2024 14:56:06 +0200
Message-ID: <20240408125417.758689012@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 69efce009f7df888e1fede3cb2913690eb829f52 ]

Shared locks are set on O_RDONLY descriptors and exclusive locks are set
on O_WRONLY ones. nlmsvc_unlock however calls vfs_lock_file twice, once
for each descriptor, but it doesn't reset fl_file. Ensure that it does.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/lockd/svclock.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index 9c1aa75441e1c..9eae99e08e699 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -659,11 +659,13 @@ nlmsvc_unlock(struct net *net, struct nlm_file *file, struct nlm_lock *lock)
 	nlmsvc_cancel_blocked(net, file, lock);
 
 	lock->fl.fl_type = F_UNLCK;
-	if (file->f_file[O_RDONLY])
-		error = vfs_lock_file(file->f_file[O_RDONLY], F_SETLK,
+	lock->fl.fl_file = file->f_file[O_RDONLY];
+	if (lock->fl.fl_file)
+		error = vfs_lock_file(lock->fl.fl_file, F_SETLK,
 					&lock->fl, NULL);
-	if (file->f_file[O_WRONLY])
-		error = vfs_lock_file(file->f_file[O_WRONLY], F_SETLK,
+	lock->fl.fl_file = file->f_file[O_WRONLY];
+	if (lock->fl.fl_file)
+		error |= vfs_lock_file(lock->fl.fl_file, F_SETLK,
 					&lock->fl, NULL);
 
 	return (error < 0)? nlm_lck_denied_nolocks : nlm_granted;
-- 
2.43.0



