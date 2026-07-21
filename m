Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155D346AA91;
	Tue, 21 Jul 2026 15:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649272; cv=none; b=ZgesD8ylZ5baxPO+DZU9aWtCCmvG70SQbtwgoRdGWLYS/4Z0/6w5T4k3KdxYnVckAO3543Rea7l+jtM54lRk3TAoxPtAZGwK+HBb6Dc7GveJNqsPbhXbXeJ4eYn+ZIynFQf/71o9fiaFGnB9tHM5AMp9NCTEy7TI5KCkLV6X86s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649272; c=relaxed/simple;
	bh=DEn0hxlg3k4rRZ7eVIEzxOwMYpj69f3DoLp5uU6slSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dK1NxxiFTzMcDznN5lucyi2w58/DTHc9yv5WggWbhIMtjAm/oqkyF0voZwSZofpcQX92WZNkW6ZRRwVTbSRuGbe9RU/u9N5rodN0e3aKCqIJrD6+MtWJX29gXm7827YJpmR94HShBQ8bXg1sH8EDZDALiOp5Zo2Q3voLzTuzmmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8e8dxOT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8e8dxOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B62E1F000E9;
	Tue, 21 Jul 2026 15:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649271;
	bh=gt6jwMRS7sbyKHjO6WJnIj8FlYA0qwqWJyWHu4zkq8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8e8dxOT+eh+ab34G215OUDak5ReXxzwMzX3e/3ORq5FjBboD2XrTwHE9m/VXl7jv
	 qJXu9y3oajMmk3YK3ivnDIkM4Rs0q31d+9nUg9vxs4GBbr9uzV4o1vfIlhRONIl3s1
	 mzSislrT2PGn7VT1PBTlxYMlMK0elPA99jV5sakE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Calum Mackay <calum.mackay@oracle.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0516/2077] tmpfs: simplify constructing "security.foo" xattr names
Date: Tue, 21 Jul 2026 17:03:09 +0200
Message-ID: <20260721152604.981888214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 832f4de4c8ba4f19e5df1d016a09917204b17834 ]

Use kasprintf() instead of doing it with kmalloc() + 2 x memcpy().

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Link: https://patch.msgid.link/20260605135322.2632068-3-mszeredi@redhat.com
Tested-by: Calum Mackay <calum.mackay@oracle.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: 1e7cd8a53b72 ("simpe_xattr: use per-sb cache")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c2f..c7897570fc9f9d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4232,7 +4232,6 @@ static int shmem_initxattrs(struct inode *inode,
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	const struct xattr *xattr;
 	size_t ispace = 0;
-	size_t len;
 
 	CLASS(simple_xattrs, xattrs)();
 	if (IS_ERR(xattrs))
@@ -4260,17 +4259,11 @@ static int shmem_initxattrs(struct inode *inode,
 		if (IS_ERR(new_xattr))
 			break;
 
-		len = strlen(xattr->name) + 1;
-		new_xattr->name = kmalloc(XATTR_SECURITY_PREFIX_LEN + len,
-					  GFP_KERNEL_ACCOUNT);
+		new_xattr->name = kasprintf(GFP_KERNEL_ACCOUNT,
+					XATTR_SECURITY_PREFIX "%s", xattr->name);
 		if (!new_xattr->name)
 			break;
 
-		memcpy(new_xattr->name, XATTR_SECURITY_PREFIX,
-		       XATTR_SECURITY_PREFIX_LEN);
-		memcpy(new_xattr->name + XATTR_SECURITY_PREFIX_LEN,
-		       xattr->name, len);
-
 		if (simple_xattr_add(xattrs, new_xattr))
 			break;
 		retain_and_null_ptr(new_xattr);
-- 
2.53.0



