Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EE2145FE5;
	Thu, 13 Jun 2024 11:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279929; cv=none; b=ibsgvh0IXKtAj0DN7itmQ13gbWr6MNE7aCvhkRxO8dJsRoJlkrM9JbkEFa/eRgkNl/7RPZo6EQrvMv+izGRpya3Hs/9lH8l2P/qWZFFRPwB1pYli/7biTHQ3fzWfQ9BCaFEaR44mkU9u9GdgGu4bUKkV5PTd7mxZ+WTgcROXQ0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279929; c=relaxed/simple;
	bh=cH6gibQKvEcmB2/Cq6C2Ul+G9AuGlo3b9FnxE8K71Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQbsaHGH0eKybueM0qDBYvQrd65dhR6QUfVB5y2E4FJwLc6SPIvWEX2W4lj3XbLWF+VmDZEYmQ20BV5ABA8rA+OQlVL8zhG6ZAWXTG4RZPIu028tXTBLYJRbKslaIb++Lgib69C+MovZ8kOlMeXOzMHliCeYO/dKoocNAtsc3UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWpFEMKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWpFEMKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C8CC2BBFC;
	Thu, 13 Jun 2024 11:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279929;
	bh=cH6gibQKvEcmB2/Cq6C2Ul+G9AuGlo3b9FnxE8K71Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWpFEMKDVkxFkBghbjzHW/ONj/xK31FbVDBo3QY0orGev3zrR93iHtLExRJxSYntH
	 osQ5DEt+hKKJiPaRKX0s5IdDS33v2b7N1rpC2Nwg9Bu734eto3c/RJtv4FE28s+RmM
	 JeCaFihRcn+/JuH63oLP5LyjeO03hIlrJJtoSYdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Luis Henriques <lhenriques@suse.de>,
	Disha Goel <disgoel@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/202] ext4: avoid excessive credit estimate in ext4_tmpfile()
Date: Thu, 13 Jun 2024 13:33:01 +0200
Message-ID: <20240613113230.976035147@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 35a1f12f0ca857fee1d7a04ef52cbd5f1f84de13 ]

A user with minimum journal size (1024 blocks these days) complained
about the following error triggered by generic/697 test in
ext4_tmpfile():

run fstests generic/697 at 2024-02-28 05:34:46
JBD2: vfstest wants too many credits credits:260 rsv_credits:0 max:256
EXT4-fs error (device loop0) in __ext4_new_inode:1083: error 28

Indeed the credit estimate in ext4_tmpfile() is huge.
EXT4_MAXQUOTAS_INIT_BLOCKS() is 219, then 10 credits from ext4_tmpfile()
itself and then ext4_xattr_credits_for_new_inode() adds more credits
needed for security attributes and ACLs. Now the
EXT4_MAXQUOTAS_INIT_BLOCKS() is in fact unnecessary because we've
already initialized quotas with dquot_init() shortly before and so
EXT4_MAXQUOTAS_TRANS_BLOCKS() is enough (which boils down to 3 credits).

Fixes: af51a2ac36d1 ("ext4: ->tmpfile() support")
Signed-off-by: Jan Kara <jack@suse.cz>
Tested-by: Luis Henriques <lhenriques@suse.de>
Tested-by: Disha Goel <disgoel@linux.ibm.com>
Link: https://lore.kernel.org/r/20240307115320.28949-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 87c6d619a564b..71e67ad3af02d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2723,7 +2723,7 @@ static int ext4_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	inode = ext4_new_inode_start_handle(dir, mode,
 					    NULL, 0, NULL,
 					    EXT4_HT_DIR,
-			EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb) +
+			EXT4_MAXQUOTAS_TRANS_BLOCKS(dir->i_sb) +
 			  4 + EXT4_XATTR_TRANS_BLOCKS);
 	handle = ext4_journal_current_handle();
 	err = PTR_ERR(inode);
-- 
2.43.0



