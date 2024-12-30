Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F83715E8B;
	Mon, 30 Dec 2024 15:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574250; cv=none; b=s6p3Wry+pxHRlEj+CJixrrKb/yfyY2zASsT663bPSyJ5nGtj0gi4GWTaD/UslnHA/PVE25PqxVCpgZ2fYewytvhlUOuPHhVCDJxjNmNfNBiUgkDgOmsbeqHIf+jAtUrc0OKzLFmUi4T3QOGG24emWUBr/8cuID0ufvLrmffd/iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574250; c=relaxed/simple;
	bh=OOsN5NxbPlUyV65cie+jQ+cp1ILpMA8BDFOEneHAbeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulCg3/+GoLqefNjWWA0airPK1he+m8QAWX8LYhTA43wH12egC8wSIDMqUWuzowCfbM/ypLsn62Ysnpa40d+G17DBQR+5bdQZ0oPMoOuiJO354USyu4NTdGSncJG4EOzhOKK79DEne3Zi+bI1N2ENqmCk4u2T7TTTK/jQ2/QX4wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mt20f953; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mt20f953"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F4DC4CED0;
	Mon, 30 Dec 2024 15:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574249;
	bh=OOsN5NxbPlUyV65cie+jQ+cp1ILpMA8BDFOEneHAbeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mt20f9537U+bp66HsQ7WrN44ZXyHxpTSEC2+f87+uR11OGB+reZSyEIzSvkqMljq0
	 omvnZBOSsvbvfDIHi4grvHHud3w3og5cSAHNzPH9Lg1exT+BoQ59lnvjhwivr/gdjI
	 14Yu/PYvO03IaO3qD1O0K9K4VcTO6or0tSceymnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3ff7365dc04a6bcafa66@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/114] udf: Verify inode link counts before performing rename
Date: Mon, 30 Dec 2024 16:42:50 +0100
Message-ID: <20241230154220.113562460@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 6756af923e06aa33ad8894aaecbf9060953ba00f ]

During rename, we are updating link counts of various inodes either when
rename deletes target or when moving directory across directories.
Verify involved link counts are sane so that we don't trip warnings in
VFS.

Reported-by: syzbot+3ff7365dc04a6bcafa66@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/namei.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 2be775d30ac1..2cb49b6b0716 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -791,8 +791,18 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 			retval = -ENOTEMPTY;
 			if (!empty_dir(new_inode))
 				goto out_oiter;
+			retval = -EFSCORRUPTED;
+			if (new_inode->i_nlink != 2)
+				goto out_oiter;
 		}
+		retval = -EFSCORRUPTED;
+		if (old_dir->i_nlink < 3)
+			goto out_oiter;
 		is_dir = true;
+	} else if (new_inode) {
+		retval = -EFSCORRUPTED;
+		if (new_inode->i_nlink < 1)
+			goto out_oiter;
 	}
 	if (is_dir && old_dir != new_dir) {
 		retval = udf_fiiter_find_entry(old_inode, &dotdot_name,
-- 
2.39.5



