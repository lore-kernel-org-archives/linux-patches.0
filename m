Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DD442885F;
	Sat, 12 Sep 2026 11:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213364; cv=none; b=CB9BgZFWNNRrkzzKkObJF1nnQvAwAH+kvnPSCJr3eM1A3D4CsTs0EY1IuUVSxcpXegc0YK+Q9rRyR8u3XXOtBJAz3AttMhV72yOl8ULwlt3cb4ViXJPgTwAGIxBcCuZrXBZh3XxTp5xZbEtJ3WzcHCg/QoCh+VtyVNLzbQlijS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213364; c=relaxed/simple;
	bh=fGkDf3H1+K+EbU+WSUDuyUq61PfywSWIkno7+NaWPss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtxu4C9967nRCeYYhuwTl7zWNVlptM3XUb69IN+6pZkXwuDGJ15GnH8d0qOJOCMsgFn0If0s5ndZkRyA5cDxRYgFQjdnzC2m0iU69T8gHAIMJrSJSkHpYK6NsEJcbdYOzrOGdDnBxGwqG0PWZMrjvk211dmOzC0okyrb0+qqEI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8Gik4ao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8Gik4ao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEEB1F000FF;
	Sat, 12 Sep 2026 11:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213362;
	bh=37bA10lV+f02yItLQfvrPh672BEwQseeQaQSPflaX78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l8Gik4aoxxZbMPZtp/RrPz7qsQMNaJmQtJEDf2+dxmIMp4iZWVpHSoThnyHi4zBTJ
	 7L0/hsTlFGlxkHmVRLWTtIp+s2ZnR5Ld1bCiuxG9BPM0QP+Nv6sn6N4AXBtP77q/vj
	 28VpZ21S0OsSWJlem0w+4Rb86K4qFiiPFZaaaNck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.12 0107/1376] s390/vfio-ap: fix potential use of uninitialized apm_filtered bitmap
Date: Sat, 12 Sep 2026 08:42:13 +0200
Message-ID: <20260912065609.942726836@linuxfoundation.org>
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

commit bf09b9d7cd7890bc3a3b7eb63d5ece15f88bfde7 upstream.

The DECLARE_BITMAP(apm_filtered, AP_DEVICES) macro allocates the bitmap
on the stack without zero-initializing it.

In vfio_ap_mdev_hot_plug_cfg(), the vfio_ap_mdev_filter_matrix() function
is only called to initialize and populate apm_filtered if either
filter_adapters or filter_domains is true. If the hot plug configuration
change only adds control domains (meaning filter_cdoms is true, but
filter_adapters and filter_domains are both false),
vfio_ap_mdev_filter_matrix() is bypassed.

Consequently, apm_filtered is passed to reset_queues_for_apids() with
uninitialized stack garbage. This can cause reset_queues_for_apids() to
interpret arbitrary stack garbage bits as valid APIDs to reset, potentially
performing unintended guest hardware queue resets.

Fix this by zero-initializing the apm_filtered bitmap at the beginning of
vfio_ap_mdev_hot_plug_cfg() using bitmap_zero().

Fixes: eeb386aeb5b7c ("s390/vfio-ap: handle config changed and scan complete notification")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2809,6 +2809,15 @@ static void vfio_ap_mdev_hot_plug_cfg(st
 	DECLARE_BITMAP(apm_filtered, AP_DEVICES);
 	bool filter_domains, filter_adapters, filter_cdoms, do_hotplug = false;
 
+	/*
+	 * Zero out the apm_filtered bitmap in case there are no adapters or
+	 * domains to be added, but only control domains. In that case,
+	 * vfio_ap_mdev_filter_matrix() - which initializes apm_filtered - will
+	 * not get called and the reset_queues_for_apids will crash because it
+	 * will access an uninitialized bitmap.
+	 */
+	bitmap_zero(apm_filtered, AP_DEVICES);
+
 	filter_adapters = bitmap_intersects(matrix_mdev->matrix.apm,
 					    matrix_mdev->apm_add, AP_DEVICES);
 	filter_domains = bitmap_intersects(matrix_mdev->matrix.aqm,


