Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9273F8F4;
	Mon,  1 Apr 2024 16:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988316; cv=none; b=AzY7TgtYr8viS7x4NdWCKWUaQK4wPcyZmexfWeGhjXm1tR6vNr/W8r/THdV7Gr4R3S/LJCC8RUXhqG5Ko7CDlSNlyH1PyO17bYwWStOOrD+yLZQnMNA66Sceg6pg6UASdesEJQjsulsGVeh2ofg/YQFOWXsXglPSu5dsdq5WLXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988316; c=relaxed/simple;
	bh=oCXTqi/tTNI/YpfLL5R1s7wqVbISJik+ezase+LyT7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMD8ZPpTtSodjCbrm7MYzwpWwBzLAg0BJeF2eUWclCUPkKLjURrNGTDK4RankuHQP9mi+rP35OMPZpOJR8YhetcF6gcp5UUQbeStvocCjvQ/+vmHNJbA5VuA9ZaNtuMg5bJ6DY6RihqPDs6r+OKNpxM3DLWPonR0WseTnrPFFHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bu6+vrY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bu6+vrY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804C1C433F1;
	Mon,  1 Apr 2024 16:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988316;
	bh=oCXTqi/tTNI/YpfLL5R1s7wqVbISJik+ezase+LyT7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bu6+vrY4WtV2CByKhYkaLEAcJmRk2kOL/mAS16HhHT7h005/sRtYn3jxyakjAlzcB
	 yEBQ8pz7HuO5HiYYXBTN3I+4WFsWOVne5gMPmEKtviBrgdQdczwDM1vZIO7QxU+cp8
	 wwzcxCxHwO7+tmTSfYT163dSoELF17Xl7sVUFpjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diana Craciun <diana.craciun@oss.nxp.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 149/432] vfio/fsl-mc: Block calling interrupt handler without trigger
Date: Mon,  1 Apr 2024 17:42:16 +0200
Message-ID: <20240401152557.581229828@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 7447d911af699a15f8d050dfcb7c680a86f87012 ]

The eventfd_ctx trigger pointer of the vfio_fsl_mc_irq object is
initially NULL and may become NULL if the user sets the trigger
eventfd to -1.  The interrupt handler itself is guaranteed that
trigger is always valid between request_irq() and free_irq(), but
the loopback testing mechanisms to invoke the handler function
need to test the trigger.  The triggering and setting ioctl paths
both make use of igate and are therefore mutually exclusive.

The vfio-fsl-mc driver does not make use of irqfds, nor does it
support any sort of masking operations, therefore unlike vfio-pci
and vfio-platform, the flow can remain essentially unchanged.

Cc: Diana Craciun <diana.craciun@oss.nxp.com>
Cc:  <stable@vger.kernel.org>
Fixes: cc0ee20bd969 ("vfio/fsl-mc: trigger an interrupt via eventfd")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20240308230557.805580-8-alex.williamson@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
index d62fbfff20b82..82b2afa9b7e31 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
@@ -141,13 +141,14 @@ static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
 	irq = &vdev->mc_irqs[index];
 
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
-		vfio_fsl_mc_irq_handler(hwirq, irq);
+		if (irq->trigger)
+			eventfd_signal(irq->trigger);
 
 	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 		u8 trigger = *(u8 *)data;
 
-		if (trigger)
-			vfio_fsl_mc_irq_handler(hwirq, irq);
+		if (trigger && irq->trigger)
+			eventfd_signal(irq->trigger);
 	}
 
 	return 0;
-- 
2.43.0



