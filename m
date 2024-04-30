Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555351E50A;
	Tue, 30 Apr 2024 11:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475184; cv=none; b=PlCCpvMCd85MC3bt/pxQn+fVQeHQmMV/2gjVFEMNuxZpBi+DGxMPup3MF+Vl76xW9fu+yCNNie5qyUnBLuZyXvTjXQZLzA8CNjjx2JKSSAiPnXIe365OET3r797/AxTj7AWv6OMSsMDfcM/Vx+I4Sg69RVp891WgSdh/gxM8kRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475184; c=relaxed/simple;
	bh=m+i7NVb+7tlRPAS8F49bZZ1hnTX0ZK4ukOhkTSiqj2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yh51AbtzUTeGUbUiEHRHeWSgFhXZH3fowlY8v1R6O3Qx7wwS7cQ6FgpNWjbDiO1KIm/wksnVgsvTNCHvLBrL86fzOYubCedM4Oq0yaMpDaaWQPOCCQWTVh2kELBD9L8zUA8hM5ao1dODLYc+uxDdyvDwg+aFBy7kLBtcsdO0fAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSix1EYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSix1EYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B12C2BBFC;
	Tue, 30 Apr 2024 11:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475184;
	bh=m+i7NVb+7tlRPAS8F49bZZ1hnTX0ZK4ukOhkTSiqj2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSix1EYIDeNKSaZSF/kil7BYvM+v4EMZXhOrNhOecssbls8S/UO6lPPVMMPY4aoS1
	 7M7Rb1P0sOfx7JirAuNQAqQq84ovsSeQypux14xCpGXdMwXLTQgDzYknuXZvYtGhtH
	 YyvPN5JDdh8eX0+FKCySBQBCNu9wiYwvQxt7zDfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/186] smb: client: fix rename(2) regression against samba
Date: Tue, 30 Apr 2024 12:37:34 +0200
Message-ID: <20240430103058.087050293@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 18d86965e31f9be4d477da0744a7cdc9815858de ]

After commit 2c7d399e551c ("smb: client: reuse file lease key in
compound operations") the client started reusing lease keys for
rename, unlink and set path size operations to prevent it from
breaking its own leases and thus causing unnecessary lease breaks to
same connection.

The implementation relies on positive dentries and
cifsInodeInfo::lease_granted to decide whether reusing lease keys for
the compound requests.  cifsInodeInfo::lease_granted was introduced by
commit 0ab95c2510b6 ("Defer close only when lease is enabled.") to
indicate whether lease caching is granted for a specific file, but
that can only happen until file is open, so
cifsInodeInfo::lease_granted was left uninitialised in ->alloc_inode
and then client started sending random lease keys for files that
hadn't any leases.

This fixes the following test case against samba:

mount.cifs //srv/share /mnt/1 -o ...,nosharesock
mount.cifs //srv/share /mnt/2 -o ...,nosharesock
touch /mnt/1/foo; tail -f /mnt/1/foo & pid=$!
mv /mnt/2/foo /mnt/2/bar # fails with -EIO
kill $pid

Fixes: 0ab95c2510b6 ("Defer close only when lease is enabled.")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index fcb93a66e47cb..44e2cc37a8b63 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -392,6 +392,7 @@ cifs_alloc_inode(struct super_block *sb)
 	 * server, can not assume caching of file data or metadata.
 	 */
 	cifs_set_oplock_level(cifs_inode, 0);
+	cifs_inode->lease_granted = false;
 	cifs_inode->flags = 0;
 	spin_lock_init(&cifs_inode->writers_lock);
 	cifs_inode->writers = 0;
-- 
2.43.0



