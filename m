Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956254F93A4;
	Tue, 13 Oct 2026 12:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895198; cv=none; b=LJsX/Zhx4CMmkOlhXEdak/7SxgvBSq6P0i44f+nsWWWxjeBqVj2/vu3g0doAZOgbeGbrecW9mVwuGicfl2X+9/XuWiafoAbuq8q913VES1bFWfoeZ2dIGlZcvjhThntvOwFyOwpmk33cxiBK0r3jrDtZ0/xUjSb9/r1CaKeiP+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895198; c=relaxed/simple;
	bh=jNZkdqpT4SN7R+qgn4hDchCR4xh+A/p63ZX37mWNmqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKcbysR+p+uWyHRXoxqcSYMdOJcKW5ZiWKJj4tZzZOE80ZAfi3hOcYSIXAb5dKnuMv04mONyNbVXuNoif6x2XgvcxdeYVz5j1KLNz4/4zdo1yF60oXZapK+MXSYm0Luz5kvRk0FiKSZ/UD2C7QHBz+4ySUnFR5zwqlGwaOEUzOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrMP6dms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrMP6dms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EB41F000FF;
	Tue, 13 Oct 2026 12:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895197;
	bh=f512R5b/t2J6XPX/1dTqusq8vVHBCz8HspQ7F2/8xRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lrMP6dmsIw3NSoOA6tOH4VmgWeBS3a7Uy1Z1AN7v/PI6dNAvQhgg2x8eamhItcHQn
	 2KVafvj0Pvl44BxWEeV6j+6eEq9JNziWV2jKUniSvp28UVty/clgi/Krydzx/0q5Mw
	 9g9SIsaKQdZ4x9kvqgddtIMf6Q4fnffVM2d8D32A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Sinha <gsinha@micron.com>,
	Bean Huo <beanhuo@micron.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 195/497] nvme-pci: add NVME_QUIRK_DMAPOOL_ALIGN_512 for Micron 4100AT
Date: Tue, 13 Oct 2026 13:36:02 +0200
Message-ID: <20261013112912.520019988@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Bean Huo <beanhuo@micron.com>

commit c72f9f7bd23c91e944910d9bcbf12503d21a4a1f upstream.

The Micron 4100AT fetches PRP Lists in 512 byte strides, but the driver
allocates small PRP List descriptors in 256 byte strides.  A descriptor
in the last 256 bytes of a dmapool page makes the controller read past
the page: the access lands on an adjacent IOVA, the IOMMU faults the
command. That last block only became reachable with commit da9619a30e73
("dmapool: link blocks across pages"), so this affects v6.4 and later.

Align the small descriptor pool to 512 bytes, as commit ebefac564796
("nvme-pci: 512 byte aligned dma pool segment quirk") already does for
another controller with the same erratum.  The last block then starts
at offset 0xE00 and the fetch stays inside the page.

Cc: <stable@vger.kernel.org> # 6.4.x: ebefac564796: nvme-pci: 512 byte aligned dma pool segment quirk
Cc: <stable@vger.kernel.org> # 6.4.x
Signed-off-by: Gaurav Sinha <gsinha@micron.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3681,6 +3681,8 @@ static const struct pci_device_id nvme_i
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN },
 	 { PCI_DEVICE(0x1344, 0x6001),   /* Micron Nitro NVMe */
 		 .driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1344, 0x6004),	/* Micron 4100AT */
+		.driver_data = NVME_QUIRK_DMAPOOL_ALIGN_512, },
 	{ PCI_DEVICE(0x1c5c, 0x1504),   /* SK Hynix PC400 */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x1c5c, 0x174a),   /* SK Hynix P31 SSD */


