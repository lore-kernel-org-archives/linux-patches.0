Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0043A1DFE39;
	Tue,  8 Oct 2024 13:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393815; cv=none; b=AwX7NJNSv53FyF+wbeiZHJPmBt3+I9lyUxvmPorKHLLKKiSBewPLb0/AQm1mx9+znO9rd8dfM/wQ0ZATeLHOx135EiaiNMYK7o43CqDZ/stcCsFqhEKsGiRdZO8UPjSlYOjFFBvl4PkgD5bqj1LiJgtzetuKkTtm/cxuVwFE5Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393815; c=relaxed/simple;
	bh=Rs7zLp7q9Ti5ZDvMclbIGGzseIbhNhOwVAtt+mi2tyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2hAAhFtGzoyv+skYefraLqxzbDeArez2UH+41NjdOS1D92827TxSpqx4TMfdv9aBq+qHTzlnDII758j/W+3oq+OX7x8orTdn1ZXrclDpBFpRApISSJTJDJH5831o7CtCt0q9TuDSkl80NPRQruzMSY5gQ/uMHALnB9IqNGhmb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1OFZPCZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1OFZPCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442A0C4CECD;
	Tue,  8 Oct 2024 13:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393814;
	bh=Rs7zLp7q9Ti5ZDvMclbIGGzseIbhNhOwVAtt+mi2tyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1OFZPCZ/yKscOdq2adBYjcsmiVp10PUgIhxf0JgOEaFlkt6eaTyUcYC9PVKAT3nh
	 BCvgaCe4EVQXrEOp7caCRKB96ry7VvGKTa4YS7ux8kvlNBJYsIjynG8uVMQhv89anV
	 1TMLTl2RbU1KZsEfoqJbNCwQ9gz9xSmoDUjs41hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yao.ly" <yao.ly@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 232/386] ext4: correct encrypted dentry name hash when not casefolded
Date: Tue,  8 Oct 2024 14:07:57 +0200
Message-ID: <20241008115638.532402649@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yao.ly <yao.ly@linux.alibaba.com>

commit 70dd7b573afeba9b8f8a33f2ae1e4a9a2ec8c1ec upstream.

EXT4_DIRENT_HASH and EXT4_DIRENT_MINOR_HASH will access struct
ext4_dir_entry_hash followed ext4_dir_entry. But there is no ext4_dir_entry_hash
followed when inode is encrypted and not casefolded

Signed-off-by: yao.ly <yao.ly@linux.alibaba.com>
Link: https://patch.msgid.link/1719816219-128287-1-git-send-email-yao.ly@linux.alibaba.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/dir.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -279,12 +279,20 @@ static int ext4_readdir(struct file *fil
 					struct fscrypt_str de_name =
 							FSTR_INIT(de->name,
 								de->name_len);
+					u32 hash;
+					u32 minor_hash;
+
+					if (IS_CASEFOLDED(inode)) {
+						hash = EXT4_DIRENT_HASH(de);
+						minor_hash = EXT4_DIRENT_MINOR_HASH(de);
+					} else {
+						hash = 0;
+						minor_hash = 0;
+					}
 
 					/* Directory is encrypted */
 					err = fscrypt_fname_disk_to_usr(inode,
-						EXT4_DIRENT_HASH(de),
-						EXT4_DIRENT_MINOR_HASH(de),
-						&de_name, &fstr);
+						hash, minor_hash, &de_name, &fstr);
 					de_name = fstr;
 					fstr.len = save_len;
 					if (err)


