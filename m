Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FFB9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB9AC433C8;
	Sun, 13 Aug 2023 21:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962746;
	bh=aYo3nfS70hiuAR6MC1KJQmyn4pU0OCZceC9spGImXIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0a4ac/ev5T2bPyNUbi1uCsdkPJb5sPsUzOLoW5gviBKwmx7h34jLb9B/dxOIO5eai
	 v7b7P+sDJqQx7HKgo009JqkGDdxFs2r52BBnCTc23bY5zFpJU+A6LEPrjzZxDFvDCI
	 cK5sYYnZHU9WRI+nyMSbOysfqtizVwJ6cfTL6UYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 142/149] scsi: fnic: Replace return codes in fnic_clean_pending_aborts()
Date: Sun, 13 Aug 2023 23:19:47 +0200
Message-ID: <20230813211722.949584804@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Karan Tilak Kumar <kartilak@cisco.com>

commit 5a43b07a87835660f91d88a4db11abfea8c523b7 upstream.

fnic_clean_pending_aborts() was returning a non-zero value irrespective of
failure or success.  This caused the caller of this function to assume that
the device reset had failed, even though it would succeed in most cases. As
a consequence, a successful device reset would escalate to host reset.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Link: https://lore.kernel.org/r/20230727193919.2519-1-kartilak@cisco.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/fnic/fnic.h      |    2 +-
 drivers/scsi/fnic/fnic_scsi.c |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -27,7 +27,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.54"
+#define DRV_VERSION		"1.6.0.55"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2139,7 +2139,7 @@ static int fnic_clean_pending_aborts(str
 				     bool new_sc)
 
 {
-	int ret = SUCCESS;
+	int ret = 0;
 	struct fnic_pending_aborts_iter_data iter_data = {
 		.fnic = fnic,
 		.lun_dev = lr_sc->device,
@@ -2159,9 +2159,11 @@ static int fnic_clean_pending_aborts(str
 
 	/* walk again to check, if IOs are still pending in fw */
 	if (fnic_is_abts_pending(fnic, lr_sc))
-		ret = FAILED;
+		ret = 1;
 
 clean_pending_aborts_end:
+	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
+			"%s: exit status: %d\n", __func__, ret);
 	return ret;
 }
 


