Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5712F502576;
	Wed, 30 Sep 2026 16:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784047; cv=none; b=NUIZft1l6iH45LpLKPadSrL3g7nP/RQx8lVfF02C8IUZ00gceZ3aZI2O7Kfs7T8tGJNl+EqIJwqcuV8BcF1pReyUX79c6QHw3F5hKAW2uSD1cl2qanaFXk3Mf5tRp0T5nhv0nHODNsEAU/gkyh8EsrV+1D+a/4HVJFpaqpi+KPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784047; c=relaxed/simple;
	bh=vPzK1rXvc3lLHscayFqJBjXeQ2ps4GXnND4mhUZz5xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruO7cBvxE1nlPlAL7YGVFt75g8mYvSRzW3X7u+gE/DLEpFvvmB+Pdkng1YdgzBv2FubG+G/38SVLM/hzl03IyhRApGLRpgj7hyZjA/Hn0nlmtfUzQOrK6H4Qoo4+AY8oAXpHlfoCFJeYGCNI35yIrBcCZxNkXm5Ps4Mo87W15B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvkwEBfq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvkwEBfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6731F00893;
	Wed, 30 Sep 2026 16:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784042;
	bh=zdN1pwpo0HQMSihqyjNsvKFIdU2+cMxiLYRhhKSibGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvkwEBfqNzUvh2TbL1Dl33JKpMSxf6Z4m9JhuH5l4cFP4aWadHbLbYa2ICQctMbpT
	 OyonhZUiP0P6jCj+ATWJYZmTChNROoTtO4toBtT468O7f11Hr6Vy2WZJDllW23g1g8
	 HvQ3xz2Ig0tSMNgUMqqPDR4ToJcsuLTtQsvzsM9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/982] s390/cio: Purge based on the cdevs online status
Date: Wed, 30 Sep 2026 17:12:33 +0200
Message-ID: <20260930152417.157808223@linuxfoundation.org>
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

[ Upstream commit 58d50cad63e85daae032924ecc3d457fb1ec02fb ]

Ensure that all devices currently offline are purged correctly.

Previously, purging logic relied on the internal FSM state to
determine whether a device was offline. However, devices with a
target state of offline could be skipped if CIO internal
processing was still ongoing during the purge operation.

Update the purge decision logic to rely on the online variable
in the cdev structure instead of the internal FSM state,
providing a more reliable indication of actual device
availability.

Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 1873c865b4d6c..bfecf08aeb894 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1322,7 +1322,7 @@ static int purge_fn(struct subchannel *sch, void *data)
 
 	cdev = sch_get_cdev(sch);
 	if (cdev) {
-		if (cdev->private->state != DEV_STATE_OFFLINE)
+		if (cdev->online)
 			goto unlock;
 
 		if (atomic_cmpxchg(&cdev->private->onoff, 0, 1) != 0)
-- 
2.53.0



