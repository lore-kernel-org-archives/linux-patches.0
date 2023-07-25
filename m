Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275AE15ACF
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3BAC433C7;
	Tue, 25 Jul 2023 11:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282885;
	bh=ZOoUxsDyKwEulenjDn/1naBRUgbYK9tIpKiPvo2Coh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9hiZXf3K7JGOf8uHqPtBk9MGGEaZa7Y3lOCqRdBVdwYhp4d4PTelFNo0meWEfOon
	 dSGKbIK7QBQSTrsnFBOgJ8j1XXOMO1jxBVhkEMaD3aTI2d7rQUJzXtyzHzexIhvb2j
	 Ya+k+sxP8LIUNNdG974JKvpDVY3GX5qhaEdzOG1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f1faa20eec55e0c8644c@syzkaller.appspotmail.com,
	Immad Mir <mirimmad17@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/183] [PATCH AUTOSEL 4.19 10/11] FS: JFS: Fix null-ptr-deref Read in txBegin
Date: Tue, 25 Jul 2023 12:44:48 +0200
Message-ID: <20230725104510.119968111@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[ Upstream commit 47cfdc338d674d38f4b2f22b7612cc6a2763ba27 ]

 Syzkaller reported an issue where txBegin may be called
 on a superblock in a read-only mounted filesystem which leads
 to NULL pointer deref. This could be solved by checking if
 the filesystem is read-only before calling txBegin, and returning
 with appropiate error code.

Reported-By: syzbot+f1faa20eec55e0c8644c@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=be7e52c50c5182cc09a09ea6fc456446b2039de3

Signed-off-by: Immad Mir <mirimmad17@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/namei.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -799,6 +799,11 @@ static int jfs_link(struct dentry *old_d
 	if (rc)
 		goto out;
 
+	if (isReadOnly(ip)) {
+		jfs_error(ip->i_sb, "read-only filesystem\n");
+		return -EROFS;
+	}
+
 	tid = txBegin(ip->i_sb, 0);
 
 	mutex_lock_nested(&JFS_IP(dir)->commit_mutex, COMMIT_MUTEX_PARENT);


