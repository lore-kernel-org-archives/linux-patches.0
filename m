Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8433E4C90;
	Sat, 12 Sep 2026 11:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213355; cv=none; b=Mfko1O8FvwD3kIyBVeFRC2D8v9JWHrx4MWdkCow3CMQyJoLxn/Bl8rL2RuAX4Ykew8PNhiEpIa24hIylZ+75lfNcHxJXZmpFx8qzLGREKDICj6lcNMAjUgXmJZYf5uQw7FFhe62RBed2nxOnwIhRhzgJ7A7MSY5xvuzRZ0YhoT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213355; c=relaxed/simple;
	bh=V5H1svWl9ae6qogBSo4yFFsEZLXq+OUbKaChxIrb5rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLZZopn5w7mCmVBcByPCChz7ZApACgXuDcBJkbzEnDo3dLCjvIaKR6mKcYOVKM/IDxbElaMjSmiuoGm7eNmOEB7O+Tm/qrlWOindQnatrgbTQpbobdmDdnYvU+DjD2LZrNjh7hpXH0ZGCbxBGu1Zyp8PDsg6oHERRt2OgWbnjkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sg6SbrYr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sg6SbrYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE2F1F000FF;
	Sat, 12 Sep 2026 11:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213353;
	bh=SvsSDDOC/bG7bxI+jOlNGpvjnSoEezMpVdSWnKL0EvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sg6SbrYrdeazjXeiBgcRnDWARfgBRViwtXxVGQftXzcVNrkqY44Aw2pRInj2299LI
	 FW8tOSCN3IMjaTILBjaR9L0z/sZOslAinz70rLlvVjflbaNbIt1kw8j4mEVftZZKjo
	 TfygVxVC45FIsvOgCJFl+TaT7uYdX8iNgH7Hmxnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.12 0105/1376] s390/vfio-ap: Fix hot-unplug skipped when last AP adapter or domain removed
Date: Sat, 12 Sep 2026 08:42:11 +0200
Message-ID: <20260912065609.898677448@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2505,24 +2505,28 @@ static void vfio_ap_mdev_hot_unplug_cfg(
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


