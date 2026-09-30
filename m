Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED364F4CFB;
	Wed, 30 Sep 2026 16:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784256; cv=none; b=BG095bAZ28BTpFJxY0bEAdLILyxnC3Tfy8gtdJ03MDI0iulLwHtFctR4vUzOG91LpAZqo7X9JIWrCTIRIF1vgs6FoZoSa28HGtapcfMpzIRBvN3g65BdUE3pzu4GKj+lK4DPotUX75NKH6HyE4MbVdGtOa8yQGAUAT1wNkqanQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784256; c=relaxed/simple;
	bh=mMvAt69sJ6WEbRDdR1NRhObgaMKq3HnbFFOS0UD4tS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTzqx99oE2JIkSM4F1VerkSgZ/t3hexvsqoHmPUAyLJYvcV1KNA1ERjHLNiGS5JrcQ7GzCL365ToH5Xp6oPqCb7ptNqDwGcMH7hlN5iuRouKtTpj+kR80AlGmqOPK/ZZvVc6sgXchQ68b+yIwI039Fh8iB945p7Iji3RPCNi5EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pImRmRA6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pImRmRA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7D31F000FF;
	Wed, 30 Sep 2026 16:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784252;
	bh=Z5rZ9lhFllxrAPOjri6TvuFwgCz90uW+j4BkO1jH4ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pImRmRA6h6Xrpp6/5kvAncKVHTIeEy7QoWhrJMK+CZRoAnKEe5eFm8IULPWbdXieL
	 THQQHyks1x2SXim9DGB5lcvrC4GQ4TOMKvcg1o+6Cs1/N4D6S4USWaL29y8VnTehHB
	 V147ZMB1+XSQwVLO+2b4hUYtMoiJUa0C7bdjpKHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/982] thermal/drivers/tegra/soctherma: Switch to devm cooling device registration
Date: Wed, 30 Sep 2026 17:13:46 +0200
Message-ID: <20260930152418.744104592@linuxfoundation.org>
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
index 1efe470f31e9a..0af9958073ffb 100644
--- a/drivers/thermal/tegra/soctherm.c
+++ b/drivers/thermal/tegra/soctherm.c
@@ -1704,9 +1704,9 @@ static void soctherm_init_hw_throt_cdev(struct platform_device *pdev)
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



