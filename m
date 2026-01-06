Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C9934AB01;
	Tue,  6 Jan 2026 17:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719965; cv=none; b=nvCGi08b/scFKMlG69mSETZJG8D+7oZW319KciPUQoR+3SXGjxHmpcNuoeE5XsjOSXsNGBPwsUVfUwdPyNb5gIxXC/QgnpDpC0r7zGg76vPqkdDbdF0RUMsQ9pO7rpGTfFn8y+c2IhcOfAwdeb2zRsREjplN+vPAYp1hCTL9U9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719965; c=relaxed/simple;
	bh=KlHbNkHOJUUb+Bg3GfdlbijMkJOVfdyfMJorC+4BqhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rG8xZYuaP91lYdhxxQgODk9TKq6mCRm9ITq9ga6wEJI84pt5nOG6bIvLRxRH3+lJmwEr03rIMq9d5lCLxpCy+2WeC74bqeMCTtvq1QZkNegCAQGWuoIdMnLqIxxN4kxVxlpIrlzkf46VSU7m3YdCB9wK/wWb+zqfLtKWshi6NfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnvHx3hu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnvHx3hu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B784AC16AAE;
	Tue,  6 Jan 2026 17:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719965;
	bh=KlHbNkHOJUUb+Bg3GfdlbijMkJOVfdyfMJorC+4BqhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnvHx3hu1yl0kfDPKimh6wQe+U/RCgh8fGrk3coSphzl1F85LGzEid/CkFet7Zbit
	 lpq9CcUsaBNFS7/hRdyWnNJzrUr7CiRhLjdFUP4c+uNHX9D63aG5D7AF65gI3ALV7N
	 AKDxNe+jFi4C0qTknsI0OcobGNe/zY3hdoz1GCAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 093/567] ksmbd: skip lock-range check on equal size to avoid size==0 underflow
Date: Tue,  6 Jan 2026 17:57:55 +0100
Message-ID: <20260106170454.769555388@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianchang Zhao <pioooooooooip@gmail.com>

commit 5d510ac31626ed157d2182149559430350cf2104 upstream.

When size equals the current i_size (including 0), the code used to call
check_lock_range(filp, i_size, size - 1, WRITE), which computes `size - 1`
and can underflow for size==0. Skip the equal case.

Cc: stable@vger.kernel.org
Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -333,6 +333,9 @@ static int check_lock_range(struct file
 	struct file_lock_context *ctx = locks_inode_context(file_inode(filp));
 	int error = 0;
 
+	if (start == end)
+		return 0;
+
 	if (!ctx || list_empty_careful(&ctx->flc_posix))
 		return 0;
 
@@ -839,7 +842,7 @@ int ksmbd_vfs_truncate(struct ksmbd_work
 		if (size < inode->i_size) {
 			err = check_lock_range(filp, size,
 					       inode->i_size - 1, WRITE);
-		} else {
+		} else if (size > inode->i_size) {
 			err = check_lock_range(filp, inode->i_size,
 					       size - 1, WRITE);
 		}


