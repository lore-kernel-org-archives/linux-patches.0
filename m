Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5515F4F55B5;
	Wed, 30 Sep 2026 15:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782496; cv=none; b=jm6rCQxQ2M8FiBYl09/BFQQsbxccRVxbLhszwm05LaS6ch8jtUc+9hu6uTzlnS33Tb+EISd0k0/o0QWMRWpAhLeruwRKxnb3GHbBICRU2wazSM5p5fWRKfqCXPyrVB2/+DS/I9LpNGrk/7vSC3e3cPiR1MdDblBYtpjA7gjR/lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782496; c=relaxed/simple;
	bh=cb/9gBbzOqoqNqTPzy2dOSek5zXDpK5pVvfFkv4RXt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rC5k/F3VbxMdWhPn1SWhtKqdj6c2JDr2S9aOp2VO11hnPU1IkdOtLpTPFJ8KGETZOiSQEJ0YATa9D/Ol/z/9YBO2gpjTaIaFGrRypo4pUHRFeaC5iiSWHccK+7YUAuld4lFQDuo9ECNa9oOqhKsoADMVFtx7vnjyCJoQfDweyHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpNdG56+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpNdG56+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBD41F0089A;
	Wed, 30 Sep 2026 15:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782484;
	bh=WcdytP2Nn5jC7dIYvEDxd0J7rRlJDY0iVZicT+HLsKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpNdG56+K535FBm88x/KnpnPniYVb+FIdtYZOn4gwqHZl43vVvySoYgprSHLSDy6Z
	 ZXSj0nmxkUkVUSqVnSN4+/D6ybpHk7c1xPfOBTCt/pTN2NMfkMtUdW42ouQTTRZ3CY
	 O10c9RqQ6+1vE5Bsnfk2ch6kEP7s9kKAuIl5N6JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/595] thermal/drivers/tegra/soctherma: Switch to devm cooling device registration
Date: Wed, 30 Sep 2026 17:19:14 +0200
Message-ID: <20260930152349.047884498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>

[ Upstream commit ee126267bc04bfb03816ae9d71ca24c5bf99e739 ]

Use devm_thermal_of_cooling_device_register() to simplify resource
management and avoid manual cleanup in error paths.

As a side effect this change has the benefit of solving an existing
issue. Before, the function tegra_soctherm_remove() only called
debugfs_remove_recursive() and never called thermal_cooling_device_unregister()
for any of the cooling devices registered here.

After the driver removal, the thermal framework's cdev list would
still hold references to thermal_cooling_device objects whose devdata
pointer (ts) pointed to memory already freed by the platform device's
devm cleanup.

With this change, the cooling device is unregistered when the driver
is removed, thus fixing the issue above.

Signed-off-by: Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/20260424160019.41710-2-daniel.lezcano@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/tegra/soctherm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/tegra/soctherm.c b/drivers/thermal/tegra/soctherm.c
index 66e0639da4bf2..7bb75fdde4ed0 100644
--- a/drivers/thermal/tegra/soctherm.c
+++ b/drivers/thermal/tegra/soctherm.c
@@ -1737,9 +1737,9 @@ static void soctherm_init_hw_throt_cdev(struct platform_device *pdev)
 			stc->init = true;
 		} else {
 
-			tcd = thermal_of_cooling_device_register(np_stcc,
-							 (char *)name, ts,
-							 &throt_cooling_ops);
+			tcd = devm_thermal_of_cooling_device_register(dev, np_stcc,
+								      (char *)name, ts,
+								      &throt_cooling_ops);
 			if (IS_ERR_OR_NULL(tcd)) {
 				dev_err(dev,
 					"throttle-cfg: %s: failed to register cooling device\n",
-- 
2.53.0



