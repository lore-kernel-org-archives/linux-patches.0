Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3092035FC02;
	Tue, 26 Aug 2025 14:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219066; cv=none; b=u1pNOfKaf5rsVzBk722Pq/eMNU/2rBFUJeW/ZhCDls3GPXvZKWvKfyvW0okBXVPVtvTNPAz4F6XiQ9F/xgai7eX4/FwYCATfLaWdIykpj9uq6UCelL/5tC12/a+qZQHgv/t2WBkMPRApKiurCtfgpTDJTCYYXk6+OTaA6q9sUgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219066; c=relaxed/simple;
	bh=JQvkHuoba2uFdJHfc9wunRFkzOqKIucFd4eJ7InorP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDRIiuXL4y5K3/KVfLNnsC+OkjQL6zd96Z8IVjNMmpCS5mcyErzew2yCvR7OEBLTcsNfWCa9X8k+/MyARhkbtTj7j+VuaELNX3KX1gtvRhuwX8xuQLuPup7q9V/5XJa5zgezlXDmgfeZcxk3TfZBQRPoaW2mgaSLHpOVMyYRVSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdjkNTce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdjkNTce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B300C113CF;
	Tue, 26 Aug 2025 14:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219065;
	bh=JQvkHuoba2uFdJHfc9wunRFkzOqKIucFd4eJ7InorP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdjkNTce/cgHRdhozWTeNN7vDiWD3vVkBTr+kngL4bWYAtv1GMWWd7d5lUivV3dBr
	 ExVRibL+dcRwHfv1or7pfBML7+twxy7BjHogVreEElVZ3Lh8LHvaQZLj99TRjIXvSN
	 kcln2o/phLJqYu7jBHbVsQEc1CAcGF/iYWNv7uU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6e516bb515d93230bc7b@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 239/403] jfs: truncate good inode pages when hard link is 0
Date: Tue, 26 Aug 2025 13:09:25 +0200
Message-ID: <20250826110913.435366831@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit 2d91b3765cd05016335cd5df5e5c6a29708ec058 ]

The fileset value of the inode copy from the disk by the reproducer is
AGGR_RESERVED_I. When executing evict, its hard link number is 0, so its
inode pages are not truncated. This causes the bugon to be triggered when
executing clear_inode() because nrpages is greater than 0.

Reported-by: syzbot+6e516bb515d93230bc7b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6e516bb515d93230bc7b
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 62c4a5450cda..6d353fbe67c0 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -145,9 +145,9 @@ void jfs_evict_inode(struct inode *inode)
 	if (!inode->i_nlink && !is_bad_inode(inode)) {
 		dquot_initialize(inode);
 
+		truncate_inode_pages_final(&inode->i_data);
 		if (JFS_IP(inode)->fileset == FILESYSTEM_I) {
 			struct inode *ipimap = JFS_SBI(inode->i_sb)->ipimap;
-			truncate_inode_pages_final(&inode->i_data);
 
 			if (test_cflag(COMMIT_Freewmap, inode))
 				jfs_free_zero_link(inode);
-- 
2.39.5



