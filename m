Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D401344605F;
	Thu, 30 Jul 2026 16:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428191; cv=none; b=USHF4UaLPtIJxIMMemJdEhqfEJs1BUmOBOUBA2IKjrrfV30Pg96W0sH4/ZhCfOc4FrXZu12QdK6Ome95AFtfJ2mFAA1nmT7+VEfSJFQY4N6LWh+3YG2hsgzuz3QoSFs99oHhz3JX5pBVGEK4b5EL+NIxZ0+HfWzc86++rwk+oZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428191; c=relaxed/simple;
	bh=uXhBwGpdkCHKduakgbNJn1UpGQFHQD7n54n7l+JHFZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvtEw0VcujPZ0nBcSYBdiOimM0cOI85QZyIA2Lv1EuZdXjDbKnszSwMHAsFn4zw+mv0J3T3aBTBsjnrpxrha2U+0L5nfH7Rxwb1GcwjVM2GGwq4YHqMSAlheKTZ5eo884+IZfzuDuexK9zNOh4MHfre4yAyZxMmV5Met7KuHnmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKaR4icD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKaR4icD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918961F00ACA;
	Thu, 30 Jul 2026 16:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428182;
	bh=m5xn5AwVoDq05ok4YmqB6KJOKT+LgoSAHFcyJjp+FCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EKaR4icDuvZofWLMgj6qVSUeweeVurL7+tBXSmHPc4ZjDODTGX/uv4DTleJBSxM3u
	 KnFNI6V3BGBaKfvbc7KYf9xoFjUHG3W0M3aVlQrQgB5V/cKrevHzE3rPDq4RcXHyVK
	 b+A2czgk6WiSBb9CIGPhN5l573OyXsma8TWBUWIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 433/484] dmaengine: dw-edma-pcie: Reject devices without driver data
Date: Thu, 30 Jul 2026 16:15:30 +0200
Message-ID: <20260730141432.887341241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -165,6 +165,9 @@ static int dw_edma_pcie_probe(struct pci
 	int err, nr_irqs;
 	int i, mask;
 
+	if (!pdata)
+		return -ENODEV;
+
 	struct dw_edma_pcie_data *vsec_data __free(kfree) =
 		kmalloc(sizeof(*vsec_data), GFP_KERNEL);
 	if (!vsec_data)


