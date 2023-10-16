Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8156C15ADD
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJueGX+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A43C433C9;
	Mon, 16 Oct 2023 09:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697447204;
	bh=b0sKZ//hVb4sraQabtwq6yQANOpp70yVg1M2WvyHX7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJueGX+3rPwyjefKb7cBI8gzXSSOhWpmbrJwMnt3zH0HI0RjyyrqPS0KEWUYHu3H3
	 4Y5gHZwdKzh+xrJ5ucK/VVgCsi3RJ7YSKF7Bu51fRQrh4IiYEJ6vbHjN2ghJ3ft/jY
	 JvvjqLj6NYytaFoXdQifyM+2j8V7Lw7BFEa3alaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <petr@tesarici.cz>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.5 013/191] scsi: Do not rescan devices with a suspended queue
Date: Mon, 16 Oct 2023 10:39:58 +0200
Message-ID: <20231016084015.711796356@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 626b13f015e080e434b1dee9a0c116ddbf4fb695 upstream.

Commit ff48b37802e5 ("scsi: Do not attempt to rescan suspended devices")
modified scsi_rescan_device() to avoid attempting rescanning a suspended
device. However, the modification added a check to verify that a SCSI
device is in the running state without checking if the device request
queue (in the case of block device) is also running, thus allowing the
exectuion of internal requests. Without checking the device request
queue, commit ff48b37802e5 fix is incomplete and deadlocks on resume can
still happen. Use blk_queue_pm_only() to check if the device request
queue allows executing commands in addition to checking the SCSI device
state.

Reported-by: Petr Tesarik <petr@tesarici.cz>
Fixes: ff48b37802e5 ("scsi: Do not attempt to rescan suspended devices")
Cc: stable@vger.kernel.org
Tested-by: Petr Tesarik <petr@tesarici.cz>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_scan.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1627,12 +1627,13 @@ int scsi_rescan_device(struct scsi_devic
 	device_lock(dev);
 
 	/*
-	 * Bail out if the device is not running. Otherwise, the rescan may
-	 * block waiting for commands to be executed, with us holding the
-	 * device lock. This can result in a potential deadlock in the power
-	 * management core code when system resume is on-going.
+	 * Bail out if the device or its queue are not running. Otherwise,
+	 * the rescan may block waiting for commands to be executed, with us
+	 * holding the device lock. This can result in a potential deadlock
+	 * in the power management core code when system resume is on-going.
 	 */
-	if (sdev->sdev_state != SDEV_RUNNING) {
+	if (sdev->sdev_state != SDEV_RUNNING ||
+	    blk_queue_pm_only(sdev->request_queue)) {
 		ret = -EWOULDBLOCK;
 		goto unlock;
 	}


