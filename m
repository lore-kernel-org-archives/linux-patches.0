Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72570357A4A;
	Fri,  9 Oct 2026 14:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557116; cv=none; b=qgojImRE3WkJlxl3LWaLwZcbHZwXg9ekuZO1l4/ZQGPUeuvP1XV0+k1HNx5c6kAf/6//U/XDJ5owE6j/fsJf5b2sWxUFnta8gXVDvMZvzaIkEIzjEwNojLwRL3xcQFvhE//VWr7KChYpL9Yi765/63xBkps21vWvwGWNLwYz/W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557116; c=relaxed/simple;
	bh=2i3p5Wv6m4Wd1adLKl1YgF1j09gXVzX2O30Y846B45k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uf5rKjwhn5+8GMs2BuHN+FbZSBk6QbHDOtHpsJ9LqW5m6hiJSgzNE+JLXsY6Ay/FqVSwZpLVXjOTIfICqcrQPMcUng+jjYD95cq5IohlD+bPArcG6ww+Amcb4932yUo+hdt00siqKscj3uXvgJLveSCYJBTi8bb0IMva7JJHtIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKC3nb2q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKC3nb2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E8F1F000FF;
	Fri,  9 Oct 2026 14:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557115;
	bh=8YOezfrPZYXhsvoQB50tgacpaFkNWfyV4cd1oRJmKqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKC3nb2qoc7S1sjPWYyDtpVZhhLNwdzD9eRK5qKfnPdmkGWS5AHLHQG/CKdnJbwcc
	 1Yb8/wQGqKul+JnfydHn85ojM9WpAjfF38q6SGUJREqorXC5xyZdYOpJ8Kya28fIHb
	 GOE53XZ8+gmHphEkjr6N884ClG31VxcXihxIOoPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Sinha <gsinha@micron.com>,
	Bean Huo <beanhuo@micron.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.2 298/428] nvme-pci: add NVME_QUIRK_DMAPOOL_ALIGN_512 for Micron 4100AT
Date: Fri,  9 Oct 2026 16:10:35 +0200
Message-ID: <20261009140952.657790748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4182,6 +4182,8 @@ static const struct pci_device_id nvme_i
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN },
 	 { PCI_DEVICE(0x1344, 0x6001),   /* Micron Nitro NVMe */
 		 .driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1344, 0x6004),	/* Micron 4100AT */
+		.driver_data = NVME_QUIRK_DMAPOOL_ALIGN_512, },
 	{ PCI_DEVICE(0x1c5c, 0x1504),   /* SK Hynix PC400 */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x1c5c, 0x174a),   /* SK Hynix P31 SSD */


