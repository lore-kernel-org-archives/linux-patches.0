Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084F915B0EC;
	Mon, 29 Jan 2024 17:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548212; cv=none; b=dMN7CRVsMrVN8KOGP7C+oui+UFbvy2+4an/pANMBsdieZ5LxAtc5pm+BnPE8EPmWE56y+A3IbAD5CltEK4PYGK+3G9lIUe3HU9teWpy2e/oDbKWtmBXCsFUM6AuUG6OlNBqx/zeudAjG1CF0vKu0MgZOKgLj7vkZF/Li01I0OZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548212; c=relaxed/simple;
	bh=WPo+op3tnvst4nxsMelMFfkXXFYYMLGNydbCK/WNqkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kj+gSwDg9Sd8ljF6Tom51fKIsQ0vjzYscgPHnoZ4Om+sTnWKZXsIMrCBStee+VDR4OGmS99FlOkpKHqZudct4YEuTiJyumpjY0fSJr1kNG6nV3JlUHok++FF4k63Jh9tg9y6SaVW3/jcS/+iXMcGX7x/DGuedcrVrv4ckEgWWAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hd2P9Fwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hd2P9Fwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A490C433A6;
	Mon, 29 Jan 2024 17:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548211;
	bh=WPo+op3tnvst4nxsMelMFfkXXFYYMLGNydbCK/WNqkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hd2P9Fwod0cpN9F63Q0ZaSXOJlwEQSoLDftLQnqYwzBNSHZJBFLA1jzZBsllY2igl
	 c8DRfPcPTnKSdduNW25Zp2mID9PY822znwJYV2lp9ncHUId5E29pJj2SqK2eaGeAGb
	 75Mg6jdfkI5as4y/UUGRet9DLue4MFzKeVkbylY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.1 021/185] s390/vfio-ap: loop over the shadow APCB when filtering guests AP configuration
Date: Mon, 29 Jan 2024 09:03:41 -0800
Message-ID: <20240129165959.286016022@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -660,8 +660,9 @@ static bool vfio_ap_mdev_filter_matrix(s
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


