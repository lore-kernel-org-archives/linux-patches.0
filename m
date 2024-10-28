Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F22F18E04F;
	Mon, 28 Oct 2024 06:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097629; cv=none; b=gJdTx0IDLKBs1RQGizEiyQ/CiyGit0PtzFPKAyYmSlJv+Zj25I7zEfKii8/zIDO51XebIagtfnBI40xV5yYW4R3X1csfBuayNlumn/jA7doqWpoEGY9zT2uilJsbg1M7zr2CZjrPAy6NU+TJI2ocf37nfNlgtrL7+tmQYnfUNY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097629; c=relaxed/simple;
	bh=/yVDTN6GaIa5z0zjINBoe4hTSSeDdwtCLMCBbeNZJaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fj1EKHk7XSVtG7enBdXCIJlqgcXb+hrN9f6sNIIe+XmQx9CrdK4m7/ue5fKVPZm+Y6a4vWbMsMurWFxhKGOJuQSttkDui+yeiPSSY6ORBLALPT9QWKJiNjx9XmDR+qA+aPO/QDTG6dLk0Mkv0rZ8n9/Epo5sn/TO6/2u9dczkr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isqfKAyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isqfKAyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CA9C4CEC3;
	Mon, 28 Oct 2024 06:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097629;
	bh=/yVDTN6GaIa5z0zjINBoe4hTSSeDdwtCLMCBbeNZJaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=isqfKAyi2IZW+5HbXp+VOjJBE8RnfwF2wl/fiqyzj6z7pX9b9CDuNZjAtDeTaBbD1
	 Tkq2erRIWF3XZR35krW7n9QZFHGSCAZpGoHlMFCH+Pp97bZGd2K29XZWzbbasNyEh4
	 dn2eO5B5PNE25KeJPFEjtWokXHTRr5gREjxhZZ0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Sauber <andrew.sauber@isovalent.com>,
	Nikolay Nikolaev <nikolay.nikolaev@isovalent.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Anton Protopopov <aspsk@isovalent.com>,
	William Tu <witu@nvidia.com>,
	Ronak Doshi <ronak.doshi@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/208] vmxnet3: Fix packet corruption in vmxnet3_xdp_xmit_frame
Date: Mon, 28 Oct 2024 07:24:18 +0100
Message-ID: <20241028062308.564370591@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 4678adf94da4a9e9683817b246b58ce15fb81782 ]

Andrew and Nikolay reported connectivity issues with Cilium's service
load-balancing in case of vmxnet3.

If a BPF program for native XDP adds an encapsulation header such as
IPIP and transmits the packet out the same interface, then in case
of vmxnet3 a corrupted packet is being sent and subsequently dropped
on the path.

vmxnet3_xdp_xmit_frame() which is called e.g. via vmxnet3_run_xdp()
through vmxnet3_xdp_xmit_back() calculates an incorrect DMA address:

  page = virt_to_page(xdpf->data);
  tbi->dma_addr = page_pool_get_dma_addr(page) +
                  VMXNET3_XDP_HEADROOM;
  dma_sync_single_for_device(&adapter->pdev->dev,
                             tbi->dma_addr, buf_size,
                             DMA_TO_DEVICE);

The above assumes a fixed offset (VMXNET3_XDP_HEADROOM), but the XDP
BPF program could have moved xdp->data. While the passed buf_size is
correct (xdpf->len), the dma_addr needs to have a dynamic offset which
can be calculated as xdpf->data - (void *)xdpf, that is, xdp->data -
xdp->data_hard_start.

Fixes: 54f00cce1178 ("vmxnet3: Add XDP support.")
Reported-by: Andrew Sauber <andrew.sauber@isovalent.com>
Reported-by: Nikolay Nikolaev <nikolay.nikolaev@isovalent.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Nikolay Nikolaev <nikolay.nikolaev@isovalent.com>
Acked-by: Anton Protopopov <aspsk@isovalent.com>
Cc: William Tu <witu@nvidia.com>
Cc: Ronak Doshi <ronak.doshi@broadcom.com>
Link: https://patch.msgid.link/a0888656d7f09028f9984498cc698bb5364d89fc.1728931137.git.daniel@iogearbox.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_xdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_xdp.c b/drivers/net/vmxnet3/vmxnet3_xdp.c
index a6c787454a1ae..1341374a4588a 100644
--- a/drivers/net/vmxnet3/vmxnet3_xdp.c
+++ b/drivers/net/vmxnet3/vmxnet3_xdp.c
@@ -148,7 +148,7 @@ vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
 	} else { /* XDP buffer from page pool */
 		page = virt_to_page(xdpf->data);
 		tbi->dma_addr = page_pool_get_dma_addr(page) +
-				VMXNET3_XDP_HEADROOM;
+				(xdpf->data - (void *)xdpf);
 		dma_sync_single_for_device(&adapter->pdev->dev,
 					   tbi->dma_addr, buf_size,
 					   DMA_TO_DEVICE);
-- 
2.43.0



