Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7F71754B;
	Tue,  8 Jul 2025 16:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993190; cv=none; b=QlIMgzY7j5zF+Q8dqNdIKNLCANUN8ffkIgQ4cB+jP6IvRr9TRyYPASpvWycbbwfNKuBSU0hRqlfQVIljywvhtHPcYyuFzDbRm2ykHBUAzJ4cQpNEX2bhjgEH0ybmWXRhFolB6cRG8UUeLuIHAhQTawFt9Y8iD52gTpAdsogbzcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993190; c=relaxed/simple;
	bh=nSGNYPRAUgyB0xTr6og+lGkjC4XAJbUhSVkUDcZ4TZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBr7/p8YWhhUlFZHh3fQyJIAUti+eHSGe8CYuVwMEcK2IgBlyMwPKXtVUUugErngkDpSIbOb49SkXJtaliYwFXGic6gXzXmILjPYfXzAkaJHPRJLmTnxDAQulPHhVJpI9m1NjW7dZDkLU2pzBkRE2pgaAiv696BRfdbpplXfu7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTaaDE5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTaaDE5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE01C4CEED;
	Tue,  8 Jul 2025 16:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993190;
	bh=nSGNYPRAUgyB0xTr6og+lGkjC4XAJbUhSVkUDcZ4TZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTaaDE5mAbPwrDA0KL3OHXaQa82bWM8uFOkZ01uCt7AOnyZrnB5zn8D3PSqT0bOnf
	 OfOsunbRPgKoskQSAVvzVcNTUSMMEAvXTV+XTTeJYT2/bcgcxaaAz4xzm6ngepm5BZ
	 81q3K6B50dW2PB7qXA6+IxqudyYOlRoYmagBtGJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Xue <xxm@rock-chips.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.12 218/232] iommu/rockchip: prevent iommus dead loop when two masters share one IOMMU
Date: Tue,  8 Jul 2025 18:23:34 +0200
Message-ID: <20250708162247.139879382@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Xue <xxm@rock-chips.com>

commit 62e062a29ad5133f67c20b333ba0a952a99161ae upstream.

When two masters share an IOMMU, calling ops->of_xlate during
the second master's driver init may overwrite iommu->domain set
by the first. This causes the check if (iommu->domain == domain)
in rk_iommu_attach_device() to fail, resulting in the same
iommu->node being added twice to &rk_domain->iommus, which can
lead to an infinite loop in subsequent &rk_domain->iommus operations.

Cc: <stable@vger.kernel.org>
Fixes: 25c2325575cc ("iommu/rockchip: Add missing set_platform_dma_ops callback")
Signed-off-by: Simon Xue <xxm@rock-chips.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20250623020018.584802-1-xxm@rock-chips.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/rockchip-iommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -1154,7 +1154,6 @@ static int rk_iommu_of_xlate(struct devi
 	iommu_dev = of_find_device_by_node(args->np);
 
 	data->iommu = platform_get_drvdata(iommu_dev);
-	data->iommu->domain = &rk_identity_domain;
 	dev_iommu_priv_set(dev, data);
 
 	platform_device_put(iommu_dev);
@@ -1192,6 +1191,8 @@ static int rk_iommu_probe(struct platfor
 	if (!iommu)
 		return -ENOMEM;
 
+	iommu->domain = &rk_identity_domain;
+
 	platform_set_drvdata(pdev, iommu);
 	iommu->dev = dev;
 	iommu->num_mmu = 0;


