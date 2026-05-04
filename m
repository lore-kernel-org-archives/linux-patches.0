Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AD240DFD4;
	Mon,  4 May 2026 14:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903711; cv=none; b=WTV0fX3kjFLc7ekCHk6Wc9zZov1o/G3YeeSLAPIOpfFNxlfLS79yPmbjwvnxgVX1eFOjm6HtNANgGVIrdmdhDSAMF5EGJWArOlHf7EZVdWynijamToRO8jerhIYQ2GWlqdvx+gylCVaFxZx1lSB2uCu3REGm3QxcZs4zSkCyDnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903711; c=relaxed/simple;
	bh=Ehi6DzPATBas1TWud/jYamJ7jKk2Qg9awB0Nz43fKKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewEE7HbO7FNfAA6zOpMNd/F1cl4i6uayPLjGqDut0P4Bu2Uv2xnD2U/N5s2JJOYkshgvI6uiCmtkf7dp4i7AN2r3/pjvhZhCvE8D7PK7sV4qFEbX9Xrnpa3J9SYLL3ydA7tl19mqs4kPsmgriY9xZ7lfTbqqaCr+CTVqXqY72MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIkTf7CR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIkTf7CR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5CFC2BCB8;
	Mon,  4 May 2026 14:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903711;
	bh=Ehi6DzPATBas1TWud/jYamJ7jKk2Qg9awB0Nz43fKKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIkTf7CRJnsxAXWaHWjq6Y1ScUNgM+qvnZkOFD0ZAanJgpurRTfhZ8Bk/tXk8/vdB
	 qo4Gj4oY3Q8Ryf4BbhESeDTtpci06u2hi05/3kvQG8zACgiezeNJ59rC0fb69X9brm
	 Otrs2s6dUCf+u+MwTatGWUF/ob2naQayVq2KCQLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Alex Williamson <alex.williamson@nvidia.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 6.18 033/275] vfio/cdx: Fix NULL pointer dereference in interrupt trigger path
Date: Mon,  4 May 2026 15:49:33 +0200
Message-ID: <20260504135144.169278741@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prasanna Kumar T S M <ptsm@linux.microsoft.com>

commit 5ea5880764cbb164afb17a62e76ca75dc371409d upstream.

Add validation to ensure MSI is configured before accessing cdx_irqs
array in vfio_cdx_set_msi_trigger(). Without this check, userspace
can trigger a NULL pointer dereference by calling VFIO_DEVICE_SET_IRQS
with VFIO_IRQ_SET_DATA_BOOL or VFIO_IRQ_SET_DATA_NONE flags before
ever setting up interrupts via VFIO_IRQ_SET_DATA_EVENTFD.

The vfio_cdx_msi_enable() function allocates the cdx_irqs array and
sets config_msi to 1 only when called through the EVENTFD path. The
trigger loop (for DATA_BOOL/DATA_NONE) assumed this had already been
done, but there was no enforcement of this call ordering.

This matches the protection used in the PCI VFIO driver where
vfio_pci_set_msi_trigger() checks irq_is() before the trigger loop.

Fixes: 848e447e000c ("vfio/cdx: add interrupt support")
Cc: stable@vger.kernel.org
Signed-off-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Acked-by: Nipun Gupta <nipun.gupta@amd.com>
Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
Acked-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
Link: https://lore.kernel.org/r/20260417202800.88287-2-alex.williamson@nvidia.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/cdx/intr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/vfio/cdx/intr.c
+++ b/drivers/vfio/cdx/intr.c
@@ -177,6 +177,10 @@ static int vfio_cdx_set_msi_trigger(stru
 		return ret;
 	}
 
+	/* Ensure MSI is configured before accessing cdx_irqs */
+	if (!vdev->config_msi)
+		return -EINVAL;
+
 	for (i = start; i < start + count; i++) {
 		if (!vdev->cdx_irqs[i].trigger)
 			continue;


