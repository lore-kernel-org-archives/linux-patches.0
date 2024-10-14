Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D06B49659;
	Mon, 14 Oct 2024 15:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919202; cv=none; b=qZ/hCDMyTJscKpsWpiHOhhfLjOll/MbFQuRA6aYoKH90bE9MZyBr9EjLkAdGpGRdEyzC1uQw29XF9Mz6UqnVwL/WgsND60UmhX1Xl9YFZhcA7efxb0Wd2qwlHyX4GJuRiWWFtE0DJEaH1A8mAZYuR2tzmSL8hfQXrcZ6/OoqCJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919202; c=relaxed/simple;
	bh=wwcixA0P/8naAN1y2B5m3j03+6MaQJnEagNOEm9jYUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCqGNzzw/cqWwZt0nIaZZ9TGTs6622H+9blXvAHe/FfUVisKHc1OhpKvq59IwIFa5CR5w4IVdcaNdMwCWRLxHG8gYHv6e5cCQzbsVnzBZ85q7eBioWUeCzrQldTSmOpq3yK4MA54oLL7q9lKBCwFml5ON75ctWb3sij771UdR/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KL1b7gti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KL1b7gti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0463EC4CEC3;
	Mon, 14 Oct 2024 15:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919202;
	bh=wwcixA0P/8naAN1y2B5m3j03+6MaQJnEagNOEm9jYUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KL1b7gtiGWUW8T1yNaHZvPw4aS0t5eOTtepgGZ9Xy8VnWNHz8A4rOe7kVhIwypBOE
	 0hjjh2zqf7rNDNTFo6xl0fOofEQXS826N1ewdKbQeP8kE7wDLXFQkYtcL3wdBGCdhZ
	 sKA4DSRbdSiQEWGgo6ZeFw/83KNx1xvQpn9sl+1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yao.ly" <yao.ly@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.1 542/798] ext4: correct encrypted dentry name hash when not casefolded
Date: Mon, 14 Oct 2024 16:18:16 +0200
Message-ID: <20241014141239.292669603@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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


