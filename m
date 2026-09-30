Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED04A23ABBE;
	Wed, 30 Sep 2026 17:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790772; cv=none; b=MXN7vEz+3Lq4+kxCSCbAmHpexsOnuA1f7dHBOXe/43ruyYo+N82bwy/GDw+XVF4UGibExrR7VMZI2gIYNncfYo16bHWiClhcasB6I7PyM1/puaeEZP+NJULnnrqbt19sBOlzhS7vEXUhoYm6ric3Va9eD1lApAZtw8iFOftSQkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790772; c=relaxed/simple;
	bh=XC1gVlRsdeo5/mEP/fqhibeCndoWamGIuokEI+2YFDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z26R9rVLcNygCFuC/fZ4sHgGYO88zOS/0b0UXVU7FHlbEaCqAmCyiMmUBkAFSnsoEFLfQYu+DGSgAc/AMV4LTrjAxpEquKpu8WSTvdADGcrgjIQQaUsfysBJLSgZPDzRhE+UWTCblwKD4b7XuUKWsJnrjTX9QXHyhB25WESCxcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kFw29o5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kFw29o5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000F31F000FF;
	Wed, 30 Sep 2026 17:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790770;
	bh=lOIgbQ208KmrjZcetLJYd2Jv0SelKNQZclXn8rp5Sw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2kFw29o53E0eGB/95coReJ4+lv5HrxSC7Y3pYWijLiuffUvz6UOm3ffntVhQXbnxT
	 Oq1ClrgyQd52AJfC2BeVkh+uH/rOWsOA8bKuExjokJx3xH8lO6knKEwuoUI9X9hlR/
	 w0uzT5Hfe19F1Gel5tM3aiIF+LCfH0QgjlMiitLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Meiyappan <kumar.meiyappan@microchip.com>,
	Sagar Biradar <sagar.biradar@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/752] scsi: pm8001: Reject non-fatal dump when controller is crashed
Date: Wed, 30 Sep 2026 17:18:21 +0200
Message-ID: <20260930152358.823160940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Meiyappan <kumar.meiyappan@microchip.com>

[ Upstream commit aa3b8f56ef27ed72394a752820abdec4608b731c ]

pm80xx_get_non_fatal_dump() can be called even after the controller has
entered a fatal error state. In that case the forensic memory contents
are not safe to access for a non-fatal dump request, and attempting to
do so can trigger a call trace.

Check controller_fatal_error before reading the non-fatal dump buffer
and return -EINVAL when the controller is already in a crashed state.

This prevents non-fatal dump collection from running in an invalid
controller state.

Signed-off-by: Kumar Meiyappan <kumar.meiyappan@microchip.com>
Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>
Link: https://patch.msgid.link/20260416154650.415624-1-sagar.biradar@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index d37b1bdb29b49..e5b5a730116a9 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -400,6 +400,13 @@ ssize_t pm80xx_get_non_fatal_dump(struct device *cdev,
 	char *buf_copy = buf;
 
 	temp = (u32 *)pm8001_ha->memoryMap.region[FORENSIC_MEM].virt_ptr;
+
+	if (pm8001_ha->controller_fatal_error) {
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "non-fatal dump not available in fatal error state\n");
+		return -EINVAL;
+	}
+
 	if (++pm8001_ha->non_fatal_count == 1) {
 		if (pm8001_ha->chip_id == chip_8001) {
 			snprintf(pm8001_ha->forensic_info.data_buf.direct_data,
-- 
2.53.0



