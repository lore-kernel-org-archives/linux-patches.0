Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2920C1A6827;
	Mon,  4 May 2026 14:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904463; cv=none; b=DwJ82HSJN5e4QBxyeGvnLP7+DRZCOZ5UmJszb3BVtE+E35e66AG8lmjFu+bMgZT2hsoQ+7DDqHjxZ/Zroc0kseDZZBsPtWwpgtEnJtsvfdeXzTfcRU1VOh93FdhEGIEbkBW5zs0Xq1vPt3gXZwBDjDVRWriqxICj9ga/L46+qrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904463; c=relaxed/simple;
	bh=rWFgWgdBfoQr7h3LDDIDzJUFe7GCNC3U0LgdS9yPRh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVXVM28tgkvNB8XsrOjhnEb5jMbz5jy8EDhoxXCj0xi7QuWFa0OP1Qm0p73clXa7ZiMJaBVydDpZFfGNk4OkMpbOkc2hmh2mhfG9O/P/gLLDjTxQ0U9DThnelQnentYxhD5aeTqNmvr7Qcfu9X9yn/ENMGjeibJ83Gq0bI/Fc0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJ4PwiF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJ4PwiF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1634C2BCB8;
	Mon,  4 May 2026 14:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904463;
	bh=rWFgWgdBfoQr7h3LDDIDzJUFe7GCNC3U0LgdS9yPRh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJ4PwiF5lgjHRBBPkd8LWdnT0MdkOQBzowyd19aJYu9WhocjKSHhz97oRrsGRmKl+
	 0Gx477I5bJBphFAub8rqXBzMtFoHw/tfsVjQBtO8DBo9Dg8h9/fRj/F2GLlq07CeJK
	 EBm6TLtPb26ksVRBptnt4PijLuXtgVnq4PrVtPc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <git@danielhodges.dev>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Subject: [PATCH 6.12 048/215] PCI: epf-mhi: Return 0, not remaining timeout, when eDMA ops complete
Date: Mon,  4 May 2026 15:51:07 +0200
Message-ID: <20260504135131.934142157@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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


