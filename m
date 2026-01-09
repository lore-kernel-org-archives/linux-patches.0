Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D016633CE9A;
	Fri,  9 Jan 2026 12:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960337; cv=none; b=ML/ipXkoCpQdVaNL7MLWJbRqcXNyyAHklx+LO9oIv1zyzEGXdJNPI8xEsOlGYSp9RqY6opcqRwsdpfbY4QjI7XJQxcyzNAp0bNm1rW/7mXEAPkxtq7Ctk1yXeJ5zKxtB/L2B1jphGfMYzZKV0Bxdw0ipAb9KzmjDjkxUyY2pUxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960337; c=relaxed/simple;
	bh=ejJ/sOJ4bk2Ld8VZNhnh0VB8TCJhUjN6nv5KsN1G05M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6H9oHAEPBztF+eYan/9tl3tfF0xGZHv5P2vsofmM0PE4IKGLdLfLge06l0VsP6kOp9eOxeIvgLydaMS/ftBsj3gbKJbnck/474wktLqkIt0S4ZUEPH/ioeXFOxwDkDvdTZMnph+Ibk+trpQNZysRgW3jh6kot5D2wEoO3RUaeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7+hUlrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7+hUlrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18012C4CEF1;
	Fri,  9 Jan 2026 12:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960337;
	bh=ejJ/sOJ4bk2Ld8VZNhnh0VB8TCJhUjN6nv5KsN1G05M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7+hUlrkxXOzJSiSOmhYGHazzEqlBAnwCBUyRUkIoTwflOSHBpa1yoLyldkQJ7GYR
	 EnulZKqsyfKProL3Fly+R5gttpi6NwzX8P3uJ/qOkkpYdX+BBXoIxFwxV81zED4Eh/
	 WQNnTolTEhPOt57EXvpvkGMeOeWHJyXZ2V6C/SAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 369/737] ksmbd: skip lock-range check on equal size to avoid size==0 underflow
Date: Fri,  9 Jan 2026 12:38:28 +0100
Message-ID: <20260109112147.875674318@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -834,7 +837,7 @@ int ksmbd_vfs_truncate(struct ksmbd_work
 		if (size < inode->i_size) {
 			err = check_lock_range(filp, size,
 					       inode->i_size - 1, WRITE);
-		} else {
+		} else if (size > inode->i_size) {
 			err = check_lock_range(filp, inode->i_size,
 					       size - 1, WRITE);
 		}


