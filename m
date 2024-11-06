Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C04618C00E;
	Wed,  6 Nov 2024 12:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896098; cv=none; b=C6j0qUgykwa3ogluSIWVzCA6f3+s9rlT8iFO13pqYcAnzpXEUH5HH4jP2RexW1beo+gMaO+9qHqvsx6O4qIQfztOKg9oesaGZjNQxiSvwSc0MhUvO23DPVhCmAmIwJ8amIoleZLnBEXPiestIttTPJKt3vqhk/LHncOa0GYXO88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896098; c=relaxed/simple;
	bh=DtAHNDFKGZhlAJ4FSZ9+8B8TRYQ85SurTC12qaraeJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2HuHleGNu3fudNs81hAFa9JyS0WpVbms3Hz4PFwBHTBIHIvELpqDRyRbOEIHD/dbRkEaj170TnKtJqB5ivpPAA81JoIVHSDzNInzw4BFC16ij7ebpbJyxyEWZjkuQJh+Bs+2QSSQoXE34hCfq94Jw2Dro+/FWUIiwCDLzfH0Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1MhsyL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1MhsyL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923EBC4CED4;
	Wed,  6 Nov 2024 12:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896098;
	bh=DtAHNDFKGZhlAJ4FSZ9+8B8TRYQ85SurTC12qaraeJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1MhsyL5LfnWPqCraLQI0EJIiQYL1vq2WZtyW/7dmJQKHTd+JkL/gYtp8HW/ytIwD
	 5MsoLHSKdHnvG1ghTdDBVDAuW2jwtFXDHjDamGMaCimeHcOfyb1hOHp/9z3duJgm8r
	 c0Wap3vx+2wKb7az2C7fiuBuL0OrRdQ2+sIqAO+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8c652f14a0fde76ff11d@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 090/245] fs/ntfs3: Additional check in ntfs_file_release
Date: Wed,  6 Nov 2024 13:02:23 +0100
Message-ID: <20241106120321.423525764@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 031d6f608290c847ba6378322d0986d08d1a645a ]

Reported-by: syzbot+8c652f14a0fde76ff11d@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index d31eae611fe06..906ee60d91cb1 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -1285,7 +1285,14 @@ static int ntfs_file_release(struct inode *inode, struct file *file)
 	/* If we are last writer on the inode, drop the block reservation. */
 	if (sbi->options->prealloc &&
 	    ((file->f_mode & FMODE_WRITE) &&
-	     atomic_read(&inode->i_writecount) == 1)) {
+	     atomic_read(&inode->i_writecount) == 1)
+	   /*
+	    * The only file when inode->i_fop = &ntfs_file_operations and
+	    * init_rwsem(&ni->file.run_lock) is not called explicitly is MFT.
+	    *
+	    * Add additional check here.
+	    */
+	    && inode->i_ino != MFT_REC_MFT) {
 		ni_lock(ni);
 		down_write(&ni->file.run_lock);
 
-- 
2.43.0



