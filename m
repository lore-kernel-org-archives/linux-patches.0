Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5826D55409E;
	Wed,  9 Sep 2026 13:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962151; cv=none; b=BsK2zZ6kcFMp46uwWKzOuj4TxMKYuho8KRp6RNT2skQTaflb4c3Rr/xj+yzPUYMzAAWBFjn9XigO+awwX41/rfRfRt5dgr4uBw0xx4SYuNDaMy5K+WQJqswHl+4dz7UUeptlK7G0dQ9UlKjkjFWdCAJzcsqHrSmys7nqdhUfXZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962151; c=relaxed/simple;
	bh=jdWobruaH/VPI/hr2lUY0NuT0nBm/P1hhVj7916nbZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G10y4W5X9je+YS0QtXQ2rieV9O6olWyUVAQuNaY+f/WKIT6YObUZZDCqzt3Zq9vWscqXlcA3Ck/91rz0JDqItBrnhRWXavqXGbjOfZdPTFJ46sGpOoG3k2pogMmuJx+Z30wX3xkHX5ZeRDkNZ381dk5FwgWc2YsV0IldQljtPtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARXVy/k1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARXVy/k1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B286B1F00A3A;
	Wed,  9 Sep 2026 13:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962150;
	bh=pvYTVVoPt5yoityoZ4+aycYOLylYyUuEje4HlUTSq24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ARXVy/k1qdJKoXY++Erk0C7qgXaWK9YcWOEHE2kvXafzuFEADmTJOIzyvmmDJHz5P
	 uXVq/q5iQhgUlvMsEQzI7f1t35fzryLL3iwqWQyo8RUhc51N3CUFzTSDDwqfOlIyiY
	 nCiqJ++c4b0EZ6v4RWt8x3aECU0DFw/dnqXpkKTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 7.2 191/556] s390/vfio-ap: Fix required lock not held during update of ap_matrix_mdev object
Date: Wed,  9 Sep 2026 15:37:51 +0200
Message-ID: <20260909134237.123582617@linuxfoundation.org>
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
 


