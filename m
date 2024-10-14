Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1CF1AB6D4;
	Mon, 14 Oct 2024 15:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920056; cv=none; b=SCW1jSawbusS9Im5LvfLG0JoqXJWtWosLWzz+QjeRVwAeg0zIokRhPmvhR+BOBIx5iUblzVLVkRNGNUEu3hhGHSL+lxUXcLzVWoNUsXsSVJuxvE1npOSIcNAPBGuuJj56VdtiFuswjLmhlElrjzOyXYoU/lrGun0P0yt6JCbJyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920056; c=relaxed/simple;
	bh=uzwzP504dEKTg70EDvBF6ENnT8ZGzvvZtOoQsUyPYDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vnrm+bxzkK3n41aEyIIBAplsu3MMsY/nyoIr6v9JIJ/68qUHI6Gu3sr7ePQ1OIOCdsQP8dgw1WHRp88IzubFIcAIBcDsIURXTVVwNp5I1tODdYUvbRJWnR6urPHSPUaZJnJQr6F1I8X86wxpWoKWWj168vtIuSuT93a6ySaA8rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zksYJvEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zksYJvEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B19C4CEC3;
	Mon, 14 Oct 2024 15:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920056;
	bh=uzwzP504dEKTg70EDvBF6ENnT8ZGzvvZtOoQsUyPYDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zksYJvEyivQIEj3DsFX3hUUhcwNOx9L6KK1sEGuUJWEb4WfGOdCi/PmfBbi2KSPvG
	 XAot5yNI8gUVHwpS6f9sZXX9VKWlS1HZkTLj3dq4FgUXJVZgERLincXlICZNFt3nFA
	 f+nBShLHveEUNjL0hNWpkoR7D3wbAGsj39aRsm64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.1 785/798] ata: libata: avoid superfluous disk spin down + spin up during hibernation
Date: Mon, 14 Oct 2024 16:22:19 +0200
Message-ID: <20241014141248.909789308@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Niklas Cassel <cassel@kernel.org>

commit a38719e3157118428e34fbd45b0d0707a5877784 upstream.

A user reported that commit aa3998dbeb3a ("ata: libata-scsi: Disable scsi
device manage_system_start_stop") introduced a spin down + immediate spin
up of the disk both when entering and when resuming from hibernation.
This behavior was not there before, and causes an increased latency both
when entering and when resuming from hibernation.

Hibernation is done by three consecutive PM events, in the following order:
1) PM_EVENT_FREEZE
2) PM_EVENT_THAW
3) PM_EVENT_HIBERNATE

Commit aa3998dbeb3a ("ata: libata-scsi: Disable scsi device
manage_system_start_stop") modified ata_eh_handle_port_suspend() to call
ata_dev_power_set_standby() (which spins down the disk), for both event
PM_EVENT_FREEZE and event PM_EVENT_HIBERNATE.

Documentation/driver-api/pm/devices.rst, section "Entering Hibernation",
explicitly mentions that PM_EVENT_FREEZE does not have to be put the device
in a low-power state, and actually recommends not doing so. Thus, let's not
spin down the disk on PM_EVENT_FREEZE. (The disk will instead be spun down
during the subsequent PM_EVENT_HIBERNATE event.)

This way, PM_EVENT_FREEZE will behave as it did before commit aa3998dbeb3a
("ata: libata-scsi: Disable scsi device manage_system_start_stop"), while
PM_EVENT_HIBERNATE will continue to spin down the disk.

This will avoid the superfluous spin down + spin up when entering and
resuming from hibernation, while still making sure that the disk is spun
down before actually entering hibernation.

Cc: stable@vger.kernel.org # v6.6+
Fixes: aa3998dbeb3a ("ata: libata-scsi: Disable scsi device manage_system_start_stop")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20241008135843.1266244-2-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-eh.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3946,10 +3946,20 @@ static void ata_eh_handle_port_suspend(s
 
 	WARN_ON(ap->pflags & ATA_PFLAG_SUSPENDED);
 
-	/* Set all devices attached to the port in standby mode */
-	ata_for_each_link(link, ap, HOST_FIRST) {
-		ata_for_each_dev(dev, link, ENABLED)
-			ata_dev_power_set_standby(dev);
+	/*
+	 * We will reach this point for all of the PM events:
+	 * PM_EVENT_SUSPEND (if runtime pm, PM_EVENT_AUTO will also be set)
+	 * PM_EVENT_FREEZE, and PM_EVENT_HIBERNATE.
+	 *
+	 * We do not want to perform disk spin down for PM_EVENT_FREEZE.
+	 * (Spin down will be performed by the subsequent PM_EVENT_HIBERNATE.)
+	 */
+	if (!(ap->pm_mesg.event & PM_EVENT_FREEZE)) {
+		/* Set all devices attached to the port in standby mode */
+		ata_for_each_link(link, ap, HOST_FIRST) {
+			ata_for_each_dev(dev, link, ENABLED)
+				ata_dev_power_set_standby(dev);
+		}
 	}
 
 	/*


