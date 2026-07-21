Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779F238399A;
	Tue, 21 Jul 2026 17:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653784; cv=none; b=YmiGxh1wsI2C6AwEiGBxbPFJZ4gV6EdviEcBBGb5GuLsVptw49OX8TYK3B7Eq8mSsPd6/Mi64SawlT3H9Lx9QaXNF098n4iM+2JKC6EZtm7FzrFkqIfmkSpngzrPnDhAGoiEx6GwFRQ0Sst4gcsbnGg5v4f/bymu+a/Sz5SNVnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653784; c=relaxed/simple;
	bh=09xn4fp0FYkrRCUJaoSiPa9oz5Ec4dqoiuAjbV9vuUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VJzpOEWMYDVuigjn+HP5WXZukjd95sW/iiOPpPYT0PhlqI2tzPFnYje3zVCqUPjfpNqi+e4uXn40LhhWdJh84IW1bwJIf4RrpWf3Ba0cmcyWR2Fz52/wDt5n+P/Ba8t+JMwrI7kWoUpsvQEvoPLvXIXMIKzRfgURpQ8o4ZrnkXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvVoVGr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvVoVGr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3AE1F000E9;
	Tue, 21 Jul 2026 17:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653782;
	bh=yBz1v+Oemp/tyC+ArVXqoREDdHU2Sk95ZN5oVSRY/z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvVoVGr+FWOW7zSjIdVX+jFB9xCNWM+Ab/9MxSt2Q0i6ymFupCjCNbTrYrFtzsGyN
	 k199rJYmnUoTeN9Sq1usOz5GNlhqmDRr3RKHawNEZNDFq0QXjuX3oT+psVfhjfhJvw
	 v5GbM/0m63dxAGVus1RlXvaCNjTLwqd94kb+82w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Mingyou Chen <qby140326@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1430/2077] platform/x86: bitland-mifs-wmi: Fix NULL pointer dereference during suspend/resume
Date: Tue, 21 Jul 2026 17:18:23 +0200
Message-ID: <20260721152626.536743586@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingyou Chen <qby140326@gmail.com>

[ Upstream commit d3666875c75eb1bc8090343fa0d6fc8fb7924356 ]

The driver registers two distinct WMI devices: a control device
(BITLAND_WMI_CONTROL) and an event device (BITLAND_WMI_EVENT). During
the probe phase, the event device handling path returns early before
initializing the platform profile device (data->pp_dev), leaving it
NULL.

However, the PM sleep operations are registered globally for the WMI
driver and are triggered for both devices. When entering suspend, the
event device invokes bitland_mifs_wmi_suspend(), which passes the
uninitialized data->pp_dev (NULL) into laptop_profile_get(). This leads
to a NULL pointer dereference inside dev_get_drvdata(), causing a
kernel Oops and halting the suspend sequence.

Fix this by adding a validity check for data->pp_dev in both the suspend
and resume callbacks, safely skipping profile operations for the event
device.

Fixes: dc1ec4fa86b2 ("platform/x86: bitland-mifs-wmi: Add new Bitland MIFS WMI driver")
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Mingyou Chen <qby140326@gmail.com>
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260701120140.430659-1-qby140326@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/bitland-mifs-wmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/bitland-mifs-wmi.c b/drivers/platform/x86/bitland-mifs-wmi.c
index b0d06a80e89ef0..3a373184519da4 100644
--- a/drivers/platform/x86/bitland-mifs-wmi.c
+++ b/drivers/platform/x86/bitland-mifs-wmi.c
@@ -300,6 +300,10 @@ static int bitland_mifs_wmi_suspend(struct device *dev)
 	enum platform_profile_option profile;
 	int ret;
 
+	/* Skip event device */
+	if (!data->pp_dev)
+		return 0;
+
 	ret = laptop_profile_get(data->pp_dev, &profile);
 	if (ret == 0)
 		data->saved_profile = profile;
@@ -311,6 +315,10 @@ static int bitland_mifs_wmi_resume(struct device *dev)
 {
 	struct bitland_mifs_wmi_data *data = dev_get_drvdata(dev);
 
+	/* Skip event device */
+	if (!data->pp_dev)
+		return 0;
+
 	dev_dbg(dev, "Resuming, restoring profile %d\n", data->saved_profile);
 	return laptop_profile_set(dev, data->saved_profile);
 }
-- 
2.53.0



