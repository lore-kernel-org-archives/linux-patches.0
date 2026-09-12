Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A7A36167B;
	Sat, 12 Sep 2026 15:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228118; cv=none; b=Qq5SWJuIAYl/0RDiArMERVci0tqKimKwUIpkszQQbIPHA8BoyrZ9YgK9kMPrNdZkhMfd6QAIPzqvbYQB3mr5VE/CNuW6XZfkg28fkJicSJmDhK9gh37FXhtW7S2biGrDQS7piUWor+lsPXiMLSzrR+VAnZqwLPR3xgiXuZlvDcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228118; c=relaxed/simple;
	bh=DjEI1nFZt6U+9Ez0kj/aICtSJDk5WRpPlfXkaf9w9jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoM5I/4aCIhIoNEtFzij2JDz8f197xksCjFBbe4q+gNb71HVrbPIJnWtqijddHlmJ6E3rRWFMwTu4oadUuzaQYgxkZuWrpDklBKUKkOxJdYeidhIjvFix1RtA1BKXfT2efM6NKx1gvqCscCgA7CRvdTGsColFVMZ64yiS17iHVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTzH7ghs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTzH7ghs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818A51F000FF;
	Sat, 12 Sep 2026 15:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228117;
	bh=iPkss5zXRy3yB180dPeH3n+lXW7zmWSY9E5qnjA4us0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TTzH7ghsXbooaPdEsYQllLWe3rXUGDnSQUFZdFPfkvjVicT1GkQd6jnYyuG6OqaFO
	 QaFkuGhxpO2wSBTM4yg6oUBoJ623wh4+QWkqsi1+716/jazmbHiiMUDKvKZlb4yrI9
	 6iCPPr8zJBdLP57U9vdJHkqCrUsDZzlc5HAmBdGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.1 0319/1191] s390/vfio-ap: Fix control domain removal in vfio_ap_mdev_cfg_remove
Date: Sat, 12 Sep 2026 08:50:47 +0200
Message-ID: <20260912065555.395548171@linuxfoundation.org>
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
@@ -2044,9 +2044,9 @@ static void vfio_ap_mdev_cfg_remove(unsi
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


