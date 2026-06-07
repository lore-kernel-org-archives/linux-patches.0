Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BAC1C5F27;
	Sun,  7 Jun 2026 10:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828015; cv=none; b=PufSlk9dMslhY1ryEMt6rYZjaVS9FtRlF8FjGSRFzrJT1Y0KHT/nHqQCGCd9djslv/M9pLgh+Omqss48C67DVb+vXkgMbAOEMpKcOxvcGhBglfM9bi6bn53vIXE472ehP6NVlRVzbvGGmZgD5PK+rt5rf281fTtuI9bvqSbnuRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828015; c=relaxed/simple;
	bh=bXfK/s1pi7z5UIefccBNcj/5ph0F36FJyqeXQva9v+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHeXxExU4MhZWzSKH3BTXCbG24i1LUwA3ZvqRAK6VCF0OC9qNKqgxMlnmvY3e7b0tatROjYuXXPSCpWh/FIjAZwEBtv0Mjw5JXYsPyrbbxZ4o08FAJTdYD/Glu0jmVcpi41XVKwLB3u8nqWUvxSef/aDwmeztCbJRs7R1tbY830=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hc/NSJdl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hc/NSJdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667251F00893;
	Sun,  7 Jun 2026 10:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828014;
	bh=bEunoh0NNjPcsX7tefksX503v/GM/9jHf0WLjdgzwx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hc/NSJdlCktgTXuIewgH0ZdJBCSfrwG5Xwq7TK6NypeCkphsjcWscyLVYZmHOeTcN
	 MZj/bccS1eg0DOFdlbALq8YGT5A5o8nHduA4M3UZm3REtCroLu4rJDS+1NqTeNoDBM
	 tfISkEgNMfKcBLXZ26RjdzhaDdcUdX8ad4xivq6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/307] s390/cio: Restore GFP_DMA for CHSC allocation
Date: Sun,  7 Jun 2026 11:58:21 +0200
Message-ID: <20260607095731.609190802@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Peter Oberparleiter <oberpar@linux.ibm.com>

[ Upstream commit ea34567db0a6b3a7ce78ba421592344315c8f90e ]

Re-add GFP_DMA when allocating memory for CHSC control blocks.
On some supported machines, CHSC cannot access memory outside
the DMA zone, causing CHSC command failures.

Cc: stable@vger.kernel.org
Fixes: a3a64a4def8d ("s390/cio: remove unneeded DMA zone allocation")
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
[ adjusted context to account for missing commit bf4afc53b77ae ]
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/chsc.c     |  4 ++--
 drivers/s390/cio/chsc_sch.c | 20 ++++++++++----------
 drivers/s390/cio/scm.c      |  2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index dcc1e1c34ca2e1..8fe6658dcfe1a3 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -1153,8 +1153,8 @@ int __init chsc_init(void)
 {
 	int ret;
 
-	sei_page = (void *)get_zeroed_page(GFP_KERNEL);
-	chsc_page = (void *)get_zeroed_page(GFP_KERNEL);
+	sei_page = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	chsc_page = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sei_page || !chsc_page) {
 		ret = -ENOMEM;
 		goto out_err;
diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index 1e58ee3cc87db1..9131ce3af1b8eb 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -293,7 +293,7 @@ static int chsc_ioctl_start(void __user *user_area)
 	if (!css_general_characteristics.dynio)
 		/* It makes no sense to try. */
 		return -EOPNOTSUPP;
-	chsc_area = (void *)get_zeroed_page(GFP_KERNEL);
+	chsc_area = (void *)get_zeroed_page(GFP_DMA | GFP_KERNEL);
 	if (!chsc_area)
 		return -ENOMEM;
 	request = kzalloc(sizeof(*request), GFP_KERNEL);
@@ -341,7 +341,7 @@ static int chsc_ioctl_on_close_set(void __user *user_area)
 		ret = -ENOMEM;
 		goto out_unlock;
 	}
