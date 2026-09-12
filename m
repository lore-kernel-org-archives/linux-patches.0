Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D369633C1BE;
	Sat, 12 Sep 2026 15:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228133; cv=none; b=MG5NWuEB2hZjSeBc6+4eeuS2jLMfVqSOhJFHEUSIC1jk8mry2NPuJQFA+Ejo+52jnZ8N+4ts2MJJbvzdEp0wQJrhI9Cyw7zE7Rjzgv6vfJ1k4T+77nNCIJy78aW/F1PwoWpbz/RKULltCx9C+ARoKxkzEIY2pzEgOT2bUL/XPLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228133; c=relaxed/simple;
	bh=zX6Yp7jC8RwIyjqY3v/GLFz9MA2m2tEgh8gOK68GNvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBIn3raxaVKrXNvS3+E4ZfswJMNLhz0fkp/cjQ51sA/fMNCOj/ub7ulYFosCe9t/K/qsvf38E3tJhWiNM2Lo0MBsrHVSgVMPdeqeEJ1T3z6tJk56R+LzNC0q4hV3wvpOXMVPVfA/V3nQn9+/qu3F1lH7mSDw6UxwjiwpbYrLocQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tA6IGuc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tA6IGuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7CF1F000FF;
	Sat, 12 Sep 2026 15:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228132;
	bh=uYulMyS3KmEnp1cwLcOJFC3tq2pKnvx/aKLDF6RraIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1tA6IGucOPlTo/EYHkG2Hsx8XLYrLVEwsx+vF2xHPFUws0FfRq2Mj00CNPZcCQZbt
	 tiyrQVakpk8aR7jdBC4RDxhuocG0puP8/0tGIEVkJIEpd7KLBmuPjmEqVhbZZ0YtdL
	 ybNetD9QjbvObI53kXhaJvyNJEe5Xlt8HplB4QJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.1 0321/1191] s390/vfio-ap: Fix required lock not held during update of ap_matrix_mdev object
Date: Sat, 12 Sep 2026 08:50:49 +0200
Message-ID: <20260912065555.439233563@linuxfoundation.org>
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
@@ -2184,12 +2184,20 @@ static void vfio_ap_mdev_cfg_add(unsigne
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
 


