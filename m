Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974B7342513;
	Tue, 16 Dec 2025 11:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884418; cv=none; b=r73BfKel6YUkvMga5mJgX792vPwd3Xe1aqsSrCDEI5xBaygTAXxcxwhctPae5ZxCZJUmo6SpxOyBFcOytf7beJIANXffsebnV6+DBiz3tU1KWGrrnX61o+gXN702RsdOx+V6xgsi3UaXCgQ/WyZSmQaCL/1SCt7YC61LqPs6IuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884418; c=relaxed/simple;
	bh=LKT5eb4VpfryV5tkY5URNaiWcD+ssFgjhGo4JAKHkr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNUstUT0QnhGDt2v9wQYOHWeBRDdTAMa3HzYaeTtOrXSJqU8pjF2GG7rWMWhnq+vhNHYh3N+p1JnV/oewnpohnxq1R+cniL+/G1Utyqs6pyy758+EuBojPYmOG2WNTcAgUCJ2uJGzP35sM6M4ZIu2wZrHA34CZKuyyfK+EUq4rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4WEnjVB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4WEnjVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199C4C4CEF1;
	Tue, 16 Dec 2025 11:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884418;
	bh=LKT5eb4VpfryV5tkY5URNaiWcD+ssFgjhGo4JAKHkr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4WEnjVBtwSxpGrGZ+epGEUfNi2B/oZd6t8co2jOoOUYcQjn+gi/kSZAc5ansamZp
	 3TaCpnYklb6GdV6/t96umUH24eoTIQmJiW0LOEQQFNcnBq6nzEqdfdqyumL7dfGN0R
	 hyleMqTfNLLBWMVJHCRoaC/pVD9O0zk7FBGIRhzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aashish Sharma <aashish@aashishsharma.net>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 188/354] iommu/vt-d: Fix unused invalidation hint in qi_desc_iotlb
Date: Tue, 16 Dec 2025 12:12:35 +0100
Message-ID: <20251216111327.724600031@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index df24a62e8ca40..5b5f57d694afd 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1088,7 +1088,7 @@ static inline void qi_desc_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 				 struct qi_desc *desc)
 {
 	u8 dw = 0, dr = 0;
-	int ih = 0;
+	int ih = addr & 1;
 
 	if (cap_write_drain(iommu->cap))
 		dw = 1;
-- 
2.51.0



