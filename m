Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F254CDDDA;
	Thu, 17 Sep 2026 15:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658886; cv=none; b=krwCkQdXWgY/To7IqveSI9VX3oq2+qTIshIkuUYF3DUTB99/oE5v2MAcu6p+bYoCJJNJkfxqcwxv0nSFUwFMWF8HOTlhGqYq2KIwYuP1bdp/UVkDkQCxyL2kiWg1K4VIEZqH/1akiuDhRlmpDLrc9k1dmWXUfCDBetE3DnbP0wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658886; c=relaxed/simple;
	bh=n+7TnzJt7z3+gpMeGZd/Nry0q/NOrNHSWOrTXaDW/o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahFDuMb6YBjw/WUHb9C0ScST5QPnbb2ixaebwruXf1RIK/yupvMIDbACdJWjwiQ0mtBehmLKrRlC3NFdnmRF5uwaD63V+owyEHLhMlF4KeL2cTPrPlV71nGq+q8NAWjYkSpzYHC/yH/Mn9adHyQSoIou+kwdaVSghRqz/z3sCJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzhj0PIY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzhj0PIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3EC1F00898;
	Thu, 17 Sep 2026 15:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658877;
	bh=O/ZQnt6eSLhf8h/z6Mz/P/Ih+yyBFL37uSHC/KkfH1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nzhj0PIY8RBkkYPzpAxsmv5vyYkQcoYQRjch5gD/KYA50ULYtzh2WB1d02SHosZ1F
	 7emUHSDc059aGaT4Bctv3heQQMmFiQHhBvAU0G0TNbA+KNuq78CJ5KdFfNjYjQ+gBD
	 KhqawPWulYHHLCl+Ow34Jx6CT7lNHIE0vvfkExmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 068/733] smb/client: fix integer truncation in collapse range
Date: Thu, 17 Sep 2026 16:06:16 +0100
Message-ID: <20260917151352.544899741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit 7811701d6af7db76481a82b9bc3c4adf7863acf5 ]

smb3_collapse_range() stores the ssize_t return value of
smb2_copychunk_range() in an int. A successful copy larger than
INT_MAX is truncated to a negative value and treated as an error.

Reproducer:

	MNT=/mnt/scratch

	truncate -s 2056M "$MNT/file"
	fallocate --collapse-range -o 1M -l 1M "$MNT/file"

Fix this by using __smb2_copychunk_range(), which reports success as
zero instead of returning the copied byte count.

Before this change, the reproducer fails with:

	fallocate: fallocate failed: Success

and the file size remains unchanged at 2056 MiB. After this change, the
reproducer succeeds and the file size becomes the expected 2055 MiB.

Fixes: 5476b5dd82c8 ("cifs: add support for FALLOC_FL_COLLAPSE_RANGE")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index d113e28b5c3b7..ae4e855f80500 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4033,8 +4033,8 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 	spin_unlock(&inode->i_lock);
 	netfs_wait_for_outstanding_io(inode);
 
-	rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
-				  old_eof - off - len, off);
+	rc = __smb2_copychunk_range(xid, cfile, cfile, off + len,
+				    old_eof - off - len, off);
 	if (rc < 0)
 		goto out_2;
 
-- 
2.53.0



