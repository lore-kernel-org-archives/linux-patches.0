Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCCE4E533D;
	Thu, 17 Sep 2026 17:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666679; cv=none; b=l/wwysoma/TaaR6jkSEt1jHsA9emiz+lCWVNP0RPmTsMiWnQBSxoYwJLD8SpX+s6yg7itg4qmkegH4COfoVOD3HxDzjxSAhdteSnZV6hHNxeoS9AIcVDmy9rN6crXVsnJmR2XvV6g+sXy0R2cx5DanfVWmCHzzTw4qKTTDoNmpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666679; c=relaxed/simple;
	bh=ZuKKVALXC7SAzRGb0HslKW9V2pqEDiD3ojxbO4Kf3qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8vciv8ZzRkXnvLvbXY9lejPoWOFlJL5WNrOsfEzESL7JzRJv+vtRU9q6Jw2LWW+Bhed/1nIJjrFWiWp2D8nQTa3kpv3WRpPswf4gxfbOteXJElvaxpbIr0gs/esd5Ian2T9fHP3mlIeVgn8pDnpcsWUsT3EJkkZvhkPo2Ww4DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlSez6rj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlSez6rj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779651F00898;
	Thu, 17 Sep 2026 17:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666678;
	bh=UiB2FbOA9eQXAcLbudhE1K3shGzRdO3ziiTnWvrs/Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MlSez6rjx39rAjxsJ5SlDcUORRc1fV3dTJQOL60QKbhuf0jSPdUf9E7EOpNVmb35N
	 iagN+dat39rGa/JtDnxOXgAyTidE9Z9D13OGkhhztgk2UMX421OfQeNx1xoMk3/zBF
	 qNLMThwE3K2TlvvrJYkNcy89dDFcJK/a86ltEWPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1118/1250] xfs: dont leak new_bp if xfs_btree_bload_drop_buf fails
Date: Thu, 17 Sep 2026 16:15:13 +0100
Message-ID: <20260917151622.532000023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit f1930bc578095409c2dcfca6e4e898b24f0f0de6 upstream.

LOLLM observes that in xfs_btree_bload_prep_block,
xfs_btree_bload_drop_buf can hit an IO error if writing the delwri
buffer list to disk fails.  In this case, we fail to release new_bp,
which means we lose a locked buffer.  Fix that.

Cc: stable@vger.kernel.org # v6.8
Fixes: e069d549705e49 ("xfs: constrain dirty buffers while formatting a staged btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_btree_staging.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -337,8 +337,10 @@ xfs_btree_bload_prep_block(
 		xfs_btree_set_sibling(cur, *blockp, &new_ptr, XFS_BB_RIGHTSIB);
 
 	ret = xfs_btree_bload_drop_buf(bbl, buffers_list, bpp);
-	if (ret)
+	if (ret) {
+		xfs_buf_relse(new_bp);
 		return ret;
+	}
 
 	/* Initialize the new btree block. */
 	xfs_btree_init_block_cur(cur, new_bp, level, nr_this_block);


