Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E811B1420;
	Thu,  6 Jun 2024 14:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683373; cv=none; b=oY+ubfQCoF1TSnA7/xdaFtSQQSjpsZx7+6pLcaS6VjYte4/I4QZP+UHsCgTRyFAh/XVJ18aa7cpRFpDxRMsWABa2jopKI2S1WbAlV7TK1+/9wa8hRJ3lbr+KJrMUQaSXf7YptSI/mSb9DbwVkihzyAaQOLSknQ5ZlG9pfgWdW+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683373; c=relaxed/simple;
	bh=7BWJQge+IdgB+1SV2kpMyXdefkirL/OzbDDx2zNnIL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OdtV2yWWt+SMshzco82izaK6dKFQ70lbjpbxX0fqWa0wUHaSCHWe++efl91ylOliAegsVBiZGigVFYHUNYQYvEd3FY1t6owuQAz08kL8JTjN6kliAh1qg+lpycibO7geZs+MUin9IBgEQiRqq+RD0B7x+HssmWQ5R60WwWYZ2jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDpnhHtB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDpnhHtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52ECFC32781;
	Thu,  6 Jun 2024 14:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683373;
	bh=7BWJQge+IdgB+1SV2kpMyXdefkirL/OzbDDx2zNnIL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDpnhHtBBdvmvFkGdGchR8XOs2PgCiURPRnyRS1OrN5x/ZE3q7/Oogh89vuS4NnOi
	 dADjV3xzogzf5eSYyuotTkHCMLtWy0d9BxIhHmvXL+muhhL2Tmxllq/xYX6JqHejTP
	 cG+3Y0wgWQIWdM/ZgVpKRA5ZtxhrqTXheMHGjgtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Luis Henriques <lhenriques@suse.de>,
	Disha Goel <disgoel@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 257/473] ext4: avoid excessive credit estimate in ext4_tmpfile()
Date: Thu,  6 Jun 2024 16:03:06 +0200
Message-ID: <20240606131708.463188884@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bbfb37390723c..8b13832238484 100644
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



