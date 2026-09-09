Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0675353FD2B;
	Wed,  9 Sep 2026 13:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962140; cv=none; b=Bjo8pPtQ8QsvbrlAgwHyZOf6M+w9NuEtrxEL02XoDUXJ7thVXb2kQGuYHPvymrFCROHAybp3eBpZwXu7X8+xiDg6L5MNMv9A3SG4QW+EOp0LBlLZL6FemoYRlqtsPUrtganHii1UI065R4ZaoGaCj/oVSkC+HIHZpz6nT8WYy5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962140; c=relaxed/simple;
	bh=sa+GXZ7IcqhfmQyL2dOMZiKanPDUgTCPJSBbmJVguB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRh5yltAo56DBdkYDIrln5+fnToVxqo6rq1v6TMznidbcI5EK5OMtmp6bKlIxaaiMzRORFBNrrbuPFWpqKXdfKrk7ySIY164rVVwBgIX3pakDgg+CdeOSadmILvZKuGhm4wUvzHJbCLbSjCsN5uHKpDDinkV7CiDe4pMAxrjdlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5qS/AtQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5qS/AtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443911F00A3A;
	Wed,  9 Sep 2026 13:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962138;
	bh=uFGYeNigbjexZ6gkLH7GnwdyvehpkV7oecdSG9usVDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y5qS/AtQaXz/0ooM2RwMcRh2KllkDBWG6HCgFNvnGc1OW4+thdFYbTUDycv/0oz6f
	 JrbS3kL1pDrxfyNlvKjIHClteLVJq0nyqGfXajw8Z8xsCAWSR9lB4jcr1i9v23EP7Y
	 XJWX9tYehFM48A6xCjXhJ0ZFYMwoYKmTis8xlZpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 7.2 187/556] s390/vfio-ap: Fix hot-unplug skipped when last AP adapter or domain removed
Date: Wed,  9 Sep 2026 15:37:47 +0200
Message-ID: <20260909134236.982097791@linuxfoundation.org>
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


