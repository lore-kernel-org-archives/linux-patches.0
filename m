Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA95562600;
	Wed,  9 Sep 2026 13:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962134; cv=none; b=ffsBGXXwz6wo9SeQkTaH7j5SyND+16tsuIcRXMXqpgZbYCswOCFYKouvmGez5iSvbdJNnXTJygBr0zp/dIR87FiSVPtprhiJYT8CoMCOIKn8GffgQcwey0F1Bc8Y8WFt//Kz2uj3zU+1yEvPP5fLMKML/Rl7eMYl1o1zniYA3sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962134; c=relaxed/simple;
	bh=iZC2b5chrgDmR2G3J56QRZxDDWicfPAUc2OHk0KPvBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9pfR/qvPNmVIo3Th0N31oMwCBDwVJ/K/w9ly8H2D9KNKUS3cfIh2tBQT2qC8WGSVqX43X+0Pu7V+a2uIPJOMifGPbBYQwMfx/4dNaL/SMy1lmbJpESoY5UT4EFiuivNMJwsuIc9qsXcmRhc+aoUSpxCOEAZ2K9dbIplRSVxan0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InrLTqvp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InrLTqvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873BA1F00A3A;
	Wed,  9 Sep 2026 13:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962133;
	bh=gEe6FzNboD0eZc/i/gFvgEGJB9e2v2nRqmZXz3uK/90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=InrLTqvpufLahFjkTm3TU7M6VkkHJqKPySXnK7CHY0zxL+/Rxm7z/KhfvWyaTlx0m
	 ghZ8kRS2nYwIhoXC1JmclkuKf3CKU6LyQbd7TVzSWEs7X7SguaPV/DHxZkif0F9PBX
	 GNJXLtImSh0mjribq7ddinwn1FM9v35SI4eIixbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 7.2 185/556] s390/vfio-ap: Fix control domain removal in vfio_ap_mdev_cfg_remove
Date: Wed,  9 Sep 2026 15:37:45 +0200
Message-ID: <20260909134236.915366678@linuxfoundation.org>
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


