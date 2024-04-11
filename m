Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A55314600A;
	Thu, 11 Apr 2024 10:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830906; cv=none; b=AyqIwAAZvJ1vM/GymIDI0SeCg67tDmy+rU5fJ/342jnRX0xxgHK9j6xDiilKjoSttlIdTVlw8PRF0VzRVvIxKL1sZPkjOtC28HxEb7QLtUQ7ibOJpY1cmTMALjVnBCMMbmTO2dABxi72m9d3HdiAMutKaJYLke5LQvrMfHD3dBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830906; c=relaxed/simple;
	bh=f4I4RlmN4+Rrv5DkSj/VTJcwdvApNXN+deE4IPKBrCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czLZCseFTW35i8RtU8gNme/2KNGY4sUMw79Bv+gLl4kphhOAPhWC4EtixMQtXUod070AgvJ4JllCJ5fyI7pd8Utu8ymFGI9Mf3o9Ww+wpil4K/nJSxNwWpSlEMnJx18TZVa77ryfzhBK/gsfX9lasS7dQ8HF6hSR0kTrCukPv2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxilZSC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxilZSC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F79C433C7;
	Thu, 11 Apr 2024 10:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830906;
	bh=f4I4RlmN4+Rrv5DkSj/VTJcwdvApNXN+deE4IPKBrCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxilZSC+sLYvIYX/cZ9qGr56xdLN/LV7GHVK6lJJBz7ZE3F/jfS5qScsizRfESLZk
	 gXSHoSRNdyY5mEfmUQo6z7u832HSq9mYaEEyy6t+3JlgJYleMiCQgFLpIxKtV1Wlko
	 aIrvoxitTdqFcqlgtitONLyD5gkuVh+BSqLv4Q0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 159/215] fs: add a vfs_fchmod helper
Date: Thu, 11 Apr 2024 11:56:08 +0200
Message-ID: <20240411095429.657652999@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 9e96c8c0e94eea2f69a9705f5d0f51928ea26c17 ]

Add a helper for struct file based chmode operations.  To be used by
the initramfs code soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 4624b346cf67 ("init: open /initrd.image with O_LARGEFILE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/open.c          | 9 +++++++--
 include/linux/fs.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 9213c15d8a8d6..484b300f3e026 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -570,14 +570,19 @@ static int chmod_common(const struct path *path, umode_t mode)
 	return error;
 }
 
+int vfs_fchmod(struct file *file, umode_t mode)
+{
+	audit_file(file);
+	return chmod_common(&file->f_path, mode);
+}
+
 int ksys_fchmod(unsigned int fd, umode_t mode)
 {
 	struct fd f = fdget(fd);
 	int err = -EBADF;
 
 	if (f.file) {
-		audit_file(f.file);
-		err = chmod_common(&f.file->f_path, mode);
+		err = vfs_fchmod(f.file, mode);
 		fdput(f);
 	}
 	return err;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 03de5c7134564..5e122cb506d6e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1731,6 +1731,7 @@ int vfs_mkobj(struct dentry *, umode_t,
 		void *);
 
 int vfs_fchown(struct file *file, uid_t user, gid_t group);
+int vfs_fchmod(struct file *file, umode_t mode);
 
 extern long vfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
-- 
2.43.0



