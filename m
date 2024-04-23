Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FCE143889;
	Tue, 23 Apr 2024 21:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908600; cv=none; b=ThwN++/7BeuNkaXwwXyIQEiVfRUogC6N5QM/078t9AXUQcxhviZEg3ZGO0oKq5bpgWx7ZLRPJi256s0ll5gppcrsylpJPwEtWL5Mgr2bW3oo8KEd+ldPMYCiKmcIpyQRr8LnkXWqtgIE0qZBh8K1Zy8td3qelYTl0MXZ5afHisQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908600; c=relaxed/simple;
	bh=kZXoggI0bkUvgD+a6GeqHGwmwbFZORqrxg/yr4VZcGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0IqWnFuQN4NwFOBRKZIcVEyTpVbWLbUgE5pRbl8pfWVIiS1gY2I/hNrMKLpAvcQjrTiRcAyfM/P7htIl2fmDAPhe0qy8bsMIonVf/4XeBCSQ41UXF5bx2tG6I5Lqayu6arhqkDpFV6f5bxSNW3+S3RuJGPIqO797SqRJlObmo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ik4V5ayE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ik4V5ayE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D3EC116B1;
	Tue, 23 Apr 2024 21:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908600;
	bh=kZXoggI0bkUvgD+a6GeqHGwmwbFZORqrxg/yr4VZcGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ik4V5ayEHWA6kyJBOARdQho7CcPRzHf94JOzCbcEUQM7JMmIcFQbhnzUapk/3KiCu
	 bD/MsMuYJLwtiP2QYH+tvvdkpOl86H/IjhD68i8EX2CpOZaaQjyhMUW2cw5wJOM98s
	 zXyewwXi0NfVZWKr3AzXa+UeHwRqNvkiHnRCSNs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/158] s390/qdio: handle deferred cc1
Date: Tue, 23 Apr 2024 14:38:21 -0700
Message-ID: <20240423213857.852969117@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Oberparleiter <oberpar@linux.ibm.com>

[ Upstream commit 607638faf2ff1cede37458111496e7cc6c977f6f ]

A deferred condition code 1 response indicates that I/O was not started
and should be retried. The current QDIO implementation handles a cc1
response as I/O error, resulting in a failed QDIO setup. This can happen
for example when a path verification request arrives at the same time
as QDIO setup I/O is started.

Fix this by retrying the QDIO setup I/O when a cc1 response is received.

Note that since

commit 2297791c92d0 ("s390/cio: dont unregister subchannel from child-drivers")
commit 5ef1dc40ffa6 ("s390/cio: fix invalid -EBUSY on ccw_device_start")

deferred cc1 responses are much more likely to occur. See the commit
message of the latter for more background information.

Fixes: 2297791c92d0 ("s390/cio: dont unregister subchannel from child-drivers")
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/qdio_main.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 9cde55730b65a..ebcb535809882 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -722,8 +722,8 @@ static void qdio_handle_activate_check(struct qdio_irq *irq_ptr,
 	lgr_info_log();
 }
 
-static void qdio_establish_handle_irq(struct qdio_irq *irq_ptr, int cstat,
-				      int dstat)
+static int qdio_establish_handle_irq(struct qdio_irq *irq_ptr, int cstat,
+				     int dstat, int dcc)
 {
 	DBF_DEV_EVENT(DBF_INFO, irq_ptr, "qest irq");
 
@@ -731,15 +731,18 @@ static void qdio_establish_handle_irq(struct qdio_irq *irq_ptr, int cstat,
 		goto error;
 	if (dstat & ~(DEV_STAT_DEV_END | DEV_STAT_CHN_END))
 		goto error;
+	if (dcc == 1)
+		return -EAGAIN;
 	if (!(dstat & DEV_STAT_DEV_END))
 		goto error;
 	qdio_set_state(irq_ptr, QDIO_IRQ_STATE_ESTABLISHED);
-	return;
+	return 0;
 
 error:
 	DBF_ERROR("%4x EQ:error", irq_ptr->schid.sch_no);
 	DBF_ERROR("ds: %2x cs:%2x", dstat, cstat);
 	qdio_set_state(irq_ptr, QDIO_IRQ_STATE_ERR);
+	return -EIO;
 }
 
 /* qdio interrupt handler */
@@ -748,7 +751,7 @@ void qdio_int_handler(struct ccw_device *cdev, unsigned long intparm,
 {
 	struct qdio_irq *irq_ptr = cdev->private->qdio_data;
 	struct subchannel_id schid;
-	int cstat, dstat;
+	int cstat, dstat, rc, dcc;
 
 	if (!intparm || !irq_ptr) {
 		ccw_device_get_schid(cdev, &schid);
@@ -768,10 +771,12 @@ void qdio_int_handler(struct ccw_device *cdev, unsigned long intparm,
 	qdio_irq_check_sense(irq_ptr, irb);
 	cstat = irb->scsw.cmd.cstat;
 	dstat = irb->scsw.cmd.dstat;
+	dcc   = scsw_cmd_is_valid_cc(&irb->scsw) ? irb->scsw.cmd.cc : 0;
+	rc    = 0;
 
 	switch (irq_ptr->state) {
 	case QDIO_IRQ_STATE_INACTIVE:
-		qdio_establish_handle_irq(irq_ptr, cstat, dstat);
+		rc = qdio_establish_handle_irq(irq_ptr, cstat, dstat, dcc);
 		break;
 	case QDIO_IRQ_STATE_CLEANUP:
 		qdio_set_state(irq_ptr, QDIO_IRQ_STATE_INACTIVE);
@@ -785,12 +790,25 @@ void qdio_int_handler(struct ccw_device *cdev, unsigned long intparm,
 		if (cstat || dstat)
 			qdio_handle_activate_check(irq_ptr, intparm, cstat,
 						   dstat);
+		else if (dcc == 1)
+			rc = -EAGAIN;
 		break;
 	case QDIO_IRQ_STATE_STOPPED:
 		break;
 	default:
 		WARN_ON_ONCE(1);
 	}
+
+	if (rc == -EAGAIN) {
+		DBF_DEV_EVENT(DBF_INFO, irq_ptr, "qint retry");
+		rc = ccw_device_start(cdev, irq_ptr->ccw, intparm, 0, 0);
+		if (!rc)
+			return;
+		DBF_ERROR("%4x RETRY ERR", irq_ptr->schid.sch_no);
+		DBF_ERROR("rc:%4x", rc);
+		qdio_set_state(irq_ptr, QDIO_IRQ_STATE_ERR);
+	}
+
 	wake_up(&cdev->private->wait_q);
 }
 
-- 
2.43.0



