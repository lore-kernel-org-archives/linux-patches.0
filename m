Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4866D515976;
	Wed, 30 Sep 2026 17:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790777; cv=none; b=bRGPOXBChWFyl+UrUee23H6gXDjt0zkPEYN9YZJZxH6flXlizQnHoM3U5LoaOGT/CE44/hFx75cQKB6S/4m1gn/AvfclQHAAydfUrdFVWb3QWOWzImZAKf8sTuzGXEBmoVlhuTD3/BPCOl9bunTS61CNLGdoc0FvaHoTNm5g3wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790777; c=relaxed/simple;
	bh=48H2Qb5tyZYZbA13lHNngOv1Jn+OrYjYJKS4wcWuVzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5QOmpdl4msrD0ISbPn7zx5gqDa8Yl8THY43m3Yij6Wm3ZPAf0VGu9pXpLsTTInjiQvqd3N9eYJdA3o9wXa0aMphjs833WFj4jQL4C5ASE/EO8XnudDCiQtD7l2mDEfDMwoY05gVVJE3joHjUxe9dcbHbmIfvM6BgK/DkcDgmrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odBCP5qA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odBCP5qA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B9C1F00898;
	Wed, 30 Sep 2026 17:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790776;
	bh=9qvo2JzdyPIAzJixX3673xBv5plQxJ4uPmKHdQ/16Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odBCP5qAC/uJRj7uSEoIWpTqRcoUnNhXbtbIYafcF2nidTGFa9Gp1WQaxo0DYUKW/
	 M0zmeWU7NXI0wg2svEZ51OQ/76bscX3rMnEm0lBj0h+/xIxkET7a3vRiOLG22jSpYF
	 gzGMnh6P5d6JD6uvy/O1RVqEjfHc39QHTlTdJnC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/752] thermal/drivers/tegra/soctherma: Switch to devm cooling device registration
Date: Wed, 30 Sep 2026 17:18:58 +0200
Message-ID: <20260930152359.636882406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 210325f92559e..36a4f421c7eaf 100644
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



