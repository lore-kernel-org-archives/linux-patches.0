Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74651DFDA4;
	Tue,  8 Oct 2024 13:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394230; cv=none; b=RdvLhxAdA+s3LbLz4twyibU0UFZwg5gl4qlDMBS+RfOMfMmYEXbmnyiGpgRp7Cs+sa7zrdOBCZvAreHXKbor977zHUwkm3eKlWAEBFOCcMJ8v3v4EA5J99rJTn2lL+twXJzqvx4KgK3w4KY9FWAePgcE8OzlUVrr5TFSheMrXDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394230; c=relaxed/simple;
	bh=AxQBGfthgjV8dt2VhUzOXoeBWaX1JROEVZhN32Rb2y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gF6aCr2HwNdOPRsgugyoHKTgnqpw/4TFcvstWW8lKFAtRV5/WhJAycKetn8+DYq+xEjWeTQZBz9swmc8VIaZbRdfZ0Al3mFKiT9sHLVw2sjG+8vAv0N1E7cvZqsMAs2Ro9oSKqiLicn6jrNUellzT7yGu4gylFBTJybLwFFH4V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDkNrV8b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDkNrV8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33710C4CECD;
	Tue,  8 Oct 2024 13:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394230;
	bh=AxQBGfthgjV8dt2VhUzOXoeBWaX1JROEVZhN32Rb2y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDkNrV8bVsSIGbykmels7Hziu8izdmDP9vMWSaE7QSIBr0y+2giXtzF9ja4qb3lO7
	 kyNFsBeo5GopQvyAcnF/kM3W/8T8v27dPBBhtqtrREcwvffMpFgnv2eZYzKuO+51FL
	 WCTUqOPlPccaTPMk50Y4q5gpgfayqrMtjvoSDK2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.6 386/386] Revert "ubifs: ubifs_symlink: Fix memleak of inode->i_link in error path"
Date: Tue,  8 Oct 2024 14:10:31 +0200
Message-ID: <20241008115644.581463296@linuxfoundation.org>
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 7bed61a1cf166b5c113047fc8f60ff22dcb04893 upstream.

This reverts commit 6379b44cdcd67f5f5d986b73953e99700591edfa. Commit
1e022216dcd2 ("ubifs: ubifs_symlink: Fix memleak of inode->i_link in
error path") is applied again in commit 6379b44cdcd6 ("ubifs:
ubifs_symlink: Fix memleak of inode->i_link in error path"), which
changed ubifs_mknod (It won't become a real problem). Just revert it.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/dir.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1126,8 +1126,6 @@ out_cancel:
 	dir_ui->ui_size = dir->i_size;
 	mutex_unlock(&dir_ui->ui_mutex);
 out_inode:
-	/* Free inode->i_link before inode is marked as bad. */
-	fscrypt_free_inode(inode);
 	make_bad_inode(inode);
 	iput(inode);
 out_fname:


