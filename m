Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E4733C534;
	Tue, 11 Nov 2025 01:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823461; cv=none; b=sAtXG4BmVX6pqCCVK7qCnUx4/RqCIKB0hDmWmg/OoR7meSA84arAk1LCTQ/uzBMkv/E/Y8ekCaFdGSI5yAQ6am2sS+JUuwv3iMhPnIBUEjkceP3/LsHLE4qkPNXAMVK78wn1zaD3uKXWQjbNu0nLH+4RM2kRKUw/ciTiYQIuFec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823461; c=relaxed/simple;
	bh=tKr5Qs44xTy7AB5CFwKsw7cbhapNOzA0420aeCCgMOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHjGJldzfNMT9/6CPRVhQC57Y4Dg743gySVPJTo0fTdbEBP5ef+zpWliRWCoXrY1qpd8R/4z9pLaY+jDqpt5s+I/Gr5guxaPD1E5S3zcSTl4vi/LW8Nbkn2uxRueT0+7arx+H/5ioZN3QIVUpf9A755Ugo5R4gz8AwtkblrS02U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1SOfTNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1SOfTNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FF6C4CEF5;
	Tue, 11 Nov 2025 01:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823461;
	bh=tKr5Qs44xTy7AB5CFwKsw7cbhapNOzA0420aeCCgMOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1SOfTNXoV6GZOwZ3G2v0q/4PLDEVtKC3V9ul2mEmCOaLq7bpeajzUNoMrxeCYt12
	 xEA1yavAXtjTsmwQbJvKasjVMrlESgws0bcEdF8UEexyivYFyfNV9kYDaHDryBtD+z
	 GSadn3YZRgrcV0riCUSqs+CvtuK7wqVX0fMMqvO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francisco Gutierrez <frankramirez@google.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 251/565] scsi: pm80xx: Fix race condition caused by static variables
Date: Tue, 11 Nov 2025 09:41:47 +0900
Message-ID: <20251111004532.553732427@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 85ff95c6543a5..0e7497e490f40 100644
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
index b53b1ae5b74c3..5317f82c51fd4 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -550,6 +550,7 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 	pm8001_ha->id = pm8001_id++;
 	pm8001_ha->logging_level = logging_level;
 	pm8001_ha->non_fatal_count = 0;
+	mutex_init(&pm8001_ha->iop_log_lock);
 	if (link_rate >= 1 && link_rate <= 15)
 		pm8001_ha->link_rate = (link_rate << 8);
 	else {
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index c46470e0cf63b..efb6dc26bc35b 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -537,6 +537,10 @@ struct pm8001_hba_info {
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



