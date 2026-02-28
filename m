Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5731C36C9F9
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302511; cv=none; b=kHSeTtrrHvGJ18WRVcwJbRxBYMn6Gb4cwF+/6/yHWT1mePoNzErE8E7Fof5VPEuO7eNSZM+fflufgi7L91z4pAlFynjZipeYJcvxBbIcF+l7XjKlPZly4AVvZiuGDhZZ9i1WqMsdcKPeUlB22Iobax86UJ7pXJeBAU0eQgkhKEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302511; c=relaxed/simple;
	bh=mHJmrwaxZINKHNRls8CI9EabtQtlulthJxcKpg3Gjls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXR5zWEGJp2oHHr1RJpeLMW0dhjUFqbSeDzL9JYf2DgBBMpNJpsIYiDO7Lij8I1B/Cu59KAdyAZ2yTSph4+oVAde5b2hX8vgHIIPPbdZDRfK+ugPVUGohAuAGZrUQa45G+9YmW4iL59vmxoMlWxg3AnuGmfXt9KPv/NzxWAQIXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rTJH+1KL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rTJH+1KL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D44C116D0;
	Sat, 28 Feb 2026 18:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302511;
	bh=mHJmrwaxZINKHNRls8CI9EabtQtlulthJxcKpg3Gjls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTJH+1KLYLB4kasxsys5dDp99tAwtec6wTzSTx22zaL3i15oL+hPOuptvE7lXL2Gs
	 GUxwGk4XTRyrLCMHC6XDJ66mLn8Kv8VM7Uo5K6KMWrCMyBbmYnFZABErkCsFc3ROBf
	 glW8c2XVE2pvMxHPA03EAsxMgYwEqDgHRIq26SP0FIX1NwWDzgdvWd0Nu2QinZDWFu
	 hP/46dWNxxNh9eYJDL7LyOKoC/C4J6htpT7kWzKoUDaiSLfgbNunhxxpqWcAXnpWsm
	 LGlNE/KKsndJhsDnWRgMcqtqoldIIuBLGJ6gorIhXGiLLq0u33vm6ZBdn78/zfE1uA
	 EPCPaPcGCJqjg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Billy Tsai <billy_tsai@aspeedtech.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/164] i3c: Move device name assignment after i3c_bus_init
Date: Sat, 28 Feb 2026 13:12:25 -0500
Message-ID: <20260228181505.1600663-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit 3502cea99c7ceb331458cbd34ef6792c83144687 ]

Move device name initialization to occur after i3c_bus_init()
so that i3cbus->id is guaranteed to be assigned before it is used.

Fixes: 9d4f219807d5 ("i3c: fix refcount inconsistency in i3c_master_register")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260112-upstream_i3c_fix-v1-1-cbbf2cb71809@aspeedtech.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index a99c727a23042..dee694024f280 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2497,12 +2497,13 @@ int i3c_master_register(struct i3c_master_controller *master,
 	INIT_LIST_HEAD(&master->boardinfo.i3c);
 
 	device_initialize(&master->dev);
-	dev_set_name(&master->dev, "i3c-%d", i3cbus->id);
 
 	ret = i3c_bus_init(i3cbus);
 	if (ret)
 		goto err_put_dev;
 
+	dev_set_name(&master->dev, "i3c-%d", i3cbus->id);
+
 	ret = of_populate_i3c_bus(master);
 	if (ret)
 		goto err_put_dev;
-- 
2.51.0

