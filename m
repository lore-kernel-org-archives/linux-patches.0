Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B8B2FDC55;
	Tue, 12 Aug 2025 18:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021668; cv=none; b=nO7kOpF4/rxS91bEqOl2h5NCvUmz+6MkofdLb9vnUyiH/9tkir2xrb3Qffkl9q3ejJCYpKLzmP34+s+TPTcIDd6i4aYineKGInizNdGteiZWbkr9ulTjGGsoYZzwf43l5VWBB6Awno7betUIQQb0/WROwyX/8MK9pYKek3hf4eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021668; c=relaxed/simple;
	bh=9hVUpa+fV+40m5mj+BijAC0OHXF8Bh10jCB7lZvaCH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNggrDMvrS1E4sIlkQ/GHY35X7CZh9qwQJZYXffygrMq3kV04+0P6wR6jxrWl1esGuFMaiO8JBDVosgFFkUGN2fBrKyU56OqgW0OkjjOQAdli3pktV01Rz52hY49fbX017izsaah3J8bsG4CSTaEuq3yfF5rhJGLZ/WVxGgO94g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHl3ah9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHl3ah9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7136BC4CEF0;
	Tue, 12 Aug 2025 18:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021667;
	bh=9hVUpa+fV+40m5mj+BijAC0OHXF8Bh10jCB7lZvaCH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHl3ah9bvFekVgnQR3Wo/PuUZ5Jz1+E2o5x/Akp2e8Tsmwa1ThSATDiABsPGA0lcC
	 qhRRwJ1AUwlOAD33eE+nuHd/Eq6eKL6BF3C1QAy/qRO3cGetfBqkMCmCnwkiEUww6O
	 BllUT6MTYYQ9KNsK+WPka6TyiVTM9pfbRq+TCaUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salomon Dushimirimana <salomondush@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/262] scsi: sd: Make sd shutdown issue START STOP UNIT appropriately
Date: Tue, 12 Aug 2025 19:29:36 +0200
Message-ID: <20250812173001.136573633@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salomon Dushimirimana <salomondush@google.com>

[ Upstream commit 8e48727c26c4d839ff9b4b73d1cae486bea7fe19 ]

Commit aa3998dbeb3a ("ata: libata-scsi: Disable scsi device
manage_system_start_stop") enabled libata EH to manage device power mode
trasitions for system suspend/resume and removed the flag from
ata_scsi_dev_config. However, since the sd_shutdown() function still
relies on the manage_system_start_stop flag, a spin-down command is not
issued to the disk with command "echo 1 > /sys/block/sdb/device/delete"

sd_shutdown() can be called for both system/runtime start stop
operations, so utilize the manage_run_time_start_stop flag set in the
ata_scsi_dev_config and issue a spin-down command during disk removal
when the system is running. This is in addition to when the system is
powering off and manage_shutdown flag is set. The
manage_system_start_stop flag will still be used for drivers that still
set the flag.

Fixes: aa3998dbeb3a ("ata: libata-scsi: Disable scsi device manage_system_start_stop")
Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
Link: https://lore.kernel.org/r/20250724214520.112927-1-salomondush@google.com
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fe694fec16b5..873c920eb0cf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3895,7 +3895,9 @@ static void sd_shutdown(struct device *dev)
 	if ((system_state != SYSTEM_RESTART &&
 	     sdkp->device->manage_system_start_stop) ||
 	    (system_state == SYSTEM_POWER_OFF &&
-	     sdkp->device->manage_shutdown)) {
+	     sdkp->device->manage_shutdown) ||
+	    (system_state == SYSTEM_RUNNING &&
+	     sdkp->device->manage_runtime_start_stop)) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
-- 
2.39.5



