Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19F9145FEE;
	Thu, 13 Jun 2024 12:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281278; cv=none; b=IfMnePqGFt+PqENU4qLMDu7wiwFvpXzIRcUiHOGpqiiKOTx6yLRQj2TgBoCZGJ867tAB1wcmjD4fNP5Cz/WHOKQFpYJl8RqJ2O0hchlsCFN6tJ/23exET8oHvXEXGvBkGwebN44/tVuWSB+e2+dR1zZ6AQ3VwylAvpBmEyWqadE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281278; c=relaxed/simple;
	bh=FdjcBlJaFYeV/5qFhm1KETp7TB2apg/TuhfPPOsLxC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N10JkSBoGld7lkT2uS1d/pUII0xrdFf+3DAmMpW9+0n9nkqmQPoLo/7l0BSWrtuF2YX669HCTrOoCcCYu3NLIT+qBthxhnfFWrGz+AMgJ2iwwW8gFJKPiebxhAp++uaS9pJQiMv3Z3214rS3mjs85l8ndjBwaOmY+NZ1O4AP+Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCFw3juV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCFw3juV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCB3C2BBFC;
	Thu, 13 Jun 2024 12:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281277;
	bh=FdjcBlJaFYeV/5qFhm1KETp7TB2apg/TuhfPPOsLxC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCFw3juV7gDX5FtLWuLgoeq+zHUO/W8hreddyghIvlWClAY/e7hbsBmp2PiZnSm80
	 nkgg6+2vNUmIsUlmW6+Ew6izN6WZGEc7/p5yDrszgAuyZbi8cnH8ckMMRQqQqMJKAV
	 maMIZ+4uf+X/6+XGNS2b+OffA/8z/wxZK/jU1Ng8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/317] ovl: remove upper umask handling from ovl_create_upper()
Date: Thu, 13 Jun 2024 13:33:09 +0200
Message-ID: <20240613113254.175627603@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 096802748ea1dea8b476938e0a8dc16f4bd2f1ad ]

This is already done by vfs_prepare_mode() when creating the upper object
by vfs_create(), vfs_mkdir() and vfs_mknod().

No regressions have been observed in xfstests run with posix acls turned
off for the upper filesystem.

Fixes: 1639a49ccdce ("fs: move S_ISGID stripping into the vfs_*() helpers")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/dir.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index a7021c87bfcb0..470ff30851b4d 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -323,9 +323,6 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	struct dentry *newdentry;
 	int err;
 
-	if (!attr->hardlink && !IS_POSIXACL(udir))
-		attr->mode &= ~current_umask();
-
 	inode_lock_nested(udir, I_MUTEX_PARENT);
 	newdentry = ovl_create_real(udir,
 				    lookup_one_len(dentry->d_name.name,
-- 
2.43.0



