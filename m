Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5C96F08B;
	Mon,  8 Apr 2024 13:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581356; cv=none; b=ZBrPmAg6BUudQTy+hvNFvZBPTRlh9HcNTafcU694m3DDHFKwcp5Od/LRkLZExEDGTrlO8SH2QYMk8CNcVkxRc3/MRY5waIyhQmsjjl04iicDXWQbV+vCiS531rUjLXWyOPQeMUE+L5a0MbEava/MO6ot6KdankCsykXCtX0XOLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581356; c=relaxed/simple;
	bh=he+zHfL3tDShvQ7q0MNP0c2Oprn9hdhxEArWpSGCW5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snplA6Pt/220zIX9KcI0o2wVd2seiIWNtYOaCTpDTDxksgW8YBMZWRB139Mled6KWwCjkv2RZ8qfTI0zBzSqC1Llx9Us9vQpXvcDeOKGXIvPJeeCZE3JRIyMaeJJhkwzQtwwkxNjeNDhmefVHqVa8+B06CDs71RlKmA4GeJmEjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JeYZOtOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JeYZOtOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D171C433C7;
	Mon,  8 Apr 2024 13:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581355;
	bh=he+zHfL3tDShvQ7q0MNP0c2Oprn9hdhxEArWpSGCW5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JeYZOtObYLl89H265qeYI1P4fAgCzckgOjhm6ADhyreh2qqkpVFN8zhLsUUd91jpT
	 1Ywu5NayYv2Ger93CL0NT+9Ht2doxPam2NVHk6Q9a3dUbJrKVJDl0RNvYIVl+ldInQ
	 qho4ufDus+ILl59+l5+kHGfoIQpnuKdyMorwJqgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Thorsten Winkler <twinkler@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/138] s390/qeth: handle deferred cc1
Date: Mon,  8 Apr 2024 14:57:01 +0200
Message-ID: <20240408125256.455719289@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit afb373ff3f54c9d909efc7f810dc80a9742807b2 ]

The IO subsystem expects a driver to retry a ccw_device_start, when the
subsequent interrupt response block (irb) contains a deferred
condition code 1.

Symptoms before this commit:
On the read channel we always trigger the next read anyhow, so no
different behaviour here.
On the write channel we may experience timeout errors, because the
expected reply will never be received without the retry.
Other callers of qeth_send_control_data() may wrongly assume that the ccw
was successful, which may cause problems later.

Note that since
commit 2297791c92d0 ("s390/cio: dont unregister subchannel from child-drivers")
and
commit 5ef1dc40ffa6 ("s390/cio: fix invalid -EBUSY on ccw_device_start")
deferred CC1s are much more likely to occur. See the commit message of the
latter for more background information.

Fixes: 2297791c92d0 ("s390/cio: dont unregister subchannel from child-drivers")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Co-developed-by: Thorsten Winkler <twinkler@linux.ibm.com>
Signed-off-by: Thorsten Winkler <twinkler@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Link: https://lore.kernel.org/r/20240321115337.3564694-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c | 38 +++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index ae4b6d24bc902..1e6340e2c2588 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1179,6 +1179,20 @@ static int qeth_check_irb_error(struct qeth_card *card, struct ccw_device *cdev,
 	}
 }
 
+/**
+ * qeth_irq() - qeth interrupt handler
+ * @cdev: ccw device
+ * @intparm: expect pointer to iob
+ * @irb: Interruption Response Block
+ *
+ * In the good path:
+ * corresponding qeth channel is locked with last used iob as active_cmd.
+ * But this function is also called for error interrupts.
+ *
+ * Caller ensures that:
+ * Interrupts are disabled; ccw device lock is held;
+ *
+ */
 static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 		struct irb *irb)
 {
@@ -1220,11 +1234,10 @@ static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 		iob = (struct qeth_cmd_buffer *) (addr_t)intparm;
 	}
 
-	qeth_unlock_channel(card, channel);
-
 	rc = qeth_check_irb_error(card, cdev, irb);
 	if (rc) {
 		/* IO was terminated, free its resources. */
+		qeth_unlock_channel(card, channel);
 		if (iob)
 			qeth_cancel_cmd(iob, rc);
 		return;
@@ -1268,6 +1281,7 @@ static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 		rc = qeth_get_problem(card, cdev, irb);
 		if (rc) {
 			card->read_or_write_problem = 1;
+			qeth_unlock_channel(card, channel);
 			if (iob)
 				qeth_cancel_cmd(iob, rc);
 			qeth_clear_ipacmd_list(card);
@@ -1276,6 +1290,26 @@ static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 		}
 	}
 
+	if (scsw_cmd_is_valid_cc(&irb->scsw) && irb->scsw.cmd.cc == 1 && iob) {
+		/* channel command hasn't started: retry.
+		 * active_cmd is still set to last iob
+		 */
+		QETH_CARD_TEXT(card, 2, "irqcc1");
+		rc = ccw_device_start_timeout(cdev, __ccw_from_cmd(iob),
+					      (addr_t)iob, 0, 0, iob->timeout);
+		if (rc) {
+			QETH_DBF_MESSAGE(2,
+					 "ccw retry on %x failed, rc = %i\n",
+					 CARD_DEVID(card), rc);
+			QETH_CARD_TEXT_(card, 2, " err%d", rc);
+			qeth_unlock_channel(card, channel);
+			qeth_cancel_cmd(iob, rc);
+		}
+		return;
+	}
+
+	qeth_unlock_channel(card, channel);
+
 	if (iob) {
 		/* sanity check: */
 		if (irb->scsw.cmd.count > iob->length) {
-- 
2.43.0



