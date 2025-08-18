Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4C731E117;
	Mon, 18 Aug 2025 13:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522468; cv=none; b=sL7lVlLr8IKVYyIqZFbUVbt2qRzIKt5H+cn6PJWUFqTOvL8RanLhO5qbiZ5H4GF3+GXuTacoE+6tpdknjeQoba+Q8Zxyjlz9FnQWBwvZzpUjO2Fr+exMmepVIEPkSjImS/+RY0rbl7uZORSrql/md6d7VMxPNtuKkxTaH2tsDiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522468; c=relaxed/simple;
	bh=Ge8VfWk94QfeGZ5Tkg/K0eUnib/yN2pwnFMVwZdqer8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNYan1DuusIrNBMstYoPbSuvmQZ9z8sGyp47lIA+3jrzD3n1f/5keiPW7RBAalSbz2bDMEPAt79mr8V0QCysXNtdbQNu/y4DlNhZkzV6Rud3jMFU2u0ybnQudZhJ6UuNJUBZmVcVSIbZIiGKm2KVkTEXv0lGVRdcjk6o4LIhLQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkfPIn+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkfPIn+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD60AC4CEEB;
	Mon, 18 Aug 2025 13:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522468;
	bh=Ge8VfWk94QfeGZ5Tkg/K0eUnib/yN2pwnFMVwZdqer8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkfPIn+9KT7p5bcoG0CmCLB+xsVTPYmYrZ818XgnRWXaoGPkMLVx0hUu2fttylCq5
	 HlLv/fw76/2K7n8tDOsM7mqX3M3FGN4xEJLvX+PxkzKkgD+86nzqwQZ5XtAHjkVeGd
	 HkFoWoQ/3qO1wat5NETMb0YZFm/GYA4NBD8j2TsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6e516bb515d93230bc7b@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 292/444] jfs: truncate good inode pages when hard link is 0
Date: Mon, 18 Aug 2025 14:45:18 +0200
Message-ID: <20250818124459.905104660@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 07cfdc440596..5fe8cb4742c2 100644
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



