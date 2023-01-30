Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02B83229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAB7C433EF;
	Mon, 30 Jan 2023 14:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088616;
	bh=6MfuKjXEDnSAb+9hBv/+/5bMaAmAbN3vlKWvof2M07w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPGlAHgHpVcUJXt14/6R4jIfX0tqNjTjicV/toP50aAchW26cQqp5KKIe0op8qdKS
	 WfgmDTmvNt8SPfGG5JTNfTyYhg6slqiKXlGsIW9cRtMjTCDPU5bzridVqjSCTEq7AH
	 48euQU61KRMeromPFvdwP2gXAQnpGXotj6D0Yhp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongliang Mu <mudongliangabcd@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.10 078/143] fs: reiserfs: remove useless new_opts in reiserfs_remount
Date: Mon, 30 Jan 2023 14:52:15 +0100
Message-Id: <20230130134310.110305194@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit 81dedaf10c20959bdf5624f9783f408df26ba7a4 upstream.

Since the commit c3d98ea08291 ("VFS: Don't use save/replace_mount_options
if not using generic_show_options") eliminates replace_mount_options
in reiserfs_remount, but does not handle the allocated new_opts,
it will cause memory leak in the reiserfs_remount.

Because new_opts is useless in reiserfs_mount, so we fix this bug by
removing the useless new_opts in reiserfs_remount.

Fixes: c3d98ea08291 ("VFS: Don't use save/replace_mount_options if not using generic_show_options")
Link: https://lore.kernel.org/r/20211027143445.4156459-1-mudongliangabcd@gmail.com
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/reiserfs/super.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1437,7 +1437,6 @@ static int reiserfs_remount(struct super
 	unsigned long safe_mask = 0;
 	unsigned int commit_max_age = (unsigned int)-1;
 	struct reiserfs_journal *journal = SB_JOURNAL(s);
-	char *new_opts;
 	int err;
 	char *qf_names[REISERFS_MAXQUOTAS];
 	unsigned int qfmt = 0;
@@ -1445,10 +1444,6 @@ static int reiserfs_remount(struct super
 	int i;
 #endif
 
-	new_opts = kstrdup(arg, GFP_KERNEL);
-	if (arg && !new_opts)
-		return -ENOMEM;
-
 	sync_filesystem(s);
 	reiserfs_write_lock(s);
 
@@ -1599,7 +1594,6 @@ out_ok_unlocked:
 out_err_unlock:
 	reiserfs_write_unlock(s);
 out_err:
-	kfree(new_opts);
 	return err;
 }
 


