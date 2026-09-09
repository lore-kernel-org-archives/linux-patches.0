Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F1F1C3BFC;
	Wed,  9 Sep 2026 14:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963596; cv=none; b=IexhzwBk4dCvGNFa3F68ARiRQtygeqnOBaaFiNW34Yw2OfsDxJ1rPflp6kt2o1KYkw/dm18Wud2pX1IHS2SmvDd1y9EA0PJ3qvyxhjcvv1yxVlDvpcwczfrGsMXsvu2/MWnYG1DL0jPcQ0hHlUaCdb3ONN8EOgS7vZb7TkZ3wh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963596; c=relaxed/simple;
	bh=0GBosVtaZB62Suq1w/BI8KVPj2bD0ksLMNLo0poAbs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcfWYbGDbvprww3DZJlSuYwj5ppJ3j5+EpK1zpVa/CJZJP9TbLjqzWoObM4WdmAYO8ZqOVeK9eg48th0hYsU4AjtHxeLgcZtUk+kgDGOlvqEeXds7goP2wASv3AvN5/Fw0FHioabJbZuDlRNSrhCX7fKe8NcyQXJahIXRdqV0bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swsKYk5j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swsKYk5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E1C1F00A3A;
	Wed,  9 Sep 2026 14:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963595;
	bh=OLlYbxhIkBsBgbNU4G6RUsG0HRDiJMmgkaCdtkhbMyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=swsKYk5jX9RPI9ZFBPb9IkabUMDgOxveAkIew3b+IiBBkZy849rk+rrX88ZyBo5Im
	 Ysba+LRxd91WSJiXDcqogqLIG7PHrGmE8QNS4ziDN1aMehC1LtXgtwgOY3Wju+ntjb
	 z6cA/9KLZv4K3l6tGVHrJTI5ELjLOUquQywNqtLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.18 134/583] s390/vfio-ap: fix potential use of uninitialized apm_filtered bitmap
Date: Wed,  9 Sep 2026 15:36:59 +0200
Message-ID: <20260909134242.780801697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Anthony Krowiak <akrowiak@linux.ibm.com>

commit bf09b9d7cd7890bc3a3b7eb63d5ece15f88bfde7 upstream.

The DECLARE_BITMAP(apm_filtered, AP_DEVICES) macro allocates the bitmap
on the stack without zero-initializing it.

In vfio_ap_mdev_hot_plug_cfg(), the vfio_ap_mdev_filter_matrix() function
is only called to initialize and populate apm_filtered if either
filter_adapters or filter_domains is true. If the hot plug configuration
change only adds control domains (meaning filter_cdoms is true, but
filter_adapters and filter_domains are both false),
vfio_ap_mdev_filter_matrix() is bypassed.

Consequently, apm_filtered is passed to reset_queues_for_apids() with
uninitialized stack garbage. This can cause reset_queues_for_apids() to
interpret arbitrary stack garbage bits as valid APIDs to reset, potentially
performing unintended guest hardware queue resets.

Fix this by zero-initializing the apm_filtered bitmap at the beginning of
vfio_ap_mdev_hot_plug_cfg() using bitmap_zero().

Fixes: eeb386aeb5b7c ("s390/vfio-ap: handle config changed and scan complete notification")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2877,6 +2877,15 @@ static void vfio_ap_mdev_hot_plug_cfg(st
 	DECLARE_BITMAP(apm_filtered, AP_DEVICES);
 	bool filter_domains, filter_adapters, filter_cdoms, do_hotplug = false;
 
+	/*
+	 * Zero out the apm_filtered bitmap in case there are no adapters or
+	 * domains to be added, but only control domains. In that case,
+	 * vfio_ap_mdev_filter_matrix() - which initializes apm_filtered - will
+	 * not get called and the reset_queues_for_apids will crash because it
+	 * will access an uninitialized bitmap.
+	 */
+	bitmap_zero(apm_filtered, AP_DEVICES);
+
 	filter_adapters = bitmap_intersects(matrix_mdev->matrix.apm,
 					    matrix_mdev->apm_add, AP_DEVICES);
 	filter_domains = bitmap_intersects(matrix_mdev->matrix.aqm,


