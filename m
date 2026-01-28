Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9BA2D9780;
	Wed, 28 Jan 2026 15:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614188; cv=none; b=RFhKvcz2IKpmMxOy8KPGFe9QLuhrvFnWTEWqMv7P9X0LGgM4rgDLSyesiPW6DLoaFjkFijhMNYpTBy6BUiM8MF+Wx1R1QhA9WAQ00sl3rTe+S6Po1wsDi92rvFfj9/6utSkkwPlKU+mKAYH2vb5W+CLXFn6Qk3kvaN0u8jZw9Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614188; c=relaxed/simple;
	bh=sn89mo6AwrIS1B4xl9npuxgSmYnS+jQPjjJMfkH2B/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbixq4jiL/Coa0MA73YfUu/LKdoczjTaDBjEK2rsSGeRUz6hdjWhVmM0J5hUpnir/1xC0UbEaw9JDtwfW4pyqhKsUVFL5ytKeDpoTCnWvQ496NsSUZNgOJyncrFU7PvCg6Y6d0CZBJC8kUbgRoU8I6sZxGJr+A/Con8BrT5pIMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4N3zvng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4N3zvng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33867C116C6;
	Wed, 28 Jan 2026 15:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614187;
	bh=sn89mo6AwrIS1B4xl9npuxgSmYnS+jQPjjJMfkH2B/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4N3zvnghipeHNdl8O+tmewDpLH307xmXBoH+Q+pmGEsDalLn30E9fwzgNiARFGGA
	 r9s9vp7nFZcSNZjMF4/zS+7IsHPEn6zjHsgC1d0v4NtPLQflwxtFhyoldz0C2k1V5/
	 hYBOTj51rCHoLyn9AxwO3HSGFSBmjj5gFr15dbq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wu Haotian <rigoligo03@gmail.com>,
	Ilikara Zheng <ilikara@aosc.io>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 061/254] nvme-pci: disable secondary temp for Wodposit WPBSNM8
Date: Wed, 28 Jan 2026 16:20:37 +0100
Message-ID: <20260128145346.896697695@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Ilikara Zheng <ilikara@aosc.io>

commit 340f4fc5508c2905a1f30de229e2a4b299d55735 upstream.

Secondary temperature thresholds (temp2_{min,max}) were not reported
properly on this NVMe SSD. This resulted in an error while attempting to
read these values with sensors(1):

  ERROR: Can't get value of subfeature temp2_min: I/O error
  ERROR: Can't get value of subfeature temp2_max: I/O error

Add the device to the nvme_id_table with the
NVME_QUIRK_NO_SECONDARY_TEMP_THRESH flag to suppress access to all non-
composite temperature thresholds.

Cc: stable@vger.kernel.org
Tested-by: Wu Haotian <rigoligo03@gmail.com>
Signed-off-by: Ilikara Zheng <ilikara@aosc.io>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3563,6 +3563,8 @@ static const struct pci_device_id nvme_i
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x1e49, 0x0041),   /* ZHITAI TiPro7000 NVMe SSD */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
+	{ PCI_DEVICE(0x1fa0, 0x2283),   /* Wodposit WPBSNM8-256GTP */
+		.driver_data = NVME_QUIRK_NO_SECONDARY_TEMP_THRESH, },
 	{ PCI_DEVICE(0x025e, 0xf1ac),   /* SOLIDIGM  P44 pro SSDPFKKW020X7  */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0xc0a9, 0x540a),   /* Crucial P2 */


