Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1607878F52;
	Mon, 12 May 2025 17:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072197; cv=none; b=OSwCuPnMHB7JsPfgPJh6ftfE7u3cFXa1v8Or8A5wXxhdGZHyC1X3ryMtjeZV3KEyqFHugIlXLcFhNNYoVmnE1aSNcf3ncUJEQrUU2EIeS6GErVN3+yHhF1BFCkLszFfGhJaKyjFv8Qs3QSN2NWtqC8uWtobZsh2CSu4Xoud123I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072197; c=relaxed/simple;
	bh=Tnf8aDyHbhMayNQosAmsPD9xlvP/NI7NsdfAGOn0Ys0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cyf4dul/F8MBs2o4/Llppi181UBA+raVfO9Zv9X1EuhHG8SeWe1Xu6m9xDj+FmKm1GJDCsi08XGRXMLDOVs3ZVqt2XXpBfq+guCSB6vVNqLPkZ2FlW8ZlEDbgatU/qb54qeYhvLK3Iwk1l0vBNrZZyBLIMGRK88CJ+Ny2O5xP+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRXfK3vI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRXfK3vI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EEAC4CEE7;
	Mon, 12 May 2025 17:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072196;
	bh=Tnf8aDyHbhMayNQosAmsPD9xlvP/NI7NsdfAGOn0Ys0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRXfK3vIevtcGDpUh+zS7s2IQDt1sXjm+mpfok7wVYcBaXKYEn8iTXB5urwOS0bob
	 GBAOA5ob9Gmp9DoS6DzsKNSHsW6Ddpg7zbK3ttg0NCG17jlSiTjoAzABsqu/ywQ6wV
	 pmLcv+IEEUt3A3mF/fjEKhtpebsOn87AB73Rz0uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.14 136/197] usb: cdnsp: fix L1 resume issue for RTL_REVISION_NEW_LPM version
Date: Mon, 12 May 2025 19:39:46 +0200
Message-ID: <20250512172049.927264565@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

commit 8614ecdb1570e4fffe87ebdc62b613ed66f1f6a6 upstream.

The controllers with rtl version larger than
RTL_REVISION_NEW_LPM (0x00002700) has bug which causes that controller
doesn't resume from L1 state. It happens if after receiving LPM packet
controller starts transitioning to L1 and in this moment the driver force
resuming by write operation to PORTSC.PLS.
It's corner case and happens when write operation to PORTSC occurs during
device delay before transitioning to L1 after transmitting ACK
time (TL1TokenRetry).

Forcing transition from L1->L0 by driver for revision larger than
RTL_REVISION_NEW_LPM is not needed, so driver can simply fix this issue
through block call of cdnsp_force_l0_go function.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/PH7PR07MB9538B55C3A6E71F9ED29E980DD842@PH7PR07MB9538.namprd07.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c |    2 ++
 drivers/usb/cdns3/cdnsp-gadget.h |    3 +++
 drivers/usb/cdns3/cdnsp-ring.c   |    3 ++-
 3 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -1793,6 +1793,8 @@ static void cdnsp_get_rev_cap(struct cdn
 	reg += cdnsp_find_next_ext_cap(reg, 0, RTL_REV_CAP);
 	pdev->rev_cap  = reg;
 
+	pdev->rtl_revision = readl(&pdev->rev_cap->rtl_revision);
+
 	dev_info(pdev->dev, "Rev: %08x/%08x, eps: %08x, buff: %08x/%08x\n",
 		 readl(&pdev->rev_cap->ctrl_revision),
 		 readl(&pdev->rev_cap->rtl_revision),
--- a/drivers/usb/cdns3/cdnsp-gadget.h
+++ b/drivers/usb/cdns3/cdnsp-gadget.h
@@ -1360,6 +1360,7 @@ struct cdnsp_port {
  * @rev_cap: Controller Capabilities Registers.
  * @hcs_params1: Cached register copies of read-only HCSPARAMS1
  * @hcc_params: Cached register copies of read-only HCCPARAMS1
+ * @rtl_revision: Cached controller rtl revision.
  * @setup: Temporary buffer for setup packet.
  * @ep0_preq: Internal allocated request used during enumeration.
  * @ep0_stage: ep0 stage during enumeration process.
@@ -1414,6 +1415,8 @@ struct cdnsp_device {
 	__u32 hcs_params1;
 	__u32 hcs_params3;
 	__u32 hcc_params;
+	#define RTL_REVISION_NEW_LPM 0x2700
+	__u32 rtl_revision;
 	/* Lock used in interrupt thread context. */
 	spinlock_t lock;
 	struct usb_ctrlrequest setup;
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -308,7 +308,8 @@ static bool cdnsp_ring_ep_doorbell(struc
 
 	writel(db_value, reg_addr);
 
-	cdnsp_force_l0_go(pdev);
+	if (pdev->rtl_revision < RTL_REVISION_NEW_LPM)
+		cdnsp_force_l0_go(pdev);
 
 	/* Doorbell was set. */
 	return true;