-	on_close_chsc_area = (void *)get_zeroed_page(GFP_KERNEL);
+	on_close_chsc_area = (void *)get_zeroed_page(GFP_DMA | GFP_KERNEL);
 	if (!on_close_chsc_area) {
 		ret = -ENOMEM;
 		goto out_free_request;
@@ -393,7 +393,7 @@ static int chsc_ioctl_start_sync(void __user *user_area)
 	struct chsc_sync_area *chsc_area;
 	int ret, ccode;
 
-	chsc_area = (void *)get_zeroed_page(GFP_KERNEL);
+	chsc_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!chsc_area)
 		return -ENOMEM;
 	if (copy_from_user(chsc_area, user_area, PAGE_SIZE)) {
@@ -439,7 +439,7 @@ static int chsc_ioctl_info_channel_path(void __user *user_cd)
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *scpcd_area;
 
-	scpcd_area = (void *)get_zeroed_page(GFP_KERNEL);
+	scpcd_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!scpcd_area)
 		return -ENOMEM;
 	cd = kzalloc(sizeof(*cd), GFP_KERNEL);
@@ -501,7 +501,7 @@ static int chsc_ioctl_info_cu(void __user *user_cd)
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *scucd_area;
 
-	scucd_area = (void *)get_zeroed_page(GFP_KERNEL);
+	scucd_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!scucd_area)
 		return -ENOMEM;
 	cd = kzalloc(sizeof(*cd), GFP_KERNEL);
@@ -564,7 +564,7 @@ static int chsc_ioctl_info_sch_cu(void __user *user_cud)
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *sscud_area;
 
-	sscud_area = (void *)get_zeroed_page(GFP_KERNEL);
+	sscud_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sscud_area)
 		return -ENOMEM;
 	cud = kzalloc(sizeof(*cud), GFP_KERNEL);
@@ -626,7 +626,7 @@ static int chsc_ioctl_conf_info(void __user *user_ci)
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *sci_area;
 
-	sci_area = (void *)get_zeroed_page(GFP_KERNEL);
+	sci_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sci_area)
 		return -ENOMEM;
 	ci = kzalloc(sizeof(*ci), GFP_KERNEL);
@@ -697,7 +697,7 @@ static int chsc_ioctl_conf_comp_list(void __user *user_ccl)
 		u32 res;
 	} __attribute__ ((packed)) *cssids_parm;
 
-	sccl_area = (void *)get_zeroed_page(GFP_KERNEL);
+	sccl_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sccl_area)
 		return -ENOMEM;
 	ccl = kzalloc(sizeof(*ccl), GFP_KERNEL);
@@ -757,7 +757,7 @@ static int chsc_ioctl_chpd(void __user *user_chpd)
 	int ret;
 
 	chpd = kzalloc(sizeof(*chpd), GFP_KERNEL);
-	scpd_area = (void *)get_zeroed_page(GFP_KERNEL);
+	scpd_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!scpd_area || !chpd) {
 		ret = -ENOMEM;
 		goto out_free;
@@ -797,7 +797,7 @@ static int chsc_ioctl_dcal(void __user *user_dcal)
 		u8 data[PAGE_SIZE - 36];
 	} __attribute__ ((packed)) *sdcal_area;
 
-	sdcal_area = (void *)get_zeroed_page(GFP_KERNEL);
+	sdcal_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sdcal_area)
 		return -ENOMEM;
 	dcal = kzalloc(sizeof(*dcal), GFP_KERNEL);
diff --git a/drivers/s390/cio/scm.c b/drivers/s390/cio/scm.c
index c7894d61306d74..375cbfa31b5373 100644
--- a/drivers/s390/cio/scm.c
+++ b/drivers/s390/cio/scm.c
@@ -228,7 +228,7 @@ int scm_update_information(void)
 	size_t num;
 	int ret;
 
-	scm_info = (void *)__get_free_page(GFP_KERNEL);
+	scm_info = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
 	if (!scm_info)
 		return -ENOMEM;
 
-- 
2.53.0



