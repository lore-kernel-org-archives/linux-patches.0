Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8353481CD;
	Tue, 26 Aug 2025 14:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217852; cv=none; b=sUF+52jJZ+XsyHKC91jeR9HhE3H6VsEpPiCGwYpl8SCh3X4Wru4UIF7aZKy1XY4HTg26ttyfkDACYW5zNWcw224FijQ++iHcJbfPjkR+O3mmncnYOB+3GbVMq1o0ZN58YP+oJIFxQSpxesh5Tem/R5zDimk5KqYmyIXwWure2F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217852; c=relaxed/simple;
	bh=7pGwjk6C7AJo/suB88KE4xommi2UEEFgrr8args7egg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzifydF7xBaExpWnfO3u0q+tlykPndehEsMyXei1EHgE+oDUpFluu1N22jGMkeH185vpn2Ur4cKEvzuksJ/Ml152RGXtDiQ4Q43gWfzmqQK+u93vCQrxnUDRwF+TlS+ceU9P7cu8FM62xhJZm6SmOo/7/N2SgTd6n3pIIWmtB10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ghxs+Wib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ghxs+Wib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588BEC4CEF1;
	Tue, 26 Aug 2025 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217852;
	bh=7pGwjk6C7AJo/suB88KE4xommi2UEEFgrr8args7egg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ghxs+WibIJGJM1td5gW9WEFrC0tCsW+0TVGKsUxh6Tz5zhg1R6HcRAI77N+kHv1pC
	 XaOoL691gJgup3uRZGmB6V0epVJ7GiqBKqQUZ6HF99RmqiSQ5f21jvqz3Le9xVl8Ug
	 TOqAPg1pOHZ0bfgLmcSDbo2UCKIkjGwoC4JX9dQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6e516bb515d93230bc7b@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 298/523] jfs: truncate good inode pages when hard link is 0
Date: Tue, 26 Aug 2025 13:08:28 +0200
Message-ID: <20250826110931.801504202@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 980aa3300f10..2472b33e3a2d 100644
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



