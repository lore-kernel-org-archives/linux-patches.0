Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EFF55C329;
	Wed,  9 Sep 2026 14:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963579; cv=none; b=tASPfaWTFZUpBbwoVUJvaun5Q7cAve/UKQ5pR5Zg3g76b1mZkV4AmGUF64nxVnhbGcXK13ye5QiNx788A58TMlvvMIq/G8+AFIQQO5m9Ud4Ap5KphVocNiXol43IhsNw/vf400L+vVnJrysouitj5vWziI7xjBZIfvTyIxhFer8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963579; c=relaxed/simple;
	bh=LYUtls2EweRO5CpOsh7vUpIAy8mZ1STxpwe65pMggfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBM9XPmqUd+T7HqX64cvs0hM+hTVJPEC8D5rCaZCKWWr+LZLi7a6xnumWT661RyNiNuPsmWRUliT2kgWVPBiKAp064VPPYJ7lCzrnb2hgVCe56Xs4yt7aM/KSIhrmJmf/gSxPSfTdnNJqW+OMQuAM5zHOmRf0YYD3kRtFlxASrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYRHM/wK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYRHM/wK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609081F00A3A;
	Wed,  9 Sep 2026 14:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963577;
	bh=5yG09hzKrklU+qkwwMbl/KvARY0U4y0dwR/o3t/i+rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tYRHM/wK3WnrS8XOdgOqYaiWwVLmqyhHyLyyfDnykBFztE7Oyc7JgEUoxHwyy+uke
	 oTQGmf8E9cmSreDQ3VmTGsG4gKQQqFhrX+s2qHK+hxbM9hkEcBEKvSMcOg7ZgD2ljv
	 Mikp9sbuYlyQQhTxIsezOvFdPnGFgnzERkMshsTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.18 128/583] s390/vfio-ap: Fix stale do_remove flag across iterations in vfio_ap_mdev_cfg_remove
Date: Wed,  9 Sep 2026 15:36:53 +0200
Message-ID: <20260909134242.576445676@linuxfoundation.org>
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

commit b1f092d94f621307927f145e3cc31893da51fc08 upstream.

The do_remove flag in vfio_ap_mdev_cfg_remove() is initialised to zero
before the loop that iterates over the list of matrix mdevs, but is
never reset at the start of each iteration. Since do_remove is
OR-accumulated across iterations, a positive result from one mdev
carries over to subsequent mdevs.

The fix is to set the do_remove flag with the first call to bitmap_and;
for example: do_remove = bitmap_an rather than do_remove |= bitmap_and.

Fixes: eeb386aeb5b7 ("s390/vfio-ap: handle config changed and scan complete notification")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2598,15 +2598,15 @@ static void vfio_ap_mdev_cfg_remove(unsi
 	DECLARE_BITMAP(aprem, AP_DEVICES);
 	DECLARE_BITMAP(aqrem, AP_DOMAINS);
 	DECLARE_BITMAP(cdrem, AP_DOMAINS);
-	int do_remove = 0;
+	int do_remove;
 
 	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
 		mutex_lock(&matrix_mdev->kvm->lock);
 		mutex_lock(&matrix_dev->mdevs_lock);
 
-		do_remove |= bitmap_and(aprem, ap_remove,
-					  matrix_mdev->matrix.apm,
-					  AP_DEVICES);
+		do_remove = bitmap_and(aprem, ap_remove,
+				       matrix_mdev->matrix.apm,
+				       AP_DEVICES);
 		do_remove |= bitmap_and(aqrem, aq_remove,
 					  matrix_mdev->matrix.aqm,
 					  AP_DOMAINS);


