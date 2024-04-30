Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772C712C47A;
	Tue, 30 Apr 2024 11:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476362; cv=none; b=UjB92ftYY1DBkZYAD6wC//1wjE/rrHzjARcHB8rqOe+LX/Qn+HZXHdSEF6M74fo8GRykMAdMRDHkBoM/5FjGDhnbbprX+2uvuLLtvxkjbpLKXyXqKgs+z3SAmDoD3RxIMLY179cd5BbDsi9ZZlU5oGtXmbSWHOUE+/hKojmygC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476362; c=relaxed/simple;
	bh=VLkcYWo3+IafxTh4CLWWMEuuODbxofv6/hBKNxhr3QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWQLDrBCtb41btHcLQTUgtFcWHCv7Oy1gNg9L1j4MJiOptPGUhPNph2ulXfkTlyjQCHe+t8ShSN3aW0vZu0fJQMwUAwaLGvfojkQNaZ3mHILgU2T+mvWgyr5pSA1oqLtRSHnfFBjBwaKL09uO2c7fUgElL3oEdpdnYhIAT+ROqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zF5bfK99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zF5bfK99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CAFC4AF18;
	Tue, 30 Apr 2024 11:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476362;
	bh=VLkcYWo3+IafxTh4CLWWMEuuODbxofv6/hBKNxhr3QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zF5bfK99d0zPzQjuQ5oSm/330JCO+ck3EF6e6W9+ug0SC1AXHk0y1UBxvlpB2urWS
	 aP9TYDjlIDuj7DqOepWIucPtHjjaQOeeLP+0MV5bUWczyuqzjSLa6MbE7HOu9gslBZ
	 AdhEWzfT3v7ysIy9pFdrg1VGG6k9tNOPrtFPAgAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/110] smb: client: fix rename(2) regression against samba
Date: Tue, 30 Apr 2024 12:39:30 +0200
Message-ID: <20240430103047.609179828@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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
index 0a79771c8f33b..f0a3336ffb6c8 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -387,6 +387,7 @@ cifs_alloc_inode(struct super_block *sb)
 	 * server, can not assume caching of file data or metadata.
 	 */
 	cifs_set_oplock_level(cifs_inode, 0);
+	cifs_inode->lease_granted = false;
 	cifs_inode->flags = 0;
 	spin_lock_init(&cifs_inode->writers_lock);
 	cifs_inode->writers = 0;
-- 
2.43.0



