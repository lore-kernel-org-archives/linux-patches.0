Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F15267B7F;
	Tue,  8 Apr 2025 11:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110140; cv=none; b=YtpjmqP/XuGr2Y/27aIpkIx3B4B69E39diAXHY2zvp+qj+4cBwl0bZ9O7b35SGl0q4Mjx6H9/ppgwGIKSAcBorWGyjd5m7o605RvH+0ZiHBW9/p1eaVedqPQ6j+mbPfEXLSnUOGlo9HlKPnxRasS4Sf6joRKnuS8CTLP59RPN9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110140; c=relaxed/simple;
	bh=bpKYVpNIh4DkLI6b42QBpQi6f/xnP0Xy41jKcawWy84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOZzIiS1cPqsqLD93R1KSFdPg++HbjbvvycoXPHsqX8O6ax2bii/Ks8aO9C3i0xiU+44VxWwL8xEcd26oRFdIcsANEURXmXZPo3u1UILT/k02aZVSnEw6yw9/EfR58kQO9KSyVNO7ia94ZxNDer3JPRFT9Dv2Z3UUdKQJSzHiVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3GT68XW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3GT68XW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FA0C4CEE5;
	Tue,  8 Apr 2025 11:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110139;
	bh=bpKYVpNIh4DkLI6b42QBpQi6f/xnP0Xy41jKcawWy84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3GT68XW0zdmNbBT70M85J5sCjgk389q3bU2J/rdwt1stWS+uMLBFiCGPs139n2vy
	 zcjrBO98s45hm5gPSkbFqDOBZN/TkQPZG3PZKdaOZrZdqZGlVFkmKo9hw2i8Fw4O4E
	 rnIHR2/H4wcZo3QmlY2uVKlx40By0rrkfTNbAEZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 183/227] nvme-pci: clean up CMBMSC when registering CMB fails
Date: Tue,  8 Apr 2025 12:49:21 +0200
Message-ID: <20250408104825.798571989@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit 6a3572e10f740acd48e2713ef37e92186a3ce5e8 ]

CMB decoding should get disabled when the CMB block isn't successfully
registered to P2P DMA subsystem.

Clean up the CMBMSC register in this error handling codepath to disable
CMB decoding (and CMBLOC/CMBSZ registers).

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index ae04bdce560a1..7993acdfd3185 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1888,6 +1888,7 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 	if (pci_p2pdma_add_resource(pdev, bar, size, offset)) {
 		dev_warn(dev->ctrl.device,
 			 "failed to register the CMB\n");
+		hi_lo_writeq(0, dev->bar + NVME_REG_CMBMSC);
 		return;
 	}
 
-- 
2.39.5



