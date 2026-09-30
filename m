Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D57A51A747;
	Wed, 30 Sep 2026 17:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789049; cv=none; b=HEnfscArPzO/BczgfXyFB1PMmfaS6OshpB+SkN0jwJznjGKZCtLXbUrA9wYdaE0HbnedrisEzc+tXPqsReJYemcCbKFGQulz7hV5vCpezSKOUki8wAu3O7MJy4egJHf4T/gFAHRG2ORo5UA2ZN7e6tjkvy06fms1XVVwABtUAXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789049; c=relaxed/simple;
	bh=CmOQlWLzcKm3N9DvVmhDK/nVd9k4pAD3B+S7NeyjXOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pp2tizK7UaDgzYa6BBrRlMfPnlF0dU9JCecluTe8+/U8icR6uM3LBk/LW1xdYN5DD4wAo6tkJT6Rez35OoZnr5iwouY/nnquVUGt3wWXKWU0erA6OVdU/falsPtwGY0Lcw5iC1bYuotH0jGBHcf4JKMBhiYT8gLD2ld1BkpfJDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B04xjnuG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B04xjnuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1071F00898;
	Wed, 30 Sep 2026 17:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789047;
	bh=I7be1QPHtGm7jzs20XVJoWh/Luv2Q3WbbKqrCcs43Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B04xjnuGxZgvN44mpHaasu3SBUWvetiQ3dBuOpSWgNNg6ucF8O3uyHDZccbXGyLi/
	 lPrfzBahm5pUtQZ115j+RvSf6qf6LcBVp83VEETX3OuEXduNjcBIEUb/XRTvlleESs
	 0A93sSr/HYbFmVDy/m9Zrtu1IOFaBNNX2/Oh+vLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Bezenah <wbezenah@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 339/877] s390/cio: Check pmcw.dnv before pmcw.ena in I/O entry points
Date: Wed, 30 Sep 2026 17:20:50 +0200
Message-ID: <20260930152421.986458870@linuxfoundation.org>
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
index acd6790dba4dd..c0289b81a0d71 100644
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



