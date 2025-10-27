Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D8932ABE1;
	Mon, 27 Oct 2025 18:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591177; cv=none; b=V1wGUBrukOSa1TGD1NYUUbOKxXa/bq1ypazctsLx8JazRi7aBfTBAdCRLYSj7xsrzpmAlrN9Ro3Pcf1WQSpWxISFhEL06EzqpFCrOcZDnB0t+lPIZ/PcsR6pwCOcYpmT3/0oU/lm0fIonQCcwkIOfj/t/WAqlyhGNB8X+qnhnXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591177; c=relaxed/simple;
	bh=qANkAEANtYvaoUrxCaDDj7zYk2ZQ2IZ4qbpB339OZd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pTGJKt2eFVxtM06sJ7TZqaQZymPVBDELcP+MGmHZbQ0+zFA+S+ObcVrXrt5ftboINe9Fs1lE4JjjE1wbJnXgYRN85rzUIjl8yx/hovZ6GB8N1XtOSU0lJhwFg03hj56j0j+vpEpbhM9/Qa3h16Zm6oD+GUAk/rCcZWvmouV942k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pgxvMOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pgxvMOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9B1C4CEF1;
	Mon, 27 Oct 2025 18:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591177;
	bh=qANkAEANtYvaoUrxCaDDj7zYk2ZQ2IZ4qbpB339OZd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pgxvMOKLJ9Xa7qIGUixFCyosSipIXQafRbT5f01U8KZ0t06WZaSnykbZ7TAb77z4
	 bzkIQ1ySUEHAj6EWF2ScmhUeFMNKiSldsJH13y5m4AAk4cmwpL6TicKBOd9S0evvBF
	 +JtY0GI00YYn9diZw/zFheHR0r+AsV/tG4ZrHoJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 096/332] fs: always return zero on success from replace_fd()
Date: Mon, 27 Oct 2025 19:32:29 +0100
Message-ID: <20251027183527.156481932@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1095,7 +1095,10 @@ int replace_fd(unsigned fd, struct file
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


