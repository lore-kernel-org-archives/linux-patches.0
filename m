Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401CC19D084;
	Mon, 23 Jun 2025 21:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714819; cv=none; b=FSv0yXYLjfFM8hG3PSy84gf5isQwd3IaNV9tI+FqwXQp+DS2Nj+goB54VFMgsdAy+JdUgk8vmPh0/0CB8nHL9i63AtwS6Us8Z/PVHARqCnH9S5RuDHygpEbLaSUgUjakwVw2Mhw3MG//diR7He8yZrl/+/Y29KxSsU0YgXWS9Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714819; c=relaxed/simple;
	bh=/8GWeppzmrf6rOlIRUiAbMjRJnpXocrN0bYwqLkgxsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sS5Gv2V3bzh7iGTbjvEQBJ62SjEXJfkFhp+8Ls6lrs7dfMZ/2IgMZ6F72vH6jI/vBUy6+dWWLFXgKGOqAlDBzi392rCRUUy6CjuPGBJP2uo4qtLcHP92fScNr1jtFP26IsqFhClK6isDb5KtZJS5p+ZSJ7RPdsymnWKniRxOuGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOv6ZR3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOv6ZR3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B18C4CEEA;
	Mon, 23 Jun 2025 21:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714819;
	bh=/8GWeppzmrf6rOlIRUiAbMjRJnpXocrN0bYwqLkgxsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOv6ZR3eeyLu3LsECyWDLairpquaYR5UbaMmLpzcrVkDZfH0IgeCyVjnOVvIBLpeD
	 A7qT+25yp/4mp+BcqjGyz/kOlNlpJEPPP6YWdjkf9/0+va0jI3xVYTji+OxSXVGaq1
	 Co8f1x7WolKxqrdq6/xdK3HcPlvB/s81ooopfpNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 440/592] ovl: fix debug print in case of mkdir error
Date: Mon, 23 Jun 2025 15:06:38 +0200
Message-ID: <20250623130710.898976083@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 527c88d8390d6c0358dea4d71696795c05328925 ]

We want to print the name in case of mkdir failure and now we will
get a cryptic (efault) as name.

Fixes: c54b386969a5 ("VFS: Change vfs_mkdir() to return the dentry.")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/20250612072245.2825938-1-amir73il@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/overlayfs.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index aef942a758cea..c69c34e11c74d 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -246,9 +246,11 @@ static inline struct dentry *ovl_do_mkdir(struct ovl_fs *ofs,
 					  struct dentry *dentry,
 					  umode_t mode)
 {
-	dentry = vfs_mkdir(ovl_upper_mnt_idmap(ofs), dir, dentry, mode);
-	pr_debug("mkdir(%pd2, 0%o) = %i\n", dentry, mode, PTR_ERR_OR_ZERO(dentry));
-	return dentry;
+	struct dentry *ret;
+
+	ret = vfs_mkdir(ovl_upper_mnt_idmap(ofs), dir, dentry, mode);
+	pr_debug("mkdir(%pd2, 0%o) = %i\n", dentry, mode, PTR_ERR_OR_ZERO(ret));
+	return ret;
 }
 
 static inline int ovl_do_mknod(struct ovl_fs *ofs,
-- 
2.39.5



