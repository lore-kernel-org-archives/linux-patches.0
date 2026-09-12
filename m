Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266D33A1690;
	Sat, 12 Sep 2026 08:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201985; cv=none; b=ODmK8F4CRnqD5jbeM8HMdys7eT0GICQ94BVAwV111JvlqvbWUizlSnHW8jMzk8mQpLy4NU/UhvSTo9Q78Evbmx5d4OMyZXG5Sq6FrLacGE4ob929fahkO5Qztj9jrROQvSlK7g4MD5trQXtp734+XRjxoELt6a9e/VJPceFI8no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201985; c=relaxed/simple;
	bh=o9WrUvB0mhaSVJxYbw7DOIEVJOK3sVR+qMhwZtHoy9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5lA8xR1TxXl5waHcPOK08oy2a+CVwrogYjx2VkpReaUt8wBjSNQof461JGe/w8MVh0uuct5cY9+bwSc9NSRmRpAS/sDC43h/40Ziju/qkDXM5BDQBFHUMFaB0NJQ5dLTNMdd7AN+Rq4Edrun4Z41PbWpTSXE7N77NNE9UqG3qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgJYvNW6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgJYvNW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4AF1F000FF;
	Sat, 12 Sep 2026 08:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201984;
	bh=IfrXr6t3G1qfHxn0nCq86fyiaeBbzxiQgtaUqb493uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YgJYvNW6oPJvOegK/hxrU6hMLDHgfJRzfSwsOHiD8XsgXUOHjYTkQ4+Tyjg8I+ttT
	 kEs4++Db250WipcR/GKaBkNjdrhXSIqn717pxeZ95H/pGzP/8By3LMefixo3UlZLTF
	 lfxqItTe4NBpx5aL6MWdIFVxExqGzqCKIoNbk6CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1110/1815] vfio/pci: Avoid mapping BARs for devices with non-mappable BARs
Date: Sat, 12 Sep 2026 08:47:40 +0200
Message-ID: <20260912065715.077302196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Farhan Ali <alifm@linux.ibm.com>

[ Upstream commit 6edd69813b2d8c30c24a86052065a5dbf390a3cd ]

vfio_pci_core_map_bars() calls pci_iomap() to set up BAR resources, but not
all devices support having their BARs mapped by the CPU. The
non_mappable_bars flag indicates that a PCI device's BARs cannot be
accessed by the CPU. The ISM device on s390 is one such device. The BAR
size for an ISM device is 256 TiB, and attempting to map the BAR will lead
to warnings:

vmalloc_node_range for size 281474976714752 failed: Address range
restricted to 0x2110bab00000 - 0x21903ab00000

Use pdev->non_mappable_bars to skip pci_iomap() for such devices. This flag
is set by the PCI core at enumeration time and already serves the same
purpose in vfio_pci_probe_mmaps().

Fixes: 05f2a68b407a ("vfio/pci: Set up BAR resources and maps in vfio_pci_core_enable()")
Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Link: https://lore.kernel.org/r/20260729181116.1373-1-alifm@linux.ibm.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 3f11a9624b9c0..6a184588ff234 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -554,6 +554,9 @@ static void vfio_pci_core_map_bars(struct vfio_pci_core_device *vdev)
 
 		vdev->barmap[bar] = IOMEM_ERR_PTR(-ENODEV);
 
+		if (pdev->non_mappable_bars)
+			continue;
+
 		if (!pci_resource_len(pdev, i))
 			continue;
 
-- 
2.53.0



