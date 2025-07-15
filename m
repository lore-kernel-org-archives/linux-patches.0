Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64122E3AE5;
	Tue, 15 Jul 2025 13:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586337; cv=none; b=jtvJPNAtCTuwYbEWJAosUTw9YlTaI8Kwu2+Duxr4hhxs8eILrqllRM/F3w4azkfxszLTNoICy/zpOHZZCZrYpuWMvE38fNG+LoG7tBABMIqt1VYpLFGJJAot16x/hGFNmlZ/fMYN+hZ8WaK0GmDq0IxwM53CkLNSbAsv1n8j4vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586337; c=relaxed/simple;
	bh=dhZ5rd18J+2oQZRwuPZbj8JWlzu9dJJ0MSVFF1XzzOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQFD7CfbvfSFZBMAU/xT/qnWri/tahBUvAzZxXrFCUl0QAJT/HgT/GxBpP3aN4saVWiSnqaA++xiRaMq7e/Trxd6GQdAzXVT6Wi799TvaWcysmP3O3CMw14aKgJDpE1rMfstMD0SnVCLfgdcGQkEKLWnBzypv33MQLdyAeGCu8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b75i9RWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b75i9RWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D30C4CEE3;
	Tue, 15 Jul 2025 13:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586337;
	bh=dhZ5rd18J+2oQZRwuPZbj8JWlzu9dJJ0MSVFF1XzzOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b75i9RWeLZuGQn4vgiHR3drOi6dnoSxehDB0JrCcZ9cedxiTY9FaaDz+9KqyhhyKk
	 QW9IgTX6PsYUy2HbXsc5zrNEpNKqHmcP3euHVycam3+ENCcfIiabbR2k5SmUGcgWwM
	 L5BcPvACutlzTybd7ZuRFx35huVbBSq3kot97JMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/148] fs/jfs: consolidate sanity checking in dbMount
Date: Tue, 15 Jul 2025 15:12:29 +0200
Message-ID: <20250715130801.404777910@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

[ Upstream commit 0d250b1c52484d489e31df2cf9118b7c4bd49d31 ]

Sanity checks have been added to dbMount as individual if clauses with
identical error handling. Move these all into one clause.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Stable-dep-of: 37bfb464ddca ("jfs: validate AG parameters in dbMount() to prevent crashes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 37 +++++++++----------------------------
 1 file changed, 9 insertions(+), 28 deletions(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index d161bbafe77f6..6bd9ab705cc66 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -178,45 +178,26 @@ int dbMount(struct inode *ipbmap)
 	dbmp_le = (struct dbmap_disk *) mp->data;
 	bmp->db_mapsize = le64_to_cpu(dbmp_le->dn_mapsize);
 	bmp->db_nfree = le64_to_cpu(dbmp_le->dn_nfree);
-
 	bmp->db_l2nbperpage = le32_to_cpu(dbmp_le->dn_l2nbperpage);
-	if (bmp->db_l2nbperpage > L2PSIZE - L2MINBLOCKSIZE ||
-		bmp->db_l2nbperpage < 0) {
-		err = -EINVAL;
-		goto err_release_metapage;
-	}
-
 	bmp->db_numag = le32_to_cpu(dbmp_le->dn_numag);
-	if (!bmp->db_numag || bmp->db_numag > MAXAG) {
-		err = -EINVAL;
-		goto err_release_metapage;
-	}
-
 	bmp->db_maxlevel = le32_to_cpu(dbmp_le->dn_maxlevel);
 	bmp->db_maxag = le32_to_cpu(dbmp_le->dn_maxag);
 	bmp->db_agpref = le32_to_cpu(dbmp_le->dn_agpref);
-	if (bmp->db_maxag >= MAXAG || bmp->db_maxag < 0 ||
-		bmp->db_agpref >= MAXAG || bmp->db_agpref < 0) {
-		err = -EINVAL;
-		goto err_release_metapage;
-	}
-
 	bmp->db_aglevel = le32_to_cpu(dbmp_le->dn_aglevel);
 	bmp->db_agheight = le32_to_cpu(dbmp_le->dn_agheight);
 	bmp->db_agwidth = le32_to_cpu(dbmp_le->dn_agwidth);
-	if (!bmp->db_agwidth) {
-		err = -EINVAL;
-		goto err_release_metapage;
-	}
 	bmp->db_agstart = le32_to_cpu(dbmp_le->dn_agstart);
 	bmp->db_agl2size = le32_to_cpu(dbmp_le->dn_agl2size);
-	if (bmp->db_agl2size > L2MAXL2SIZE - L2MAXAG ||
-	    bmp->db_agl2size < 0) {
-		err = -EINVAL;
-		goto err_release_metapage;
-	}
 
-	if (((bmp->db_mapsize - 1) >> bmp->db_agl2size) > MAXAG) {
+	if ((bmp->db_l2nbperpage > L2PSIZE - L2MINBLOCKSIZE) ||
+	    (bmp->db_l2nbperpage < 0) ||
+	    !bmp->db_numag || (bmp->db_numag > MAXAG) ||
+	    (bmp->db_maxag >= MAXAG) || (bmp->db_maxag < 0) ||
+	    (bmp->db_agpref >= MAXAG) || (bmp->db_agpref < 0) ||
+	    !bmp->db_agwidth ||
+	    (bmp->db_agl2size > L2MAXL2SIZE - L2MAXAG) ||
+	    (bmp->db_agl2size < 0) ||
+	    ((bmp->db_mapsize - 1) >> bmp->db_agl2size) > MAXAG) {
 		err = -EINVAL;
 		goto err_release_metapage;
 	}
-- 
2.39.5



