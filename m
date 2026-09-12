Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76291478E27;
	Sat, 12 Sep 2026 11:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213346; cv=none; b=PKh1vvf4xfCmJWD1UnVbTsfOiHnvT5nZEr6pv6MehaNNdOj5i2JHgd0nOp8hgnY2GNu3VzCDGC7XbfUIdnacSmLh5sLGFQZTgwLWvRtHFWZVOGu6yfSgN9OXfG3G072ndAPum0F+dfvFoQk/cqboCZqZAW/BuZqpY4a/OGYuYok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213346; c=relaxed/simple;
	bh=Dd/vPcyIZP5+zJLIwqPUvlQmnv+7o6zyxUcly7j2v+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ypcy4YOjrznUtXg0FPPctGoUry0yRrd4s2E+3hVPOO8AQjJgRFCWw81nw8tl5H+gIirenqB5yXf/esUJB8tJ8LfCZLGtm/J/E0jG1jyzPBm0WZ8oJRZ6GkmsynVIXu5GHf0bZTp9GhZlvAsyKUR6P1k7u6aq2b+f7kn9imw7+WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fC6GuLYI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fC6GuLYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE081F000FF;
	Sat, 12 Sep 2026 11:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213343;
	bh=JGVCKDpGQcjg53W224VmxhvTVooZTi2ACD4v15XfqE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fC6GuLYIeWeqRwmQJygWkQATPtYH514s4ye7iM+NxAWg42k0B7sCluXROMfPkAQ+3
	 x0Fio5RcQFF2AYWb//jWxJUogPH09r+MMcn1YkiU8LbQs8GUY7m3wP564lYFFVkOcL
	 wQ3Fl1IT/w7f4Ocph9RB5jp3FOzkBlPvRGI0k1s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.12 0103/1376] s390/vfio-ap: Fix control domain removal in vfio_ap_mdev_cfg_remove
Date: Sat, 12 Sep 2026 08:42:09 +0200
Message-ID: <20260912065609.853426437@linuxfoundation.org>
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
@@ -2561,9 +2561,9 @@ static void vfio_ap_mdev_cfg_remove(unsi
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


