Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB96C1C07C9;
	Tue, 15 Oct 2024 13:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997224; cv=none; b=BQhXYT+l3/bRRCZO2uy07h7Fbhzq9jV7O0MhLhT1/VS3cV/Odhx0fClVxS+zAeyIpExYfH+iAfGySdu6iHJzZ58KwZcA3DN9+07iogNgi9LkGSCbSDpdHGcwLaiaYHrioEadu/GVwh+5C5qy9Ru4MtEx4irE7Zu9GVO9Lg55chg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997224; c=relaxed/simple;
	bh=tseIqRELrryyXVkJdwawwaVJ7y24KGtdiQ1uqe8yXvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phQLo8efYaNEikohWouDNV7mDjlN7XtHCIf2V4BmATxBD+4RPLx4/ijsEMlDYr/2O9GmGfk3smBmpj+yPN8BYHGJGeBmz/uprecX1DB9fud1HE+LMUK77r3SBkIoGwnYFRaeEkvQFPC+nNrGdj/WIpNF/oX0dEglpnf8I0ckuHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1ITV8RS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1ITV8RS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2996C4CEC6;
	Tue, 15 Oct 2024 13:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997224;
	bh=tseIqRELrryyXVkJdwawwaVJ7y24KGtdiQ1uqe8yXvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1ITV8RSdvCBIG8uiHHHU4VJshne5DbI0dTSSw3EuLiZdWOaXBYDj9jooueswRPh/
	 dpthNNBSmh4Kaa0SZhT044b1NddLqyBw/DeX5XHDfUXsWI5WNFOBeV1MyeFzlzLjvv
	 /Xmva1Oaj9W8t8+Z9OCSG39cyzc1dVwp79h4jCLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/518] jfs: fix out-of-bounds in dbNextAG() and diAlloc()
Date: Tue, 15 Oct 2024 14:40:26 +0200
Message-ID: <20241015123921.704478703@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9b6849b9bfdb9..801996da08a45 100644
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
index 36ed756820648..da3a1c27d3498 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -1362,7 +1362,7 @@ int diAlloc(struct inode *pip, bool dir, struct inode *ip)
 	/* get the ag number of this iag */
 	agno = BLKTOAG(JFS_IP(pip)->agstart, JFS_SBI(pip->i_sb));
 	dn_numag = JFS_SBI(pip->i_sb)->bmap->db_numag;
-	if (agno < 0 || agno > dn_numag)
+	if (agno < 0 || agno > dn_numag || agno >= MAXAG)
 		return -EIO;
 
 	if (atomic_read(&JFS_SBI(pip->i_sb)->bmap->db_active[agno])) {
-- 
2.43.0



