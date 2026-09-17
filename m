Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30A24C10EE;
	Thu, 17 Sep 2026 16:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661011; cv=none; b=iAjj6YY2yE+4FO0Ucs/xeyK/zK0NLMC9hm4REbViiIAQzj5+PbdbNylUWxj2JVortp842+RjU7eZHshkhxjJ5W5yCHtcvLcxETAAzhx9cCjfZ2qp1APuXM2dQ7RbnqCfAf/HeVsvmUikqA9F9JiOD9LET1ZxXpymBsKJADoBjd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661011; c=relaxed/simple;
	bh=2FL9D62MA6WdVZenrAtAJLMuMhI8dn07YNAyKI5MfRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6b4xxq5TxfEYoxuKfR+ij7etlQmj01JD+siodTUJ4ZEq68DCetk7YRDmNzaNd4/tS+ScuEVH3AucG0RVIAXDMod2bFG8Jh2jYWG3Pt4UwuPFAP65i2cUdyAMiWk6EhN0i3GL6NPI1cQYd88/xOJbWcC9T75fL2LlMtef8in9oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktuhN750; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktuhN750"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9511F000FF;
	Thu, 17 Sep 2026 16:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661009;
	bh=0TlvoF2nqMH5/IRefZrSI1nj5TnlhQNPmBE6iHJ8s7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ktuhN750Z543fazi/o/MLHrzXDsgLfl1p/50u2qbP98MPveqXpNLgDqNAhS/UqaLk
	 Cvhm8OLsYRIuvxSZrijTnEQTKrJhoA5ADlFo3UR2fYgsVHxUL2MhI/uESll1Y5EPfw
	 jaklErfVB3cTCqywANYuIwdBYBWkx99ziWKFPkps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0052/1250] s390/cio: Purge based on the cdevs online status
Date: Thu, 17 Sep 2026 15:57:27 +0100
Message-ID: <20260917151553.347442437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4b2dae6eb3760..7f8f78b1f8aea 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1329,7 +1329,7 @@ static int purge_fn(struct subchannel *sch, void *data)
 
 	cdev = sch_get_cdev(sch);
 	if (cdev) {
-		if (cdev->private->state != DEV_STATE_OFFLINE)
+		if (cdev->online)
 			goto unlock;
 
 		if (atomic_cmpxchg(&cdev->private->onoff, 0, 1) != 0)
-- 
2.53.0



