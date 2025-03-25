Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71069257421;
	Tue, 25 Mar 2025 12:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905662; cv=none; b=rDCWDFThwOfCSJ5yNpIvFbaoD6l1OY2MKo605kVJkTeNbdVb5XZIddKxZnahoZWpfVxVU90iHhMj4+xa3jRSpcVb1gE/iX9mjeltR7bTZpgjkZqWtT5rhlwZVqXLSEkPgGsaZNcu/y6wCTm6OND09Vhybj9BFdsKkvOpbBDA64A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905662; c=relaxed/simple;
	bh=XHgRvtl8/thB413eBD0JfSVHGtpch3RAaqNVPU9HHaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIZYp4rZ9au8X+ucu9lsWdZ5AUazymVVO4O+yPEqpFClaQjl7qa8DY7KYmdLCvQ35xevgsJvdwdhwrSQ/BS6VTLsyG+QQWpfhGiEGesTIXTl2DhANSz8/bY7Smy+3ynRAA7P9d1TMYiGQTfbOELA2sHtUDPystDnhBaVIbxUQbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1M2pbGpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1M2pbGpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DD7C4CEE4;
	Tue, 25 Mar 2025 12:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905662;
	bh=XHgRvtl8/thB413eBD0JfSVHGtpch3RAaqNVPU9HHaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1M2pbGpl/EvNwqoOSv+kfvkaUX2ogCnJY0FhletYqyOntKYTv9kC6VMruECSjtpzn
	 N1teaPdS2GqgmwCtIpBoHClzqZFqc/7rebbOJieR/x8ua3QxybtB5sHwYC1mM1tZGp
	 0nenuav8Xe6tYe+PfVi4Tgg7I2HoQu9CPEjoRaEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 095/198] xfs: recompute growfsrtfree transaction reservation while growing rt volume
Date: Tue, 25 Mar 2025 08:20:57 -0400
Message-ID: <20250325122159.142292957@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 578bd4ce7100ae34f98c6b0147fe75cfa0dadbac ]

While playing with growfs to create a 20TB realtime section on a
filesystem that didn't previously have an rt section, I noticed that
growfs would occasionally shut down the log due to a transaction
reservation overflow.

xfs_calc_growrtfree_reservation uses the current size of the realtime
summary file (m_rsumsize) to compute the transaction reservation for a
growrtfree transaction.  The reservations are computed at mount time,
which means that m_rsumsize is zero when growfs starts "freeing" the new
realtime extents into the rt volume.  As a result, the transaction is
undersized and fails.

Fix this by recomputing the transaction reservations every time we
change m_rsumsize.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_rtalloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1070,6 +1070,9 @@ xfs_growfs_rt(
 			nsbp->sb_rbmblocks;
 		nrsumblocks = XFS_B_TO_FSB(mp, nrsumsize);
 		nmp->m_rsumsize = nrsumsize = XFS_FSB_TO_B(mp, nrsumblocks);
+		/* recompute growfsrt reservation from new rsumsize */
+		xfs_trans_resv_calc(nmp, &nmp->m_resv);
+
 		/*
 		 * Start a transaction, get the log reservation.
 		 */
@@ -1153,6 +1156,8 @@ error_cancel:
 		 */
 		mp->m_rsumlevels = nrsumlevels;
 		mp->m_rsumsize = nrsumsize;
+		/* recompute growfsrt reservation from new rsumsize */
+		xfs_trans_resv_calc(mp, &mp->m_resv);
 
 		error = xfs_trans_commit(tp);
 		if (error)


