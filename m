Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8B73A2AE1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302662; cv=none; b=tEkMPPoquhGZ2lQb+pzRi260CjeIkGyCveFUjQY4K0iv+F30rKee102ngxI4bm/uBq23yW/wNZkdmNv26lI1ME+BURSZMt2V6VJS16MHklTvn8SBEOCM3BAK5jYEasgg4S8UKrDOAcTpyyipEmTTRswvDCzvyHWFRGFnslCOYZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302662; c=relaxed/simple;
	bh=RqrSODPnvHSSiSnaD0J/ScbTY7VbAf9Td8X/W893ycs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiyqzwrZTHGW7sJm0fgUvFO/kLwaTK6d00gJuK75JwqInQT71FOXvpIPXusb7xx2td/7bDZyOFG/HkIwt8wnh9UMfS3XwWX2SkITVDdWnngb5C/NYxpvoVd3ogMPUH5BkYtWONsY1P1CfFmUDhJ4CxrYyUpuz1RYxEOyhCtF/6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lJStz1oB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJStz1oB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44877C116D0;
	Sat, 28 Feb 2026 18:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302661;
	bh=RqrSODPnvHSSiSnaD0J/ScbTY7VbAf9Td8X/W893ycs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJStz1oBMmYqr6Gz1cBX4DN7wSUq9lcSwNKg62utChpIG0sfGdmw8Eo/amUwZbqdc
	 ZBW1rtaltVPwqbAuOfuxtsR7wpkteHROygJ9jZOxtUce6plWUe4l588oetPJoqahpM
	 eRiHobAYKIZWBHuQ2ZAVbgLJBTkHnhkBEOyjEY6cOf509sW8wXlSTHpvEqMg2cvuSx
	 EsJZpPZJgNCMaaSZg2WubDrpxd5o5Xr1Ay9RpHjzoaNMYN20H21J+Y1maVUMhM1jB0
	 lF+tFAqh3KqhvHHs8hQz0Dvif8f7cBs4B9hKENZ99RKFAgccKxU1cnAvHc4yqSpvhz
	 tOAK920Ygb01w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Billy Tsai <billy_tsai@aspeedtech.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/147] i3c: Move device name assignment after i3c_bus_init
Date: Sat, 28 Feb 2026 13:15:14 -0500
Message-ID: <20260228181736.1605592-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 1f4a7902ec4ea..e47cfef8c9920 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2539,12 +2539,13 @@ int i3c_master_register(struct i3c_master_controller *master,
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

