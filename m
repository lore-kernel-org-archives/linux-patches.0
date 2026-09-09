Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F1B4C6803;
	Wed,  9 Sep 2026 13:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962149; cv=none; b=XGUdReEAGU+HUiFk3PkhdeKuO+ikW2AgBdqUj0lq0u4IF9n0SqOmurEsvU2XU+nXZRP6yHqiMn+MHa3Kex7SrwcP6VuTTuy1Wm3M/JP4RG4M7sz/j+iv/1KWMGxGmhJzipG3VgUMLC26xch8fWKqZHW0PDAQNZF7S597WCvOWWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962149; c=relaxed/simple;
	bh=dVTEgVty6aM15fSb5gVKyKC5F96rYS0Mef5BqVLqhqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Awv41D8UZEseEuc8lPo5D9i8TjtrdCyNqyBYDUV2G/ytwZ0iyHHKo0i2vcUliegWeqPYanFLu5yVRZlJchPYpRuUt7akjrPijqxQDVOiRLNah+zn7oiAeex0v7juzM5rUGVJGABJ6e3WzyjOin9jWWlAsep0846y0F4BHcWf7Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4ul9ICJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4ul9ICJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD3E1F00A3D;
	Wed,  9 Sep 2026 13:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962147;
	bh=AIZT/QteUMvBhg2eeVvUrOam+ooUOgkmJjIfvW1kgNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4ul9ICJDdIbo7y2IyOoIcssySlLZrXBoubVK2KX1Kp+fAxQ3QiAYd42QTd53DKNj
	 8FRhVpQTcYeqlMHsu6a6WCVvCn9M8szrOX9X0b2Z17vzzEnPJPVW6pA+Xi9FkFJvIm
	 d1RCKMi7Mua24CG5FLgGpB7EK1ECQu7yH9cnxYPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 7.2 190/556] s390/vfio-ap: fix potential use of uninitialized apm_filtered bitmap
Date: Wed,  9 Sep 2026 15:37:50 +0200
Message-ID: <20260909134237.088578584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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


