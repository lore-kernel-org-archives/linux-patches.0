Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A463AFB11;
	Wed, 30 Sep 2026 16:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787065; cv=none; b=e99UEp1UbXrBq1zh+C1yImSUG8BGgdUcT05taVBXJafizgfNmYwhA4WUK/wkVr6Hvxz7NvokZco7EcSPRyQPIBNvZgUxxMlkf2wmdgFcKdTPtvAfqzaKBUy4Ybh9cT8xSIOASuz+EizsKEFOibnGTa4VBD+HDcTo44CvPEgn20Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787065; c=relaxed/simple;
	bh=UuMzvR+TXy3tK4xUinCN8JLGPVvjcn4G86BZZEiAGFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/W6xmqwKWlh2V8CZEjHcHnCxsHzP1wavmo4FFMBeqaxD7zZk+4SeTeSYEV5VvThRcyT/+yzEef0TWkqyg5qiPsfOKz1S5SeBniQF57qS7AUwU4cQWE5w4pgNqTbrI90MCMDkAenZsjswhFzf6qdHqB5/0ULras/YMDli9qspGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqxldR06; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqxldR06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B141F000FF;
	Wed, 30 Sep 2026 16:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787063;
	bh=Rrx4nL4TsSl3jNtfD7mNLWivYigkgnLBbSgm60xuPJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EqxldR06bmBJAFyuERLXNnls6i804jiS22lL63U70B8BiGfM4IWBIV/jE0T001fck
	 +m5KIVmYkjAxNdrD44/eSkyYHrKNbCpLo92uLcGgxc99Gaa7TvkJWFISWyPuGg7Gmm
	 AAbvgmf5o+FKzg8f4cVc8Au/naRr7/RW8Ovx4SnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Bezenah <wbezenah@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 062/457] s390/cio: Guard PMCW field accesses with dnv check
Date: Wed, 30 Sep 2026 17:22:47 +0200
Message-ID: <20260930152347.377421313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineeth Vijayan <vneethv@linux.ibm.com>

[ Upstream commit 9590f4d83880dfb5a81906e48e72779248fbe8f0 ]

When PMCW.DNV is 0, no I/O device is associated with the subchannel.
However, several code paths access PMCW fields directly from the cached
sch->schib without first invoking the update helper. Add explicit DNV
validation before accessing PMCW fields from the cached SCHIB to avoid
using invalid data.

Reported-by: William Bezenah <wbezenah@linux.ibm.com>
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Fixes: 8c58a229688c ("s390/cio: Do not unregister the subchannel based on DNV")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/chp.c          | 3 +++
 drivers/s390/cio/device.c       | 9 +++++----
 drivers/s390/cio/device_fsm.c   | 3 +++
 drivers/s390/cio/device_ops.c   | 9 +++++++++
 drivers/s390/cio/vfio_ccw_fsm.c | 2 +-
 5 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/cio/chp.c b/drivers/s390/cio/chp.c
index c890f21a82ce3..eaf0527bff6cc 100644
--- a/drivers/s390/cio/chp.c
+++ b/drivers/s390/cio/chp.c
@@ -78,6 +78,9 @@ u8 chp_get_sch_opm(struct subchannel *sch)
 	int opm;
 	int i;
 
