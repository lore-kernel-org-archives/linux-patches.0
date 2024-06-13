Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3FD13E3F9;
	Thu, 13 Jun 2024 12:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282374; cv=none; b=sIIdf6g97kkS5cYmi258ig+EFYXAxOhC2GjDFA6ynGd5VjJalXRn++uMOgqv7kyv8PxQwQzr6ZmXwUvkkuNer2RQCJxGk+jL3y+KDHXZcoulfaCKjJYyRT4bMPyu8+gOGYry9aYRwMbPrCYkrqp5LE3YwPtq8uzyKAB0xJzfZwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282374; c=relaxed/simple;
	bh=TrXUCsuzM+i5b7I4w18Xq3PQVYupRhpXduRiZU2zvqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mnfw7KoUqPDmSucl7ViRVrscK9n0iiL/W4gnos/92N7n+8Vgxz43nTrSAoinVK5FfuxwbFai4eb7DFcIWFOVaDqBXY1JZB8bnABuZHF6+mgqtymBI9GNfygKEAU36OeQ3u6PE8mDCuEED/Cxddnv/YnJX19Hj55FyEk++mRjxEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leEXUuUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leEXUuUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0FDC2BBFC;
	Thu, 13 Jun 2024 12:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282374;
	bh=TrXUCsuzM+i5b7I4w18Xq3PQVYupRhpXduRiZU2zvqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leEXUuUBYiEvXpnCJAkKebg1I39L4q1SgaZ3+zjwakBB4ta9T/vCCsyHYlm2A7Oyb
	 ZOkx2eyYt3vDgW6Vb+nEi36KCcSiOK1nhzbMtVItglISthooyDMABhZ1X3z7SZR/be
	 sGIpkAOGVAdLVAHluewdZMoTSoTKkdIOAPiG3NOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 215/402] ovl: remove upper umask handling from ovl_create_upper()
Date: Thu, 13 Jun 2024 13:32:52 +0200
Message-ID: <20240613113310.535804144@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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
index 519193ce7d575..89fc23803dafc 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -325,9 +325,6 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
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



