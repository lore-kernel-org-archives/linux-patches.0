Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784402A1B2;
	Wed, 23 Apr 2025 15:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421199; cv=none; b=V0MnAWE2wCo3YipVE/kWtF+dol0awHMriQ5hNT7YeNnEL+K9W4ZbnQ/WmIJO/oF0VIlGMN7iVTZNBtdLOflpikwUzN4kuzEXzv4aMJGzltdLi/rrKImTD96GAbhYQ8bqhCimlA7bBwGLzwceLdisSvES/HXsUiwuTmWyg2bunYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421199; c=relaxed/simple;
	bh=WgQpmuXTsYEsIFFQrIwxgJlZHGovXZdG+e3J29rhGQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t59C2heYfatemuzgkP4ONtUFhKkhOFIbV+QdixN14tkhjMp308Mj4b5b07yCcjuZEeL9Gtj0wUNwvaEFMg6cSoDX4+LKSamGipn2w8faLl5Uh8kx5FkSm6FtG4zh46+VOpiQBIwq8MeMSZXXfncfdnZeJC9T1wi7HOGU9xPme9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwWH4flK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwWH4flK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0EAC4CEE2;
	Wed, 23 Apr 2025 15:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421199;
	bh=WgQpmuXTsYEsIFFQrIwxgJlZHGovXZdG+e3J29rhGQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwWH4flKJY5SjU/xUXlgHyW/BL479kpB5Tz2vesWjVmIYAf8fuFZG6HLgsNvGs6Tb
	 uVq3RSbdTAmtZOJI8cOIiwK7mwzsn3SOfVNSXN8NAMI2p5KcKcDZEMJYIDO80LE9zI
	 u/lTXeFgcpioswHLA+u59xOrwS0RCaOtB9VX1zoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 147/241] ksmbd: fix the warning from __kernel_write_iter
Date: Wed, 23 Apr 2025 16:43:31 +0200
Message-ID: <20250423142626.557274213@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


