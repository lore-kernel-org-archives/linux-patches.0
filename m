Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEEB359F8A;
	Fri,  9 Jan 2026 11:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959510; cv=none; b=SGb5znTHBWkpQrII1fnAoACFppivMFGlsvLx6+2RfFYPQDDRPhY5d+tIVLWzfYu+KoB429EUkjPFoF/myqsGqr3XTD8yK81Uc0nRC5gSq/0K4gjHa8px3Cp+HL4IJ8jw9cdbAH09GQ3rn+pfRqFRXVkBpyl7mSznCw1CFdpHCvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959510; c=relaxed/simple;
	bh=J/4yaW6wGxetNHvdkI+DtOfWrzaAeulqew3h/0aSJ7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EiKyMjBzBOG92wxjrDhyZZgs79e0ojWq6e1l9fBVQJGZHl9/9avRKcmnCPcsEkIM0xI3F6v9IJd0N4kTLKhqNX5amxxDJ2aKtYAuYolYsd4NYKZs/9loo50B2HV6H6QVph6pKeSFw6qprZ7IzLJXhddIOjozenKDWdFMt3hzbPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXmvctJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXmvctJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E6BC16AAE;
	Fri,  9 Jan 2026 11:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959510;
	bh=J/4yaW6wGxetNHvdkI+DtOfWrzaAeulqew3h/0aSJ7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXmvctJrl1MJo0kaVkc/ujDqJlaPBXdCHQRH7orB6+iLrq7rUIAbdGTaJ6nNlC8jQ
	 igE6ud1agJeybtEYAbgmAhH51illeppMa/lL3SsiT9rsktm57naZ4INtHWGLB0eeHO
	 vh/eTEHrjoBRxKYtlpwCEXuDuHz1tZa2tf3lst38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com,
	Sidharth Seela <sidharthseela@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/737] ntfs3: Fix uninit buffer allocated by __getname()
Date: Fri,  9 Jan 2026 12:33:29 +0100
Message-ID: <20260109112136.630459529@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sidharth Seela <sidharthseela@gmail.com>

[ Upstream commit 9948dcb2f7b5a1bf8e8710eafaf6016e00be3ad6 ]

Fix uninit errors caused after buffer allocation given to 'de'; by
initializing the buffer with zeroes. The fix was found by using KMSAN.

Reported-by: syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com
Fixes: 78ab59fee07f2 ("fs/ntfs3: Rework file operations")
Signed-off-by: Sidharth Seela <sidharthseela@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index a967babea8a59..f27e25776b730 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1758,6 +1758,7 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 	de = __getname();
 	if (!de)
 		return -ENOMEM;
+	memset(de, 0, PATH_MAX);
 
 	/* Mark rw ntfs as dirty. It will be cleared at umount. */
 	ntfs_set_state(sbi, NTFS_DIRTY_DIRTY);
-- 
2.51.0



