Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC6151C06C;
	Wed, 30 Sep 2026 17:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790740; cv=none; b=W3bop5/8F6NMtEb/6xFVwkTHVuvxKsdqo+aRpXeTEYPAInLZdZkUTHdwFYSu2zCeJiouk4dXOFFj9WG8tOmmG94b33EEkySyyXQyP4/RY5IrM+tl6b1UnQC8dksbJgJ77UnRQ3AQC9r1GiB5Q2j41Whluhq3rZlexAg/Ye7owaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790740; c=relaxed/simple;
	bh=i26JAz0pxcVzinUSSD2QWiHIs2VcRFJRK84NAYCnoEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJGj8eDrMfDHqwJhWjTFymX4Q9IReTyaUtXYVctuoKTNrAStyWE+tAaMBTmVGsZlgy5LkzH8PoxcZNTbgPuxqLA3e8/Gi1OnPoyn/R+FJz/pD+O+wisoxi/q/noKK8eRGa9cQzo4McSveEap1IBVDtcgnYCniu/8P9froBUh5ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRdvcFqo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRdvcFqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84B01F000FF;
	Wed, 30 Sep 2026 17:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790739;
	bh=f5MF29GxHA+4eG/2Xt6vENh20vE3l5H2xa50wFXAKqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CRdvcFqoGbg0654qWGRDnx75XC23g1mFQHYHZH5bE9jG523Ki5t+S3xVgCeOb/McI
	 RII/9cZjfteTDqzrwg5FA0IHELjwZfDRpMoaQPrvrY7D/ocI+CpSLnAlOKOuxKXrkA
	 f2FrRw68bjc90hOHKya3xFf20gOKhCWyoApB9dS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Meiyappan <kumar.meiyappan@microchip.com>,
	Sagar Biradar <sagar.biradar@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/752] scsi: pm8001: Reject firmware update in fatal error state
Date: Wed, 30 Sep 2026 17:18:20 +0200
Message-ID: <20260930152358.802070783@linuxfoundation.org>
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
index 256ecb9134856..8b55f930a16aa 100644
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



