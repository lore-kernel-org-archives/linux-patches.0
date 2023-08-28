Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E1C6FB1
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBED9C433C9;
	Mon, 28 Aug 2023 10:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217723;
	bh=fEZNC2vOt10JdZYK+9HEBXh7HJGE3X8yq0rWe/cUlXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRumS9T0R2askLMbhPsb/q0kx06x2w0I8bLhQEGcoz3u6/i5KMZzVSQDogUKppco7
	 biLcoFfuYt5lisTMXfa4WtM8VKp89afoAFKdlkNLN7BnALTXle20Y9hG47dAtZDQCw
	 /NzyN/CFkOwmCJob8f33iX2bYC3o7xdf0pjJHYEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f1faa20eec55e0c8644c@syzkaller.appspotmail.com,
	Immad Mir <mirimmad17@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/57] FS: JFS: Fix null-ptr-deref Read in txBegin
Date: Mon, 28 Aug 2023 12:12:29 +0200
Message-ID: <20230828101144.527030301@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101144.231099710@linuxfoundation.org>
References: <20230828101144.231099710@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Immad Mir <mirimmad17@gmail.com>

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
 fs/jfs/namei.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 56c3fcbfe80ed..6726dcddd6f86 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -813,6 +813,11 @@ static int jfs_link(struct dentry *old_dentry,
 	if (rc)
 		goto out;
 
+	if (isReadOnly(ip)) {
+		jfs_error(ip->i_sb, "read-only filesystem\n");
+		return -EROFS;
+	}
+
 	tid = txBegin(ip->i_sb, 0);
 
 	mutex_lock_nested(&JFS_IP(dir)->commit_mutex, COMMIT_MUTEX_PARENT);
-- 
2.40.1



