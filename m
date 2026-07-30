Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247BA380FD6;
	Thu, 30 Jul 2026 15:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426754; cv=none; b=nRETnFiadH2VxX/TmkPdfPPba2TERI727hMhKCd/ConHVMYRXhOAIqzopNPhIGSoQeFRhSUrVgB/BPpOWoCoX6BYnW4t5JJ1vbJvqsALXYGxjmo4JVIXFgKzASQEpvv5a3ntZNDEBCiTkob+sdAnBAX83Gy7b6BqaBgEFqxxlO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426754; c=relaxed/simple;
	bh=RbCInuNpv7Akgu7FkKlNGKc/fk2eqLsk0y69LuXk84w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ak+k7KxK+B5G7DlOzNzcFgtuYsXUtt40Pm372nkA8V/6Fm0AWxWs7Or2rwGZMXAgnguUsTw7vykQGrYZvzZkn9ROqwy05FIFQtl+5LGJJO0XTJGpbnIuDIOdnOkWPPn0+nj86Baxf7AtGROrGyL4fthQE+0i448NgTrm0fzNr0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1XD0PJA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1XD0PJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FADC1F000E9;
	Thu, 30 Jul 2026 15:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426753;
	bh=cx3A8Rgsk3LbcksGNn5OA+1ue2PVHjClQgYggGAh3TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x1XD0PJAxpcfQHr5ebewauDuL/L+SeSuQz5OABXNpzhOUe8QfK3DJmhouV/z0G95d
	 U2ALroSWQbQHQL0wxVv6bcAiDJcTxKTZhJlRl2lw6XFZ7jjSrCYF3IgKTWHSs4ONgj
	 OCTDVm5H2rWA1tR58IJJy+73VEqmNwvrkaveqSHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 531/602] dmaengine: dw-edma-pcie: Reject devices without driver data
Date: Thu, 30 Jul 2026 16:15:23 +0200
Message-ID: <20260730141447.173070761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


