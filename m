Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAB821C190;
	Tue,  8 Jul 2025 16:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992621; cv=none; b=mnzu/ihIbnyagLVOOEP/jcXJIly9OGPLH+p1XIYCQMo0lMTHgNVMybiCFqrkD2s+/DAJ8fbNeUTgSriljbbTsl+cC9kwM+LprBXRN1ztJOh3hX16W/ngOQzNIoRr7QW69ujOFWhezuYvN9GVo26dVP0GKTt4Ddot6J5MH1VIvQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992621; c=relaxed/simple;
	bh=Xef8uLP+wI8HtnmKFur1Wkb116b9fbWieGSHDDmYsEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJP0w2DwT1PrTB5aiuB+0F0mViG8O1fgZNdo9PT1EmwYgx91Q8euEOFzQWCJRcgg9zTJChwh5tbdnoFhmyYCbN6ZotJAwwVJpAlFnEHUJ80AeUuxYlONlMolO1kvRGBiOPNp8QJTrwSQqQBtAuBR4yZ6MpWYdmBZRVsSM/lczOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkpPMvFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkpPMvFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1831C4CEED;
	Tue,  8 Jul 2025 16:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992621;
	bh=Xef8uLP+wI8HtnmKFur1Wkb116b9fbWieGSHDDmYsEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkpPMvFZ5CfRgbl/QtaPMP5ACRPS9RPald3gWgJ/6qF/I+Mf7TvdRefOT4E4ykjK1
	 gzdXQkgIPhbsQZ8neoFRBJ1Xv+NOWaufFuXJikewn5TEQvzcFGAFUMIAX/Jey1kIeT
	 rk74UuS/W1Yw/yUtu0d82YBrFfmTfgUKS5xaLXns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Ruess <julianr@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.12 006/232] s390/pci: Fix stale function handles in error handling
Date: Tue,  8 Jul 2025 18:20:02 +0200
Message-ID: <20250708162241.598367597@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 45537926dd2aaa9190ac0fac5a0fbeefcadfea95 upstream.

The error event information for PCI error events contains a function
handle for the respective function. This handle is generally captured at
the time the error event was recorded. Due to delays in processing or
cascading issues, it may happen that during firmware recovery multiple
events are generated. When processing these events in order Linux may
already have recovered an affected function making the event information
stale. Fix this by doing an unconditional CLP List PCI function
retrieving the current function handle with the zdev->state_lock held
and ignoring the event if its function handle is stale.

Cc: stable@vger.kernel.org
Fixes: 4cdf2f4e24ff ("s390/pci: implement minimal PCI error recovery")
Reviewed-by: Julian Ruess <julianr@linux.ibm.com>
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_event.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -260,6 +260,8 @@ static void __zpci_event_error(struct zp
 	struct zpci_dev *zdev = get_zdev_by_fid(ccdf->fid);
 	struct pci_dev *pdev = NULL;
 	pci_ers_result_t ers_res;
+	u32 fh = 0;
+	int rc;
 
 	zpci_dbg(3, "err fid:%x, fh:%x, pec:%x\n",
 		 ccdf->fid, ccdf->fh, ccdf->pec);
@@ -268,6 +270,15 @@ static void __zpci_event_error(struct zp
 
 	if (zdev) {
 		mutex_lock(&zdev->state_lock);
+		rc = clp_refresh_fh(zdev->fid, &fh);
+		if (rc)
+			goto no_pdev;
+		if (!fh || ccdf->fh != fh) {
+			/* Ignore events with stale handles */
+			zpci_dbg(3, "err fid:%x, fh:%x (stale %x)\n",
+				 ccdf->fid, fh, ccdf->fh);
+			goto no_pdev;
+		}
 		zpci_update_fh(zdev, ccdf->fh);
 		if (zdev->zbus->bus)
 			pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);


