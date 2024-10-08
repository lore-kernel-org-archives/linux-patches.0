Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CB71DF24B;
	Tue,  8 Oct 2024 13:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392428; cv=none; b=sA5dJCiBknutuUKzMxhkXrfZe69mxLjWv2a3vEkoZGE81hsC4vILoi8PpxmMq3HGml05FQsjl+vjqbs0tQnQV2xVJd+N6NxE1+iGWG1I/CH66XDmGJYP1UOaq3cXPuT+DiydpH2F1E2+nDx3yN2+dU3wi1+pVr+gv5CjXRsTQzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392428; c=relaxed/simple;
	bh=S1EDAclqtgrnUijiYl0KOxMjYbCgcNOAMjRmQRxJ0lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ov5Vh5XsUzDEAiYIxcIBL9QEHCbw15HM9uPpcHm3BQKAxvZOsRWODHxebUdGRnbmvRLxoAcfjEwV99rJEgHqZ4gIjGhrUEjzkP/et14gylloLIIimzgC4VepHM6dunznm6jSvnXkiExSYfxJH36LHdCHtRr618jvIWXHoid1W8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUWrqvsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUWrqvsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF923C4CECC;
	Tue,  8 Oct 2024 13:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392428;
	bh=S1EDAclqtgrnUijiYl0KOxMjYbCgcNOAMjRmQRxJ0lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUWrqvsMpl76j8wzxDJPEFArH3SqmcKGIL2nrdEp+Scuax4UzLvafb0gkaqmi8TJx
	 YnYn1Js1UjeyGR/7I1PnRRb7yGnqh0aiSE/ajKE5aAnYUS3x5iPeDUIvBAO0ae6izS
	 xuGbiKcAV9IWMFn/3CqwyYprvyHGvPm00Gu5GjAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yao.ly" <yao.ly@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.11 381/558] ext4: correct encrypted dentry name hash when not casefolded
Date: Tue,  8 Oct 2024 14:06:51 +0200
Message-ID: <20241008115717.282173679@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


