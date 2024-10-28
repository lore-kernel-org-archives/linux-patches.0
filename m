Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E22189BAF;
	Mon, 28 Oct 2024 06:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097651; cv=none; b=t05rJhj3WSx0x3oFEoEumeC71oquHtK/dIRV694mMbIun67iXfaZPB79kYWutFIJ6b1x1YCDikkbyyjk75pcjHVoPWEKB2zxLli3JJPDtiIdghn9D/N4VwdaXyGkJNIb94oWGM/1/YpMz4yLEbICkIHy33D02+rWqiPj4pLWTsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097651; c=relaxed/simple;
	bh=DwJXaOJrzEn9p64WkLd/Vg0gH369LslyXg5t8nD9YWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBOvngmBezeE3rXBzGrr22GGFYUnCzDPoI0njtLMLAvqEDX2EaCd0Ky8lZ11GViEzV3MDbkmxrD4SJctlb1Ia1eIAKXhDZndhoG2p+dnybMmELSs3/lKssJmBNBOUtUdaluoHgGoZ3/MnP3soECqrTJTd8iER029MTxjXFElRJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avKElBiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avKElBiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF8CC4CEC3;
	Mon, 28 Oct 2024 06:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097651;
	bh=DwJXaOJrzEn9p64WkLd/Vg0gH369LslyXg5t8nD9YWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avKElBiT6B0o3zOOs3wlYsYZ/J0kFKtHJIRqcytSOZeqpWiRs8JQ+qu0//KLHlRGH
	 y0n7VfiCPddG//rJj9usu58VBAbXOvvKnWNYyFYcyGFuQfQkgfif/eDGbyeXDhWd8Z
	 4gKtz4/PICbNuDU91wrtl1hN1+Gn2pofTXDxOoLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Butler <wab@google.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/208] nvme-pci: set doorbell config before unquiescing
Date: Mon, 28 Oct 2024 07:24:27 +0100
Message-ID: <20241028062308.795284180@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: William Butler <wab@google.com>

[ Upstream commit 06c59d427017fcde3107c236177fcc74c9db7909 ]

During resets, if queues are unquiesced first, then the host can submit
IOs to the controller using shadow doorbell logic but the controller
won't be aware. This can lead to necessary MMIO doorbells from being
not issued, causing requests to be delayed and timed-out.

Signed-off-by: William Butler <wab@google.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 26bc0a81f64c ("nvme-pci: fix race condition between reset and nvme_dev_disable()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 32b5cc76a0223..61c9b175e035f 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2757,10 +2757,10 @@ static void nvme_reset_work(struct work_struct *work)
 	 * controller around but remove all namespaces.
 	 */
 	if (dev->online_queues > 1) {
+		nvme_dbbuf_set(dev);
 		nvme_unquiesce_io_queues(&dev->ctrl);
 		nvme_wait_freeze(&dev->ctrl);
 		nvme_pci_update_nr_queues(dev);
-		nvme_dbbuf_set(dev);
 		nvme_unfreeze(&dev->ctrl);
 	} else {
 		dev_warn(dev->ctrl.device, "IO queues lost\n");
-- 
2.43.0



