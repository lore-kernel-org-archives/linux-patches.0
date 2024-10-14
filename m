Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37481C8773;
	Mon, 14 Oct 2024 14:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917741; cv=none; b=EDrsuEaq8Z63sLOq2eq/8XKjSuPUZv8MbCtQMB2k+rakfgpHZ6aTyTbqP7BdcnATXmUECPZIfnhhAtxsw+MEad+2Er6IuJUi3veX2S6X1I4nyTyw1XiM/vj6PsRNnZcwIzqZtFKagc0i6pwpM18ocUggLRrm+aKmkqXFmhTPlf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917741; c=relaxed/simple;
	bh=q5Cs6/HUmLPkeGxi7S8yDLxFjn2qFkGT69LbIwgHSEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRWeXqdK1v4519L2vSamW0be6moy/oM/ufxHqTS212t1C7CKY0vpwG0GNlzc6lwf1THf8N5tzHNJIA+6UbLY0D5oceZlLNXjYp3sjJod02uWR7pmzC3BEDh4+/3FQiptUzRmB7bA9W7Fp0Fjtq/rKyGf7p8zg+xsQbAc30kQdGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Br8OwcTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Br8OwcTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12761C4CEC3;
	Mon, 14 Oct 2024 14:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917741;
	bh=q5Cs6/HUmLPkeGxi7S8yDLxFjn2qFkGT69LbIwgHSEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Br8OwcTkKXWTYHq4tJatIVyB6+SHXwwNGLHZ5Mlu9ulst2Z+FU53Y8OHOJUz1RGTt
	 ff6o+BOsl1YWxCyO3hhVxKF5XWcekiAs/ymEje+iLDUFtu6KwoFHW8zjgr4X74vU0y
	 OXoBNA9cMgNMTjztETi8+IqmkhW6pDSlDXZK71xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/798] jfs: fix out-of-bounds in dbNextAG() and diAlloc()
Date: Mon, 14 Oct 2024 16:11:13 +0200
Message-ID: <20241014141222.596465816@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index d2df00676292d..bc645014b2849 100644
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
index ba6f28521360b..c72e97f065798 100644
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



