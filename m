Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC71B13792B;
	Thu, 12 Dec 2024 17:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022951; cv=none; b=rxHy4LdbXRgJ8J9sGZ2ndRHEG9QJbR/UgEpE9tEsbELhuiDuCjZfKhY3anJsiJsmF1A2eIFcFuKFJO8S4xzBisLhtvB4N6bpusIKLKMeHVK/ccpa16+yolZHdqBXQbBVkToSM6xgjPrl3wv6nc2FzOJel9UE76CB5gquCHJ7Frs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022951; c=relaxed/simple;
	bh=YxyH301M1I4eGGU0ViY5Nh96A38eEPIUy6P6E3BLSkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKbf662Y5chLTUlw0n6fXnu+iCPgfZa14XvL1QqfHSnh1GO3awb0x4/Wsk6H0h26QsTxaRusVsCz+KW5LfkHmQPNgKZg6mLzH2UI/Noaaq6eVlv2tzMQ7RuEJ8x4nUb7GtKsAkgsFfmOK7Dq2sT+4HFMqdsafuYppGPjMOYWEr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGGZxse0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGGZxse0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE0EC4CECE;
	Thu, 12 Dec 2024 17:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022950;
	bh=YxyH301M1I4eGGU0ViY5Nh96A38eEPIUy6P6E3BLSkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGGZxse0V/YsHyuPORaLfFWIHcXZ1DUBBjdFCk5CX++3zyk8ZgJBjk9LUzICXIbQE
	 GqRS5Kb3mOx/gnqSM58thLHHSAKqeej/79fxzvJyWgJMU54Pih9OdsTRojeTmGxIxa
	 vkpmpA10WCndzNl13LGjj3NvjMVqiNb+h1CTl8oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 377/565] xfs: remove unknown compat feature check in superblock write validation
Date: Thu, 12 Dec 2024 15:59:32 +0100
Message-ID: <20241212144326.530483878@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 652f03db897ba24f9c4b269e254ccc6cc01ff1b7 ]

Compat features are new features that older kernels can safely ignore,
allowing read-write mounts without issues. The current sb write validation
implementation returns -EFSCORRUPTED for unknown compat features,
preventing filesystem write operations and contradicting the feature's
definition.

Additionally, if the mounted image is unclean, the log recovery may need
to write to the superblock. Returning an error for unknown compat features
during sb write validation can cause mount failures.

Although XFS currently does not use compat feature flags, this issue
affects current kernels' ability to mount images that may use compat
feature flags in the future.

Since superblock read validation already warns about unknown compat
features, it's unnecessary to repeat this warning during write validation.
Therefore, the relevant code in write validation is being removed.

Fixes: 9e037cb7972f ("xfs: check for unknown v5 feature bits in superblock write verifier")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f867da8128ca6..3175e3620a418 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -256,13 +256,6 @@ xfs_validate_sb_write(
 	 * the kernel cannot support since we checked for unsupported bits in
 	 * the read verifier, which means that memory is corrupt.
 	 */
-	if (xfs_sb_has_compat_feature(sbp, XFS_SB_FEAT_COMPAT_UNKNOWN)) {
-		xfs_warn(mp,
-"Corruption detected in superblock compatible features (0x%x)!",
-			(sbp->sb_features_compat & XFS_SB_FEAT_COMPAT_UNKNOWN));
-		return -EFSCORRUPTED;
-	}
-
 	if (!xfs_is_readonly(mp) &&
 	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
 		xfs_alert(mp,
-- 
2.43.0



