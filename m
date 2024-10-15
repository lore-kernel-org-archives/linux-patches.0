Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2841B1D9A42;
	Tue, 15 Oct 2024 11:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992637; cv=none; b=oiwnrPyM4ByMseLn7WUv3AuCUD0MRCsTxQzKFi0z6sqKV8XfNFD/nWDCDr84RVJgiWteoM/i5ycikrTYUd4gN9fChjK1J/qeQX5kxkMImouA1GyTxkM7W402SoYJ9w/fLli2ccdHp3FITHJmdlWMvdt0Ib88hCLLNWlF8H+20HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992637; c=relaxed/simple;
	bh=9aZCCdqIATW/4oowozvTaqTVf1WwfCKKI7lpVJbXI5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbXPyEszzf5F64HiVoPXqFKKTO1eZLfBXcMJ+ON73zklYsryu7v3Cs0M8G+tasAyT6jI7q7lK8JU4vrYiqL4YCn0MtmMadTiR2JBM1XBNylUm62GLACk97UjIP88HKHG6R+W6zeNf9KECZXMLrpOMqGc0GFEIeeZQp0KUH1h2Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfW5mNX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfW5mNX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D491C4CEC6;
	Tue, 15 Oct 2024 11:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992637;
	bh=9aZCCdqIATW/4oowozvTaqTVf1WwfCKKI7lpVJbXI5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfW5mNX0RlZ9Af3p48DRdKBcPQgrMg+ydzSEi71v97igFlc+h2euObxjsm4/VZLj6
	 nCkGkf/oNOV1T0lafmIEC5WsAMCKaG6ijLrtYDWbHNK3sLKxq2C/OeyZtRN6xQGYx9
	 76UCrRHYUXNBEzHMPVgFDbsGUh1kt0RtGXyFr+44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 173/691] jfs: fix out-of-bounds in dbNextAG() and diAlloc()
Date: Tue, 15 Oct 2024 13:22:01 +0200
Message-ID: <20241015112447.232203476@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3f5c14315719b..625457e94b30a 100644
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



