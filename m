Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A283C24;
	Thu, 13 Jun 2024 12:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282173; cv=none; b=AmAC8fKSfIJfH227e++rcx/KACSNMs9Pg8B0ZRZKqs6uZq1+915O1q9WgyyUbfytEA/d4ekbfEQWJBMCfG+uJPti37y5ALjbX3v47tm5fr6SIlYmiUPy7X0x6p147Z26cCEnq44zPRUh5o9S+aIgpeTyz0vgxcvmKLfv8gFGIRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282173; c=relaxed/simple;
	bh=3iQ1Inj7Mc6jqAXtuDwFqhRqwpqziT0fx95lII4C/PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R36k9nqCTESuOXM7ptMVgQaLjgJtKZTziGfK1uRFD5U1/tvIf/XzKU7ojrbchnzhHjBp9lpeIMOeNmLj+b4TVyx87fyTIkPcbq9yR3XjrMgd+LpsVyyXOjODhLtXULzFwz/MS9KRA1E4Ejz0s67i70ms5MdczLFRkhYWDsSxCPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnyBmB0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnyBmB0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AC0C2BBFC;
	Thu, 13 Jun 2024 12:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282173;
	bh=3iQ1Inj7Mc6jqAXtuDwFqhRqwpqziT0fx95lII4C/PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnyBmB0B0WjVMwJEKn/faSyP4gOKswBECeo9rKsPQiTrqRMoHE3k0vDJQipDxEWan
	 rLiUqqo3s5WMoBAsiGe+kmvI2c4O11Oer9vPJTVsLHIAUlTmUxL0lWJCJV0CUPhNe/
	 BTparvB9oOqeK3Dlu+uXJTwshH6UnrvgcbzguN6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Luis Henriques <lhenriques@suse.de>,
	Disha Goel <disgoel@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/402] ext4: avoid excessive credit estimate in ext4_tmpfile()
Date: Thu, 13 Jun 2024 13:31:54 +0200
Message-ID: <20240613113308.257815194@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 14c977e1e4bba..e9501fb28477b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2901,7 +2901,7 @@ static int ext4_tmpfile(struct user_namespace *mnt_userns, struct inode *dir,
 	inode = ext4_new_inode_start_handle(mnt_userns, dir, mode,
 					    NULL, 0, NULL,
 					    EXT4_HT_DIR,
-			EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb) +
+			EXT4_MAXQUOTAS_TRANS_BLOCKS(dir->i_sb) +
 			  4 + EXT4_XATTR_TRANS_BLOCKS);
 	handle = ext4_journal_current_handle();
 	err = PTR_ERR(inode);
-- 
2.43.0



