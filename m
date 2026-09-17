Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE215A5147;
	Thu, 17 Sep 2026 16:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661228; cv=none; b=FhdGmy+gXwDGw8QfTaDHAyRrJzjrWa9x8jpwHYvEJ4NrT4u6DN29Uj/VsMovw0RZbpwKC7k6Qhxc4cAkH+slO7VlrzWj7lJw76lSz2Ba6+w980x0Ne6eZ3eXXwNBda3NLrfTf8cuYdv5sLbrV565lRdxVYKpQ/LafaxoYAWUCZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661228; c=relaxed/simple;
	bh=2yuIWUbfeqnsWul5xa8Op6f5MZKrlBJctDuMk5XjyBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDOXxPEy5M3OLqd35ZziA6Z+YZP02TEQ0BJTSuXTRINashVM3ZNCdjT9+3AwL+MUJA31xnQD7PhYfvuKzoSWH9FtdbWEzHZIKJ+6kHLW758iOT3RBl2ewRSIAbDjqsSjXAWLCGMHpOv2XiwrXBYDChkc3K+1X3HckqBtTH9ZK0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWePIsby; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWePIsby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3629F1F000FF;
	Thu, 17 Sep 2026 16:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661226;
	bh=89ejhd/IjjDzVF3PIXgVU1txgdHWyjSv0rZOASHGPFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oWePIsbyE2LOVd3r9K6oP7Q85PmYIao4zVkjoUZ7nEPk/LVI1kTenVefNRhZx7sXO
	 Kl2yEntKdjCtBcu8N/glYoIeTCVCClOHYgBfveLMAQM9dhNVPglN8UwRqubgtHNirK
	 tI/+hGo27Lloj5UeXCpMUvYEZGL9gJ/OB26M+1pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Meiyappan <kumar.meiyappan@microchip.com>,
	Sagar Biradar <sagar.biradar@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0118/1250] scsi: pm8001: Reject firmware update in fatal error state
Date: Thu, 17 Sep 2026 15:58:33 +0100
Message-ID: <20260917151555.218763141@linuxfoundation.org>
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

[ Upstream commit 2a8fbcfb04aa9db189bfa3842d4f586aecd0e631 ]

pm8001_store_update_fw() allows a firmware update request even when the
controller has already entered a fatal error state.

Firmware update is not valid once the controller is in that state, and
attempting it can lead to a call trace. Reject the request early by
checking controller_fatal_error, set the firmware status to
FAIL_PARAMETERS, and return -EINVAL.

Signed-off-by: Kumar Meiyappan <kumar.meiyappan@microchip.com>
Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>
Link: https://patch.msgid.link/20260416153757.414896-1-sagar.biradar@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index c10854ec44c7b..a27f3287748ee 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -823,6 +823,14 @@ static ssize_t pm8001_store_update_fw(struct device *cdev,
 		goto out;
 	}
 
+	if (pm8001_ha->controller_fatal_error) {
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "controller in fatal error state, firmware update rejected\n");
+		pm8001_ha->fw_status = FAIL_PARAMETERS;
+		ret = -EINVAL;
+		goto out;
+	}
+
 	for (i = 0; flash_command_table[i].code != FLASH_CMD_NONE; i++) {
 		if (!memcmp(flash_command_table[i].command,
 				 cmd_ptr, strlen(cmd_ptr))) {
-- 
2.53.0



