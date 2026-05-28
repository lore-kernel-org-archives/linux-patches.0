Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5529B338936;
	Thu, 28 May 2026 19:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998395; cv=none; b=cUm1naZW2bR9i60SdAm7+8UJu/rNiQgpZWZGX6AgyRT0eg/m/ufQAElFob7QZ/zHEmGkTpPW+F4HbQqkw7LyEbfYFCNPwhsqOtehEAru0Zp8k4+HIWSexfgN3zP5uSy9In2W5t0UNLG7clcvKCx+H1griLSBAIQRhZn+a1+uT2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998395; c=relaxed/simple;
	bh=UiHp28j1ON4zx37f4RN1QgSJ1VYM0S2vxFEdsoUyAFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6EQTJqiQXU8ZH/mRs+viCAjW8DJ2j1WqC2mS5M5hCzDDlVNo1+wSDdC9bQSYTpD89IrbrnW/8210T0t26gOn+i3FmxoCs86v01aWU4HrF632SnoO1LVjsEWJDzPfPo2IuJlTZIh1QybjV95pM0sEOCNqnQ9ENrAMDYkKaViLOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KdcxwnyF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KdcxwnyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9451F00A3E;
	Thu, 28 May 2026 19:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998394;
	bh=K7M7Qp0IFJkyzKato1nFD8XMS02b5BFardKXTV7NU+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KdcxwnyFIrhaQm0BYlQQh9Ygiv2mfAyLyBaQ4L9LVcTD/L8kHxwPlRunPHolSHMee
	 w5IlfFj5ajsQSRGNAx9ZUg8apH8iSpfrwxFFooMyod5rlbq2A9ajv6998ll4f8+shm
	 dMP9n/UCGprdXrGI7TYgsU+ItyDsU87x3Pz55Ygk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 7.0 121/461] s390/cio: Restore GFP_DMA for CHSC allocation
Date: Thu, 28 May 2026 21:44:10 +0200
Message-ID: <20260528194650.484061995@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Oberparleiter <oberpar@linux.ibm.com>

commit ea34567db0a6b3a7ce78ba421592344315c8f90e upstream.

Re-add GFP_DMA when allocating memory for CHSC control blocks.
On some supported machines, CHSC cannot access memory outside
the DMA zone, causing CHSC command failures.

Cc: stable@vger.kernel.org
Fixes: a3a64a4def8d ("s390/cio: remove unneeded DMA zone allocation")
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/chsc.c     |    4 ++--
 drivers/s390/cio/chsc_sch.c |   20 ++++++++++----------
 drivers/s390/cio/scm.c      |    2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -1142,8 +1142,8 @@ int __init chsc_init(void)
 {
 	int ret;
 
-	sei_page = (void *)get_zeroed_page(GFP_KERNEL);
-	chsc_page = (void *)get_zeroed_page(GFP_KERNEL);
+	sei_page = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	chsc_page = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sei_page || !chsc_page) {
 		ret = -ENOMEM;
 		goto out_err;
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -292,7 +292,7 @@ static int chsc_ioctl_start(void __user
 	if (!css_general_characteristics.dynio)
 		/* It makes no sense to try. */
 		return -EOPNOTSUPP;
-	chsc_area = (void *)get_zeroed_page(GFP_KERNEL);
+	chsc_area = (void *)get_zeroed_page(GFP_DMA | GFP_KERNEL);
 	if (!chsc_area)
 		return -ENOMEM;
 	request = kzalloc_obj(*request);
@@ -340,7 +340,7 @@ static int chsc_ioctl_on_close_set(void
 		ret = -ENOMEM;
 		goto out_unlock;
 	}
-	on_close_chsc_area = (void *)get_zeroed_page(GFP_KERNEL);
+	on_close_chsc_area = (void *)get_zeroed_page(GFP_DMA | GFP_KERNEL);
 	if (!on_close_chsc_area) {
 		ret = -ENOMEM;
 		goto out_free_request;
@@ -392,7 +392,7 @@ static int chsc_ioctl_start_sync(void __
 	struct chsc_sync_area *chsc_area;
 	int ret, ccode;
 
-	chsc_area = (void *)get_zeroed_page(GFP_KERNEL);
+	chsc_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!chsc_area)
 		return -ENOMEM;
 	if (copy_from_user(chsc_area, user_area, PAGE_SIZE)) {
@@ -438,7 +438,7 @@ static int chsc_ioctl_info_channel_path(
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *scpcd_area;
 
-	scpcd_area = (void *)get_zeroed_page(GFP_KERNEL);
+	scpcd_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!scpcd_area)
 		return -ENOMEM;
 	cd = kzalloc_obj(*cd);
@@ -500,7 +500,7 @@ static int chsc_ioctl_info_cu(void __use
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *scucd_area;
 
-	scucd_area = (void *)get_zeroed_page(GFP_KERNEL);
+	scucd_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!scucd_area)
 		return -ENOMEM;
 	cd = kzalloc_obj(*cd);
@@ -563,7 +563,7 @@ static int chsc_ioctl_info_sch_cu(void _
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *sscud_area;
 
-	sscud_area = (void *)get_zeroed_page(GFP_KERNEL);
+	sscud_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sscud_area)
 		return -ENOMEM;
 	cud = kzalloc_obj(*cud);
@@ -625,7 +625,7 @@ static int chsc_ioctl_conf_info(void __u
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *sci_area;
 
-	sci_area = (void *)get_zeroed_page(GFP_KERNEL);
+	sci_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sci_area)
 		return -ENOMEM;
 	ci = kzalloc_obj(*ci);
@@ -696,7 +696,7 @@ static int chsc_ioctl_conf_comp_list(voi
 		u32 res;
 	} __attribute__ ((packed)) *cssids_parm;
 
-	sccl_area = (void *)get_zeroed_page(GFP_KERNEL);
+	sccl_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sccl_area)
 		return -ENOMEM;
 	ccl = kzalloc_obj(*ccl);
@@ -756,7 +756,7 @@ static int chsc_ioctl_chpd(void __user *
 	int ret;
 
 	chpd = kzalloc_obj(*chpd);
-	scpd_area = (void *)get_zeroed_page(GFP_KERNEL);
+	scpd_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!scpd_area || !chpd) {
 		ret = -ENOMEM;
 		goto out_free;
@@ -796,7 +796,7 @@ static int chsc_ioctl_dcal(void __user *
 		u8 data[PAGE_SIZE - 36];
 	} __attribute__ ((packed)) *sdcal_area;
 
-	sdcal_area = (void *)get_zeroed_page(GFP_KERNEL);
+	sdcal_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sdcal_area)
 		return -ENOMEM;
 	dcal = kzalloc_obj(*dcal);
--- a/drivers/s390/cio/scm.c
+++ b/drivers/s390/cio/scm.c
@@ -229,7 +229,7 @@ int scm_update_information(void)
 	size_t num;
 	int ret;
 
-	scm_info = (void *)__get_free_page(GFP_KERNEL);
+	scm_info = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
 	if (!scm_info)
 		return -ENOMEM;
 


