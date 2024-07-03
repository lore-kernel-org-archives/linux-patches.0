Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4E3181CE6;
	Wed,  3 Jul 2024 11:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004789; cv=none; b=TB7MMfxzIy/lHWOVmrfMRWlOd4GBsctgMGL+l5oCcEfsWkDz7OcOHQAuWGOVYppsU9VM/IU5GG5Q41ZUX5GsYO0Uvl/GgD/oiwboKloeVVIEQazn29IasP8gVGpBpHCVDNRgaF5UO5srLbvfOc2YnOZqZEhhDzRZ+gvXwEuz+Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004789; c=relaxed/simple;
	bh=yB7t6Kyez1TolSsLI2gltSdVPCk9d1uxVmt3Gq5Qz2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCSpQRtE6ySSqr7lb1+c1lG+T4TnUsNT/GjyGZ4CVvlYOIhfFL0mvbdOTVgoIZ9xIf8lvjbHz2i/CQmDkB/9Pj1SPD1MD/mXpRXrQKLIXzxfPlWWGiceprUjB2o8wxmOWI9qRVu2T/LL5ownYt6YsTD/57kw3ePVSzEIVusnjjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neK+kD9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neK+kD9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D528EC32781;
	Wed,  3 Jul 2024 11:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004789;
	bh=yB7t6Kyez1TolSsLI2gltSdVPCk9d1uxVmt3Gq5Qz2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=neK+kD9NwKVpYyl3CSg6r/m79geGFvRa/eaQydGYKu80FUL2rZwrwHTlkoHXzs5gr
	 wM5D0ETg4GYYa8Uhev++qZmvLuqkcIY5KxJFTlRp2tHgVUkpU08JSDgnvekhSUexfh
	 vqZ44J5E9bU/ulEZM4M9Gd4t6+4jAGdJ1zy19skg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Aprelkov <aaprelkov@usergate.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/290] iommu/arm-smmu-v3: Free MSIs in case of ENOMEM
Date: Wed,  3 Jul 2024 12:38:29 +0200
Message-ID: <20240703102909.021653701@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Aprelkov <aaprelkov@usergate.com>

[ Upstream commit 80fea979dd9d48d67c5b48d2f690c5da3e543ebd ]

If devm_add_action() returns -ENOMEM, then MSIs are allocated but not
not freed on teardown. Use devm_add_action_or_reset() instead to keep
the static analyser happy.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Aleksandr Aprelkov <aaprelkov@usergate.com>
Link: https://lore.kernel.org/r/20240403053759.643164-1-aaprelkov@usergate.com
[will: Tweak commit message, remove warning message]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 982c42c873102..9ac7b37290eb0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2925,7 +2925,7 @@ static void arm_smmu_setup_msis(struct arm_smmu_device *smmu)
 	}
 
 	/* Add callback to free MSIs on teardown */
-	devm_add_action(dev, arm_smmu_free_msis, dev);
+	devm_add_action_or_reset(dev, arm_smmu_free_msis, dev);
 }
 
 static void arm_smmu_setup_unique_irqs(struct arm_smmu_device *smmu)
-- 
2.43.0



