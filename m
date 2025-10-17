Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B55330B1E;
	Fri, 17 Oct 2025 15:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716385; cv=none; b=TfnyprH91C+PuCCZ11yd2IOWrhSNHcJ2n3MQu1UnOJUo+LD1vt2PydtYc0KG06L6dlWuu1sYiEcjKKzAfXBC7TVc5DUe7ad4JnH38sM3Sb7mRWezH7DhqydRs25VEG4ythc2XAwwgBpevlkORJdvS7kVRRpNvcK2lzMAK8N7oqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716385; c=relaxed/simple;
	bh=lg17htMOMrwpIcBZo4PdmJ6Z8sQc6QgDCLDO/X6X9OA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuOctm84MTU4DrfM3l5ZHMT8nNf5hjcslOcek+Th/CNejkAZ9rZjv8P/wezx2nARat92BWvzxJrDC3ZL7ev2dlqOs0g2o90+06ajHg/G+yvAYMo6dEknwZxugx3DAibDqbUdNGnjyGnX4UkcBEpFXHVt01HGq0nS36jkL5h62AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkII3PCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkII3PCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEB0C4CEE7;
	Fri, 17 Oct 2025 15:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716385;
	bh=lg17htMOMrwpIcBZo4PdmJ6Z8sQc6QgDCLDO/X6X9OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkII3PCPBwyeqK3AfcAY6CZBx+9mdyl7ZC6x/g1KQ3Su2YYfSXuS6wz2sXgJp0VRs
	 2FIVPDnrj6c+nY9z7ChBOjvoLN6d+LqzRdLKNbn12kdJ+yIRdR/pJn+tFuvk8KBke2
	 qb3u2PyzAu6LJCkGHZ+h+eDLGwjYJvIKV302ktBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/276] s390/cio: unregister the subchannel while purging
Date: Fri, 17 Oct 2025 16:53:58 +0200
Message-ID: <20251017145147.775205972@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineeth Vijayan <vneethv@linux.ibm.com>

[ Upstream commit fa172f043f5bc21c357c54a6ca2e9c8acd18c3db ]

The cio_ignore list is used to create and maintain the list of devices
which is to be ignored by Linux. During boot-time, this list is adjusted
and accommodate all the devices which are configured on the HMC
interface. Once these devices are accessible, they are then available to
Linux and set online.

cio_ignore purge function should align with this functionality. But
currently, the subchannel associated with the offline-devices are not
unregistered during purge. Add an explicit subchannel-unregister function
in the purge_fn callback.

Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: 9daa5a879586 ("s390/cio: Update purge function to unregister the unused subchannels")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index c2ed91b69f079..70c5b85d2dfc9 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1327,6 +1327,7 @@ static int purge_fn(struct device *dev, void *data)
 {
 	struct ccw_device *cdev = to_ccwdev(dev);
 	struct ccw_dev_id *id = &cdev->private->dev_id;
+	struct subchannel *sch = to_subchannel(cdev->dev.parent);
 
 	spin_lock_irq(cdev->ccwlock);
 	if (is_blacklisted(id->ssid, id->devno) &&
@@ -1335,6 +1336,7 @@ static int purge_fn(struct device *dev, void *data)
 		CIO_MSG_EVENT(3, "ccw: purging 0.%x.%04x\n", id->ssid,
 			      id->devno);
 		ccw_device_sched_todo(cdev, CDEV_TODO_UNREG);
+		css_sched_sch_todo(sch, SCH_TODO_UNREG);
 		atomic_set(&cdev->private->onoff, 0);
 	}
 	spin_unlock_irq(cdev->ccwlock);
-- 
2.51.0



