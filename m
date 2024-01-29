Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F17B15A4A3;
	Mon, 29 Jan 2024 17:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548058; cv=none; b=NsHO5mP3DdzO3/xm5XTNeX49mi/KXTQjdYcnqfbGI9vn/i+tnpXXKkaFbFX12MuDIQUIKoeklSreT718c2lcX7oy25Xvgqq3C9aISao5lkLYvFV5XHa4/JJEt15PTP97UIxDpH1/RiDxPFGT26FMzc+O6EouaNukvgn4ew2usZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548058; c=relaxed/simple;
	bh=WmtHhPx4MVzLreOqMslc/qGXOlPvtDeVJ6HKfNQXRFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AG9o37n6C4wxnNAc+Iv0cttyS0Mqlwv1lN1+yXGWinVHgDzT1jgFpRbEA4ExCarOKbNLxiFEm3NU9QoYYkFkh2ZWanE0WOwW8QUaCD4PETWwTeAy2CDV1X8fSkQdN1wbCBjNQRLW2Cy5y+gd9i4IR1NWzyBj8jso9McCt+AiEnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sv4DqdpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sv4DqdpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6BDC43399;
	Mon, 29 Jan 2024 17:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548057;
	bh=WmtHhPx4MVzLreOqMslc/qGXOlPvtDeVJ6HKfNQXRFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sv4DqdpKAageDZ5+stULUccjzZrjC0JamUKA0GrfWs+axHq1vJLgHw4KIztBcCZ3/
	 HWVE71LtGl18zye+RHhvITh94nmfetmSwFl8QHCikv4yUEE+GpHGPHslL92vsXBMgv
	 wZBeS0jK10PIUAL0C7Rb4cBu3pO7FTeVE6VZO/5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.7 037/346] s390/vfio-ap: loop over the shadow APCB when filtering guests AP configuration
Date: Mon, 29 Jan 2024 09:01:08 -0800
Message-ID: <20240129170017.477748271@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

From: Tony Krowiak <akrowiak@linux.ibm.com>

commit 16fb78cbf56e42b8efb2682a4444ab59e32e7959 upstream.

While filtering the mdev matrix, it doesn't make sense - and will have
unexpected results - to filter an APID from the matrix if the APID or one
of the associated APQIs is not in the host's AP configuration. There are
two reasons for this:

1. An adapter or domain that is not in the host's AP configuration can be
   assigned to the matrix; this is known as over-provisioning. Queue
   devices, however, are only created for adapters and domains in the
   host's AP configuration, so there will be no queues associated with an
   over-provisioned adapter or domain to filter.

2. The adapter or domain may have been externally removed from the host's
   configuration via an SE or HMC attached to a DPM enabled LPAR. In this
   case, the vfio_ap device driver would have been notified by the AP bus
   via the on_config_changed callback and the adapter or domain would
   have already been filtered.

Since the matrix_mdev->shadow_apcb.apm and matrix_mdev->shadow_apcb.aqm are
copied from the mdev matrix sans the APIDs and APQIs not in the host's AP
configuration, let's loop over those bitmaps instead of those assigned to
the matrix.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Fixes: 48cae940c31d ("s390/vfio-ap: refresh guest's APCB by filtering AP resources assigned to mdev")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240115185441.31526-3-akrowiak@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -692,8 +692,9 @@ static bool vfio_ap_mdev_filter_matrix(s
 	bitmap_and(matrix_mdev->shadow_apcb.aqm, matrix_mdev->matrix.aqm,
 		   (unsigned long *)matrix_dev->info.aqm, AP_DOMAINS);
 
-	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
-		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
+	for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm, AP_DEVICES) {
+		for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm,
+				     AP_DOMAINS) {
 			/*
 			 * If the APQN is not bound to the vfio_ap device
 			 * driver, then we can't assign it to the guest's


