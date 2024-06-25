Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6021E14A0B3;
	Tue, 25 Jun 2024 09:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308365; cv=none; b=g2wiP2UKFxAo/7L3fU52o+gMNKXUOKN9PkVLfWkiYlvdJutN7LWhn9X+OeodWz5Utda4Sgs4kpukAQurPeuo1m19ckCq/zlrYMHb5RIJU5Cww2M+x19+SIHsUmlLP2ogxcYtnjQ1OfpVy/vtM/zzz3s1z5Viwb+jXiOXgeBKXfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308365; c=relaxed/simple;
	bh=JPe0cmdRC1gC6jSoxv0xFjbgUouv6q10bK5rSjuZiPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZJMyJJxTqXe2pSlmpCYxt/mwfFONL124S1W2s2+xTebh+w1YsnYoZFBNyBYmvPIAAr80f06zdA/Ndy2Mnx1rqyUwH5u0mLiGRKt6WmcDACw289nOYpPPN+Bu43i5mYdB+VwCUvwuitqNX+krkA26aXYbnaevZ+USaWuLw/hV9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtSEYchj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtSEYchj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBECC32781;
	Tue, 25 Jun 2024 09:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308365;
	bh=JPe0cmdRC1gC6jSoxv0xFjbgUouv6q10bK5rSjuZiPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtSEYchj1fTgpU/t/5cCE4UAYo1AzZg7RUWpJM67NejJ6yRPr6MCdApwECJLm+/Or
	 X4g2VdxfBr9hUCmmNWJBmeOxEV1Ay97xo8VhEowsMzIQZFhycA+vETkriwBkYi+XAD
	 djV2ncxbWeNZL53im7n5ne0hGr5VHZRtg2S04KbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Aprelkov <aaprelkov@usergate.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 066/250] iommu/arm-smmu-v3: Free MSIs in case of ENOMEM
Date: Tue, 25 Jun 2024 11:30:24 +0200
Message-ID: <20240625085550.598631006@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 41f93c3ab160d..3afec8714cf28 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3402,7 +3402,7 @@ static void arm_smmu_setup_msis(struct arm_smmu_device *smmu)
 	smmu->priq.q.irq = msi_get_virq(dev, PRIQ_MSI_INDEX);
 
 	/* Add callback to free MSIs on teardown */
-	devm_add_action(dev, arm_smmu_free_msis, dev);
+	devm_add_action_or_reset(dev, arm_smmu_free_msis, dev);
 }
 
 static void arm_smmu_setup_unique_irqs(struct arm_smmu_device *smmu)
-- 
2.43.0



