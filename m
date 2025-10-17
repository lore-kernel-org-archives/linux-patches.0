Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D82323EA9E;
	Fri, 17 Oct 2025 15:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714845; cv=none; b=SFEbx1vLsjHGR/KaBznUIi6PLGL86fA4wjHTYd3epSYSadcEe0TIU+iPnU12VvdHwH5ph2nmmkUhkrozUdl+FD78dbLk3/VNwYz+9Vv39q6ivglIcq+TGDCPx3Rte/TPzAcjgvOubUYW2E+CIRIrJJDRwOgjom12L0nqqNMvj/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714845; c=relaxed/simple;
	bh=vOemVMe1psOAivnsfSlydM/Sn+0062TP3Qtu3g1JPC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jLkyXcwbx1squUoHWrQ1mJHGOpK7xlawy8i3n4uWV/vevMdzcc7Lm+iAemSA4wSdl0qtiqTrORvWN5fMn8+Me/zLVjjA80SlnXABFqwA6vUBn0h6X6treIov/FCfd0Ph7k1wUYjMEb/h8CS0q57AQAglslZFjFmC3mNTlFiIOG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ge+x7WGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ge+x7WGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63EEC116B1;
	Fri, 17 Oct 2025 15:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714845;
	bh=vOemVMe1psOAivnsfSlydM/Sn+0062TP3Qtu3g1JPC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ge+x7WGdYMIJLekwlNBZsIw7sZNuT9VzcRkPqJAfyw2YdNSAobEtnD2pBYn8kMmpO
	 10KRkWywcGmDf4gDHm8CFIcHWtA82rpOXimNnVZ6m/mSKsRC9MHvvR1GSLxBGfw6U7
	 MU1jFH/KW7GqFQKGSDqWM7kg6Cgvam9d1bno5hCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.17 001/371] fs: always return zero on success from replace_fd()
Date: Fri, 17 Oct 2025 16:49:36 +0200
Message-ID: <20251017145201.839827566@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 708c04a5c2b78e22f56e2350de41feba74dfccd9 upstream.

replace_fd() returns the number of the new file descriptor through the
return value of do_dup2(). However its callers never care about the
specific returned number. In fact the caller in receive_fd_replace() treats
any non-zero return value as an error and therefore never calls
__receive_sock() for most file descriptors, which is a bug.

To fix the bug in receive_fd_replace() and to avoid the same issue
happening in future callers, signal success through a plain zero.

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://lore.kernel.org/lkml/20250801220215.GS222315@ZenIV/
Fixes: 173817151b15 ("fs: Expand __receive_fd() to accept existing fd")
Fixes: 42eb0d54c08a ("fs: split receive_fd_replace from __receive_fd")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://lore.kernel.org/20250805-fix-receive_fd_replace-v3-1-b72ba8b34bac@linutronix.de
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/file.c
+++ b/fs/file.c
@@ -1330,7 +1330,10 @@ int replace_fd(unsigned fd, struct file
 	err = expand_files(files, fd);
 	if (unlikely(err < 0))
 		goto out_unlock;
-	return do_dup2(files, file, fd, flags);
+	err = do_dup2(files, file, fd, flags);
+	if (err < 0)
+		return err;
+	return 0;
 
 out_unlock:
 	spin_unlock(&files->file_lock);


