Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18DE149C69;
	Tue, 25 Jun 2024 09:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308948; cv=none; b=CUt5LxSufsMcZoHsKdCGiFVBO/jrE31xfIS0PjqxzPbzncOH8LxyCaoJzpSP1M3AO5hpPE70wejgBUuvDrw8TXF1yuhbRB6nZ7Ved4RZMjsSQTHNIIYiDsKdk6FyuzUwCBsBxURiE4F6kGTLzqxjoyAOuM5X7W8/ArRicKBorPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308948; c=relaxed/simple;
	bh=A350TWNHpG7XvLZ3qhsVeEyZk3JPCiHSaQdgpmrVAq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3eMbrH4WVAaNQD9Vpd/tJfH9+j7wM9mkWHdODGy5IkuVfccQ+w9cCGhSzOA3I97PGakAY5x+Xmlh3Fsj7sIV0v20GWDY0YrQRooypAqj2AHWV8Qcue9b7fLZruDZKpmJRQx5oUodGt/pjCU3JIv/R25CwkmbNvFL8Flmkqc/6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRdeQkDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRdeQkDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA8EC32786;
	Tue, 25 Jun 2024 09:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308947;
	bh=A350TWNHpG7XvLZ3qhsVeEyZk3JPCiHSaQdgpmrVAq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRdeQkDNGx1+g7o40VFWyr40WamAs6pDHnqj2qU0NHzqv1ZYzFFvTgy4NuJXXgCcS
	 xR2a0IAZ0bYGYETSizvSjACRr0syOeiJEHPpHyeRBbYQNf9sV0AjOc/GoDNoPVVX+f
	 srfaArIEhjBBCIaQNlIJd9wspUEN2N3O7jotgsxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Aprelkov <aaprelkov@usergate.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/192] iommu/arm-smmu-v3: Free MSIs in case of ENOMEM
Date: Tue, 25 Jun 2024 11:31:54 +0200
Message-ID: <20240625085538.781239648@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bd0a596f9863a..68b81f9c2f4b1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3193,7 +3193,7 @@ static void arm_smmu_setup_msis(struct arm_smmu_device *smmu)
 	smmu->priq.q.irq = msi_get_virq(dev, PRIQ_MSI_INDEX);
 
 	/* Add callback to free MSIs on teardown */
-	devm_add_action(dev, arm_smmu_free_msis, dev);
+	devm_add_action_or_reset(dev, arm_smmu_free_msis, dev);
 }
 
 static void arm_smmu_setup_unique_irqs(struct arm_smmu_device *smmu)
-- 
2.43.0



