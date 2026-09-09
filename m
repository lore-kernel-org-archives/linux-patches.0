Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4994C565112;
	Wed,  9 Sep 2026 14:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963599; cv=none; b=FS8T/j82TI3pAbv1QkkgQNxj+8bNzolPQZ/GTgRRhhSy52wpabADVfdHXvmN/nyuKTVPaQ/ff2GFUYg8ERR/qX3hcvYKe7XzUXwcWCJaPjkLOZ4SRKeh5WCuVtKQ4964BvSTWMQJWsllOYFX5ZqOxMFTpImdYBq+5pZF/fNgZbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963599; c=relaxed/simple;
	bh=SFU8x6WYPZ7F/HP92mFwtXV9QINtM144CjVQJ8Zhp1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5t7lvyHRTHDCqAJ1kDpwziddPYXug7CUAgEaDktLryXThVh9vM1AQgYR50dJRAZbvHsbE++cZTZPDHSP/smMjk0DoEwuaRdcwWqPTDZQUoyBATw9gpX4pi8NQMKH1Vq+jlFGrH9MZu4uEN3/XlxglKnCKFN4wqO/31aOEmrIsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWvRFJ3+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWvRFJ3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00061F00A3A;
	Wed,  9 Sep 2026 14:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963598;
	bh=HjzbtmMrdjX6U7r6fGFdCKGQKtsqSo6d4F+5GGzK5UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BWvRFJ3+KmAf18PiG4G35vD39wuxhXfHl8m1yTwohFrjS9/BVX7IM8R21sNrKyqZA
	 hsIsbvQ8OaeIs/Fth8S4YweMHgG0zp9D+RKZGp+uE01nrstH8rV68ywIm2aS/pzU7u
	 0ZBZezFdhQjukWZjf2H0jEDCP+X3l144tkdcjcrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.18 135/583] s390/vfio-ap: Fix required lock not held during update of ap_matrix_mdev object
Date: Wed,  9 Sep 2026 15:37:00 +0200
Message-ID: <20260909134242.814319229@linuxfoundation.org>
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
@@ -2801,12 +2801,20 @@ static void vfio_ap_mdev_cfg_add(unsigne
 	 * called.
 	 */
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
 


