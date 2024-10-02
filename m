Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83451D0487;
	Wed,  2 Oct 2024 13:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875806; cv=none; b=sW4L5B3yqvH69Csg1EUlSUM3lriDFrlu3DGqIa0nXEYOnw/fjTNr2fhB8IHvXdN9Zho0KHOZR8dwQU2XYN+Q37X2uiGl5fk+rQ6H+1YKlOdu5xW7X9Y3sMvbgs1O0FazOBOjIJajt3ts3PZkoh4W78b81IVue34KcqyRUe8mx6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875806; c=relaxed/simple;
	bh=h1I6zwv5R7Qku4Up5vqcFx19fJpGwY5mZ+2SwUNOvjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQa6tQ0glVLq42DLJmUX5sc0qSAudKyQAoPH/j0ONY2YJime9wiSU0gd+pqSInmzWgpuiWFv9MUjJKhpVqC97HxFCz+9HlBNthTwxqJl9M+elcwXvTx3kMp/3QtUG1bAVe3UTabmgfN4rIS1D+pqgwH8yHcLbpF6DKKn/b0ljXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=buzDdNRi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="buzDdNRi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2665DC4CEC5;
	Wed,  2 Oct 2024 13:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875806;
	bh=h1I6zwv5R7Qku4Up5vqcFx19fJpGwY5mZ+2SwUNOvjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=buzDdNRii3V/i6tc5dRpy/VNfANblB4bluQQbcgfDQ8+JqpxLnWazD4qZG+/EVfGV
	 gejYFDNux+JnZFLSWTg1w6sV0YwcbPCViQjIbl1VaEsmzlNL5ddf3elgxTsHuPFwXo
	 0ouzYYkQ8/Ozel2pY7ssgCFWQJ7QIOKit7ooSmis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 220/695] jfs: fix out-of-bounds in dbNextAG() and diAlloc()
Date: Wed,  2 Oct 2024 14:53:38 +0200
Message-ID: <20241002125831.241671152@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Jeongjun Park <aha310510@gmail.com>

[ Upstream commit e63866a475562810500ea7f784099bfe341e761a ]

In dbNextAG() , there is no check for the case where bmp->db_numag is
greater or same than MAXAG due to a polluted image, which causes an
out-of-bounds. Therefore, a bounds check should be added in dbMount().

And in dbNextAG(), a check for the case where agpref is greater than
bmp->db_numag should be added, so an out-of-bounds exception should be
prevented.

Additionally, a check for the case where agno is greater or same than
MAXAG should be added in diAlloc() to prevent out-of-bounds.

Reported-by: Jeongjun Park <aha310510@gmail.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 4 ++--
 fs/jfs/jfs_imap.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 5713994328cbc..0625d1c0d0649 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -187,7 +187,7 @@ int dbMount(struct inode *ipbmap)
 	}
 
 	bmp->db_numag = le32_to_cpu(dbmp_le->dn_numag);
-	if (!bmp->db_numag) {
+	if (!bmp->db_numag || bmp->db_numag >= MAXAG) {
 		err = -EINVAL;
 		goto err_release_metapage;
 	}
@@ -652,7 +652,7 @@ int dbNextAG(struct inode *ipbmap)
 	 * average free space.
 	 */
 	for (i = 0 ; i < bmp->db_numag; i++, agpref++) {
-		if (agpref == bmp->db_numag)
+		if (agpref >= bmp->db_numag)
 			agpref = 0;
 
 		if (atomic_read(&bmp->db_active[agpref]))
diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index 1407feccbc2d0..a360b24ed320c 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -1360,7 +1360,7 @@ int diAlloc(struct inode *pip, bool dir, struct inode *ip)
 	/* get the ag number of this iag */
 	agno = BLKTOAG(JFS_IP(pip)->agstart, JFS_SBI(pip->i_sb));
 	dn_numag = JFS_SBI(pip->i_sb)->bmap->db_numag;
-	if (agno < 0 || agno > dn_numag)
+	if (agno < 0 || agno > dn_numag || agno >= MAXAG)
 		return -EIO;
 
 	if (atomic_read(&JFS_SBI(pip->i_sb)->bmap->db_active[agno])) {
-- 
2.43.0



