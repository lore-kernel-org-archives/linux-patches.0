Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227DE44AB98;
	Thu, 30 Jul 2026 15:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425158; cv=none; b=pAxcm3ZShvzRa0Dq1Ze/W9GDsY20F0ij583YqGqlpQZnS8HIKoPBhbjJOBsf65uwpY+otfqYv0t2d7hawNSbD4RkAFxZmS2QcixFnd9R9z4lVNshnppdyAND2sHMP9vCFxbVQmgzukiONSa8AAmYptDjZ/rwcHN7K3lLC6dpgnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425158; c=relaxed/simple;
	bh=keF2lQBYlDdS3Lg/JduN6DLW77tOK0aU23ykl9ZJXeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpRElXj3eb8diBdptewxt7zmHrTS/mLnef4AJWv0C9PqorfVBhRzr0rbboneUqzRXf8hJpZR+z6GyBSzbMTs+RPjpQ2Np1hy50yNBrsdUi54ioUlbEeCP7Ie9M1N4udfPjyaRvpjFfqTFUPwHqPjiK16pkWZZvm/W8rwH+jdGZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2n8vMyi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2n8vMyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA5A1F00A3D;
	Thu, 30 Jul 2026 15:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425157;
	bh=J1yUEIoeezJzWidju1g8lI92nudDA7u96g27rFwxZ3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d2n8vMyiJdB0ZrR4MdFx7pQZDR+RAPICl1SgG7tVLhf2eGWGHBF2GYJfqp4yaRWs7
	 CpSiHZ78Fj+FI6Q1mfal1RnwxVVcwTamd5iNSUvYxFbb4qMIZkHFOA69nhAY62ZKNp
	 85FIHj6b7JQrvCdoaGuD6Bz4YSi8NOteHBR6NY78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 642/675] dmaengine: dw-edma-pcie: Reject devices without driver data
Date: Thu, 30 Jul 2026 16:16:12 +0200
Message-ID: <20260730141458.776143664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 11d7cfe0c119691b2dafbb699bbca90258c678aa ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-edma-pcie.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/dma/dw-edma/dw-edma-pcie.c
+++ b/drivers/dma/dw-edma/dw-edma-pcie.c
@@ -166,6 +166,9 @@ static int dw_edma_pcie_probe(struct pci
 	int err, nr_irqs;
 	int i, mask;
 
+	if (!pdata)
+		return -ENODEV;
+
 	struct dw_edma_pcie_data *vsec_data __free(kfree) =
 		kmalloc(sizeof(*vsec_data), GFP_KERNEL);
 	if (!vsec_data)


