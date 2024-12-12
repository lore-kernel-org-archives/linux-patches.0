Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5B913792B;
	Thu, 12 Dec 2024 15:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018841; cv=none; b=kqrQbHhrMzY8ifGpc6sTi2mee+JlidPPzDzdvsBGBMg6/8ZweGkkWGbMAKjdZBzzX3PJ5eD67x/+bDPdwvw0W0oBBfpMmuokYWkgJq07dleHLkjdQ6E3BYDpqehgqIZZtuBK+BF+Msz32uIw/kX0/S/V1jC/doeDfg0hjK70zQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018841; c=relaxed/simple;
	bh=Wqz7NsVqJ/bbhMzmIoAhthAGOfBu8HZovpALfQkja/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEstsoAngrXNcTR0MAPnYkS4dTs2ybTTioQDsPj/p4RNkrABnRfrtFC2Hh4CeSgHxX9yV+K2GQtVlGmmHCBxtSpaGRJG1bsECEXyiCrblER3vZvaTc7eerIDTawOCMTok4eyj2S+FX9cDxHr4TScj0JjJwyaoJRmhlCE/rNSXrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GT6Dj6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GT6Dj6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C43EC4CECE;
	Thu, 12 Dec 2024 15:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018840;
	bh=Wqz7NsVqJ/bbhMzmIoAhthAGOfBu8HZovpALfQkja/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GT6Dj6z2EpUyzVe82DGtMhPXSzkny314zFPxDBQD8fR+jRRghhoKKelRwY8tH0QY
	 iJNPL78KmJKvNaLWBXTf3yL6uqfuyvULalba6pcU4oRZyB20wbhESLO4Wyd7eTOTaH
	 Q6hanccCvBDSpbUqb52AxNa4P5k2kYf2zXYjiMAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/772] s390/cio: Do not unregister the subchannel based on DNV
Date: Thu, 12 Dec 2024 15:49:53 +0100
Message-ID: <20241212144351.923316196@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Vineeth Vijayan <vneethv@linux.ibm.com>

[ Upstream commit 8c58a229688ce3a097b3b1a2efe1b4f5508c2123 ]

Starting with commit 2297791c92d0 ("s390/cio: dont unregister
subchannel from child-drivers"), CIO does not unregister subchannels
when the attached device is invalid or unavailable. Instead, it
allows subchannels to exist without a connected device. However, if
the DNV value is 0, such as, when all the CHPIDs of a subchannel are
configured in standby state, the subchannel is unregistered, which
contradicts the current subchannel specification.

Update the logic so that subchannels are not unregistered based
on the DNV value. Also update the SCHIB information even if the
DNV bit is zero.

Suggested-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Fixes: 2297791c92d0 ("s390/cio: dont unregister subchannel from child-drivers")
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/cio.c    |  6 +++++-
 drivers/s390/cio/device.c | 18 +++++++++++++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 923f5ca4f5e6b..54bfa9fe3031b 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -459,10 +459,14 @@ int cio_update_schib(struct subchannel *sch)
 {
 	struct schib schib;
 
-	if (stsch(sch->schid, &schib) || !css_sch_is_valid(&schib))
+	if (stsch(sch->schid, &schib))
 		return -ENODEV;
 
 	memcpy(&sch->schib, &schib, sizeof(schib));
+
+	if (!css_sch_is_valid(&schib))
+		return -EACCES;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cio_update_schib);
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 5666b9cc5d296..bdf5a50bd931d 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1378,14 +1378,18 @@ enum io_sch_action {
 	IO_SCH_VERIFY,
 	IO_SCH_DISC,
 	IO_SCH_NOP,
+	IO_SCH_ORPH_CDEV,
 };
 
 static enum io_sch_action sch_get_action(struct subchannel *sch)
 {
 	struct ccw_device *cdev;
+	int rc;
 
 	cdev = sch_get_cdev(sch);
-	if (cio_update_schib(sch)) {
+	rc = cio_update_schib(sch);
+
+	if (rc == -ENODEV) {
 		/* Not operational. */
 		if (!cdev)
 			return IO_SCH_UNREG;
@@ -1393,6 +1397,16 @@ static enum io_sch_action sch_get_action(struct subchannel *sch)
 			return IO_SCH_UNREG;
 		return IO_SCH_ORPH_UNREG;
 	}
+
+	/* Avoid unregistering subchannels without working device. */
+	if (rc == -EACCES) {
+		if (!cdev)
+			return IO_SCH_NOP;
+		if (ccw_device_notify(cdev, CIO_GONE) != NOTIFY_OK)
+			return IO_SCH_UNREG_CDEV;
+		return IO_SCH_ORPH_CDEV;
+	}
+
 	/* Operational. */
 	if (!cdev)
 		return IO_SCH_ATTACH;
@@ -1462,6 +1476,7 @@ static int io_subchannel_sch_event(struct subchannel *sch, int process)
 		rc = 0;
 		goto out_unlock;
 	case IO_SCH_ORPH_UNREG:
+	case IO_SCH_ORPH_CDEV:
 	case IO_SCH_ORPH_ATTACH:
 		ccw_device_set_disconnected(cdev);
 		break;
@@ -1493,6 +1508,7 @@ static int io_subchannel_sch_event(struct subchannel *sch, int process)
 	/* Handle attached ccw device. */
 	switch (action) {
 	case IO_SCH_ORPH_UNREG:
+	case IO_SCH_ORPH_CDEV:
 	case IO_SCH_ORPH_ATTACH:
 		/* Move ccw device to orphanage. */
 		rc = ccw_device_move_to_orph(cdev);
-- 
2.43.0



