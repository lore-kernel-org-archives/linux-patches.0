Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D76327453;
	Tue, 29 Apr 2025 17:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946732; cv=none; b=Mvhb5HWGDeCNK586wqTtyr/gaDYHVRQ+YsSWFJbcP016gTxcnlaF47gPhqe92WRTSJiN7P21H4WirA/tzClXbKYI+B7IELOOfWVLoXFXROt/BbOrm2iSXH4GmSVId2Epc2D7o6duF0AuATVy/B8O6vXe/N/N5DdrkoPHGIuKcic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946732; c=relaxed/simple;
	bh=o6ZRuLa9gSXqQuMm0S3t45sNdCAdh/mw/3Bdl82xVpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkvKMmQRAmfoI3DTX3TL7J+rLvmFamV27SStnYV4XOsGuXNN202eQrfwgQddG2834I599NCRVky0+OukOaqFDiV319AjVK/vJPYur1d0KwkIBJG+RR7bGj/YN+axIY/xfa0GszRDBfQcXt+85KeWM5OYE31+TV8mm4rd8zNeRS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtDXQuwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtDXQuwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA32C4CEF1;
	Tue, 29 Apr 2025 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946732;
	bh=o6ZRuLa9gSXqQuMm0S3t45sNdCAdh/mw/3Bdl82xVpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtDXQuwa4wmlpTWZ0vlW2G3lFaDcOThUp8yQGFaB5m9zxcRaTyOxLZky0xhW5gQ2f
	 1KUmMgJemIT81LfvVXjBsUMDIOJxxN3D3qXIrCQXaYI+xFhYAKPEjD8xNVtoxm9ioM
	 M5r8n40fV2e+jF+BVUWahrAwJje5Fp3LRiAjui1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/286] ext4: reject casefold inode flag without casefold feature
Date: Tue, 29 Apr 2025 18:39:15 +0200
Message-ID: <20250429161109.953905352@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 8216776ccff6fcd40e3fdaa109aa4150ebe760b3 ]

It is invalid for the casefold inode flag to be set without the casefold
superblock feature flag also being set.  e2fsck already considers this
case to be invalid and handles it by offering to clear the casefold flag
on the inode.  __ext4_iget() also already considered this to be invalid,
sort of, but it only got so far as logging an error message; it didn't
actually reject the inode.  Make it reject the inode so that other code
doesn't have to handle this case.  This matches what f2fs does.

Note: we could check 's_encoding != NULL' instead of
ext4_has_feature_casefold().  This would make the check robust against
the casefold feature being enabled by userspace writing to the page
cache of the mounted block device.  However, it's unsolvable in general
for filesystems to be robust against concurrent writes to the page cache
of the mounted block device.  Though this very particular scenario
involving the casefold feature is solvable, we should not pretend that
we can support this model, so let's just check the casefold feature.
tune2fs already forbids enabling casefold on a mounted filesystem.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20230814182903.37267-2-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 642335f3ea2b ("ext4: don't treat fhandle lookup of ea_inode as FS corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c991955412a49..d0fcf91ec9d62 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5004,9 +5004,12 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 				 "iget: bogus i_mode (%o)", inode->i_mode);
 		goto bad_inode;
 	}
-	if (IS_CASEFOLDED(inode) && !ext4_has_feature_casefold(inode->i_sb))
+	if (IS_CASEFOLDED(inode) && !ext4_has_feature_casefold(inode->i_sb)) {
 		ext4_error_inode(inode, function, line, 0,
 				 "casefold flag without casefold feature");
+		ret = -EFSCORRUPTED;
+		goto bad_inode;
+	}
 	if ((err_str = check_igot_inode(inode, flags)) != NULL) {
 		ext4_error_inode(inode, function, line, 0, err_str);
 		ret = -EFSCORRUPTED;
-- 
2.39.5



