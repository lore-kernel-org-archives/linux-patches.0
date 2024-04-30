Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB63211C;
	Tue, 30 Apr 2024 11:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475759; cv=none; b=FLJjKbuFSOJCBY/oVLu6groDMSfbi/gs2ZiAzDlrtuVHjcs3QQJBGPyNljU1rNtRAHnirD6+yONzdEEVZIUzkkoGlv/IWrmKs09aOQlrSEKYstIwwrGblAgGN+r7D4PpkJyQLHbAWj8Myk64pBRy+p4o12FGqBjTUKvoHJurARs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475759; c=relaxed/simple;
	bh=BEWgrd1dVAYkHvB7mbEj2gdqsFOHavQwMyZ57lKqWfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWjHgbVqccvXmUtDvmSRtEeQ6/PymZ2bD27y3R/G9s018D4wmCcCkXYYQMMFmS48IqCZKwu0ZyNodH9ajbAWijzFDX8+qjEJ55F6mr9hcwKFc4MBo0TgCxd9az3HzT10LKK2wL9ff0sIkqZWo/QijnIdBQJNrCSTWa6eV83AAYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjEeu4Ix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjEeu4Ix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524CFC2BBFC;
	Tue, 30 Apr 2024 11:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475758;
	bh=BEWgrd1dVAYkHvB7mbEj2gdqsFOHavQwMyZ57lKqWfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vjEeu4IxQ0XOZvXBY610iavMnjZ3EliE6TRzBXoijZe92zXDChqUGG0X6R1O40f4F
	 b1AlaHn83EfiJTsPEFI1HD0NcEeKgNhLQltU2eMtE7R3soAPjOain1++vJ5X6+Y13V
	 OD85QXSm6x48IwkeEY+6MfnIilkvEtov38KZoT/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 01/80] smb: client: fix rename(2) regression against samba
Date: Tue, 30 Apr 2024 12:39:33 +0200
Message-ID: <20240430103043.444334807@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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
 fs/cifs/cifsfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 9bbead15a0287..d3adcb9e70a66 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -374,6 +374,7 @@ cifs_alloc_inode(struct super_block *sb)
 	 * server, can not assume caching of file data or metadata.
 	 */
 	cifs_set_oplock_level(cifs_inode, 0);
+	cifs_inode->lease_granted = false;
 	cifs_inode->flags = 0;
 	spin_lock_init(&cifs_inode->writers_lock);
 	cifs_inode->writers = 0;
-- 
2.43.0



