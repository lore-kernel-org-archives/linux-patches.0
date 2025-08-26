Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29262352067;
	Tue, 26 Aug 2025 14:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217643; cv=none; b=M0fht7WUO2fgHkFKGSzpv/pdV2y+Els/jfLKCIDNPXENLjTDVEJWZ8kUSdsyz6B+n4aVRQLYuDXMsEC16W25eMVKdeMLtl0VCcWLCR+kh/H91j79gefxJtjAqEaN6Jn8mGcNfcC2guTi8pL1j4AjGQf7mMlDQ2h7WTvJxmYs61k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217643; c=relaxed/simple;
	bh=r1iOXwoHac4VvjRZdsnXGI58/MeEGxtL5OtLjPkf7l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgMUdOzTt14CTwlhDHkxNVR35OLu0V6/uWHynDXCPHfCEOKzHx2UxZUM++AZO1BQW2JHk+BDx8FyVjfv08d6PUFO/N+GV2plRFpnst31HtYT8+iVj3cDN1BKYkh3eA84q8Xish/5F2gV69ZnsaXrwmLk0FTJT9gZjaJKJQhlek8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+34FviR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+34FviR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0A2C113D0;
	Tue, 26 Aug 2025 14:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217643;
	bh=r1iOXwoHac4VvjRZdsnXGI58/MeEGxtL5OtLjPkf7l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+34FviRCpX3cb1KfLTi48buWC1Rblw4EWGRl+c15HqDhA32wQW/ELN+pxd6F3eDu
	 29wo0n5CDmPQHe7WtEw1fz5n/lfgOG1rgJRYG94wvNBwRmkdoL6t38h4YWNRmx4NOX
	 uWUYQQgIwgYLxjjiYVMqWvRIXls1GR5EEXb5RGpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/523] securityfs: dont pin dentries twice, once is enough...
Date: Tue, 26 Aug 2025 13:07:10 +0200
Message-ID: <20250826110929.886379273@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 27cd1bf1240d482e4f02ca4f9812e748f3106e4f ]

incidentally, securityfs_recursive_remove() is broken without that -
it leaks dentries, since simple_recursive_removal() does not expect
anything of that sort.  It could be worked around by dput() in
remove_one() callback, but it's easier to just drop that double-get
stuff.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/security/inode.c b/security/inode.c
index 6c326939750d..e6e07787eec9 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -159,7 +159,6 @@ static struct dentry *securityfs_create_dentry(const char *name, umode_t mode,
 		inode->i_fop = fops;
 	}
 	d_instantiate(dentry, inode);
-	dget(dentry);
 	inode_unlock(dir);
 	return dentry;
 
@@ -306,7 +305,6 @@ void securityfs_remove(struct dentry *dentry)
 			simple_rmdir(dir, dentry);
 		else
 			simple_unlink(dir, dentry);
-		dput(dentry);
 	}
 	inode_unlock(dir);
 	simple_release_fs(&mount, &mount_count);
-- 
2.39.5



