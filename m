Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C3D145B27;
	Tue, 21 Jul 2026 17:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654629; cv=none; b=t1fsVT9hRjegR4eY3os6jtSxgYKiPjwRvvVTd7p9UvFV+8PbCjIq/LUNJqy7gFexMFggq1b8Q7B+U5R8nrtfvY4eUQHFwDPykkbBHvtG0EihUlN1HzxrO0Mi+fea6ShmUWuH/DU5laAsXfHdwH7vE0t9ZMAcynEVPt5cE5Un7AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654629; c=relaxed/simple;
	bh=1lXp9vDt9/4PjX31ifWR2re3twMZ7Co75E0NRY1pMbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVx7bvBUaO0ve7EOwEcgoN377ZFl6UfWWdlqlKuEMUwqzlvMSX0V5C4ew7KMmQI/dpCM40ivGj7G5iQsGLtUzWlnsg6qK0an82nLFs3NDUMyjz7XxI5vdFusm6kcQO6zaTgTYUuqIzN6U2fJVRo8LWkaGWg7yviwR7KNUEXrT0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIXKxyWk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIXKxyWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE061F000E9;
	Tue, 21 Jul 2026 17:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654628;
	bh=xXvs9kj6ltEqA2zemDirvlzkS+i1TXdmE0ua0a1++jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gIXKxyWkuQ9eKtPuoj1qUTQW9fkWFtDNXZ2utSF434Zog8CbbcDbWKhJWkSmcr/um
	 LSFi5CO340uZyHV448mhEg+Ptt3IYS8GGfru04BjB9yZeQen647DZmJ28P0bAb+4Jv
	 CRmNCcdzU5+YV+I/tTVjv5WmNTscXblFJXzVgzr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 7.1 1777/2077] dmaengine: dw-edma-pcie: Reject devices without driver data
Date: Tue, 21 Jul 2026 17:24:10 +0200
Message-ID: <20260721152634.665299313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit 11d7cfe0c119691b2dafbb699bbca90258c678aa upstream.

dw_edma_pcie_probe() treats the PCI device ID driver_data as the
template for the controller layout and copies it unconditionally. A
device bound dynamically via sysfs can match the driver without that
data, which leads to a NULL pointer dereference.

Reject such matches before enabling the device.

Fixes: 41aaff2a2ac0 ("dmaengine: Add Synopsys eDMA IP PCIe glue-logic")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260521142153.2957432-3-den@valinux.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-edma-pcie.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/dma/dw-edma/dw-edma-pcie.c
+++ b/drivers/dma/dw-edma/dw-edma-pcie.c
@@ -314,6 +314,9 @@ static int dw_edma_pcie_probe(struct pci
 	int i, mask;
 	bool non_ll = false;
 
+	if (!pdata)
+		return -ENODEV;
+
 	struct dw_edma_pcie_data *vsec_data __free(kfree) =
 		kmalloc_obj(*vsec_data);
 	if (!vsec_data)


