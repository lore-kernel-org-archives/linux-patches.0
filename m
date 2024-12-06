Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9BD149E0E;
	Fri,  6 Dec 2024 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496603; cv=none; b=ETUedIF2Ki8qXmKWDqSqT1tJVelJvz/9o60j3Mo/Hls/fjxYiiZqchfO8bvMIiIYPteBqrSrtzFP+DMs6te8N1+H7wJprvM+nRikuIhdM/FwOLZttcUpE3v9QqepY3IKXL1zI+VX5pukac0c5lU6nIzfew2q8pJWhhUBm3//1rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496603; c=relaxed/simple;
	bh=OJgJJHSpBmPqo5pQI1RfkGJzVxK92Z3+7O9IbhBdndY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkahFAWr82Lv26LkTRu5pT6ObCvzfFKYJ3Ca/C7cVQdCWWCIE7gN9655XmgyO8SDaAAOQ/ZvWsFxtcwlmQg5rjXOPhKea8KfcZR6dkt69i1hP09LeMMGXWLmXPhPpFOers0XajknirzvvTnT2N83DuUPtCkr6CTh9pyZBDpnZsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkOxmJTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkOxmJTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AB9C4CED1;
	Fri,  6 Dec 2024 14:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496603;
	bh=OJgJJHSpBmPqo5pQI1RfkGJzVxK92Z3+7O9IbhBdndY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkOxmJTgUL2CH21EL623sv650QZFyCNt+KjpH1PwwtUIEW+Oa39jefc9izyPqaUmv
	 9OcUg7R316E8dZnNwgMeyvJZ/94omjT946ZL4jyEKTH5RiD/pbp5Lz22OgUaLJU37c
	 eQ3L7NIZZFaBHdrCikXm4V0BB1kZnXmQDNwChOVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/676] s390/cio: Do not unregister the subchannel based on DNV
Date: Fri,  6 Dec 2024 15:27:51 +0100
Message-ID: <20241206143655.384174465@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 6127add746d18..81ef9002f0640 100644
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
index 57e0050dbaa53..6b374026cd4f4 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1387,14 +1387,18 @@ enum io_sch_action {
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
@@ -1402,6 +1406,16 @@ static enum io_sch_action sch_get_action(struct subchannel *sch)
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
@@ -1471,6 +1485,7 @@ static int io_subchannel_sch_event(struct subchannel *sch, int process)
 		rc = 0;
 		goto out_unlock;
 	case IO_SCH_ORPH_UNREG:
+	case IO_SCH_ORPH_CDEV:
 	case IO_SCH_ORPH_ATTACH:
 		ccw_device_set_disconnected(cdev);
 		break;
@@ -1502,6 +1517,7 @@ static int io_subchannel_sch_event(struct subchannel *sch, int process)
 	/* Handle attached ccw device. */
 	switch (action) {
 	case IO_SCH_ORPH_UNREG:
+	case IO_SCH_ORPH_CDEV:
 	case IO_SCH_ORPH_ATTACH:
 		/* Move ccw device to orphanage. */
 		rc = ccw_device_move_to_orph(cdev);
-- 
2.43.0



