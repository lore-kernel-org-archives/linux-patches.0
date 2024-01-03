Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77371BDEC;
	Wed,  3 Jan 2024 16:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxKrQ2H7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B20CC433CA;
	Wed,  3 Jan 2024 16:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301027;
	bh=7w1iaCxSUxcAUZn1V9MRCC2WD3aj48cTTO3wf85P9FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxKrQ2H7rsKO2qKIutdYoBAXWEWwWT1lsbEaLetClwl2ZTIAiFpIX7K1KCxIqbcT8
	 B2lRYs77B0ElGBZOAu8RlA4bBkOM6Eb9bgJydG7FOtze1xa/0QDXkcVTYHaiKRsSzb
	 Ag/CiyXycl1S/Ug5XwkHrW0rBFE05P67l3DawhcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coverity Scan <scan-admin@coverity.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/100] ksmbd: fix uninitialized pointer read in ksmbd_vfs_rename()
Date: Wed,  3 Jan 2024 17:54:08 +0100
Message-ID: <20240103164858.966734024@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 48b47f0caaa8a9f05ed803cb4f335fa3a7bfc622 ]

Uninitialized rd.delegated_inode can be used in vfs_rename().
Fix this by setting rd.delegated_inode to NULL to avoid the uninitialized
read.

Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d_name")
Reported-by: Coverity Scan <scan-admin@coverity.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 58a6665f1c3ab..5d2bb58d77e80 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -744,6 +744,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 	rd.new_dir		= new_path.dentry->d_inode,
 	rd.new_dentry		= new_dentry,
 	rd.flags		= flags,
+	rd.delegated_inode	= NULL,
 	err = vfs_rename(&rd);
 	if (err)
 		ksmbd_debug(VFS, "vfs_rename failed err %d\n", err);
-- 
2.43.0



