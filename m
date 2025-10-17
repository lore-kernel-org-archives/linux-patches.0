Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D88337117;
	Fri, 17 Oct 2025 15:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714048; cv=none; b=dJSraOhihU9/OHAdu5C+/RNHjVu16sxO06z1QMglanZy7GZUyc5MdPZe2BYH9HLDKK8NzuoKMcHpS0hsBrcViXq6D0tHMboBUMK3o1QFmKscoLwsIypj8GX2eL6ijfe/xbYD2M2oU91+ieSvr7TLs68G3fMwj08MgMW7HSsGVBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714048; c=relaxed/simple;
	bh=DAXRcqHSHD62BS2uHbN2Gl1CC5gm0Yjl9ONZ6ZZqJ8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L2GLZPyXlMclTz6zD5QdAxOJTd2R7FvrxFxIM+Jlb6H7ub3X8HmKcgxHrH0MD+jjcWZTcEz8dziEGMCH6vFvTobZb5AytztYTYDxR9dxlVQ7vT7gIyLHliCWAi5okp9ssZrXSmq/J5Yh8sFvZhGi7s42oWjqf56EyapGNXN33vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dx+aa6zP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dx+aa6zP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E7FC4CEE7;
	Fri, 17 Oct 2025 15:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714048;
	bh=DAXRcqHSHD62BS2uHbN2Gl1CC5gm0Yjl9ONZ6ZZqJ8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dx+aa6zPCbUw8b/PbkUCuXHZDfOgRUWh7kmADJIE9GaBHTYrrxdljLsTUfHb0+yR8
	 VpFN4ScEghLaGspjk+hqJYgVqB7/voiTWp0VudRhuIHRxj+bzIHux1R6DxUQmpEP+8
	 n/N1jEmiqfC3yHehgrhjuR72CWBvvd8pd53/5Q+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 001/277] fs: always return zero on success from replace_fd()
Date: Fri, 17 Oct 2025 16:50:08 +0200
Message-ID: <20251017145147.197046032@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1262,7 +1262,10 @@ int replace_fd(unsigned fd, struct file
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


