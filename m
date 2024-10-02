Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C227916F84F;
	Wed,  2 Oct 2024 13:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876802; cv=none; b=jqYfLgBsC/BBiIMEMYzomcJS0V3hSrqYSmvuOr0VYVD2Y4pg0eEPpq9scooxuPv/yYKkaXDswVLpYJFZLqy0WYNJam7jI0Fc9gJo2N+F5/d65Ucm/tT144Wmn6zRyqTFdEhxTsM6hB1ktoWvhuHYYsu/aUmsLQYoL64WUchsn10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876802; c=relaxed/simple;
	bh=MWB28fb43WxBodkxFlNH/dPlEumOLkWkmDYPnhbv48k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npyHZ3tRCpOkQbB+uLh9wKJCI7ClmOtyOji5QRPw5S+Zn4HSb0Z/eRZfst5+9YnLdZXPEOdjnPmkZWOxn5mLWU8L8dyb0U7fORb4H9hmMPZuqPb+N+SBCH5Z/jtZHb98OvfoHZJXCi5W1KnrH80hhpdtUSgbrrQIjJ/h5drY3/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0EBtbwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0EBtbwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A5DC4CECD;
	Wed,  2 Oct 2024 13:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876802;
	bh=MWB28fb43WxBodkxFlNH/dPlEumOLkWkmDYPnhbv48k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0EBtbwg+R+P3+4dQcI64S6tec5S7eNeX+20b6sQgnLEeR2/TA/EFqa55o9AqrvlG
	 HMZt+UspI8PqBjAL/rbKk/ie3eecp1ujrXK6j2/b8MYkinsgEZxMA7MLEOpZ0yXmIE
	 tR4OzfDO0zNEFCVA/9axAVsBowgK5leVBoyXoh6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.11 567/695] ksmbd: allow write with FILE_APPEND_DATA
Date: Wed,  2 Oct 2024 14:59:25 +0200
Message-ID: <20241002125845.139689860@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


