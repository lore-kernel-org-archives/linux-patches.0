Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AE4335BCB;
	Mon, 18 Aug 2025 13:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523233; cv=none; b=grv7BzmmG+uKA0vzHNaMVzI+aGaDSHZEXKLZt/7pQAFIKR70kB3cfEyO2DvzerKivNgd1xfQ6a/T4UXDQzGWPNhZMXadauX6vaxvfrtdb35AEqN+wG0ZuwqOj/0IclSthgClfJ6wOCAzDoNhlzUbGuu1nSBO83sOYR0MPYjWras=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523233; c=relaxed/simple;
	bh=rrllElex7TiG+/kOTX9pvN1PUVqTNkZC0eM+AXoJQV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFjJIYqGpooLnNso/YEcCbBZLZAMF2NyzuuFs3aqpkiiusfVoF6KUJCHvpWl+tH+3qudT/SXpgshrJUt6IZmVJyfA7/0phfqY4fXQ/Yx2GGAdPvaetniasmv8CLTWNNDPSNkPc2P8lwIUpow7Wo2+kw4oZwarZSqlEah6HybODI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0olqZ2tx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0olqZ2tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42798C4CEEB;
	Mon, 18 Aug 2025 13:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523233;
	bh=rrllElex7TiG+/kOTX9pvN1PUVqTNkZC0eM+AXoJQV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0olqZ2txefR3ZZkruv0S4ffwZZOmwMcBI8dOE7AIuxGg7fjDZe/W+iR5VBZOhrh0l
	 k6tHC9ZSmuw8oi5W4KjotIE1KqsbGaScc69smP1Nc9+yg6zpSOagd0Vm+X1BJ60w8y
	 nHB8lO64uwUIg9nOKxELJCdZImBcId9IVrSqXFAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 109/515] fix locking in efi_secret_unlink()
Date: Mon, 18 Aug 2025 14:41:35 +0200
Message-ID: <20250818124502.557247477@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



