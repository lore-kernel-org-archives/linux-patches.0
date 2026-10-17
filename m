Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4AC391E51;
	Sat, 17 Oct 2026 17:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257065; cv=none; b=O5n0X/yEj5SRICBzGV8L2eJCoMzE+QzgPQr1+62JETyqtv93ZQjZnVR/lY6rIPTO7c+0raQ9NShDzdk9g+heOmH+akk1F5CJDFNDcnH6JqXSAhxXCKb/j/r/5ARMwz366OARW7XRc6skX4M1T/3ZsrfzcSRRktzaYRdMc1ZAVpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257065; c=relaxed/simple;
	bh=l7Rlb0T6ZbK8BYz0U3GG1KuXukjvY8ZStBfMf88SkB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tlp89XJ+M1Ihmk66nNh0L9uwdbDZKsYgLlg89iSl/obkrS+LxkRdeewAFuoSmnJHoHaMP5Qi6gexhcDpSUDRu30D4SO/56bBiQ5Xtc8mZPJu9CvOtMguHmasViAlT6zvecDVRMQZwZgggDKs0qDZMk/cnG9Wsy6TGWriQ8rPVHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=01zGYzkp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="01zGYzkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5311F000C4;
	Sat, 17 Oct 2026 17:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257063;
	bh=00FNnNfo9kmZphVlAkX6UpqWH5sVDTQlm/zGcnl9UFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=01zGYzkpP8uK78sIbnDkNK4PQgjhXC1SmmWjQPacIDNK85ChME7e4EbtMs/b98lSn
	 6u238/yzUEqMcfssrkgkl6S/VgrQWpkA8mYKQU0mNUQ3Nq1ZOAaKxyeMRmiTt6Zv3t
	 UBmlQCeXMOkIx9k9FvbUAo0Mgg/K7fIvGvl7D8/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Zi Yan <ziy@nvidia.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Dave Jones <davej@codemonkey.org.uk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0433/1674] fs: Free any excess xarray nodes in clear_inode()
Date: Sat, 17 Oct 2026 17:45:05 +0200
Message-ID: <20261017160442.240620317@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit ee3f011250104129893d8e9599147e457d4d7280 ]

For many years we've had a hard to hit leak of xarray nodes.  Hugh
documented it well in commit 786b31121a2c.  Recently people and
syzbot have found ways to force it to happen with madvise.  Rather
than fix the leaks where they happen, just call xa_destroy() which
has the side-effect of cycling the i_pages lock.

Cc: Rik van Riel <riel@surriel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Link: https://lore.kernel.org/all/20260121062243.1893129-1-tujinjiang@huawei.com/
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://patch.msgid.link/20260623192850.1595958-1-willy@infradead.org
Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 030e07b169c27..a118d7c40ff6b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -642,21 +642,18 @@ void dump_mapping(const struct address_space *mapping)
 void clear_inode(struct inode *inode)
 {
 	/*
-	 * We have to cycle the i_pages lock here because reclaim can be in the
-	 * process of removing the last page (in __filemap_remove_folio())
-	 * and we must not free the mapping under it.
+	 * We have to cycle the i_pages lock here because reclaim
+	 * can be in the process of removing the last page (in
+	 * __filemap_remove_folio()) and we must not free the mapping
+	 * under it.  We also remove nodes which are empty; these
+	 * can occur in two different ways.  The first is that radix
+	 * tree expansion can fail partway and the second is that THP
+	 * collapse_file() can allocate some temporary nodes and not
+	 * clean them up.
 	 */
-	xa_lock_irq(&inode->i_data.i_pages);
+	xa_destroy(&inode->i_data.i_pages);
+
 	BUG_ON(inode->i_data.nrpages);
-	/*
-	 * Almost always, mapping_empty(&inode->i_data) here; but there are
-	 * two known and long-standing ways in which nodes may get left behind
-	 * (when deep radix-tree node allocation failed partway; or when THP
-	 * collapse_file() failed). Until those two known cases are cleaned up,
-	 * or a cleanup function is called here, do not BUG_ON(!mapping_empty),
-	 * nor even WARN_ON(!mapping_empty).
-	 */
-	xa_unlock_irq(&inode->i_data.i_pages);
 	BUG_ON(!list_empty(&inode->i_data.private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
-- 
2.53.0



