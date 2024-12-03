Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FDF1B3942;
	Tue,  3 Dec 2024 14:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237743; cv=none; b=Qo51V871MyihrRZJ6PGqu8BDCEex4pjKEfEFKZ+UNAu5t+afOfKu+DhGZ/TXrHqwcvUxVI3yOF41VViyY2sjwGZp7UfrDJTtMdxNirV82RGpz4FNvjPEOjPnLEl/GkHjUTy0SyGQxh2sqIe4NlYkrmWzHviyaxD0KGL9zz7v2Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237743; c=relaxed/simple;
	bh=uXtrQZcT7N68IgUSzHE9AiKUEd7RXA5ctbhj1AtZFXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4eCQwJvJLlcKgB4/YAcGSI9vIdaVxHWAON+wTMQO1NxNhIDIQALYN6kEFH2BYYWbmfjxLEwZCFMNbDw6cxBKl1aXLGD2nc+2TW+jNsnPvJyY5RQLY+84dWzVLHGx2/H3PYfhOtMZLEkb+RaS/PaLhcAKiZxlGwijL/VX87RLzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hs3fMCbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hs3fMCbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93EBC4CECF;
	Tue,  3 Dec 2024 14:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237743;
	bh=uXtrQZcT7N68IgUSzHE9AiKUEd7RXA5ctbhj1AtZFXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hs3fMCbIlGHFndg6zCmv+69NJjZmyuMbGMtXspE40cWWnIFmWjRd0bLOwWJBSJAiV
	 D3ud2ebRzZX8SFJj1Xnf65UTc0WdFyek/Op6cpCcQU+IuTJ/1Mo1XhbjKStMRyllEg
	 4HERt4w5YSMLSp/LWk/IhTWP2JodUtfg38dXvGfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 057/817] s390/cio: Do not unregister the subchannel based on DNV
Date: Tue,  3 Dec 2024 15:33:49 +0100
Message-ID: <20241203143957.908842917@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index c32e818f06dba..ad17ab0a93149 100644
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
index b0f23242e1714..9498825d9c7a5 100644
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



