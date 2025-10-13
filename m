Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C01F17A2EC;
	Mon, 13 Oct 2025 15:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369433; cv=none; b=CYvNQViUH6hXNK0r/6CPSZ7p33g1OE93YcmKF1JZC5zXL1L2XV9nNYJiWF2nbRSGKFNJvSAvb//987A3dSQNSIxURtDCVpFgitiTTE1LJzOlX2Cer2AT33IUNN2pTxn/1K32qyjfNkTgCDueMloxe9AYRdogKyPf9exqd0TIDuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369433; c=relaxed/simple;
	bh=l0GLU5VYx2tdDt5u+Nuh7K+WeTDy21oSyQDL8UWIwN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6J4lpGtFhedWbeUdoQ2ra0fBQFIdFzyomETCzBV+wqlSGwTqOJpQeppEgX/Rpk2XwgxlHFZkMwcY6eAZOodX4/sdxavbyqHPa1Z0txAaZgRkBa6x7e2oHBBt/kKnKVICZJLdm7hARpgOBT+xRVETVM70zBeyXH7Sot4vkHdY64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJD1tWff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJD1tWff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE947C4CEE7;
	Mon, 13 Oct 2025 15:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369433;
	bh=l0GLU5VYx2tdDt5u+Nuh7K+WeTDy21oSyQDL8UWIwN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJD1tWffedFPJkNcE+aX1zSWofBfAPlT9+MkLnB1iO6ezzHe08xBtQBgh8ir+cspG
	 FCx9t0kQDo3vOxZTXuZf+zk+de0J147iWt0Kp65QLUcaCOcLbbNtfRHgLVJg4uNmyB
	 yX/D6NhF4csRcuoNvfHW7eIZeVoGO+OtiO1HbYjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 245/563] scsi: pm80xx: Restore support for expanders
Date: Mon, 13 Oct 2025 16:41:46 +0200
Message-ID: <20251013144420.159765157@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit eeee1086073e0058243c8554738271561bde81f1 ]

Commit 0f630c58e31a ("scsi: pm80xx: Do not use libsas port ID") broke
support for expanders. After the commit, devices behind an expander are
no longer detected.

Simply reverting the commit restores support for devices behind an
expander.

Instead of reverting the commit (and reintroducing a helper to get the
port), get the port directly from the lldd_port pointer in struct
asd_sas_port.

Fixes: 0f630c58e31a ("scsi: pm80xx: Do not use libsas port ID")
Suggested-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20250814173215.1765055-13-cassel@kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index f7067878b34f3..753c09363cbbc 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -477,7 +477,7 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
 	bool internal_abort = sas_is_internal_abort(task);
 	struct pm8001_hba_info *pm8001_ha;
-	struct pm8001_port *port = NULL;
+	struct pm8001_port *port;
 	struct pm8001_ccb_info *ccb;
 	unsigned long flags;
 	u32 n_elem = 0;
@@ -502,8 +502,7 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
 
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
 
-	pm8001_dev = dev->lldd_dev;
-	port = pm8001_ha->phy[pm8001_dev->attached_phy].port;
+	port = dev->port->lldd_port;
 
 	if (!internal_abort &&
 	    (DEV_IS_GONE(pm8001_dev) || !port || !port->port_attached)) {
-- 
2.51.0



