Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1563133D6CB;
	Tue, 16 Dec 2025 11:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886026; cv=none; b=uI8/9k3VaTb0IGgTjjNafMR9kF+wIC4tqYI8PwcTJFaSD5tnM47KTPK+NSATYgJE0EI2MOp50cM8oJA3+GTnLTe1t5VrnuVSYltjIOZDvs4TQga1R6IqzIsKdzZykoz7jSx9hX2zH/2PAV5u/+U1hogL3MiXUGJHJN5gzcV/QrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886026; c=relaxed/simple;
	bh=imYJzDdvlZCLOiJfdseUYuwIKlLchpY1fgNOBC9/zpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VF8NNxKlowAqBIySTeEwUd28di9G8mhUIUduuD1EdVXcwfRJXNsWh4jZWmUSVTrxK/1Bc4Tx0O5uYquayukA9mgoPW+qFFjs4gAHvWfiGsGTjuy6Yim58SCQQU3F1GbsIYEAuGNQFXRKC1G20qP9dHnIHXZXVsZVBZ2cEDnuMu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vnoz0nH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vnoz0nH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79753C4CEF1;
	Tue, 16 Dec 2025 11:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886025;
	bh=imYJzDdvlZCLOiJfdseUYuwIKlLchpY1fgNOBC9/zpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vnoz0nH+Q/Jr8AvRhAGOv6KIlPkpXz4iIiB/kX+9axCO9EsL0pPn1H5Z3l/kF6Yk9
	 EEa2gZMiBUJBd2AxqeszuECJLvjYJYeFmEWCnPlYWByZUkk8osmaKN51C7LE3aMxEk
	 oZ9G6qawgK2fyuxCv1f69gxpnCOrRajA2bEjOEFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aashish Sharma <aashish@aashishsharma.net>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 282/507] iommu/vt-d: Fix unused invalidation hint in qi_desc_iotlb
Date: Tue, 16 Dec 2025 12:12:03 +0100
Message-ID: <20251216111355.696515907@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aashish Sharma <aashish@aashishsharma.net>

[ Upstream commit 6b38a108eeb3936b21643191db535a35dd7c890b ]

Invalidation hint (ih) in the function 'qi_desc_iotlb' is initialized
to zero and never used. It is embedded in the 0th bit of the 'addr'
parameter. Get the correct 'ih' value from there.

Fixes: f701c9f36bcb ("iommu/vt-d: Factor out invalidation descriptor composition")
Signed-off-by: Aashish Sharma <aashish@aashishsharma.net>
Link: https://lore.kernel.org/r/20251009010903.1323979-1-aashish@aashishsharma.net
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 21b2c3f85ddc5..96823fab06a71 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1100,7 +1100,7 @@ static inline void qi_desc_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 				 struct qi_desc *desc)
 {
 	u8 dw = 0, dr = 0;
-	int ih = 0;
+	int ih = addr & 1;
 
 	if (cap_write_drain(iommu->cap))
 		dw = 1;
-- 
2.51.0



