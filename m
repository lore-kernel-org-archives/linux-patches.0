Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216133;
	b=UMvDFasCecTgx0S+YbETj1bSPqxbMgTTvySy217gKFx6dic1Jroa/zvFlHUa7N7EVUEd
	 g8H4lAzNhDfjA4NzKwfvsBSSn2qyFIv/cg1SvnqnyZoEIZkrHaHore3DMvuy3HicBknqc
	 mJAMuPui2Z9Q0nhdvzO3SELr57BGKkAt8gwAzmPQgYdCQQIhd3YzQqaueamohrVgDevTq
	 70jqSHX7V/JoZYT6HFCiGqwNerEGPoys4YUW3qzCwyEtK1EQIn2sclqUKtcD3akRV8cPs
	 /ACFJE3erpews0kkFJM4F7iZGtMoQPuDvH7hUSyvAWzJiBniuTyIG8ymj2/O9PRHljg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rzKqH/vDfewRw9TcBbJTvI89wbSeKppj4H0Xtq7DPFY=;
	b=YWTkpwOlEHukbHbrF+xZY2CBUiWDl+p4cH40wHKtEI2/YxC26SBuDJ2xobjcaVKJAhu1
	 kssa9vLrHuhln9YLXJ5FPtLbyT6fEV8hiG3XrAJ1wfdBa7Usw4B0Ie+Tp1WmaCDgl8IAE
	 Q3JoZc2dBBklSsOKHh7DnkmKrJ1E8B6J8QgVb+rvjA/WCcDszwgU8eCmvjEwO9XwyB8Vd
	 9nTr4+OfbsrzRJ0Hgd2D+T37To7LMpHp6RSHRQPW8Va95gfxm6eGOIYKQ1FpC+vOZJRWu
	 rS4OqajkGmFQrQZuOlpaYrpoJvNPrqwFQqFpo3yxeTYF2sIdEWLzq4EH0fBHLC6GJCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lk8l2xSB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8388A606A31E;
	Wed, 28 Oct 2026 19:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lk8l2xSB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45C01F01825;
	Wed, 28 Oct 2026 19:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216133;
	bh=rzKqH/vDfewRw9TcBbJTvI89wbSeKppj4H0Xtq7DPFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lk8l2xSB7qOGKis017EaTwJ0imXx8jNAeW6Tu8yDZBJo01QMAQrsSeNJMoNrj+jt3
	 hLqpZ37QCWbix7fr/VZNh+9rgj2f/2Im04zsK5LzsOl0j7+rflBgWViVIALbmpADYG
	 IZLUo6C/lbWXzqu2E4BHBp1ZO9k7cQVexKq93Ujg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1415/1887] ext2: Fix lost inode updates for IS_SYNC inodes
Date: Wed, 28 Oct 2026 17:58:31 +0100
Message-ID: <20261028170531.657544903@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 356984d1a5c32e94810cbb6c8dc7d8ff2d4d919a ]

ext2_setsize() and ext2_xattr_set2() had a construct like:

	if (IS_SYNC(inode)) {
		sync_inode_metadata(inode, 1);
	} else {
		mark_inode_dirty(inode);
	}

which leads to lost inode updates for IS_SYNC inodes because
sync_inode_metadata() does anything only if the inode is already dirty
and hence inode updates may be simply lost. Fix the problem by
unconditionally marking the inode dirty and *then* call
sync_inode_metadata().

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260727104923.3828017-26-jack@suse.cz
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/inode.c | 3 +--
 fs/ext2/xattr.c | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index e5362c376a7a5..bae9d58976960 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1289,11 +1289,10 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 	filemap_invalidate_unlock(inode->i_mapping);
 
 	inode->i_mtime = inode->i_ctime = current_time(inode);
+	mark_inode_dirty(inode);
 	if (inode_needs_sync(inode)) {
 		sync_mapping_buffers(inode->i_mapping);
 		sync_inode_metadata(inode, 1);
-	} else {
-		mark_inode_dirty(inode);
 	}
 
 	return 0;
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 2f89b1073307b..fd06fb19528fc 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -776,6 +776,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 	/* Update the inode. */
 	EXT2_I(inode)->i_file_acl = new_bh ? new_bh->b_blocknr : 0;
 	inode->i_ctime = current_time(inode);
+	mark_inode_dirty(inode);
 	if (IS_SYNC(inode)) {
 		error = sync_inode_metadata(inode, 1);
 		/* In case sync failed due to ENOSPC the inode was actually
@@ -788,8 +789,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 			}
 			goto cleanup;
 		}
-	} else
-		mark_inode_dirty(inode);
+	}
 
 	error = 0;
 	if (old_bh && old_bh != new_bh) {
-- 
2.53.0



