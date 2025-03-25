Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846C825743D;
	Tue, 25 Mar 2025 12:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905649; cv=none; b=M1J3gu6+OS2x0LosaiC2LtZDARIjNzn6PH10Lt/CfEJi1PfGSC2O/lu86TJIFjZCtDocVP+5YmCS6qHeqa7cN49cEpu1wo57g9Sv7ZxeNwnWtiKKowQuEorUVDf50aU7fEPVLyeXql1sMF4tO/mdMKMq6J6nw8aLdTIgigQ6Vbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905649; c=relaxed/simple;
	bh=2g+qD3gtPh+3DhfICcL/MiBrVgOQ5ISve/ToXR+N1/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnpJ6Ul+LPImWnYD6BjRlVEF2pxOG0WqfF0a35jU4PHJuns5E3MuI/xaUicQf6Pulfq4jhhHdU8ZDRAmekNUpRlvaUaPvko88isUfImlwtqK4GPUDmSn/JYvL0C/KtHKfhfgbqpSy/OTBpTHb6KlHj4wN0z2u24jiFDSp/a2xQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tFTWN9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tFTWN9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E66C4CEE4;
	Tue, 25 Mar 2025 12:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905649;
	bh=2g+qD3gtPh+3DhfICcL/MiBrVgOQ5ISve/ToXR+N1/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tFTWN9ZEjeMGFbVG1ycSmnh5DlKsIfe+LepehmUCMFpw1spY4K5tkGfgoa4WQnr7
	 CRfYcmuOEYzWsLnWj6qiag2LU7ov6O6Li6eXaSg4LHd/rmcEI4FAqnPGnDPgI3JUjE
	 KDitx9evf6HCnrSgvXvxStV/oIOEVv8iLxjOGEB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 089/198] xfs: consider minlen sized extents in xfs_rtallocate_extent_block
Date: Tue, 25 Mar 2025 08:20:51 -0400
Message-ID: <20250325122158.980156472@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 944df75958807d56f2db9fdc769eb15dd9f0366a ]

minlen is the lower bound on the extent length that the caller can
accept, and maxlen is at this point the maximal available length.
This means a minlen extent is perfectly fine to use, so do it.  This
matches the equivalent logic in xfs_rtallocate_extent_exact that also
accepts a minlen sized extent.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_rtalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -318,7 +318,7 @@ xfs_rtallocate_extent_block(
 	/*
 	 * Searched the whole thing & didn't find a maxlen free extent.
 	 */
-	if (minlen < maxlen && besti != -1) {
+	if (minlen <= maxlen && besti != -1) {
 		xfs_extlen_t	p;	/* amount to trim length by */
 
 		/*


