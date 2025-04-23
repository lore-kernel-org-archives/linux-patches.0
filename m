Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9172BEC3A;
	Wed, 23 Apr 2025 15:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422446; cv=none; b=gh4oYQm1LxvGq6zV4a4DDWMHjrsfxGfYaEEc+tLu+3dFOcFb9UbBfQpLfqjps/eUOihsrO6iqSlKI8fMM7QQm3/tp4LvezVi90BJMQB35SWzv9od2neTKJQZeG2i72T/b3lj0Fi3tCUb0AL2nfgATjFVkHaLeE3oTYWbvkdnDfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422446; c=relaxed/simple;
	bh=tgtUzIv85qy0+SS+KnClh/omouzAwcW7FSX78CUxt9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7IM99s9pZjmcTbB15Mm7/9mQDDmJPPVbJvlqGbCAcuLqun6ZvvU3UWP9AyTlvlHqShWrGayt59Id43M+rt+kTaWMg+c6VYU9gkCGkwOU0Z26r8H42yZg2tCPnNCV2st1jpcMrEUttgZPH54SZ1MMHWXqV5a1SVsbmc6RWgyGP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5qeFkez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5qeFkez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C724C4CEE2;
	Wed, 23 Apr 2025 15:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422446;
	bh=tgtUzIv85qy0+SS+KnClh/omouzAwcW7FSX78CUxt9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5qeFkezYTgbiZij9QTUjQCvQV2WQj1Ve6V+xOI+pCQnOfdt+ZqIDOMkTI1A9BKbe
	 zGeUJtsG8OaiKZzWM9vNsgXVUH+D4luMKHMDNxAfy/x/6u0Ay94ZmHD6rAhDiBjYnf
	 UhKy40fMAzOJDvd0l9q60f6NwtONVmflStv/2gEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 327/393] ksmbd: fix the warning from __kernel_write_iter
Date: Wed, 23 Apr 2025 16:43:43 +0200
Message-ID: <20250423142656.835382006@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit b37f2f332b40ad1c27f18682a495850f2f04db0a upstream.

[ 2110.972290] ------------[ cut here ]------------
[ 2110.972301] WARNING: CPU: 3 PID: 735 at fs/read_write.c:599 __kernel_write_iter+0x21b/0x280

This patch doesn't allow writing to directory.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -496,7 +496,8 @@ int ksmbd_vfs_write(struct ksmbd_work *w
 	int err = 0;
 
 	if (work->conn->connection_type) {
-		if (!(fp->daccess & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE))) {
+		if (!(fp->daccess & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE)) ||
+		    S_ISDIR(file_inode(fp->filp)->i_mode)) {
 			pr_err("no right to write(%pD)\n", fp->filp);
 			err = -EACCES;
 			goto out;


