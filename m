Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2155366567;
	Wed, 20 May 2026 16:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294391; cv=none; b=GLPbg4COIZeFtxwbb0uejHUJvAZgywCq5qW2qifBSH3rGUR7ih/pi6CiV0FaGwGnlbo++30nlcwpLe5VZwho7NflaC4WmsyZUFSV/pvOvSyJRf28iTZUtbHxZrZMg8rDJiSfMsxVwpFZ3/iLtSqDNR7Icubkux+yPA4TzBSYe20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294391; c=relaxed/simple;
	bh=uy8WiMbWZjRf9mtu10zoz5mrooBf8afisw41YjciQYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7rUoITWfB+l3rBr2Yc5IcQw2yXOR2xlaOIkhRCYoF95+l8FtccGa3z+jbfTV51D8bDx8DFGADzZRRFQqPSr7QPBqLVWdv4fLp/m+L0SvqIxG6wW2eOBG10vG3C5+Hanxg1uiWGORA8XqCMThh2cEfOgFXMvzN1W5ZuElKWrDaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QB7JLpG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QB7JLpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8C31F000E9;
	Wed, 20 May 2026 16:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294389;
	bh=KTSQ2a9wFE25z+bKwgVPqsaclfTUMqIJCygm6cCGH5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0QB7JLpGSgM16s7KlLOg9NKfG98mSJzFCoazDWm/Dc4ZtO9Il010GkIXE10lxKALK
	 LJnhpWeSGTmeX/AzOo+9oBS32Eov1RyKk3oFOj2CKESbQX72kS9RvN/n94vT1md0p4
	 nmfNELkrYky/yT34dHg5blN9cx10TcJm7RoCu/x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <aleksa@amutable.com>,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0021/1146] dcache: permit dynamic_dname()s up to NAME_MAX
Date: Wed, 20 May 2026 18:04:31 +0200
Message-ID: <20260520162148.866551032@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksa Sarai <aleksa@amutable.com>

[ Upstream commit 97b67e64affb0e709eeecc50f6a9222fc20bd14b ]

dynamic_dname() has had an implicit limit of 64 characters since it was
introduced in commit c23fbb6bcb3e ("VFS: delay the dentry name
generation on sockets and pipes"), however it seems that this was a
fairly arbitrary number (suspiciously it was double the previously
hardcoded buffer size).

NAME_MAX seems like a more reasonable and consistent limit for d_name
lengths. While we're at it, we can also remove the unnecessary
stack-allocated array and just memmove() the formatted string to the end
of the buffer.

It should also be noted that at least one driver (in particular,
liveupdate's usage of anon_inode for session files) already exceeded
this limit without noticing that readlink(/proc/self/fd/$n) always
returns -ENAMETOOLONG, so this fixes those drivers as well.

Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")
Fixes: c23fbb6bcb3e ("VFS: delay the dentry name generation on sockets and pipes")
Signed-off-by: Aleksa Sarai <aleksa@amutable.com>
Link: https://patch.msgid.link/20260401-dynamic-dname-name_max-v1-1-8ca20ab2642e@amutable.com
Tested-by: Luca Boccassi <luca.boccassi@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/d_path.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/d_path.c b/fs/d_path.c
index bb365511066b2..a48957c0971ef 100644
--- a/fs/d_path.c
+++ b/fs/d_path.c
@@ -301,18 +301,19 @@ EXPORT_SYMBOL(d_path);
 char *dynamic_dname(char *buffer, int buflen, const char *fmt, ...)
 {
 	va_list args;
-	char temp[64];
+	char *start;
 	int sz;
 
 	va_start(args, fmt);
-	sz = vsnprintf(temp, sizeof(temp), fmt, args) + 1;
+	sz = vsnprintf(buffer, buflen, fmt, args) + 1;
 	va_end(args);
 
-	if (sz > sizeof(temp) || sz > buflen)
+	if (sz > NAME_MAX || sz > buflen)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	buffer += buflen - sz;
-	return memcpy(buffer, temp, sz);
+	/* Move the formatted d_name to the end of the buffer. */
+	start = buffer + (buflen - sz);
+	return memmove(start, buffer, sz);
 }
 
 char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
-- 
2.53.0



