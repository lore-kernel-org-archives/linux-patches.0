Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D90214388D;
	Tue, 23 Apr 2024 21:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908506; cv=none; b=ZmdNqnBeMV2h+JSwv3BInr0i6uN1UnAlKviTz3MIFHhCu8W6ppVYSDbFE9H8Z3AeR2pasbd//QocWI8d2tM3DoZ2D3HHhGLv/VTsY9ryaoLMtZ5BygW0LIeF7myyZF+vtXtFVw3TFmsXj7349UgFEV1pd0BPJpv4gNr8RIlNQbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908506; c=relaxed/simple;
	bh=DQs11mPTJXtwbSraGcFT9lf9/fH+sFlpK8cLrbFNhHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6g7upY7B5e2x9rAAmvr9374KJWHDZJ3lIgjL6EnKT0vTIzRxweB5SoPwdlzc8XMtXySqiDlnlORFSe8oC0+lZ5iRBJOQ4C6RbJcl8aeaBmyO3Jdp6BQPfqRNB2Zjsf1mfiaiT/oQKo+6gwX2Lih3GbFeg1ZxsncvROFi6o2/i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/pax02b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/pax02b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F299AC116B1;
	Tue, 23 Apr 2024 21:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908506;
	bh=DQs11mPTJXtwbSraGcFT9lf9/fH+sFlpK8cLrbFNhHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/pax02bNeoRIyXmH+qWFs2EjopHswhKI6WT6YfKXGW/PeWDY5Mqo9edlUThe87a9
	 bY0shgUEL4IWk9kl3Ux6wRuZhOYhZOvgWQNBkBF1ZgAw45HLKJ0BU8mIq1uUSF3wVx
	 qK5jrivzwvobqeFj9n5hQ1YvNpQHjXnM1bhc3L58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 060/158] s390/qdio: handle deferred cc1
Date: Tue, 23 Apr 2024 14:38:02 -0700
Message-ID: <20240423213857.908507504@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



