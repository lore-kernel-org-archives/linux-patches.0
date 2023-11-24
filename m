Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB3A39FC3;
	Fri, 24 Nov 2023 18:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q19CX6uH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C074C433C7;
	Fri, 24 Nov 2023 18:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849920;
	bh=v0SWq/eqiQigrDjrqV/CxQ/uefUk1fVD6DMLAobgQu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q19CX6uHu8Q8g+vCoOrEH7oELqPi63p3CsvIo82Wa3Jn7XP80DCX+p/fpnjz3O2I4
	 PXFHvDRBTa8gQbulEVNEsbWvUTYd0qrQyhhv0az2NqRVXIbN9M0QGoR2UNIRcJXpHu
	 nAuo+0KLHGLNYUvrPuA8KaV1GPey0wKSd5g5k8k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Batra <gbatra@linux.vnet.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.6 373/530] powerpc/pseries/iommu: enable_ddw incorrectly returns direct mapping for SR-IOV device
Date: Fri, 24 Nov 2023 17:48:59 +0000
Message-ID: <20231124172039.363757082@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Gaurav Batra <gbatra@linux.vnet.ibm.com>

commit 3bf983e4e93ce8e6d69e9d63f52a66ec0856672e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/iommu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -914,7 +914,8 @@ static int remove_ddw(struct device_node
 	return 0;
 }
 
-static bool find_existing_ddw(struct device_node *pdn, u64 *dma_addr, int *window_shift)
+static bool find_existing_ddw(struct device_node *pdn, u64 *dma_addr, int *window_shift,
+			      bool *direct_mapping)
 {
 	struct dma_win *window;
 	const struct dynamic_dma_window_prop *dma64;
@@ -927,6 +928,7 @@ static bool find_existing_ddw(struct dev
 			dma64 = window->prop;
 			*dma_addr = be64_to_cpu(dma64->dma_base);
 			*window_shift = be32_to_cpu(dma64->window_shift);
+			*direct_mapping = window->direct;
 			found = true;
 			break;
 		}
@@ -1270,10 +1272,8 @@ static bool enable_ddw(struct pci_dev *d
 
 	mutex_lock(&dma_win_init_mutex);
 
-	if (find_existing_ddw(pdn, &dev->dev.archdata.dma_offset, &len)) {
-		direct_mapping = (len >= max_ram_len);
+	if (find_existing_ddw(pdn, &dev->dev.archdata.dma_offset, &len, &direct_mapping))
 		goto out_unlock;
-	}
 
 	/*
 	 * If we already went through this for a previous function of


