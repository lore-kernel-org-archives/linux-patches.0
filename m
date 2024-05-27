Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BF617E90E;
	Mon, 27 May 2024 19:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837285; cv=none; b=S2rHR7KPxGZirbW/BKzqi9ODdCCCb1qnu1ZvmUNZtJXQ5mAk2hM3ZSvu/ULnPXXuyGV7eqYSh410lf/zjsH7UHzl382FxKv1gvZc9zwo50/JWHTTGx/oSOlW54Fv9g5keTDxnsavAY37e7DVNJLkjuMN1D0Bg7IsmZDDhmRWi0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837285; c=relaxed/simple;
	bh=eliin5crgdEefAJAj+o36XzFiZLHjR79LzkR4nTaRQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAwI7ufbzgwpCki//e6hwi5LKvHxaBKM87iDtGobo1YZ4sUAPXE5YTym3qVHeDqfyYnX7548f6mXF9K7BNGQE9zXqz0nNO4XQhHpiZADTYNDfs60uz1UlVcjQMtHLiZ9NrkBAlZiZH8XJgBjK4QYkY5lWyllF6vvnBVeXMwdS1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvfmSxh9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvfmSxh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C3EC2BBFC;
	Mon, 27 May 2024 19:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837285;
	bh=eliin5crgdEefAJAj+o36XzFiZLHjR79LzkR4nTaRQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvfmSxh9LekFytvZ1rFXB/GTEH5SPNpnOnohYPIJCVvkRlBRFA3JUCeYvGAbz0raf
	 Up9is9YOtu3/m/uyJRWWJSCTAFYBrRoxnOetWK8/XQyJaI9mBr14XVuZNEvph6HhF5
	 3GJ/NyLdR/dFyDr31lw7spxACX4piqRom85360dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Luis Henriques <lhenriques@suse.de>,
	Disha Goel <disgoel@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 382/427] ext4: avoid excessive credit estimate in ext4_tmpfile()
Date: Mon, 27 May 2024 20:57:09 +0200
Message-ID: <20240527185634.547706896@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 5e4f65c14dfb9..a630b27a4cc6e 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2897,7 +2897,7 @@ static int ext4_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
 	inode = ext4_new_inode_start_handle(idmap, dir, mode,
 					    NULL, 0, NULL,
 					    EXT4_HT_DIR,
-			EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb) +
+			EXT4_MAXQUOTAS_TRANS_BLOCKS(dir->i_sb) +
 			  4 + EXT4_XATTR_TRANS_BLOCKS);
 	handle = ext4_journal_current_handle();
 	err = PTR_ERR(inode);
-- 
2.43.0



