Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB2A310782;
	Wed,  3 Dec 2025 15:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776143; cv=none; b=N7O4/PZZt0dOnXPmJj+jJC++nrFl3/Qd0DyfA0PnPOiUAxyOP/uqYhZxgeYiFQYutmd33gYtXqYGYJiurnFgmOXJA1C34apA+8fGkpX9IFvTQdg8QjF3HSxHoErM6ME+FmDHiPZUxdS+hb46AKMnbj5+QN7LGdq7hnE9sKRGlZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776143; c=relaxed/simple;
	bh=rVDbNA7O6Dxh5RJ843J4oHHqMbcklMo2Fc6yNfhfw2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIO2uQD5pHqEmCcn5CU6lynrmEAwO5iDXwP3R9wgkpeEbrrxWbJKijC44FQGOcUMDAzH+bSJ+muWmeSo00B+hWZF+5GjKoXF1+jTvcS5hdYV0w8jHQuClR2TQjpES2ZSwyJNpuPT69kuVGUtmgHqpgGDKPU1NIwkEcXEYTB+3Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMM26CJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMM26CJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFA5C4CEF5;
	Wed,  3 Dec 2025 15:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776143;
	bh=rVDbNA7O6Dxh5RJ843J4oHHqMbcklMo2Fc6yNfhfw2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMM26CJ8ZOoPhpqX1k0O56bYDsjhCxA3BurxZn2ylG/FYybtzC2CZICZVVf9+h2x1
	 QbrO99TUw/phls+qqOe73dlKozea93TIxm4GWusvCmTVs0sg/qYAQFu6tx53ISm8Hb
	 w3RT6ecCpZxkgYTzmpFWUCLqmASjbGuyp/V2LMVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francisco Gutierrez <frankramirez@google.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/300] scsi: pm80xx: Fix race condition caused by static variables
Date: Wed,  3 Dec 2025 16:24:56 +0100
Message-ID: <20251203152404.033121994@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francisco Gutierrez <frankramirez@google.com>

[ Upstream commit d6477ee38ccfbeaed885733c13f41d9076e2f94a ]

Eliminate the use of static variables within the log pull implementation
to resolve a race condition and prevent data gaps when pulling logs from
multiple controllers in parallel, ensuring each operation is properly
isolated.

Signed-off-by: Francisco Gutierrez <frankramirez@google.com>
Link: https://lore.kernel.org/r/20250723183543.1443301-1-frankramirez@google.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_ctl.c  | 22 ++++++++++++----------
 drivers/scsi/pm8001/pm8001_init.c |  1 +
 drivers/scsi/pm8001/pm8001_sas.h  |  4 ++++
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 12035baf0997b..9c117e4e7f5bb 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -534,23 +534,25 @@ static ssize_t pm8001_ctl_iop_log_show(struct device *cdev,
 	char *str = buf;
 	u32 read_size =
 		pm8001_ha->main_cfg_tbl.pm80xx_tbl.event_log_size / 1024;
-	static u32 start, end, count;
 	u32 max_read_times = 32;
 	u32 max_count = (read_size * 1024) / (max_read_times * 4);
 	u32 *temp = (u32 *)pm8001_ha->memoryMap.region[IOP].virt_ptr;
 
-	if ((count % max_count) == 0) {
-		start = 0;
-		end = max_read_times;
-		count = 0;
+	mutex_lock(&pm8001_ha->iop_log_lock);
+
+	if ((pm8001_ha->iop_log_count % max_count) == 0) {
+		pm8001_ha->iop_log_start = 0;
+		pm8001_ha->iop_log_end = max_read_times;
+		pm8001_ha->iop_log_count = 0;
 	} else {
-		start = end;
-		end = end + max_read_times;
+		pm8001_ha->iop_log_start = pm8001_ha->iop_log_end;
+		pm8001_ha->iop_log_end = pm8001_ha->iop_log_end + max_read_times;
 	}
 
-	for (; start < end; start++)
-		str += sprintf(str, "%08x ", *(temp+start));
-	count++;
+	for (; pm8001_ha->iop_log_start < pm8001_ha->iop_log_end; pm8001_ha->iop_log_start++)
+		str += sprintf(str, "%08x ", *(temp+pm8001_ha->iop_log_start));
+	pm8001_ha->iop_log_count++;
+	mutex_unlock(&pm8001_ha->iop_log_lock);
 	return str - buf;
 }
 static DEVICE_ATTR(iop_log, S_IRUGO, pm8001_ctl_iop_log_show, NULL);
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 45bffa49f8766..8fe26597bf905 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -505,6 +505,7 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 	pm8001_ha->id = pm8001_id++;
 	pm8001_ha->logging_level = logging_level;
 	pm8001_ha->non_fatal_count = 0;
+	mutex_init(&pm8001_ha->iop_log_lock);
 	if (link_rate >= 1 && link_rate <= 15)
 		pm8001_ha->link_rate = (link_rate << 8);
 	else {
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 74099d82e4364..c0aba3493d470 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -540,6 +540,10 @@ struct pm8001_hba_info {
 	u32 ci_offset;
 	u32 pi_offset;
 	u32 max_memcnt;
+	u32 iop_log_start;
+	u32 iop_log_end;
+	u32 iop_log_count;
+	struct mutex iop_log_lock;
 };
 
 struct pm8001_work {
-- 
2.51.0



