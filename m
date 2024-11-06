Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE471DFE27;
	Wed,  6 Nov 2024 12:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897065; cv=none; b=dXz5Bc0wcMW6pb1EbT5pRPUTWbRFhdEfWR0zFQjPcYsBchLStptHxK685GCr0xCXCAgxcm1Jl4Hg39ez2nZNbH3Yvgt7x3YWcxrgOdMoPTKYDAvPYb7KoQHtzWfk6S5yjG3unzwPzJnG4d/znxiBSUaX8sesMLkC3BxyssGFjWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897065; c=relaxed/simple;
	bh=4sdBtWtvIHU0ydI9dPB+Jdrtq7/hsEkopMAG+GaynLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuq8tVaqUnw21ln1eo4Ud3Rd7Vq2TPLVTaF09lxgxik2GrIS76l/hiOb2JsIiAcBMGadhMtpyClareKwUG+nwgmeHUxtnq4sgQyC8cxzS4EiqEA8p0ZCWtZ2obPkn1VEsu9FqR9xxYozqvGlnxLD1W+/ukDiw6OzPgSMYYtT+pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3cCdwCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3cCdwCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7D1C4CED3;
	Wed,  6 Nov 2024 12:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897064;
	bh=4sdBtWtvIHU0ydI9dPB+Jdrtq7/hsEkopMAG+GaynLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3cCdwCITja1ZeDB5727+DsdghYPu6XJPJqVnWo1GX11kZKYqW1w+2b7pPbtcrfrf
	 NMlR5T2LIPkcdr+gvbm9LpX1OpK4+e3NJUgSRLCIm58zPGvQ7YGgapzWfQkAcXO7Xe
	 az2BsmebXRZUCXgrHQd6pqBKEHh+Ok8baL2aaUtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/126] fs/ntfs3: Stale inode instead of bad
Date: Wed,  6 Nov 2024 13:04:15 +0100
Message-ID: <20241106120307.561494009@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 1fd21919de6de245b63066b8ee3cfba92e36f0e9 ]

Fixed the logic of processing inode with wrong sequence number.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 28cbae3954315..026ed43c06704 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -524,11 +524,15 @@ struct inode *ntfs_iget5(struct super_block *sb, const struct MFT_REF *ref,
 	if (inode->i_state & I_NEW)
 		inode = ntfs_read_mft(inode, name, ref);
 	else if (ref->seq != ntfs_i(inode)->mi.mrec->seq) {
-		/* Inode overlaps? */
-		_ntfs_bad_inode(inode);
+		/*
+		 * Sequence number is not expected.
+		 * Looks like inode was reused but caller uses the old reference
+		 */
+		iput(inode);
+		inode = ERR_PTR(-ESTALE);
 	}
 
-	if (IS_ERR(inode) && name)
+	if (IS_ERR(inode))
 		ntfs_set_state(sb->s_fs_info, NTFS_DIRTY_ERROR);
 
 	return inode;
-- 
2.43.0



