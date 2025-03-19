Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1895A1B2194;
	Wed, 19 Mar 2025 14:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394916; cv=none; b=iTd64mxFCKNt7druN1rJn13JgEHntAsI5ZywwZg3UhDDHTrcTlTcLskjF0cPn+eqdyrpLGdU7LNMh4FtI5IvOIZggu1UUa8hNCmSGWG1E43hgVQ7hTt5D3+8IucJvaMmInLYczmG2fQc0pkL6G09o+riaHVZB4Mw/q2bnbzLQDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394916; c=relaxed/simple;
	bh=sWLafWLYfIC2uS67ZTNKtbjcUyyUtg7pC64YmxhKMb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0bsqc8t0ymk3qoitm5ojecXCOQ/XV1i3ON0iUQNwMfY2j1Tuw6+WNfkizsw8GXrYA/HZZlP9KNGG2t0Z+R5BCCsx2xArAqnwhSeyk/iPJNpWrRS96N/HftsFxzaklo2D8mxH81x62a5JB28QlZ3tZlF3OuKFbO3nZtyCZMVmFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drafT5be; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drafT5be"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9127C4CEE4;
	Wed, 19 Mar 2025 14:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394915;
	bh=sWLafWLYfIC2uS67ZTNKtbjcUyyUtg7pC64YmxhKMb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drafT5bes70xQ+ETkLVSP8a+O4tZXmog4vDDwawClqosj1/tyarzS9HZfxEKng64g
	 wdMWiVzt/TdQgoQNf60QlOZeuXhuqfhi8j37yYTK4Ie8NWM2Cabog6NUzW7lWs1/g9
	 5cgsWTEP7mhO/DVz5URCjUHrQyO8g4KxpYRwxyV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Lentocha <christopherericlentocha@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 125/241] nvme-pci: quirk Acer FA100 for non-uniqueue identifiers
Date: Wed, 19 Mar 2025 07:29:55 -0700
Message-ID: <20250319143030.818476595@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Lentocha <christopherericlentocha@gmail.com>

[ Upstream commit fcd875445866a5219cf2be3101e276b21fc843f3 ]

In order for two Acer FA100 SSDs to work in one PC (in the case of
myself, a Lenovo Legion T5 28IMB05), and not show one drive and not
the other, and sometimes mix up what drive shows up (randomly), these
two lines of code need to be added, and then both of the SSDs will
show up and not conflict when booting off of one of them. If you boot
up your computer with both SSDs installed without this patch, you may
also randomly get into a kernel panic (if the initrd is not set up) or
stuck in the initrd "/init" process, it is set up, however, if you do
apply this patch, there should not be problems with booting or seeing
both contents of the drive. Tested with the btrfs filesystem with a
RAID configuration of having the root drive '/' combined to make two
256GB Acer FA100 SSDs become 512GB in total storage.

Kernel Logs with patch applied (`dmesg -t | grep -i nvm`):

```
...
nvme 0000:04:00.0: platform quirk: setting simple suspend
nvme nvme0: pci function 0000:04:00.0
nvme 0000:05:00.0: platform quirk: setting simple suspend
nvme nvme1: pci function 0000:05:00.0
nvme nvme1: missing or invalid SUBNQN field.
nvme nvme1: allocated 64 MiB host memory buffer.
nvme nvme0: missing or invalid SUBNQN field.
nvme nvme0: allocated 64 MiB host memory buffer.
nvme nvme1: 8/0/0 default/read/poll queues
nvme nvme1: Ignoring bogus Namespace Identifiers
nvme nvme0: 8/0/0 default/read/poll queues
nvme nvme0: Ignoring bogus Namespace Identifiers
nvme0n1: p1 p2
...
```

Kernel Logs with patch not applied (`dmesg -t | grep -i nvm`):

```
...
nvme 0000:04:00.0: platform quirk: setting simple suspend
nvme nvme0: pci function 0000:04:00.0
nvme 0000:05:00.0: platform quirk: setting simple suspend
nvme nvme1: pci function 0000:05:00.0
nvme nvme0: missing or invalid SUBNQN field.
nvme nvme1: missing or invalid SUBNQN field.
nvme nvme0: allocated 64 MiB host memory buffer.
nvme nvme1: allocated 64 MiB host memory buffer.
nvme nvme0: 8/0/0 default/read/poll queues
nvme nvme1: 8/0/0 default/read/poll queues
nvme nvme1: globally duplicate IDs for nsid 1
nvme nvme1: VID:DID 1dbe:5216 model:Acer SSD FA100 256GB firmware:1.Z.J.2X
nvme0n1: p1 p2
...
```

Signed-off-by: Christopher Lentocha <christopherericlentocha@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 99c2983dbe6c8..d2eeba15c73b3 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3715,6 +3715,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1cc1, 0x5350),   /* ADATA XPG GAMMIX S50 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1dbe, 0x5216),   /* Acer/INNOGRIT FA100/5216 NVMe SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1dbe, 0x5236),   /* ADATA XPG GAMMIX S70 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e49, 0x0021),   /* ZHITAI TiPro5000 NVMe SSD */
-- 
2.39.5



