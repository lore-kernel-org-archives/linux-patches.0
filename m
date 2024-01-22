Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA57B2581;
	Tue, 23 Jan 2024 00:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969596; cv=none; b=J07shCu9veTdbp7S5qPZXtRj9KErVXpUwv9pQKx7f2actvreamkBbscf5R4nW64RnS46LNfuAFa62i5+mxfPhcw69zg3tuYypREwgl3pqcQSM4SEVdchoDdsG+fdUGgcTdfDzzwCUZoxH4S7lYp7bvwt80g0SGAvhUagSIzZ/CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969596; c=relaxed/simple;
	bh=oQAc6/xZuERuMnDysxF/DdSO8T1WxuAVlowAI7tOOSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/aQsZynkJGK9/XkE+TqoKDlRiWv8Kb2/Rot+3VEhrZEZyUX/TnMtF9eJll+BeSYIubzJS2EfmUjkIXfXhWgY23tudpaSDTCnkO3feUGay9jX/S5Npulbn/UjG83FbEn7bAz/0/+Fb5I659QCEclvek7cBREa5V0qne6R7vDxNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RcRqdF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RcRqdF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E880C43390;
	Tue, 23 Jan 2024 00:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969596;
	bh=oQAc6/xZuERuMnDysxF/DdSO8T1WxuAVlowAI7tOOSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RcRqdF7wzosO83AKbwq6Aem2WN81SdCpxmEjtd+hTuxrIsUJOqUvnYuHdhG+LjeJ
	 J7n048lJN6swNwC9YlO2qC32W37Q/yOGpSbjANbgMzB7HCPuhp+C6B6nvvIaVPqVWG
	 kITj0r3mV6beZWEPRAVQwVXmk6KrHZOSQ2xUEXmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 323/641] media: i2c: mt9m114: use fsleep() in place of udelay()
Date: Mon, 22 Jan 2024 15:53:47 -0800
Message-ID: <20240122235828.001224639@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 02d4e62ae2452c83e4a3e279b8e4cb4dcbad4b31 ]

With clang-16, building without COMMON_CLK triggers a range check on
udelay() because of a constant division-by-zero calculation:

ld.lld: error: undefined symbol: __bad_udelay
>>> referenced by mt9m114.c
>>>               drivers/media/i2c/mt9m114.o:(mt9m114_power_on) in archive vmlinux.a

In this configuration, the driver already fails to probe, before
this function gets called, so it's enough to suppress the assertion.

Do this by using fsleep(), which turns long delays into sleep() calls
in place of the link failure.

This is probably a good idea regardless to avoid overly long dynamic
udelay() calls on a slow clock.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Fixes: 24d756e914fc ("media: i2c: Add driver for onsemi MT9M114 camera sensor")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/mt9m114.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9m114.c b/drivers/media/i2c/mt9m114.c
index ac19078ceda3..1a535c098ded 100644
--- a/drivers/media/i2c/mt9m114.c
+++ b/drivers/media/i2c/mt9m114.c
@@ -2112,7 +2112,7 @@ static int mt9m114_power_on(struct mt9m114 *sensor)
 		duration = DIV_ROUND_UP(2 * 50 * 1000000, freq);
 
 		gpiod_set_value(sensor->reset, 1);
-		udelay(duration);
+		fsleep(duration);
 		gpiod_set_value(sensor->reset, 0);
 	} else {
 		/*
-- 
2.43.0



