Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59CA3AF65F;
	Sat, 17 Oct 2026 16:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255602; cv=none; b=ugKsZWRYgu6y3v5Sa+PImkjpVKuMbLsxlWzSCc3qLrKpktCaHtuHFQCuYqY1WRSqQA+azhJqVIp/egYIvAZDYL6RBSrxRoJVW3h9/AJhbJSnrE7o43rMSwRG5iJU542ZVARsGRkstx0F+3imdk+uqFYIWlwdvi3vF8Mtf+L6Mh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255602; c=relaxed/simple;
	bh=2zuXtbWGpRHKQ0/f+ZhJLxnR1kYaOF3OYCQaYRqOrdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9g8x8TgQrj3jGqjjgbwQyxvQjTmX97VfZPKOIM4MWpDqHbUHvl8i5NrpH6Egk+bBNPYCKiGZFYOfzhkqlu0kbK0gvorhqku2gVLD+cQCYlVOGQ3sxDBq/r6TRf/GPVDe0SQg6DU0p9hGuYb2YhTnVSl8oZOE1MFRsJrnSjX7Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldsfwdLn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldsfwdLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E331F000C4;
	Sat, 17 Oct 2026 16:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255601;
	bh=0He+YdsQ94FhwyxlbL4gCR2cos03aUutmRBI/TWjgzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ldsfwdLnwaTecqal39SV31l+dwilcLgz7bRppHKBSN+8mmKWV7vbH4Qk/MSRc4wGI
	 +EGsudMDYOJcXu5GN5JhzxUM5oETfMKuHw47/PiQxIrF5P2NPKTcJhHR4A+7F/Fl16
	 GD2hFK5VwLhfhx9ksD4OoSMiz7oKnVcN82LrToUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Aishwarya <aishwarya.tcv@arm.com>,
	Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 829/869] scsi: ufs: qcom : Fix NULL pointer dereference in ufs_qcom_setup_clocks
Date: Sat, 17 Oct 2026 18:01:10 +0200
Message-ID: <20261017160058.135354297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Nitin Rawat <quic_nitirawa@quicinc.com>

[ Upstream commit 720fa0cb59e411eca6b274f78073b6d2fe68eb45 ]

Fix a NULL pointer dereference in ufs_qcom_setup_clocks due to an
uninitialized 'host' variable. The variable 'phy' is now assigned
after confirming 'host' is not NULL.

Call Stack:

Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000000

ufs_qcom_setup_clocks+0x28/0x148 ufs_qcom (P)
ufshcd_setup_clocks (drivers/ufs/core/ufshcd-priv.h:142)
ufshcd_init (drivers/ufs/core/ufshcd.c:9468)
ufshcd_pltfrm_init (drivers/ufs/host/ufshcd-pltfrm.c:504)
ufs_qcom_probe+0x28/0x68 ufs_qcom
platform_probe (drivers/base/platform.c:1404)
really_probe (drivers/base/dd.c:579 drivers/base/dd.c:657)
__driver_probe_device (drivers/base/dd.c:799)
driver_probe_device (drivers/base/dd.c:829)
__driver_attach (drivers/base/dd.c:1216)
bus_for_each_dev (drivers/base/bus.c:370)
driver_attach (drivers/base/dd.c:1234)
bus_add_driver (drivers/base/bus.c:678)
driver_register (drivers/base/driver.c:249)
__platform_driver_register (drivers/base/platform.c:868)
ufs_qcom_pltform_init+0x28/0xff8 ufs_qcom
do_one_initcall (init/main.c:1274)
do_init_module (kernel/module/main.c:3041)
load_module (kernel/module/main.c:3511)
init_module_from_file (kernel/module/main.c:3704)
__arm64_sys_finit_module (kernel/module/main.c:3715.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Fixes: 77d2fa54a945 ("scsi: ufs: qcom : Refactor phy_power_on/off calls")
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Reported-by: Aishwarya <aishwarya.tcv@arm.com>
Closes: https://lore.kernel.org/lkml/20250620214408.11028-1-aishwarya.tcv@arm.com/
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Closes: https://lore.kernel.org/linux-scsi/CA+G9fYuFQ2dBvYm1iB6rbwT=4b1c8e4NJ3yxqFPGZGUKH3GmMA@mail.gmail.com/T/#t
Co-developed-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20250623134809.20405-1-quic_nitirawa@quicinc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 5fbcc234131f1..ba760aab3a7d7 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -934,7 +934,7 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
 				 enum ufs_notify_change_status status)
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
-	struct phy *phy = host->generic_phy;
+	struct phy *phy;
 	int err;
 
 	/*
@@ -945,6 +945,8 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
 	if (!host)
 		return 0;
 
+	phy = host->generic_phy;
+
 	switch (status) {
 	case PRE_CHANGE:
 		if (on) {
-- 
2.53.0



