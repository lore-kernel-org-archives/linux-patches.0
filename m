Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB005AEC42;
	Thu, 17 Sep 2026 16:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661260; cv=none; b=OsjzooVK+oYv6SSJ2/ei5ZhJMxdcubAboFnxGS/mBeRt2UnZLYQ6fgzpZ4su6+GJBepOaQC+UEmMdGJX7YCx8GJqkAwVJW2ntnenSjelb28D0WXgGDZ9wS/KsXYsDPzwndC/CZgKEscfv0yu4kD44kD6zTcydHava/DlumSqh4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661260; c=relaxed/simple;
	bh=YDBQ+aofiSOTTKDTyphomDrq25/tU/B0bn5z++fe158=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iu0TJ5D11fi7P3xSd+qT2jhIbAtChqoXiLqQxsZ5b2f/ecNgf2JI1QEwqKc2zuLZ/MtaYW8uY3jEAFAzFD4cud7hRP4A0UpzBUoJMOJNhB/Dar/x4q5YWSVntAJEHO9YEtUwPenZIYJuX9PnDziCoyWL3MFpWGea081XzxXuFHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0PdFMImU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0PdFMImU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851201F000FF;
	Thu, 17 Sep 2026 16:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661259;
	bh=oWsNmXEKQu3+OEEPngLXSDGrK0EIOyr2eSzLTecyPWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0PdFMImUoPpAepyhXxDqg7r0oDK5YdulI5Y8rTrvH3TCGClGw7OmJZE5lUSlvXJlp
	 RKNDAJ/Aw1ToREqRoz7SrkNy7z/WcE8v1zpxHqJHOcknAFEY2PiS0I32Vy5j45jB/y
	 pEl7nOwFMxzkDxpjPc4csMIdLiL9DtF+LExwz+20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Meiyappan <kumar.meiyappan@microchip.com>,
	Sagar Biradar <sagar.biradar@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0119/1250] scsi: pm8001: Reject non-fatal dump when controller is crashed
Date: Thu, 17 Sep 2026 15:58:34 +0100
Message-ID: <20260917151555.245158048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 31960b72c1e92..1ce8226fcd292 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -401,6 +401,13 @@ ssize_t pm80xx_get_non_fatal_dump(struct device *cdev,
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



