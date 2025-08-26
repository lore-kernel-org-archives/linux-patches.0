Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F3042AA4;
	Tue, 26 Aug 2025 12:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212699; cv=none; b=VhJqV+qxvbFzakUqNHdzzH9Gm3bBmtCa/fUfKalGW5zTCxyqdoUZL6ldOOf8UU+RkMKEeVOQzY7PfYTSPWVM2A0/SJhZ5ikA15h31v3qyVH0+030NuOvq7Q4bB/+VJfs2NXD/88tN41IlJcDKUrKETHICTwgXcJ6ygDz9fqsOC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212699; c=relaxed/simple;
	bh=FEbGbljXCwzX69Zf4I4LFjfaW8nxzOq2mfDIOmWUWvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QERNFEXHD4m1vcOmhZWS7lYxlHvospY9NUroaFxHA08hkcSXX47iO4kS0J2IIwLagAwZWm1ruIb21d1RyPKqlsF6GGCgb9lLDGA2+LLbjfnMKyl1Y1GN5Zy9W1DcMl9kbX9AJURVzqrrgrcbbtlNqLF06+CCjR6AT2MxtW2BUGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=16xYOPRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="16xYOPRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7498BC4CEF4;
	Tue, 26 Aug 2025 12:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212698;
	bh=FEbGbljXCwzX69Zf4I4LFjfaW8nxzOq2mfDIOmWUWvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=16xYOPRh9zmt7C9OHJB/j2aezd2HVgGDT4o3sugn4iq40V7dUKHAHS4cCzVf4DZPO
	 ywTF4NhAGPDY2d4q2yhps/w8IbsF93xA4vWogO/lng4XYOHsEaxtYmEWN0UZ9+hCRZ
	 2fWZbvuyQNIY4rqY72bsfQ4zK8wmxWvYq2IeKcBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/587] nvme-pci: try function level reset on init failure
Date: Tue, 26 Aug 2025 13:03:38 +0200
Message-ID: <20250826110954.689882131@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 5b2c214a95942f7997d1916a4c44017becbc3cac ]

NVMe devices from multiple vendors appear to get stuck in a reset state
that we can't get out of with an NVMe level Controller Reset. The kernel
would report these with messages that look like:

  Device not ready; aborting reset, CSTS=0x1

These have historically required a power cycle to make them usable
again, but in many cases, a PCIe FLR is sufficient to restart operation
without a power cycle. Try it if the initial controller reset fails
during any nvme reset attempt.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 97ab91a479d1..136dba6221d8 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1755,8 +1755,28 @@ static int nvme_pci_configure_admin_queue(struct nvme_dev *dev)
 	 * might be pointing at!
 	 */
 	result = nvme_disable_ctrl(&dev->ctrl, false);
-	if (result < 0)
-		return result;
+	if (result < 0) {
+		struct pci_dev *pdev = to_pci_dev(dev->dev);
+
+		/*
+		 * The NVMe Controller Reset method did not get an expected
+		 * CSTS.RDY transition, so something with the device appears to
+		 * be stuck. Use the lower level and bigger hammer PCIe
+		 * Function Level Reset to attempt restoring the device to its
+		 * initial state, and try again.
+		 */
+		result = pcie_reset_flr(pdev, false);
+		if (result < 0)
+			return result;
+
+		pci_restore_state(pdev);
+		result = nvme_disable_ctrl(&dev->ctrl, false);
+		if (result < 0)
+			return result;
+
+		dev_info(dev->ctrl.device,
+			"controller reset completed after pcie flr\n");
+	}
 
 	result = nvme_alloc_queue(dev, 0, NVME_AQ_DEPTH);
 	if (result)
-- 
2.39.5



