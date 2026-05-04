Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0EE315785;
	Mon,  4 May 2026 14:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904504; cv=none; b=bKg46wP4hIzW+lJGiqBrG+U4FvtcywH+6yaNxy3zgyohR8smrf3fqWbMeN0dMUa3A5hcBY3EDv+WLJJBtz4te9g+SqZl76olVZEl/NJlo4qJo8wVr1YxbjMyu2JlWsSmr2rHZf+k9O8PoAZpNro1LqXG8gj/UKK44OJHclbXbxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904504; c=relaxed/simple;
	bh=E55mx7EkBGrGIJPKxxyhXyIQn9ai7Y7d2PmSuagzVic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIP9Wm8REf81RbjTqN2anDIZYTF0vz43k535mEAe+SQAVTbs9+MQ/oWySCjuzFO+dCuXTj+7XMxRTcHI5l7NNXQE/S61TEQmVLGPtY1ZdoLu3/2VoT7vK/rWtDzad6icy4svQ+1url02MQ1BRTPVpH4dhpJghr1f0ChAhxwoqFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifF5cqOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifF5cqOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9966C2BCB8;
	Mon,  4 May 2026 14:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904504;
	bh=E55mx7EkBGrGIJPKxxyhXyIQn9ai7Y7d2PmSuagzVic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifF5cqOdMTVhTu4bDlNebYbmdUJMypHhc4rIUU5WYqzw9RKdVAiCyN4Po7UGSur8J
	 1yEdbtnJkm9BUlt5LQcXp5iNq4zVvDBXXzjv2Yvqw0K+3vPx9/Ocmr6QvN7Hoa7HPk
	 smk74qFsvAV19qjNpr2cVv2shjuCJu6q4Zkxc+Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Alex Williamson <alex.williamson@nvidia.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 6.12 031/215] vfio/cdx: Fix NULL pointer dereference in interrupt trigger path
Date: Mon,  4 May 2026 15:50:50 +0200
Message-ID: <20260504135131.312952139@linuxfoundation.org>
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


