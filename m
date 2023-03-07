Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D65BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7601DC4339B;
	Tue,  7 Mar 2023 17:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209622;
	bh=6UUeGEX5GlhzaR1SlSF1KWn04741UKjkHzpSXTw1kj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXducqvthLV1cJGJ01F3KEp7cK0Sp2AcmxqUgWR59tOUGD4S7nFmXuQhTLJGfpw6P
	 jX8Ll54bZ0LsQSnRkuR3QkuKeryfJWzgUHiKtWXCSF9mVBD+z3mKlwu/L+Rg4KuyuN
	 HrmW14Jo11KWIJ+ZfzikIEj008T0NlA42ioHMmuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0278/1001] xen/grant-dma-iommu: Implement a dummy probe_device() callback
Date: Tue,  7 Mar 2023 17:50:50 +0100
Message-Id: <20230307170033.728152303@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>

[ Upstream commit 2062f9fb6445451b189595e295765c69f43bc12e ]

Update stub IOMMU driver (which main purpose is to reuse generic
IOMMU device-tree bindings by Xen grant DMA-mapping layer on Arm)
according to the recent changes done in the following
commit 57365a04c921 ("iommu: Move bus setup to IOMMU device registration").

With probe_device() callback being called during IOMMU device registration,
the uninitialized callback just leads to the "kernel NULL pointer
dereference" issue during boot. Fix that by adding a dummy callback.

Looks like the release_device() callback is not mandatory to be
implemented as IOMMU framework makes sure that callback is initialized
before dereferencing.

Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
Fixes: 57365a04c921 ("iommu: Move bus setup to IOMMU device registration")
Signed-off-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Link: https://lore.kernel.org/r/20230208153649.3604857-1-olekstysh@gmail.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/grant-dma-iommu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/grant-dma-iommu.c b/drivers/xen/grant-dma-iommu.c
index 16b8bc0c0b33d..6a9fe02c6bfcc 100644
--- a/drivers/xen/grant-dma-iommu.c
+++ b/drivers/xen/grant-dma-iommu.c
@@ -16,8 +16,15 @@ struct grant_dma_iommu_device {
 	struct iommu_device iommu;
 };
 
-/* Nothing is really needed here */
-static const struct iommu_ops grant_dma_iommu_ops;
+static struct iommu_device *grant_dma_iommu_probe_device(struct device *dev)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+/* Nothing is really needed here except a dummy probe_device callback */
+static const struct iommu_ops grant_dma_iommu_ops = {
+	.probe_device = grant_dma_iommu_probe_device,
+};
 
 static const struct of_device_id grant_dma_iommu_of_match[] = {
 	{ .compatible = "xen,grant-dma" },
-- 
2.39.2



