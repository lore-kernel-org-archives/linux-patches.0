Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765C84D5A1;
	Sat, 12 Sep 2026 07:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198520; cv=none; b=lz8PcvnaZD/rskYiHMyHnmNxzQBOVxDuuWGDqJP+1YmT9Z+O535ANeE6RcLv7CUon1Y65Sxqbrz7IAR/ELvLu9pg2KyWyCmAsjvorzGVFKx47sTyyZc4imrcYFEx40/exgXyubCtxuUP19DMH5jHEJWuYE4PI+GIHCNCXey6nDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198520; c=relaxed/simple;
	bh=3t4IF/3DksUn84RWv4GC7yQdSUaRJBQymI0//eCRLnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwXHU1Lpzb/L76OiBcgpkrlqzO6Lzji4ehJ4uz6NcPIFmDWTygAtrzumqvde7xK6DPZTd2YYi7ZLtNUUeToF8t037E/5NXwUGH/W9iA9tmn200JuzFBevZorIx8VvlG3N32DA1SVw4xijhciNHT9BahT8W9EUA9QesJhzer5SHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGTM0apt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGTM0apt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53FF1F000FF;
	Sat, 12 Sep 2026 07:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198519;
	bh=Qh8WqknJeGhqWvOGCwaSLZLKv1cJEgexQ7n7XQ/492E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GGTM0apt5gCbf78NGzAS+TBqkBJ1C1sN3CM49W0t+kfhQ3YeaRBaoxgsK0N0wPcV/
	 vxUWupVXsyU2jsmmt7J93tmbV7a0gLZ5Im0/Nf4pJA53aaobBJBfd/Y0mA1TMDZjQb
	 vGcbvn67Y5Gh9C5P53PwrNrmJIFy5nf3GiCFXSlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0396/1815] firmware: arm_scmi: Clean up channels on setup failure
Date: Sat, 12 Sep 2026 08:35:46 +0200
Message-ID: <20260912065658.192031428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 687d67be3d87894ef12e8a164434612e0b53cfae ]

scmi_channels_setup() can fail after the common BASE channel or earlier
protocol channels have already been registered in the TX/RX IDRs.

Route this failure through the existing channel cleanup label so the
transport channels, transport devices and IDR state created before the
failure are released before the probe error path frees the SCMI instance
ID.

Fixes: 05a2801d8b90 ("firmware: arm_scmi: Use dedicated devices to initialize channels")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-4-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index ec373595f9557..d2af47d03b4bb 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -3263,7 +3263,7 @@ static int scmi_probe(struct platform_device *pdev)
 	ret = scmi_channels_setup(info);
 	if (ret) {
 		err_str = "failed to setup channels\n";
-		goto clear_ida;
+		goto clear_txrx_setup;
 	}
 
 	ret = bus_register_notifier(&scmi_bus_type, &info->bus_nb);
@@ -3379,7 +3379,6 @@ static int scmi_probe(struct platform_device *pdev)
 	scmi_notification_quiesce(&info->handle);
 	scmi_cleanup_txrx_channels(info);
 	scmi_notification_exit(&info->handle);
-clear_ida:
 	ida_free(&scmi_id, info->id);
 
 out_err:
-- 
2.53.0



