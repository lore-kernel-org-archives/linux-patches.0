Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3380C42885F;
	Sat, 12 Sep 2026 11:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213368; cv=none; b=tkQB8wgs6AUWBjrnvYmcmAjAz0nsXHjqHG4KDqb0tpjvHBZgO19ABonCfK/TtzMXJL7Af3nsEHTV71sTAz8io4c6nFU2uY0V3ut9KDGT+u0+dGmzgFPtYIutJ7R9J+wrDc/XLDsYzsDc2TF3Uw7IhTY1PW5bwrfFCuuA9SOnfmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213368; c=relaxed/simple;
	bh=cABF92e1ORskuw5Gbg0Ofi9io/W4PRhQEP8YYCQEV/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+SwQAYbgexyXBnivJuT1k2PMzdk91Q50RdgW07y4HNoz32MXvUxqWC1gkylP0O/g0xC8bMswsZfFyjFAJx2Tz3rvhJxeXoYr2sD0XVdhFbHQ0ZZi4Xs719N7ti4+vY1HeUOK+J0bwOdToGzLM46CsJT9yc7i7dUrQj242SXxd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlUqDcA/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlUqDcA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3807C1F000FF;
	Sat, 12 Sep 2026 11:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213367;
	bh=omfcDTQwdRfIiu8gZCtO5qpWbD1ug4nj25PURUqz5UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NlUqDcA/HFquNY60OWs4KeDvazcf372UX1Ia6Bz3Lgyei/AKpzYKR/NVHxKBJgcgN
	 LapyUeeTevsSbNnLx09+gi0ZaXQALr+LpleWfziexSiJX/tRHX6+4RWIJ0lvo1pOIS
	 EvT7nAKxAgOmjgcduzpfBph5UZlRPvUp2uckkoM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.12 0108/1376] s390/vfio-ap: Fix required lock not held during update of ap_matrix_mdev object
Date: Sat, 12 Sep 2026 08:42:14 +0200
Message-ID: <20260912065609.963618495@linuxfoundation.org>
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

commit 5883528250be57fa92270459b33603ff52de0a91 upstream.

In the vfio_ap_mdev_cfg_add function, the apm_add, aqm_add and adm_add
fields of an ap_matrix_mdev object fields are modified while not holding
the matrix_dev->mdevs_lock. This lock must be held while making these
to guard against a race condition with another caller that may be
concurrently modifying these fields or any of the fields in the
matrix_mdev->matrix.

Fixes: eeb386aeb5b7c ("s390/vfio-ap: handle config changed and scan complete notification")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2737,12 +2737,20 @@ static void vfio_ap_mdev_cfg_add(unsigne
 	vfio_ap_filter_apid_by_qtype(apm_add, aqm_add);
 
 	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		/*
+		 * The mdevs_lock must be held in order to access fields
+		 * within matrix_mdev
+		 */
+		mutex_lock(&matrix_dev->mdevs_lock);
+
 		bitmap_and(matrix_mdev->apm_add,
 			   matrix_mdev->matrix.apm, apm_add, AP_DEVICES);
 		bitmap_and(matrix_mdev->aqm_add,
 			   matrix_mdev->matrix.aqm, aqm_add, AP_DOMAINS);
 		bitmap_and(matrix_mdev->adm_add,
 			   matrix_mdev->matrix.adm, adm_add, AP_DEVICES);
+
+		mutex_unlock(&matrix_dev->mdevs_lock);
 	}
 }
 


