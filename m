Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CA8357D11;
	Wed, 30 Sep 2026 16:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786343; cv=none; b=hZvS0j/M18kC78UixgDCQUcUCj8OQzcPrf03K+lgHCuL+Dt+54w5GlP6vWwBpt15/XD+pB/H3aRKnfsMa0LvTAanOq+njMl9VxMp+EU8QjzqLKFSH+cAszDV4V2m94W4OcAr4DPjCkZOj4Uhe8+7Hq456B3U19TyIXpz9AEzfvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786343; c=relaxed/simple;
	bh=Y+etC5sjk1ELrC8Pxu2wBK6VGqMcei/1t6YrPGeJHN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmgzRpYigfK5rHUqgRdFHOgJ11LUlcVpavOVfN4+5OrdvSkzL21US0TUsJFplrsWLjWQt5lWKsMVh3mfgn/vlVsH5hx29DTYzo/G7tSY9QbPiyp6CN+gsfvSAFhI5L9hDLDHAdsrdy8bLBqTVLCMvmK5c/IWOIyX7Qwf9Phnz/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PG4djLHb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PG4djLHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D0A1F000FF;
	Wed, 30 Sep 2026 16:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786341;
	bh=bwuJsp5yZgnVM76Orak3DMtk6Q1LYKmyG9wOJp2po5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PG4djLHbxg199DPDtoJv09iOOquRFqtLWgdgXC7JEG5xGgz0gTutf02TLcUl87APa
	 rNAKxXBlvi+l7L9qpPXp+p9wTFuLpdLIWqeah4l4pZVpoUirrVbF6Ik8J/LVchIlvd
	 q1p3No25tvozq3pHCVRMzd/USE/z7AYMYUeCLTqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Bezenah <wbezenah@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 826/982] s390/cio: Check pmcw.dnv before pmcw.ena in I/O entry points
Date: Wed, 30 Sep 2026 17:26:02 +0200
Message-ID: <20260930152434.501790618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a5dba3829769c..a18919a50909a 100644
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
@@ -375,6 +379,8 @@ int ccw_device_halt(struct ccw_device *cdev, unsigned long intparm)
 	if (!cdev || !cdev->dev.parent)
 		return -ENODEV;
 	sch = to_subchannel(cdev->dev.parent);
+	if (!sch->schib.pmcw.dnv)
+		return -ENODEV;
 	if (!sch->schib.pmcw.ena)
 		return -EINVAL;
 	if (cdev->private->state == DEV_STATE_NOT_OPER)
@@ -409,6 +415,8 @@ int ccw_device_resume(struct ccw_device *cdev)
 	if (!cdev || !cdev->dev.parent)
 		return -ENODEV;
 	sch = to_subchannel(cdev->dev.parent);
+	if (!sch->schib.pmcw.dnv)
+		return -ENODEV;
 	if (!sch->schib.pmcw.ena)
 		return -EINVAL;
 	if (cdev->private->state == DEV_STATE_NOT_OPER)
@@ -544,6 +552,8 @@ int ccw_device_tm_start_timeout_key(struct ccw_device *cdev, struct tcw *tcw,
 	int rc;
 
 	sch = to_subchannel(cdev->dev.parent);
+	if (!sch->schib.pmcw.dnv)
+		return -ENODEV;
 	if (!sch->schib.pmcw.ena)
 		return -EINVAL;
 	if (cdev->private->state == DEV_STATE_VERIFY) {
@@ -686,6 +696,8 @@ int ccw_device_tm_intrg(struct ccw_device *cdev)
 {
 	struct subchannel *sch = to_subchannel(cdev->dev.parent);
 
+	if (!sch->schib.pmcw.dnv)
+		return -ENODEV;
 	if (!sch->schib.pmcw.ena)
 		return -EINVAL;
 	if (cdev->private->state != DEV_STATE_ONLINE)
-- 
2.53.0



