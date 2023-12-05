Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E9F6FB1;
	Tue,  5 Dec 2023 03:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xafeXwzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F138DC433C7;
	Tue,  5 Dec 2023 03:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747156;
	bh=OWMmLA8sLE0mvJ3e8K/pIJesV0LPjIy36Za9uNGSml0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xafeXwzKbOge/lA/m4ArL27ZE4xawGyy7djkmPcVcLIuOX1ro4z5FOzKMDRM2w7K/
	 37cch/xBf2kwQP8cRagXJSRaf+CzdRCKKCtR2JHMTLoH5stA2EhkNLQVnWTke2aOvz
	 jHeGkg57lDd492Y8maDBAxutn1ytKb/YUMDShhk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Batra <gbatra@linux.vnet.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/107] powerpc/pseries/iommu: enable_ddw incorrectly returns direct mapping for SR-IOV device
Date: Tue,  5 Dec 2023 12:16:55 +0900
Message-ID: <20231205031536.554380972@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaurav Batra <gbatra@linux.vnet.ibm.com>

[ Upstream commit 3bf983e4e93ce8e6d69e9d63f52a66ec0856672e ]

When a device is initialized, the driver invokes dma_supported() twice -
first for streaming mappings followed by coherent mappings. For an
SR-IOV device, default window is deleted and DDW created. With vPMEM
enabled, TCE mappings are dynamically created for both vPMEM and SR-IOV
device.  There are no direct mappings.

First time when dma_supported() is called with 64 bit mask, DDW is created
and marked as dynamic window. The second time dma_supported() is called,
enable_ddw() finds existing window for the device and incorrectly returns
it as "direct mapping".

This only happens when size of DDW is big enough to map max LPAR memory.

This results in streaming TCEs to not get dynamically mapped, since code
incorrently assumes these are already pre-mapped. The adapter initially
comes up but goes down due to EEH.

Fixes: 381ceda88c4c ("powerpc/pseries/iommu: Make use of DDW for indirect mapping")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Gaurav Batra <gbatra@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231003030802.47914-1-gbatra@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/iommu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 97b026130c71b..ad089d3f2d7c1 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -909,7 +909,8 @@ static int remove_ddw(struct device_node *np, bool remove_prop, const char *win_
 	return 0;
 }
 
-static bool find_existing_ddw(struct device_node *pdn, u64 *dma_addr, int *window_shift)
+static bool find_existing_ddw(struct device_node *pdn, u64 *dma_addr, int *window_shift,
+			      bool *direct_mapping)
 {
 	struct dma_win *window;
 	const struct dynamic_dma_window_prop *dma64;
@@ -922,6 +923,7 @@ static bool find_existing_ddw(struct device_node *pdn, u64 *dma_addr, int *windo
 			dma64 = window->prop;
 			*dma_addr = be64_to_cpu(dma64->dma_base);
 			*window_shift = be32_to_cpu(dma64->window_shift);
+			*direct_mapping = window->direct;
 			found = true;
 			break;
 		}
@@ -1275,10 +1277,8 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 
 	mutex_lock(&dma_win_init_mutex);
 
-	if (find_existing_ddw(pdn, &dev->dev.archdata.dma_offset, &len)) {
-		direct_mapping = (len >= max_ram_len);
+	if (find_existing_ddw(pdn, &dev->dev.archdata.dma_offset, &len, &direct_mapping))
 		goto out_unlock;
-	}
 
 	/*
 	 * If we already went through this for a previous function of
-- 
2.42.0