+	if (!sch->schib.pmcw.dnv)
+		return 0;
+
 	opm = 0;
 	chp_id_init(&chpid);
 	for (i = 0; i < 8; i++) {
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index fb591118ecb2a..68dd4a62975d2 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -922,7 +922,7 @@ static int ccw_device_move_to_sch(struct ccw_device *cdev,
 
 	if (!sch_is_pseudo_sch(old_sch)) {
 		spin_lock_irq(&old_sch->lock);
-		old_enabled = old_sch->schib.pmcw.ena;
+		old_enabled = old_sch->schib.pmcw.dnv && old_sch->schib.pmcw.ena;
 		rc = 0;
 		if (old_enabled)
 			rc = cio_disable_subchannel(old_sch);
@@ -941,7 +941,7 @@ static int ccw_device_move_to_sch(struct ccw_device *cdev,
 		CIO_MSG_EVENT(0, "device_move(0.%x.%04x,0.%x.%04x)=%d\n",
 			      cdev->private->dev_id.ssid,
 			      cdev->private->dev_id.devno, sch->schid.ssid,
-			      sch->schib.pmcw.dev, rc);
+			      sch->schid.sch_no, rc);
 		if (old_enabled) {
 			/* Try to re-enable the old subchannel. */
 			spin_lock_irq(&old_sch->lock);
@@ -1207,7 +1207,7 @@ static void io_subchannel_quiesce(struct subchannel *sch)
 	cdev = sch_get_cdev(sch);
 	if (cio_is_console(sch->schid))
 		goto out_unlock;
-	if (!sch->schib.pmcw.ena)
+	if (!sch->schib.pmcw.dnv || !sch->schib.pmcw.ena)
 		goto out_unlock;
 	ret = cio_disable_subchannel(sch);
 	if (ret != -EBUSY)
@@ -1254,7 +1254,8 @@ static int recovery_check(struct device *dev, void *data)
 	switch (cdev->private->state) {
 	case DEV_STATE_ONLINE:
 		sch = to_subchannel(cdev->dev.parent);
-		if ((sch->schib.pmcw.pam & sch->opm) == sch->vpm)
+		if (sch->schib.pmcw.dnv &&
+		    (sch->schib.pmcw.pam & sch->opm) == sch->vpm)
 			break;
 		fallthrough;
 	case DEV_STATE_DISCONNECTED:
diff --git a/drivers/s390/cio/device_fsm.c b/drivers/s390/cio/device_fsm.c
index ab419d40a8a7a..b5686c25c83c7 100644
--- a/drivers/s390/cio/device_fsm.c
+++ b/drivers/s390/cio/device_fsm.c
@@ -170,6 +170,9 @@ __recover_lost_chpids(struct subchannel *sch, int old_lpm)
 	int mask, i;
 	struct chp_id chpid;
 
+	if (!sch->schib.pmcw.dnv)
+		return;
+
 	chp_id_init(&chpid);
 	for (i = 0; i<8; i++) {
 		mask = 0x80 >> i;
diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
index c1ba4a19368f2..f2f7f8cba410b 100644
--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -490,6 +490,8 @@ struct channel_path_desc_fmt0 *ccw_device_get_chp_desc(struct ccw_device *cdev,
 	struct chp_id chpid;
 
 	sch = to_subchannel(cdev->dev.parent);
+	if (!sch->schib.pmcw.dnv)
+		return NULL;
 	chp_id_init(&chpid);
 	chpid.id = sch->schib.pmcw.chpid[chp_idx];
 	return chp_get_chp_desc(chpid);
@@ -510,6 +512,8 @@ u8 *ccw_device_get_util_str(struct ccw_device *cdev, int chp_idx)
 	struct chp_id chpid;
 	u8 *util_str;
 
+	if (!sch->schib.pmcw.dnv)
+		return NULL;
 	chp_id_init(&chpid);
 	chpid.id = sch->schib.pmcw.chpid[chp_idx];
 	chp = chpid_to_chp(chpid);
@@ -662,6 +666,9 @@ int ccw_device_get_mdc(struct ccw_device *cdev, u8 mask)
 	struct chp_id chpid;
 	int mdc = 0, i;
 
+	if (!sch->schib.pmcw.dnv)
+		return 0;
+
 	/* Adjust requested path mask to excluded varied off paths. */
 	if (mask)
 		mask &= sch->lpm;
@@ -798,6 +805,8 @@ int ccw_device_get_chpid(struct ccw_device *cdev, int chp_idx, u8 *chpid)
 
 	if ((chp_idx < 0) || (chp_idx > 7))
 		return -EINVAL;
+	if (!sch->schib.pmcw.dnv)
+		return -ENODEV;
 	mask = 0x80 >> chp_idx;
 	if (!(sch->schib.pmcw.pim & mask))
 		return -ENODEV;
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 5fd94e9d5c618..9a000b0231d60 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -399,7 +399,7 @@ static void fsm_close(struct vfio_ccw_private *private,
 
 	spin_lock_irq(&sch->lock);
 
-	if (!sch->schib.pmcw.ena)
+	if (!sch->schib.pmcw.dnv || !sch->schib.pmcw.ena)
 		goto err_unlock;
 
 	ret = cio_disable_subchannel(sch);
-- 
2.53.0



