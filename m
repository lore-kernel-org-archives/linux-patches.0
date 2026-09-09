Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056E8577E3C;
	Wed,  9 Sep 2026 14:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963588; cv=none; b=Bt2K2MZy+31yZXjIgGflKw6spvtqJLDIVMjxs6FjdXD4v13mF77+6vNE//bqlnSHQBP9rHV59GaF6ykixRvQVpeIkDVbuiUMUgP/VLcHWVhncixNYBassMD6nYDEgCBuP+C9ZsEOXYcCqv96YBqHpRWUmTVbeHD7nHD6vFIytTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963588; c=relaxed/simple;
	bh=ZeID1KBBSB6x0SzkNRZP6Lb5vqxpmd5h6ethk5lJF0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5N+4Mvy09ygcKZBt3WyyEVsP4Ke+mpl0ejI57TlaLyhnib7TBGGUhIxLN4cugNvWXUoMV9h8t1aeHjWZwFAHJGiDZelFkn+qqs/jTZohsc9YuhmPrsahjFRF4mTwZ/ljAWIk3uDq0VYtorFPmL4vVgwc279+JUa8+qYYsF9V4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzpYpxZn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzpYpxZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C391F00A3A;
	Wed,  9 Sep 2026 14:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963586;
	bh=BCyWwKCK/KrLjoIxcRp42ao1oesY9DstUq46v3T90KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HzpYpxZnKbsXOa4+2WX6UOLnxbA874kqUyXZB4/wkSVte+WqW6sQNu3Oc7LTihZOf
	 OFNQzcnhReTxg03FiEU6pEJAdfEF8ktZDlua72UH/dEOkKh5q7Bqn77ltRX0kNVVny
	 6vAovWk6G1AApBhoS7w9Hq1sehPildxGqSSKyW4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.18 131/583] s390/vfio-ap: Fix hot-unplug skipped when last AP adapter or domain removed
Date: Wed,  9 Sep 2026 15:36:56 +0200
Message-ID: <20260909134242.681248811@linuxfoundation.org>
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
@@ -2554,24 +2554,28 @@ static void vfio_ap_mdev_hot_unplug_cfg(
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


