Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D819E571;
	Mon, 14 Oct 2024 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915877; cv=none; b=TtE0FWvobntOYiEYhIlQ/UdCoKLepvV4DmYNY6OS3GCzi0q/ck7RcrErTGAHq71qkugUAQmpO7bVlLGsfmwE37V8MKzOLTxxz+x+Fqve8UMAi9EP5OnS0mBPFyI6McBWfR5uBEgpRM3vNVOYT3t1SXd5rgX8YIrrZnwbfK1hsww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915877; c=relaxed/simple;
	bh=GoaL2BArruFLiZ2CyJzK2rBUa+59JR1NiJjf8/mzBpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbl7E5E9WKE+0gtkxR0+lsebHFKIbGh3GAi5c8y04ajWDb2Jj6KUI1Pu9EjbZPMJWyLtvBH0cZjjjgezrWofPCsXAPZ/kRBiIOFUOqeYO/NFDOLC6Uw/Nj5PHyRLWRA/r5IijrX1Hoj7mZWHPjzcx/L4eDkPoswhv2QGjwYQAaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1VxVGVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1VxVGVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD8DC4CEC3;
	Mon, 14 Oct 2024 14:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915876;
	bh=GoaL2BArruFLiZ2CyJzK2rBUa+59JR1NiJjf8/mzBpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1VxVGVq+tp2RijvWSW2RyS/iH5ap72hGAzei0L7iGmpkBEJNsuYl/R4ZZUlTMIHQ
	 gXYdwq7n4bVn9GDrpiTaetReeJlla5jsHFH5eog29ax9NBVKqMBGI82YHIyrBZyOla
	 4iUoHYLiQERqXzHLAj/jdmi8rVZDgeH6P+ZK9fIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 004/214] fs/ntfs3: Optimize large writes into sparse file
Date: Mon, 14 Oct 2024 16:17:47 +0200
Message-ID: <20241014141045.163253948@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit acdbd67bf939577d6f9e3cf796a005c31cec52d8 ]

Optimized cluster allocation by allocating a large chunk in advance
before writing, instead of allocating during the writing process
by clusters.
Essentially replicates the logic of fallocate.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index cddc51f9a93b2..d31eae611fe06 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -408,6 +408,42 @@ static int ntfs_extend(struct inode *inode, loff_t pos, size_t count,
 		err = 0;
 	}
 
+	if (file && is_sparsed(ni)) {
+		/*
+		 * This code optimizes large writes to sparse file.
+		 * TODO: merge this fragment with fallocate fragment.
+		 */
+		struct ntfs_sb_info *sbi = ni->mi.sbi;
+		CLST vcn = pos >> sbi->cluster_bits;
+		CLST cend = bytes_to_cluster(sbi, end);
+		CLST cend_v = bytes_to_cluster(sbi, ni->i_valid);
+		CLST lcn, clen;
+		bool new;
+
+		if (cend_v > cend)
+			cend_v = cend;
+
+		/*
+		 * Allocate and zero new clusters.
+		 * Zeroing these clusters may be too long.
+		 */
+		for (; vcn < cend_v; vcn += clen) {
+			err = attr_data_get_block(ni, vcn, cend_v - vcn, &lcn,
+						  &clen, &new, true);
+			if (err)
+				goto out;
+		}
+		/*
+		 * Allocate but not zero new clusters.
+		 */
+		for (; vcn < cend; vcn += clen) {
+			err = attr_data_get_block(ni, vcn, cend - vcn, &lcn,
+						  &clen, &new, false);
+			if (err)
+				goto out;
+		}
+	}
+
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	mark_inode_dirty(inode);
 
-- 
2.43.0



