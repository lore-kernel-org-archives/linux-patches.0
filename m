Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29742FF148;
	Tue, 12 Aug 2025 18:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024969; cv=none; b=t7kVOE4urdsz2EntwmTWJXp95Y033B6C+ibNU6VeK4PFs7EaXAt8wIDoOEOV8EnwY1GiAvE1gSMRQ+H41zeZNFVNjez8pc6jlVkUqOVHf1QILu2+yG/usehDT+sUEU7JD2R+ifK83AFtIOJ2aOC9VUu+aCOW9SJoec1fgj6cP7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024969; c=relaxed/simple;
	bh=zX90YrfiKQNmLIpOs8NU5+7oDeH39dcy7sHi3VunTAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqQ8ARD15WrT3eW26fA9XA/leb9MfbxAZwpumTBKaeWrGtbu8P1AM+stwOiKevoKGkIA8IvJzGiWYZYAHe0bX8cuHd/zUagblUcYX6hvIYRaF3shpBU5GtfZH1UxTOzCJDtO6GJLAc6f8aIg7Hv9mWNKHUccgY82aiiGCM+scW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wA3G5grr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wA3G5grr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7856CC4CEF0;
	Tue, 12 Aug 2025 18:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024968;
	bh=zX90YrfiKQNmLIpOs8NU5+7oDeH39dcy7sHi3VunTAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wA3G5grr6kn3EoHKECDnlllEdZelgslGbHu5le3sIsdgQ8Ka4X7Muh0Pun/06y5y9
	 2fQ/0EuQMDz5ssLKhr3ChIawV6WO65PHCw7pP1Bt5Emse698KokOdpTB8D1MpSxop8
	 Ge2FcbJR9+vKz62/RivtZVSH+OxYoG65T0Hi7MXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salomon Dushimirimana <salomondush@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 497/627] scsi: sd: Make sd shutdown issue START STOP UNIT appropriately
Date: Tue, 12 Aug 2025 19:33:12 +0200
Message-ID: <20250812173446.546163305@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index eeaa6af294b8..282000c761f8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4173,7 +4173,9 @@ static void sd_shutdown(struct device *dev)
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



