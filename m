Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007C151B167;
	Wed, 30 Sep 2026 17:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789052; cv=none; b=EpscU5jJxacoiZ9sCbw+73dgHv2IdYEPVOmCqs5vn/cxxzdOtfVZ0toUsEkrig3ZktAupiiP3I0/arZVLlAaSofa843NU/mWuemWtWVYmgpl4YfmkY3LS/CdJB0BSogU6t0r29waVs2D/NuSovsNApNOoA+BALyHqKeGZAEEqDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789052; c=relaxed/simple;
	bh=jIEf7+YXAFZjwgbBEGS+WtWBDpkaUEfc208ULAGHPdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eig3ta/YIVD4jOSCktdfyzf1W6k4V2OwfDTA5Sc1jZv6pUvTowvjkXWug+nRAB/WLOPOiLlKWXHKFOr7qfYf+2/XsBqKH6MiovFz63qVLPwmT/dwdM9Xw91xWWXuWPH5am9rXN2gh2cu1UEZhvxdjAmvut4azWuKSnlWi+I3o/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+kkIvLC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+kkIvLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2C11F000FF;
	Wed, 30 Sep 2026 17:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789050;
	bh=k0CeC3KhdORbCBsPLPA4D0GuQ+2ikXR8hWh8oa96j10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+kkIvLCWcbnM8SRNJlCxCwWqmi9Axe0XFDg5X9jZ8zJUpvTRDpXR99j3gWVgUGIY
	 4yxKU8RfwuM874VjeN8ycDs2+vBmDZVnJPS6cHKGSOdWLfU52+lmSaoWRZDHCmSeaX
	 lkx3w9uX9pa4wSOOz+0G5hmPHSU/vtHXuWgR8oJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Bezenah <wbezenah@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 340/877] s390/cio: Guard PMCW field accesses with dnv check
Date: Wed, 30 Sep 2026 17:20:51 +0200
Message-ID: <20260930152422.007272281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0c5bda060249e..b6ef882f98607 100644
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
index 7e309ea2e177c..b6e2839dfeb37 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -925,7 +925,7 @@ static int ccw_device_move_to_sch(struct ccw_device *cdev,
 
 	if (!sch_is_pseudo_sch(old_sch)) {
 		spin_lock_irq(&old_sch->lock);
-		old_enabled = old_sch->schib.pmcw.ena;
+		old_enabled = old_sch->schib.pmcw.dnv && old_sch->schib.pmcw.ena;
 		rc = 0;
 		if (old_enabled)
 			rc = cio_disable_subchannel(old_sch);
@@ -944,7 +944,7 @@ static int ccw_device_move_to_sch(struct ccw_device *cdev,
 		CIO_MSG_EVENT(0, "device_move(0.%x.%04x,0.%x.%04x)=%d\n",
 			      cdev->private->dev_id.ssid,
 			      cdev->private->dev_id.devno, sch->schid.ssid,
-			      sch->schib.pmcw.dev, rc);
+			      sch->schid.sch_no, rc);
 		if (old_enabled) {
 			/* Try to re-enable the old subchannel. */
 			spin_lock_irq(&old_sch->lock);
@@ -1210,7 +1210,7 @@ static void io_subchannel_quiesce(struct subchannel *sch)
 	cdev = sch_get_cdev(sch);
 	if (cio_is_console(sch->schid))
 		goto out_unlock;
-	if (!sch->schib.pmcw.ena)
+	if (!sch->schib.pmcw.dnv || !sch->schib.pmcw.ena)
 		goto out_unlock;
 	ret = cio_disable_subchannel(sch);
 	if (ret != -EBUSY)
@@ -1257,7 +1257,8 @@ static int recovery_check(struct device *dev, void *data)
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
index 42791fa0b80e2..96bab4cde37a2 100644
--- a/drivers/s390/cio/device_fsm.c
+++ b/drivers/s390/cio/device_fsm.c
@@ -169,6 +169,9 @@ __recover_lost_chpids(struct subchannel *sch, int old_lpm)
 	int mask, i;
 	struct chp_id chpid;
 
+	if (!sch->schib.pmcw.dnv)
+		return;
+
 	chp_id_init(&chpid);
 	for (i = 0; i<8; i++) {
 		mask = 0x80 >> i;
diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
index c0289b81a0d71..8fe3ff4f0855d 100644
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



