Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1ECE1465A8;
	Tue, 25 Jun 2024 09:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308704; cv=none; b=lhIjOREpArPq+lx6P365gmqMNSX8ZODnU+jj4UUDebG0rl47BCnwUtkRNjO3P7PDqDKXL7TraOj1dAiu/Cn6XZwwhZeQH6dmnU04Pv+E86Kn8SDrqzqqeIUHfXDFxONmD4sV8iN+bs9qxAaIVyKOomWPYhGJHR48tqx9q940RmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308704; c=relaxed/simple;
	bh=zkR2sY+wVdVcHCm8t47CY/oRdozrq/kdzPH2RbzR7bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9UGN5RQ2Lt2jSII7AOZ7SZWQkawu8fhxWiG+sKgFzS58abdnFsPSQ46XGcg6h+H5PoG/+Jn9w0K8QMkUHOsvAKIdk64lEWU+ZHMAISBBdgrXANWAti7BN6TWWg/mJCf8OCAmH2D9eVfAPBYUw2znCZqVbJj0oNQqh10+DDY5J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PzNXOOBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzNXOOBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0F9C32781;
	Tue, 25 Jun 2024 09:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308703;
	bh=zkR2sY+wVdVcHCm8t47CY/oRdozrq/kdzPH2RbzR7bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzNXOOBDK80hXIbTePAq3cGhQVRMqQjF7YXNxSbrCMaaAwh5R7nVQy5TD6gArzHmx
	 AsFc8jFRgRNVm4OTirGo7fyVmdeZQPoBQUlfQ6fnr3ujTjDXDq3rj6znN2dgQcEAaS
	 f8V16EwlsklMIbcEzdmF7VPI/mkUzYzpIRaf/vbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Joao Machado <jocrismachado@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Christian Heusel <christian@heusel.eu>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.9 212/250] scsi: core: Introduce the BLIST_SKIP_IO_HINTS flag
Date: Tue, 25 Jun 2024 11:32:50 +0200
Message-ID: <20240625085556.192643638@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 633aeefafc9c2a07a76a62be6aac1d73c3e3defa upstream.

Prepare for skipping the IO Advice Hints Grouping mode page for USB storage
devices.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Joao Machado <jocrismachado@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Christian Heusel <christian@heusel.eu>
Cc: stable@vger.kernel.org
Fixes: 4f53138fffc2 ("scsi: sd: Translate data lifetime information")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20240613211828.2077477-2-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c           |    4 ++++
 include/scsi/scsi_devinfo.h |    4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -63,6 +63,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
@@ -3125,6 +3126,9 @@ static void sd_read_io_hints(struct scsi
 	struct scsi_mode_data data;
 	int res;
 
+	if (sdp->sdev_bflags & BLIST_SKIP_IO_HINTS)
+		return;
+
 	res = scsi_mode_sense(sdp, /*dbd=*/0x8, /*modepage=*/0x0a,
 			      /*subpage=*/0x05, buffer, SD_BUF_SIZE, SD_TIMEOUT,
 			      sdkp->max_retries, &data, &sshdr);
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -69,8 +69,10 @@
 #define BLIST_RETRY_ITF		((__force blist_flags_t)(1ULL << 32))
 /* Always retry ABORTED_COMMAND with ASC 0xc1 */
 #define BLIST_RETRY_ASC_C1	((__force blist_flags_t)(1ULL << 33))
+/* Do not query the IO Advice Hints Grouping mode page */
+#define BLIST_SKIP_IO_HINTS	((__force blist_flags_t)(1ULL << 34))
 
-#define __BLIST_LAST_USED BLIST_RETRY_ASC_C1
+#define __BLIST_LAST_USED BLIST_SKIP_IO_HINTS
 
 #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
 			       (__force blist_flags_t) \


