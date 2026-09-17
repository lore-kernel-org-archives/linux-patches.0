Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FF74B44CD;
	Thu, 17 Sep 2026 15:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658879; cv=none; b=WkZtm7ILPRyicLqSUB9FaPyiePvkvaD4SNbS0Ulxk2Pe4jeAKJvsxUrQ+t6bAzvIQePnqN9mTNsVSehcoIFocHInsWJ2dUb/RARx6fLK6C8jcFv9gAoqiyvDPgXtUoL1K93Ne1mrtav7N60p+r7ZIS4GNjRuzK89pCkf4FAPiIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658879; c=relaxed/simple;
	bh=DNWczy1GQ42LIjaEJK0SpOplSdZDpf77ojZeK80Ft2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9IgLKgAXykEistwWj3tX7qgeZTdAwNX/zAY9hI/AMXDPsz3+RZEFynlgxRt6S0t+mYb1qJAw2xI4iHZPJBp90tM3W6ErmIoxWbnpbubJ+0utHjrx5AJJXVIC9IXlZhE3vImFtQjLPCfcYGFDbjjWhzKwu/6Hte7jqGV0IBe+Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KyQ34gTv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KyQ34gTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38E81F00899;
	Thu, 17 Sep 2026 15:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658871;
	bh=zVR50E6rs05Vb30+Hdxc8zdH6tYPF4SJWMuD5TO7SKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KyQ34gTvkjcDInK2gFvr8VolfSpvOz89BP/JpyW/lK6vfhFRGjOv1TsBkIcbbIB2h
	 fkAbCsNrNiXJUzC55zAZxxYj2/oUSHLImV36cHRomFVkopWuxGEfjV1IjMOR2doSBQ
	 jf6jORORG7rcxUAN3cf7PZpjpgwdcXpR8wIDqozo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 066/733] smb/client: mark file sparse before emulating insert range
Date: Thu, 17 Sep 2026 16:06:14 +0100
Message-ID: <20260917151352.485533461@linuxfoundation.org>
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

[ Upstream commit cd03ce4950d80147ac8f20bc03c42b75b0352407 ]

The SMB client emulates FALLOC_FL_INSERT_RANGE with SET_EOF, COPYCHUNK
and SET_ZERO_DATA.

SET_ZERO_DATA creates a hole only when the file is sparse. On a
non-sparse file, it clears the inserted range but leaves its blocks
allocated, causing the extent count check in xfstests generic/064 to
fail.

Fix this by marking the file sparse before modifying it.

This patch produces the expected sparse extents in xfstests generic/064
only when the server-reported block size is compatible with the server's
deallocation granularity.

For ksmbd, the reported block size follows the backing filesystem,
and the test passes. For Samba, the test passes with a block size
matching the backend granularity, for example, 4 KiB on Btrfs, but not
with the default 1 KiB value. For Windows Server 2022, 4 KiB inserts do
not generate holes, while aligned inserts of 64 KiB or larger do.

Fixes: 7fe6fe95b936 ("cifs: add FALLOC_FL_INSERT_RANGE support")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 3b96dc3615ab4..a2fe71df2d4fb 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4010,6 +4010,11 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 
 	count = old_eof - off;
 
+	/* SET_ZERO_DATA creates a hole only in a sparse file. */
+	rc = smb2_set_sparse(xid, tcon, cfile, inode, true);
+	if (rc)
+		goto out;
+
 	filemap_invalidate_lock(inode->i_mapping);
 	rc = filemap_write_and_wait_range(inode->i_mapping, off, new_eof - 1);
 	if (rc < 0)
-- 
2.53.0



