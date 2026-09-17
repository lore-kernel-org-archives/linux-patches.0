Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46AD547050;
	Thu, 17 Sep 2026 18:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671248; cv=none; b=G5t1QsmDzVhFACPNuh+XPcHdfBJwU7r4DIEFRZA8bDPAxSJKrNUfBh0cDgEESykgfn/ezdBYaXP5q5q135DNOkbCIubX44C012WMyzxFiaKi8gsjd7nlz8KEPWQQrUfZYIrV7H7iUYZwMRI7EH0FKG6m3Ci+mMJdZE2svtrxHac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671248; c=relaxed/simple;
	bh=kirqQOUQhUR1osDQNoA8h+/hs/qFVO3munUVHzHd1PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjmQgWjnBOvgvRm1ARfBnllR4+R7wehWdtptTlhsP77xbcMxrJ+KX0zgEEvu9MuEiSBiP1x06SbBJw3cGszZ/E5iaqn7+1AAE65g+5REFdRlnAgTxQBMBfkF38VQSTWWI6p2RFnn5DQQvRanDnHbPu+TMxszww+wBeH9s6AxLa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2uTF6En; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2uTF6En"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DD61F000FF;
	Thu, 17 Sep 2026 18:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671247;
	bh=wFJSRDgT3YuqgTXHlpDoRsdkgYIlsyqcuDjmAywcg74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2uTF6En+vbcNldJpXmJPcTGf9zlpG22fntrtWuVajKs247Cn/xIz+ZGYXbaRVXip
	 dWCsL4PECaoy2jMzj7x9OsNNYpF64hRid7Q8R30x7J+bh8r7j543cB2wxNKINqdVP8
	 N4TZ27y3jgodyNcIcywEAwLvOfFRHbDFloGw9t3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0913/1102] xfs: dont leak new_bp if xfs_btree_bload_drop_buf fails
Date: Thu, 17 Sep 2026 16:14:16 +0100
Message-ID: <20260917151603.537492679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -336,8 +336,10 @@ xfs_btree_bload_prep_block(
 		xfs_btree_set_sibling(cur, *blockp, &new_ptr, XFS_BB_RIGHTSIB);
 
 	ret = xfs_btree_bload_drop_buf(bbl, buffers_list, bpp);
-	if (ret)
+	if (ret) {
+		xfs_buf_relse(new_bp);
 		return ret;
+	}
 
 	/* Initialize the new btree block. */
 	xfs_btree_init_block_cur(cur, new_bp, level, nr_this_block);


