Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9128F5C;
	Mon,  1 Apr 2024 16:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990212; cv=none; b=iEfNpFGj9qPpljzs0hqyHr+XweMsMwRy/jEpR18FW4GmPVMQU3z001t07/OLX4MNp7ACLHanyHnItWk7lY32EXIu+In6NYDrP76LKxf37Lf0utKKVi5vww9zfJFJGZAsF1IZIQHDMUcWdA4ev/aESITxDouQwPgYRKwMZct9PZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990212; c=relaxed/simple;
	bh=5vEecD5BBjRGVO2HmvUNN32DihtTZIYu4/jLDA6509E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Put5C/VQ8oDdHgBcDNIMF/fO4qibLh1dvok7fxKC5u3q+TqAhRHsAnsgOdYMag/jy1WQ97YZkV+p4N4WG0OQIk0419+a5pRGXk11ZQja5IS0cEqaPAhsS8Lq2jmQCdcV6uB1YExp+R6tWq3QIF3t4Nv6jVhrjc/OhxF8BBSBA9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xwZfW0zP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xwZfW0zP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E94C433C7;
	Mon,  1 Apr 2024 16:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990212;
	bh=5vEecD5BBjRGVO2HmvUNN32DihtTZIYu4/jLDA6509E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xwZfW0zPxTb/9Nld+aUXdszPwRzrAoipc4es1ZXD95S9BW2v0a21Kj8P10JVWSHhb
	 cJlFU0VqoPNKE5A4maZdML2BdGwQ5Fkd8DGUF30IfO1FuoefZPwZHr3jHkiH5HAK4U
	 VAyFQqg0nE8F/xwqHSO6nLzVYE24/fFrlvWpDpKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diana Craciun <diana.craciun@oss.nxp.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.6 281/396] vfio/fsl-mc: Block calling interrupt handler without trigger
Date: Mon,  1 Apr 2024 17:45:30 +0200
Message-ID: <20240401152556.287328235@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Alex Williamson <alex.williamson@redhat.com>

commit 7447d911af699a15f8d050dfcb7c680a86f87012 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
@@ -141,13 +141,14 @@ static int vfio_fsl_mc_set_irq_trigger(s
 	irq = &vdev->mc_irqs[index];
 
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
-		vfio_fsl_mc_irq_handler(hwirq, irq);
+		if (irq->trigger)
+			eventfd_signal(irq->trigger, 1);
 
 	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 		u8 trigger = *(u8 *)data;
 
-		if (trigger)
-			vfio_fsl_mc_irq_handler(hwirq, irq);
+		if (trigger && irq->trigger)
+			eventfd_signal(irq->trigger, 1);
 	}
 
 	return 0;


