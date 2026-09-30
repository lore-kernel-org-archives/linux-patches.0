Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E973B309EF2;
	Wed, 30 Sep 2026 18:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794272; cv=none; b=XY3OS9xjwxDaaqfLp1YSCZ4Hm8uxyjV9RNSyfGaVj24rqRVDeUjcFbaPomCv/7p5cV9D1ITxck31Td7ZuBvTUSsqQ05PsVK67wuB2NrzVRQfD0M5wRYzp35+bMgwhsVuzwIbPNnpsbUpiD2MAETu4OwSDn8tafcoVt8+877qjb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794272; c=relaxed/simple;
	bh=UeXQxrZQrMpF4rOs3hAdyw2K+U0YUTCiUqOKD0hay8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgpBTt9jJkLyuFfBAuA1fOx0xzxbJ9k6w+6mZQA98xKgmFQo8hc7/wkztbCdOhQu5cwGg47F29cxWe0BxW3vw9HcB/wOsUpbZJgLxWFjil77fSg5ZVi/hMfAN5EuMLFZLfPa5lAzcpCTuVthIS8S0tFo1oH6Pt9DWEBAp6TOW9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWIefhGO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWIefhGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500911F000FF;
	Wed, 30 Sep 2026 18:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794270;
	bh=Z/87fCRiTA9nii6e1RswX2ul805khFlRukEGP9L9sHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kWIefhGOCw9OlTtT77TYOS7uP3HtZYWaO03CUjFes9zajBzxEtCARvN+VwMig55W2
	 wy59/tnfE1EVrxhVm7H1lNCi+zR6fvpf69v4MFf57WapYXUl6dXHP7YRSmf8W/nokb
	 pAxwo89gcc4gWxINS3pk9FtGeegkzMYDQsD/3L1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0107/1193] thermal/drivers/tegra/soctherma: Switch to devm cooling device registration
Date: Wed, 30 Sep 2026 17:13:11 +0200
Message-ID: <20260930152436.608690406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ea66cba09e569..ad0cace829b2e 100644
--- a/drivers/thermal/tegra/soctherm.c
+++ b/drivers/thermal/tegra/soctherm.c
@@ -1699,9 +1699,9 @@ static void soctherm_init_hw_throt_cdev(struct platform_device *pdev)
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



