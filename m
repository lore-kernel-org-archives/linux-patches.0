Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2AE364024;
	Tue, 16 Dec 2025 12:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887773; cv=none; b=uuXQkl9Tiyny/N0Dod7coAtcsDs0JtBl6PzPyUAPcchXMMLPuiOHlnNlZ2WJnb4GG3mMeh08jMQVMmEp4yninJ1y1NTrmNie6sAAmFj4VirwK8vlUr/0BjBs/bHzks375pWpzcD/k2vMr5bAGrBQNLznHSdHASP74dlPwcUiCjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887773; c=relaxed/simple;
	bh=IIaopEyVgrn+WDlDqya3yReZYxxeK+taWKULYtK91FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVec373wMZZyYs5cQ/SSmL7t93+DeR/JClMnDYjrd34AOSCUFjdyLgNNIRjZ92vihbh/kqIO5moqVpYAB1DzWAOq8LhJspUFcN4S0QGKhNmV8whWCutjogAZby6M57ePsnxpS1g96mi8yFrXstt/JvukjFLnkXJtFV5HzAfSgC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VXPvoCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VXPvoCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED42C4CEF1;
	Tue, 16 Dec 2025 12:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887772;
	bh=IIaopEyVgrn+WDlDqya3yReZYxxeK+taWKULYtK91FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2VXPvoCsC1A5qti4OiOyMhm6fiKC/9m6tZUz0f9nlfMeBevkJ1BHd0CZKvxjbCNur
	 KOpxniGV+Eal9CNvKdjO23TOmkSbuAWzD+xkOT9lR/+G3+4LvKl/fhHYAaPbahVDBA
	 Sev48spY94XR4pf0siG8+6emu+q/SJ3IbYcyYqZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aashish Sharma <aashish@aashishsharma.net>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 333/614] iommu/vt-d: Fix unused invalidation hint in qi_desc_iotlb
Date: Tue, 16 Dec 2025 12:11:40 +0100
Message-ID: <20251216111413.430254967@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index 3056583d7f56b..dcc5466d35f93 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1097,7 +1097,7 @@ static inline void qi_desc_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 				 struct qi_desc *desc)
 {
 	u8 dw = 0, dr = 0;
-	int ih = 0;
+	int ih = addr & 1;
 
 	if (cap_write_drain(iommu->cap))
 		dw = 1;
-- 
2.51.0



