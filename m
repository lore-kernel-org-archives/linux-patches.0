Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41E3267B15;
	Tue,  8 Apr 2025 12:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114172; cv=none; b=PJAZb2uYdLVGf91ysZ0K+ILdlLAbjU6HENCtj3JtJVZaeXxj04zO0aUZH3iiF9XvntoLJ7jn8vIcp/BNYW79jTwucceJmg095j/XruYfCITiSfBHQUlqJaetA8FOmKqAIRnkAhijbB5aIdvAN2sQYLHE3/Y3kePEoGj8vDvSHK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114172; c=relaxed/simple;
	bh=DvvnoSyOZAlF/gKogQbEUov1aoLKUhtVna3fBQhORig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brktkLL6/YPQZ3Qm8mMKY2qWVlEuqFNwZZvY83HwvNz77TaAcvFewhG3nkeSQtitZiCh+bIyPofXx/R1kfe0hHpGqdQeOGUJ9OewIRZOxKJMsqYL+RxAp0IDsWX03a3lEUnjbKBrUQ9R5z3KujlsPJZqMSTEGefeKM5YxEv4Iwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/OjvLWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/OjvLWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACA1C4CEE5;
	Tue,  8 Apr 2025 12:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114172;
	bh=DvvnoSyOZAlF/gKogQbEUov1aoLKUhtVna3fBQhORig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/OjvLWSL6xAIUROkc+umcIHYYR1zSJzesS0AGrktIxxpVszh6xcDNqAjplssELfC
	 ugvn5+EUtVLZhEE9w4VB18WEKeaTLtuixySWLF13k0Kun8+DOcYw3Ou1aIsIXlk+Jr
	 Ip7ecpF318fkRdZPAHVLlai0KiW7fIO7HHCtSy5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 001/499] fs: support O_PATH fds with FSCONFIG_SET_FD
Date: Tue,  8 Apr 2025 12:43:33 +0200
Message-ID: <20250408104851.295925144@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 0ff053b98a0f039e52c2bd8d0cb38f2831edfaf5 ]

Let FSCONFIG_SET_FD handle O_PATH file descriptors. This is particularly
useful in the context of overlayfs where layers can be specified via
file descriptors instead of paths. But userspace must currently use
non-O_PATH file desriptors which is often pointless especially if
the file descriptors have been created via open_tree(OPEN_TREE_CLONE).

Link: https://lore.kernel.org/r/20250210-work-overlayfs-v2-1-ed2a949b674b@kernel.org
Fixes: a08557d19ef41 ("ovl: specify layers via file descriptors")
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/autofs/autofs_i.h | 2 ++
 fs/fsopen.c          | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/autofs/autofs_i.h b/fs/autofs/autofs_i.h
index 77c7991d89aac..23cea74f9933b 100644
--- a/fs/autofs/autofs_i.h
+++ b/fs/autofs/autofs_i.h
@@ -218,6 +218,8 @@ void autofs_clean_ino(struct autofs_info *);
 
 static inline int autofs_check_pipe(struct file *pipe)
 {
+	if (pipe->f_mode & FMODE_PATH)
+		return -EINVAL;
 	if (!(pipe->f_mode & FMODE_CAN_WRITE))
 		return -EINVAL;
 	if (!S_ISFIFO(file_inode(pipe)->i_mode))
diff --git a/fs/fsopen.c b/fs/fsopen.c
index 094a7f510edfe..1aaf4cb2afb29 100644
--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -453,7 +453,7 @@ SYSCALL_DEFINE5(fsconfig,
 	case FSCONFIG_SET_FD:
 		param.type = fs_value_is_file;
 		ret = -EBADF;
-		param.file = fget(aux);
+		param.file = fget_raw(aux);
 		if (!param.file)
 			goto out_key;
 		param.dirfd = aux;
-- 
2.39.5



