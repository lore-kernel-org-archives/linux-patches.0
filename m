Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013355678C9;
	Wed,  9 Sep 2026 14:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963582; cv=none; b=OGgnhoAgMIE1UBOzJXuIKGtnPPb8C2A29CFe64M9yNcnrynDYqu2ASzEhejYSKAHikuSwYmvUWrC1/1tCz5kBXPkBHMr39BDAkdhY3wvPG3PY3CQX0Cwuzi5c56UKTryfDIfs1WAVDdVGz4/fu7iurghoZtY5DTsYc1sC/fIGd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963582; c=relaxed/simple;
	bh=lcgJ+9sY2hkbupynJmRgBevLWI2D9mfw3GLuJp8i6Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5XE/l97hOP5BwSLvVBUQKDLqUyCOCNmy7LJUpVZ3wM70PXaXS5fdd/0ZjRyuVq0GbN86BPQQys49NW0VAdNxwxc5Hsnsf8FMARhohFyh9bsMf/rjFSIRIIg35Pd1Bn+m80WBsxRjl0sW+u9oYzEfbZyLGIcq62IWO0RRmllbpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjoUCVRD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjoUCVRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AA41F00A3A;
	Wed,  9 Sep 2026 14:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963580;
	bh=GjWk6rkU6m24YdwtiNWb/r03s1sCjDnw7LvhtLH+0Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CjoUCVRDBSJpdedSRN4OpvMW+DdNoGT9R2njYc4aoRG7xSMfswhP/uNYDCQ+kymUR
	 ngi6mP4O479gUGfSozJfru3utXtbs/tzK62pelc6JE4D0cQEjd29ATBiW22JhsdnuY
	 9DOvzr4tZnJmWqmFKkTAov1WDO1iRFUtBfv51YxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.18 129/583] s390/vfio-ap: Fix control domain removal in vfio_ap_mdev_cfg_remove
Date: Wed,  9 Sep 2026 15:36:54 +0200
Message-ID: <20260909134242.609641449@linuxfoundation.org>
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

commit 6b8a02e216f6b520cc029e43ddc83956605135d5 upstream.

The vfio_ap_config_remove function uses the bitmap_andnot function to clear
bits from the matrix_mdev->matrix.adm bitmap (specifies the control domains
assigned to the mdev). This prevents the explicitly unplugged control
domains from being removed the KVM guest. The bitmap_and function is used
instead.

Fixes: eeb386aeb5b7c ("s390/vfio-ap: handle config changed and scan complete notification")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2610,9 +2610,9 @@ static void vfio_ap_mdev_cfg_remove(unsi
 		do_remove |= bitmap_and(aqrem, aq_remove,
 					  matrix_mdev->matrix.aqm,
 					  AP_DOMAINS);
-		do_remove |= bitmap_andnot(cdrem, cd_remove,
-					     matrix_mdev->matrix.adm,
-					     AP_DOMAINS);
+		do_remove |= bitmap_and(cdrem, cd_remove,
+					matrix_mdev->matrix.adm,
+					AP_DOMAINS);
 
 		if (do_remove)
 			vfio_ap_mdev_hot_unplug_cfg(matrix_mdev, aprem, aqrem,


