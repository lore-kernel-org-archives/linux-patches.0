Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CB820DD51;
	Mon,  4 May 2026 13:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902994; cv=none; b=Oaf0JufcSVsaJvfkQRxGRnS6hyNSWSwvdkgsbCjdR8Pk90cZmwJW7KHPTTb3NxnXOYJUX9mSgs8ddsMs4cya7HuE4Iwg3jBEQmB0qpToa8nO959Y54BG8H1SJyj5tZPJa4Bbg+DYepvWK0x3WcugqhpynI+Vi3QbBHLUYz4uAW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902994; c=relaxed/simple;
	bh=z8Jt269I7haGLjuGmp1GFSR52bgk8knHdi9TL29vyzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uj6dHU5ZzzieOO7v7nOKx0kuKPOLMW1J01DquUCUk/hnhp+5ZEXi4SSoNoxJg7FclXSd2sq9ec7Q89BH+enRnynBaiIJfqbXArbq+TjRJgeZ2jwUWp0q0YUf53iIPmT2+dWQeCCL3278UJwRc2oKq67Y+s2uc9fIV7o+henr3vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPSF3yJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPSF3yJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFFEC2BCB8;
	Mon,  4 May 2026 13:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902994;
	bh=z8Jt269I7haGLjuGmp1GFSR52bgk8knHdi9TL29vyzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPSF3yJuC+JDiu6P3D6DuRplQGg2ko9wX78uWO60KtvtF5ZqnIKDpKWx4vEXWYmsM
	 EAct3CYXSg9uBq1tM0Gn1CpPN/F5n7P9zb7ZWDBXUUuMtb+FuZcU7MTUcg68PNL7lN
	 iyvx9zxoHkfT5XXx3PBIbwbyGqHRAAmQNuxDOhxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <git@danielhodges.dev>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Subject: [PATCH 7.0 061/307] PCI: epf-mhi: Return 0, not remaining timeout, when eDMA ops complete
Date: Mon,  4 May 2026 15:49:06 +0200
Message-ID: <20260504135145.115867023@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Hodges <git@danielhodges.dev>

commit 36bfc3642b19a98f1302aed4437c331df9b481f0 upstream.

pci_epf_mhi_edma_read() and pci_epf_mhi_edma_write() start DMA
operations and wait for completion with a timeout.

On successful completion, they previously returned the remaining
timeout, which callers may treat as an error.  In particular,
mhi_ep_ring_add_element(), which calls pci_epf_mhi_edma_write() via
mhi_cntrl->write_sync(), interprets any non-zero return value as
failure.

Return 0 on success instead of the remaining timeout to prevent
mhi_ep_ring_add_element() from treating successful completion as an
error.

Fixes: 7b99aaaddabb ("PCI: epf-mhi: Add eDMA support")
Signed-off-by: Daniel Hodges <git@danielhodges.dev>
[mani: changed commit log as per https://lore.kernel.org/linux-pci/20260227191510.GA3904799@bhelgaas]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260206200529.10784-1-git@danielhodges.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/endpoint/functions/pci-epf-mhi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pci/endpoint/functions/pci-epf-mhi.c
+++ b/drivers/pci/endpoint/functions/pci-epf-mhi.c
@@ -367,6 +367,8 @@ static int pci_epf_mhi_edma_read(struct
 		dev_err(dev, "DMA transfer timeout\n");
 		dmaengine_terminate_sync(chan);
 		ret = -ETIMEDOUT;
+	} else {
+		ret = 0;
 	}
 
 err_unmap:
@@ -438,6 +440,8 @@ static int pci_epf_mhi_edma_write(struct
 		dev_err(dev, "DMA transfer timeout\n");
 		dmaengine_terminate_sync(chan);
 		ret = -ETIMEDOUT;
+	} else {
+		ret = 0;
 	}
 
 err_unmap:


