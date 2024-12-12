Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66B022967A;
	Thu, 12 Dec 2024 16:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021844; cv=none; b=t+3ZJQT+WDR421oYPngVDbNlYLrDArk/UKH8Au/wLhYsSrb4a9lcR1g+kz3axKUSnCK374djwXL+IU9hIOJMPUuq+eJs8kVQJhPb90niodEMgqHw70PRwmHk0408Njp+mQTsEMWSixzBzb6d6CRgF6GNeTNY6FsNwiJ34K0UbJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021844; c=relaxed/simple;
	bh=R/agaCc8CIO4yLeePRukWe55V6Ee+ul/kwmZxYNKC2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fygfW50Bix4aLsgrrIILW4NZdw/36QXKxzPcQLL7OiM45PW7Puij6vxUKvC8J53Cg86hmuUfdCFkImQ8jABEgL4iu7k8h2lpDA1XXF/K7fK9NB07Aqvk8pT8g7puAtAjqReYukH67hzP05w1bEBGUNnXIlxjfSRKyhTf4gpN38s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEIWZxhV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEIWZxhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3516EC4CECE;
	Thu, 12 Dec 2024 16:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021844;
	bh=R/agaCc8CIO4yLeePRukWe55V6Ee+ul/kwmZxYNKC2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEIWZxhVIeQf7WwX4ei5jTimgg8QsnuTLDGivyAb3HVfz4wFHHAcEAEwppyD2221r
	 IF0t5iqfFv9axqfvBfiRIWCcijwaY9TSe3GztMDtPwsaq4VJEsz/zTWqTbq2h+D2a3
	 hx2GgQ17MT75/0jQ8a0eUhqhw8j/VnTssc9bkymQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/565] s390/cio: Do not unregister the subchannel based on DNV
Date: Thu, 12 Dec 2024 15:54:33 +0100
Message-ID: <20241212144314.572404674@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c16f18cfeed72..c2ed91b69f079 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1390,14 +1390,18 @@ enum io_sch_action {
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
@@ -1405,6 +1409,16 @@ static enum io_sch_action sch_get_action(struct subchannel *sch)
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
@@ -1474,6 +1488,7 @@ static int io_subchannel_sch_event(struct subchannel *sch, int process)
 		rc = 0;
 		goto out_unlock;
 	case IO_SCH_ORPH_UNREG:
+	case IO_SCH_ORPH_CDEV:
 	case IO_SCH_ORPH_ATTACH:
 		ccw_device_set_disconnected(cdev);
 		break;
@@ -1505,6 +1520,7 @@ static int io_subchannel_sch_event(struct subchannel *sch, int process)
 	/* Handle attached ccw device. */
 	switch (action) {
 	case IO_SCH_ORPH_UNREG:
+	case IO_SCH_ORPH_CDEV:
 	case IO_SCH_ORPH_ATTACH:
 		/* Move ccw device to orphanage. */
 		rc = ccw_device_move_to_orph(cdev);
-- 
2.43.0



