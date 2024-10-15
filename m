Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25461EABD1;
	Tue, 15 Oct 2024 12:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993751; cv=none; b=jq9lJT/UzgPi0Xu0wnE/D8JbrA+r9/vTcf0PUo3ELMu4XmEN4rG5BmHkQwePZstWdn37XdBeywGDI5ReOBbFyUm7I8kGILItIMl5gMlGWYHjiW61ejHgDP7fBu1RmBT/5jFUL2C7nbqxSds3qxgQwQCUS+/hQRsRkc7hPvSnPjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993751; c=relaxed/simple;
	bh=uayjGSyPE1UJydSkjd3bUC6WkSaKUYu9BPb9XbgaehY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNp+YS2RdibCJVZBdVUYU0mlvq6WInnD5WUXXSIMMoPD1oHbQnAF00evrZTmluacc1WP1WrXAx2rGEvtBfaQz42XPqo8U31XnQ2Be6An69Uzr6IxzGtX+7f5jpFwF3U3jtlWTG8Af2lz/uESVPrOGmCXGksctRtlJb7ZVrhEvAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BP054+mt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BP054+mt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61490C4CEC6;
	Tue, 15 Oct 2024 12:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993750;
	bh=uayjGSyPE1UJydSkjd3bUC6WkSaKUYu9BPb9XbgaehY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BP054+mt379LkZDNuWcqgZBwvLPIyNb11GYMjW6+RTnYZtgdN//5aKSjNNw4/+wLB
	 HHEQgA+OiiwtKjK2M7Z1gxEc3iZndLf6D27SyhaXEm0pMra9pJff4wNAodrTFTsGD1
	 Y4z5pg3Cs3Nv9WRXdXqXQ2/hAuShq5aOGy5PQEH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yao.ly" <yao.ly@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.15 504/691] ext4: correct encrypted dentry name hash when not casefolded
Date: Tue, 15 Oct 2024 13:27:32 +0200
Message-ID: <20241015112500.346883054@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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


