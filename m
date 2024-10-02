Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850B81D0DE6;
	Wed,  2 Oct 2024 14:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880331; cv=none; b=h1tv3RntR5Yb3/3xuF8oa0xaBHev99cVZwPFQt6C20PsGjjQ0zmgiV1oq6AmnKgs+pdV8BJiYhTr+gAntmb46pk+EtwW6yvZdXVhKSah1Gx9La+SYpS8oYDQMjjsrNio8a3GmHi3MnQ31ULjVEILnqeMze3z5a1ew2vQ1KRLIEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880331; c=relaxed/simple;
	bh=WClZB9lNiRQRrDqlpCZX0IATQsR8ZtPDmT5nOEm9vDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjkOvJXC0LNffr40guJSocQncj9Fb4+o3nu1V21qIhJZ3MiBsCguvDGSWFa5NOUF05ERyy2KKqGoHd8mj0Qy8palqVgtH5lOCSVLyCmmh472w5BqNJQpTWuA1/GQbhAiJWxP1KATHHLo8ZnTxLeQv+RnvMFeaFl/ER6dqLNSua0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLJ4aGGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLJ4aGGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F919C4CEC5;
	Wed,  2 Oct 2024 14:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880331;
	bh=WClZB9lNiRQRrDqlpCZX0IATQsR8ZtPDmT5nOEm9vDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLJ4aGGt6wU1Ngse0zDfIdVGiBrmXjLfP+dsnNWnBgOVJV1XrE6p1Fpp5DpG9kMsa
	 1YByMCexwKXo/D5HJS0WhXz71g2ktx3z0QtX8B8lNZOI4YFBAv2OKF+G8reL845lGu
	 WhOsD/HTkS6cOD80hm0UoBs2y+hEE5s5Lbz0Gz7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 422/538] ksmbd: allow write with FILE_APPEND_DATA
Date: Wed,  2 Oct 2024 15:01:01 +0200
Message-ID: <20241002125809.091842038@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 2fb9b5dc80cabcee636a6ccd020740dd925b4580 upstream.

Windows client write with FILE_APPEND_DATA when using git.
ksmbd should allow write it with this flags.

Z:\test>git commit -m "test"
fatal: cannot update the ref 'HEAD': unable to append to
 '.git/logs/HEAD': Bad file descriptor

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -496,7 +496,7 @@ int ksmbd_vfs_write(struct ksmbd_work *w
 	int err = 0;
 
 	if (work->conn->connection_type) {
-		if (!(fp->daccess & FILE_WRITE_DATA_LE)) {
+		if (!(fp->daccess & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE))) {
 			pr_err("no right to write(%pD)\n", fp->filp);
 			err = -EACCES;
 			goto out;


