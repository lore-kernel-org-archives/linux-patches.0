Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A098B335BA8;
	Mon, 18 Aug 2025 13:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524978; cv=none; b=p4gIyclKtBbqT3D5tYl39N0soL40oMMBefEGu41OC9E1ZQLPfXyJfvM3pZlHIoMDacdP87zfqbbjY+SiZBKvrs02dtWxNAVOwlo/vKaIZudlQGKTIQv3KNobwQlugA6oqSbp5LGevhH155/RkzgOkJ7OaW+kjriz06YOlIpFDP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524978; c=relaxed/simple;
	bh=k8zwIoPG25Ee6WPntgdCTi++W8+sTLMRpaB16GeNE28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehtU0u1T+8j8xjZYXqV4P9fc7wksyh4r9o2i1+eeu64kpfKy0L6t7jW/1cs8cty9H67LaLCDGyUWk/8o7yxVCxdJeCt2V30CtcrfZ16Jzel1Gd5cX8IfPDn6UFllP//aD7p/Q3+/urGf7hjLgVTgFy7Gs5Rsuok9N12iX4MEbck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9+6yGIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9+6yGIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28295C4CEEB;
	Mon, 18 Aug 2025 13:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524978;
	bh=k8zwIoPG25Ee6WPntgdCTi++W8+sTLMRpaB16GeNE28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9+6yGIPl6ZMp51E3n3Uwva2H+KWL3VOUL7/xNlvx/wyW2Pkn5gbh0pumAmj9Lic2
	 xu06i8O6nyXIQkp7TEvK9b9w8mjN27KEesKFS7+6fFjVbPMQLLKu1TQq9gPZtx4fGx
	 q9n8QuPVW/gFaIyvIwMkwAEKupPrip3Fj85Ztsds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 121/570] fix locking in efi_secret_unlink()
Date: Mon, 18 Aug 2025 14:41:48 +0200
Message-ID: <20250818124510.475650304@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 2c58d42de71f9c73e40afacc9d062892d2cc8862 ]

We used to need securityfs_remove() to undo simple_pin_fs() done when
the file had been created and to drop the second extra reference
taken at the same time.  Now that neither is needed (or done by
securityfs_remove()), we can simply call simple_unlink() and be done
with that - the broken games with locking had been there only for the
sake of securityfs_remove().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virt/coco/efi_secret/efi_secret.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/virt/coco/efi_secret/efi_secret.c b/drivers/virt/coco/efi_secret/efi_secret.c
index 1864f9f80617..f2da4819ec3b 100644
--- a/drivers/virt/coco/efi_secret/efi_secret.c
+++ b/drivers/virt/coco/efi_secret/efi_secret.c
@@ -136,15 +136,7 @@ static int efi_secret_unlink(struct inode *dir, struct dentry *dentry)
 		if (s->fs_files[i] == dentry)
 			s->fs_files[i] = NULL;
 
-	/*
-	 * securityfs_remove tries to lock the directory's inode, but we reach
-	 * the unlink callback when it's already locked
-	 */
-	inode_unlock(dir);
-	securityfs_remove(dentry);
-	inode_lock(dir);
-
-	return 0;
+	return simple_unlink(inode, dentry);
 }
 
 static const struct inode_operations efi_secret_dir_inode_operations = {
-- 
2.39.5



