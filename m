Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946823F86FB;
	Fri, 15 May 2026 16:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861566; cv=none; b=Gabwd0bUHnR914h9Ij4lEhVaSH/mxdnmhnhPqGAiUwbGTIL6okZDDlRcIGBgJNduy7ySoayyU4bnPU15LI/xmJirZC8gHtjEoyhoHpOTTmVTD+QrjbpShhfdwMaHbcpD0/NXuKWvnz4JNvEsLpSBvPUzWFzAerXFYIhdUSom0xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861566; c=relaxed/simple;
	bh=j2gY0Ruea5mMrl8GYAeMtNFXtT+fMgETABs7jwgLf5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLt9XZvw/mxrAVyEHD9t53ySYpNVZDJI9hauS9NDBwF5Gj0EiDSyydnnHrG8WvMSrNqY873Pfpfenle3jvejy8xRM4eXrTOnqPeGynA9p7yGXiUlel7q6ul7Ni5p932s4UPA0qULfWvsSV0GpnBiouSzrVDjL6w3tB/0N97ywNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXrTzUgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXrTzUgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03558C2BCB0;
	Fri, 15 May 2026 16:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861566;
	bh=j2gY0Ruea5mMrl8GYAeMtNFXtT+fMgETABs7jwgLf5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXrTzUgfqb9ThbXj+VDyd3JR9R2qEXbqBKJEzdizsfLzwj8BhVoWShkLKwzk9JQmm
	 SouSYwYjIGqeRc/rwdxinUsry2a+7H1oYLsS+H9iR4hBUdQO+lG8UyIHtRS073+xRo
	 T/scKAGHKO0lJQ6nD5xeX6fchBIeQ4+WkdpXM2lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <git@danielhodges.dev>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 376/474] PCI: epf-mhi: Return 0, not remaining timeout, when eDMA ops complete
Date: Fri, 15 May 2026 17:48:05 +0200
Message-ID: <20260515154723.165615347@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Daniel Hodges <git@danielhodges.dev>

[ Upstream commit 36bfc3642b19a98f1302aed4437c331df9b481f0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/endpoint/functions/pci-epf-mhi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pci/endpoint/functions/pci-epf-mhi.c
+++ b/drivers/pci/endpoint/functions/pci-epf-mhi.c
@@ -331,6 +331,8 @@ static int pci_epf_mhi_edma_read(struct
 		dev_err(dev, "DMA transfer timeout\n");
 		dmaengine_terminate_sync(chan);
 		ret = -ETIMEDOUT;
+	} else {
+		ret = 0;
 	}
 
 err_unmap:
@@ -402,6 +404,8 @@ static int pci_epf_mhi_edma_write(struct
 		dev_err(dev, "DMA transfer timeout\n");
 		dmaengine_terminate_sync(chan);
 		ret = -ETIMEDOUT;
+	} else {
+		ret = 0;
 	}
 
 err_unmap:


