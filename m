Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DED4847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF426C433D2;
	Wed,  1 Mar 2023 18:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694371;
	bh=zWuA3UfuEa+JaU+TQU1FsEaLrZ9m0D0dRt/S7p1enzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QlHUET/fysN5WUdzP8WCuCgmDd0ccWs7K7yQpttbEV50rEvDEGnyyE3DPfP2MXTmQ
	 93qnQm10DdtS7lAVgcCaEPzQNsqBLF90M18gd6KuKs2ssqDwyyMALgTdc9BjFhhPoQ
	 WgqLEhE4z+p9GydwW8L3l2Ce6v1wSMRKjAYT9T8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <miklos@szeredi.hu>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.1 40/42] fs: use consistent setgid checks in is_sxid()
Date: Wed,  1 Mar 2023 19:09:01 +0100
Message-Id: <20230301180658.844097833@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Brauner <brauner@kernel.org>

commit 8d84e39d76bd83474b26cb44f4b338635676e7e8 upstream.

Now that we made the VFS setgid checking consistent an inode can't be
marked security irrelevant even if the setgid bit is still set. Make
this function consistent with all other helpers.

Note that enforcing consistent setgid stripping checks for file
modification and mode- and ownership changes will cause the setgid bit
to be lost in more cases than useed to be the case. If an unprivileged
user wrote to a non-executable setgid file that they don't have
privilege over the setgid bit will be dropped. This will lead to
temporary failures in some xfstests until they have been updated.

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3549,7 +3549,7 @@ int __init list_bdev_fs_names(char *buf,
 
 static inline bool is_sxid(umode_t mode)
 {
-	return (mode & S_ISUID) || ((mode & S_ISGID) && (mode & S_IXGRP));
+	return mode & (S_ISUID | S_ISGID);
 }
 
 static inline int check_sticky(struct user_namespace *mnt_userns,


