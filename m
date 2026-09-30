Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BBE515980;
	Wed, 30 Sep 2026 16:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787034; cv=none; b=rqHlI4BPloJ7CzdlH5haYVhd44nqkihniGXEEmdiL0HkVFDa/HVb8s5vjx6y8+c90BXuQDI6x52avBQvw97wWcb0AdXopV/ikLhAMN/jkVNWk7kJJ1AmttsgEr274KaAyMKMm9rYUp+KtjlwakRPZZy0DgFdLnH89Ll2euYp4Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787034; c=relaxed/simple;
	bh=NIBbe7SAyLO2FQt+tF+zg6ulHjb+XQb8ac57v49myig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4Qf/u2Q71sYQASRTe7fOgL/q1+rFd2+8ns7MQm9aT5QGE8jmhTkQ6qQcubV1D8pw5+mCPMRfnJFtqIqkTSke/DgINmfW0E13Lehp8uP3hflriH/zYBCSMsPKXsTvbirOBI7M1jn8gJHYvV3pawSF0Pr+3v9k2iNM0cBdulf7og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fI4uyZaR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fI4uyZaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026551F000FF;
	Wed, 30 Sep 2026 16:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787032;
	bh=i6fbijdONkQ2p0pnfbdPvti+LWJydaeJ4GpwY99mAiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fI4uyZaRq7P3mSu7TxA6GY5MNy/J8zjgs2e4uRhfJ+7VhvAauSqz1tshfeJJkmfYN
	 dxE+ADYlINemZUpvmEewmMZHFz20YL6T1kh4b9XCKSOse0vDgn5tos5JuyrSTAUMlX
	 VlhbUJwrVFJcyPGsH5M5EfmcBwaHQYBOOth5pd/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Bezenah <wbezenah@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 061/457] s390/cio: Check pmcw.dnv before pmcw.ena in I/O entry points
Date: Wed, 30 Sep 2026 17:22:46 +0200
Message-ID: <20260930152347.355642613@linuxfoundation.org>
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

[ Upstream commit f6f2985eabdb2bfdc82ce90a1ea3ec53ba795f34 ]

The device number valid (dnv) bit in the PMCW must be checked before
acting on any other PMCW fields for IO-type subchannels. A subchannel
with dnv=0 has no valid device number associated, making it meaningless
to evaluate the enabled (ena) state or issue any I/O instruction against
it.

Reported-by: William Bezenah <wbezenah@linux.ibm.com>
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Fixes: 8c58a229688c ("s390/cio: Do not unregister the subchannel based on DNV")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/device_ops.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
index 61c07b4a0fe89..c1ba4a19368f2 100644
--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -142,6 +142,8 @@ int ccw_device_clear(struct ccw_device *cdev, unsigned long intparm)
 	if (!cdev || !cdev->dev.parent)
 		return -ENODEV;
 	sch = to_subchannel(cdev->dev.parent);
+	if (!sch->schib.pmcw.dnv)
+		return -ENODEV;
 	if (!sch->schib.pmcw.ena)
 		return -EINVAL;
 	if (cdev->private->state == DEV_STATE_NOT_OPER)
@@ -198,6 +200,8 @@ int ccw_device_start_timeout_key(struct ccw_device *cdev, struct ccw1 *cpa,
 	if (!cdev || !cdev->dev.parent)
 		return -ENODEV;
 	sch = to_subchannel(cdev->dev.parent);
+	if (!sch->schib.pmcw.dnv)
+		return -ENODEV;
 	if (!sch->schib.pmcw.ena)
 		return -EINVAL;
 	if (cdev->private->state == DEV_STATE_NOT_OPER)
@@ -379,6 +383,8 @@ int ccw_device_halt(struct ccw_device *cdev, unsigned long intparm)
 	if (!cdev || !cdev->dev.parent)
 		return -ENODEV;
 	sch = to_subchannel(cdev->dev.parent);
+	if (!sch->schib.pmcw.dnv)
+		return -ENODEV;
 	if (!sch->schib.pmcw.ena)
 		return -EINVAL;
 	if (cdev->private->state == DEV_STATE_NOT_OPER)
@@ -413,6 +419,8 @@ int ccw_device_resume(struct ccw_device *cdev)
 	if (!cdev || !cdev->dev.parent)
 		return -ENODEV;
 	sch = to_subchannel(cdev->dev.parent);
+	if (!sch->schib.pmcw.dnv)
+		return -ENODEV;
 	if (!sch->schib.pmcw.ena)
 		return -EINVAL;
 	if (cdev->private->state == DEV_STATE_NOT_OPER)
@@ -548,6 +556,8 @@ int ccw_device_tm_start_timeout_key(struct ccw_device *cdev, struct tcw *tcw,
 	int rc;
 
 	sch = to_subchannel(cdev->dev.parent);
+	if (!sch->schib.pmcw.dnv)
+		return -ENODEV;
 	if (!sch->schib.pmcw.ena)
 		return -EINVAL;
 	if (cdev->private->state == DEV_STATE_VERIFY) {
@@ -694,6 +704,8 @@ int ccw_device_tm_intrg(struct ccw_device *cdev)
 {
 	struct subchannel *sch = to_subchannel(cdev->dev.parent);
 
+	if (!sch->schib.pmcw.dnv)
+		return -ENODEV;
 	if (!sch->schib.pmcw.ena)
 		return -EINVAL;
 	if (cdev->private->state != DEV_STATE_ONLINE)
-- 
2.53.0



