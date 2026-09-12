Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CA033C1BE;
	Sat, 12 Sep 2026 15:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228124; cv=none; b=Eb1HD7UULxv+7oep233Il0RAYOA5nvoaLxgM5RBCST0LpNEICksbdvub9EAn2cbjRXAbjuXJzwDT1ycCkWOtkeDeQZL2TR0FfBQp6WVr257htzp/1DFIJl1DewUTGlr179ywQ5HZyazZn92rvJQn6toCsrtjiOs+QSesSXM3Ni0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228124; c=relaxed/simple;
	bh=Lrr8YeHRjRZejz/7+NpL1ZH4WWTzs8c6jbScDWtm8lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBX4dTFo0p4HP7SDKDxJZLs28X03Q7VKnAkkDEm0bkgXpb8+tKQ6zv7rw6AHVwKsMYD3tnrE1H3whKZCIg7LgsYx5bFyTo6FMfMYRZZvG659CNTHfDSpT5eCx6k4PwjziBTAjfmNHMB8g2FtkK1LY8Cv4kSXsaICFeeFe8PGz0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnbBCCgT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnbBCCgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C7E1F000FF;
	Sat, 12 Sep 2026 15:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228122;
	bh=DV90eLf2DCXEiuw6HMy6VGLFmCH4N2PpkXiFNUzTrUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xnbBCCgTrQjV5fZybaFh69kBkQ9r12+Lw9myWGt10PrrGANhfOYi/74B2VlXF9SNZ
	 Blw5enA5GOi1i/ngkNmX+uMJd9mNZGG6/UBg+e0TuBd1hrzLYraFSQTNELaXCNNIna
	 Db1WdWj7ZzLo94MtBhD0qWeEoiX3V7EtiKV9OMCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.1 0320/1191] s390/vfio-ap: Fix hot-unplug skipped when last AP adapter or domain removed
Date: Sat, 12 Sep 2026 08:50:48 +0200
Message-ID: <20260912065555.417012339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Krowiak <akrowiak@linux.ibm.com>

commit 917f509bfb88048094dbb85c4e9dbc4d6fe4a886 upstream.

The vfio_ap_mdev_hot_unplug_cfg() function uses the return value of
bitmap_andnot() to determine whether the guest APCB needs to be updated.
However, bitmap_andnot() returns false when the resulting destination
bitmap is empty. This means that if the only adapter, domain or control
domain assigned to an mdev is removed from the host's AP configuration,
the bit is correctly cleared from the shadow APCB, but bitmap_andnot()
returns false because the result is an empty bitmap. Consequently,
do_hotplug remains 0 and vfio_ap_mdev_update_guest_apcb() is never called,
leaving the KVM guest with stale hardware access to the unplugged AP
devices.

Fix this by replacing the bitmap_andnot() return value check with
bitmap_intersects() to determine whether the shadow APCB actually
overlaps with the removal mask. If there is an intersection, call
bitmap_andnot() solely for its side effect of clearing the bits, then
unconditionally set do_hotplug to trigger the guest APCB update.

Fixes: eeb386aeb5b7c ("s390/vfio-ap: handle config changed and scan complete notification")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1988,24 +1988,28 @@ static void vfio_ap_mdev_hot_unplug_cfg(
 					unsigned long *aqrem,
 					unsigned long *cdrem)
 {
-	int do_hotplug = 0;
+	bool do_hotplug = false;
 
-	if (!bitmap_empty(aprem, AP_DEVICES)) {
-		do_hotplug |= bitmap_andnot(matrix_mdev->shadow_apcb.apm,
-					    matrix_mdev->shadow_apcb.apm,
-					    aprem, AP_DEVICES);
+	if (bitmap_intersects(matrix_mdev->shadow_apcb.apm, aprem, AP_DEVICES)) {
+		bitmap_andnot(matrix_mdev->shadow_apcb.apm,
+			      matrix_mdev->shadow_apcb.apm,
+			      aprem, AP_DEVICES);
+		do_hotplug = true;
 	}
 
-	if (!bitmap_empty(aqrem, AP_DOMAINS)) {
-		do_hotplug |= bitmap_andnot(matrix_mdev->shadow_apcb.aqm,
-					    matrix_mdev->shadow_apcb.aqm,
-					    aqrem, AP_DEVICES);
+	if (bitmap_intersects(matrix_mdev->shadow_apcb.aqm, aqrem, AP_DOMAINS)) {
+		bitmap_andnot(matrix_mdev->shadow_apcb.aqm,
+			      matrix_mdev->shadow_apcb.aqm,
+			      aqrem, AP_DOMAINS);
+		do_hotplug = true;
 	}
 
-	if (!bitmap_empty(cdrem, AP_DOMAINS))
-		do_hotplug |= bitmap_andnot(matrix_mdev->shadow_apcb.adm,
-					    matrix_mdev->shadow_apcb.adm,
-					    cdrem, AP_DOMAINS);
+	if (bitmap_intersects(matrix_mdev->shadow_apcb.adm, cdrem, AP_DOMAINS)) {
+		bitmap_andnot(matrix_mdev->shadow_apcb.adm,
+			      matrix_mdev->shadow_apcb.adm,
+			      cdrem, AP_DOMAINS);
+		do_hotplug = true;
+	}
 
 	if (do_hotplug)
 		vfio_ap_mdev_update_guest_apcb(matrix_mdev);


