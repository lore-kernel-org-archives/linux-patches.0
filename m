Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDC7509F05;
	Wed, 30 Sep 2026 16:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784127; cv=none; b=Hn1boGEDHnuWZSu1ELKNvinoyBU8bF2sVh9FZntkN5RlsQOG92lEY8f06CHZSFfR4qN5UcoOerPYf797S92qbE3xJms+kqQs21lpp1V53d3Q/xyVNiLPlpqjD3QK5W0dWqn9xHrukv9IqZ18SdcdMnD11g9VwxKCWAo4pSUD9QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784127; c=relaxed/simple;
	bh=sfjcjcHBGmXqCFmXuVKCkDNV/bgTysCxR4wQ/Qex16c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cv8xEKUGErqplf3a3/B1xHwauPx2EldQhnti7o2oslqLxIJQ2uo1f1C24mCyqcwnaCsFR1suJpzbSmFoLwV9KI1SAn+Uo33XfNBTOoKy4b9J3G8hY9PStC0XdGH+wC+Y5+jDZs8G1Kbj1WQ/+BQQPQUk+8exLdXT1a4OdiSS818=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igLcIetE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igLcIetE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105721F00893;
	Wed, 30 Sep 2026 16:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784119;
	bh=+ry3yLTah+I5yaABbLhOxKULv8m8d8PJqERI6guMm24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=igLcIetEMxeMEwWsercNoTXKg2wZMJplJTmU/7TG2vGfDBeiEzBARXzNWm5HDhuAu
	 rhm5SaHaSnDBXSYBHGopRgPU6PTAMGn0r9ahE7TGvL2kkd1qeGlj+FHRI30rnfM8j4
	 rGlEoP+q3dN1R4C/HPdMvURQ2alYPKrgTaNZQQ7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Meiyappan <kumar.meiyappan@microchip.com>,
	Sagar Biradar <sagar.biradar@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/982] scsi: pm8001: Reject firmware update in fatal error state
Date: Wed, 30 Sep 2026 17:12:59 +0200
Message-ID: <20260930152417.720170673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8113045f7cb93..0158e0353fe0d 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -827,6 +827,14 @@ static ssize_t pm8001_store_update_fw(struct device *cdev,
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



