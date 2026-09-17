Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C4C4E36D6;
	Thu, 17 Sep 2026 17:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667266; cv=none; b=ofn45xkBKnf+oWtP5Ol7SpnXi3YtAqi4KwAIywzcn1rEKo8KVmiRpgarb9isnefgB2BAuWEaYPL2LrCgU9E4kQZukeMdB5GOnBkltjyEqUUn+vcT2VVj1SobUYKb7pjw2FNn+84OiAO+6pa4OcXUrhAy1GgGkkYbKS82f/3xG+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667266; c=relaxed/simple;
	bh=RGC33rmIsJ35MYSpHHxP6YIfEAhq9piR5BhqxZaO8QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZQdmFeyGKGsTYmzsu7rek6Wx27/Vk2B7hU6m4IOC5iEPqSdu/BiRJe4lbT8XPjvb8uuQR18YXufrLCux7Ukse3pxSHdUBj/nve0c2x1ZsoaouLh5aaAqmiluxz+ceV2byoTnIE4apoUiuQfDkQOjNFcE3ivm7d/quK61DTtw64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGTrY9x6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGTrY9x6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271401F000FF;
	Thu, 17 Sep 2026 17:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667265;
	bh=NWiN0lawo0k0wXMkb+DGfntNPLveOmaBropLTs3SXZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGTrY9x6Rg9Jcyh8UoggEna7FFdHEr9h0RR6VDO+p0t4jny/qxpVUsU3nGOl9KdCa
	 DcfAX4z3I3D6VOvwoCweT5SsdIlCzWv1a8R6JHb2ZEq0dPo5k6sdyCqcjVuwFvxVNU
	 e3rCOvDTseFbARBHMVD7Hk3Mw4tsGvbiYkO2Cugw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0034/1102] s390/cio: Purge based on the cdevs online status
Date: Thu, 17 Sep 2026 15:59:37 +0100
Message-ID: <20260917151540.297274632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 858a9e171351b..7e309ea2e177c 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1331,7 +1331,7 @@ static int purge_fn(struct subchannel *sch, void *data)
 
 	cdev = sch_get_cdev(sch);
 	if (cdev) {
-		if (cdev->private->state != DEV_STATE_OFFLINE)
+		if (cdev->online)
 			goto unlock;
 
 		if (atomic_cmpxchg(&cdev->private->onoff, 0, 1) != 0)
-- 
2.53.0



