Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B945D54704B;
	Thu, 17 Sep 2026 17:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667413; cv=none; b=ZRTNljL9JsvX+nFr28hxb+taZX9wvuubGJ8kc2cLCZOTyQA3l2F73hqUk/cqJQ38DiEddbO9w0R+fWEpJJR0RRG7iaImMsXta5TGEp43tMNAMVZ0/aRC1kkfqiv9uyqMu55tSSmlhSIVmqCH5yjV7CmrR4ghnVVMQDFg0bgk5wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667413; c=relaxed/simple;
	bh=hzjcnW4PhpRx+6eTpGt2jn7nBz/z3CUnfqMYPml5JC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjOUGeNI4egFepzrHwUB2TVLV6rMWCQKvkGc2/ZcztjJUpOREfdkFP4/dv/Y0v6LJjhUTvV5Ev2y3jk0pgw5nr1X7db/tdWvoiQ2LJNpTHa3TOlLUCDU+7fulCRrRhRzv5jc+vssrgg/Nsz4OPHCQFyZcLaajBYxymF2Ec4HCCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=om1rns3X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="om1rns3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AB51F000FF;
	Thu, 17 Sep 2026 17:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667411;
	bh=HHVY3lKJbEt3AsxKN0BXbB7PGL4F/QdfifGTngmJJOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=om1rns3Xp+53jPTvJcBOhWLXL/CXxh3DkifKPm5eQZkuIGTHTbKGA2rFWY3fznsFk
	 RnjNKQ4XKTsGKMOCoD1RMMhUA1ps7bikkUYaDebfGf2ln2M2j16dwmrvUaRsewHlRR
	 CyGFh0xUz0+hgrlMmWX8aSR5jZcaUYMaQ+rxdpMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Meiyappan <kumar.meiyappan@microchip.com>,
	Sagar Biradar <sagar.biradar@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0083/1102] scsi: pm8001: Reject firmware update in fatal error state
Date: Thu, 17 Sep 2026 16:00:26 +0100
Message-ID: <20260917151541.561161020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 4362bd6cc29e7..0d597988902dd 100644
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



