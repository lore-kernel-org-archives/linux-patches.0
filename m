Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247C6355808;
	Tue, 16 Dec 2025 12:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887265; cv=none; b=DWX4cwoXppsYP6A/DNyy2zAIguDUOwePM46ueaVB0KI+zcAJKc1F6mB3kpgXUuXdrARr4Od9d1MKINpjV8gkx6NPm8eENigP5Giw1Q6BIVWtHUEXujXTfo31hrlNVcE1oU35rXsVF0rioc5WRU6IDjj7LbA9p8LJ5JgkPDzM1u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887265; c=relaxed/simple;
	bh=Hth0uIq+5qKOoFZTzNePkFpsCxyV+D7bjV76mynB8UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7U1B0V+xZmOCe/sgH7DclfjMmXTnpPWrF2XzffmDyxcDJRTsYw1lZguRZlyI63m8mj3+0CIPDrdtStNdjq/QS2WPt1FtDT361AqRZAqKplfwfzBdxAtaahmhbGO9FKT2iuecbnLeN0I5g7TXOZqoCE1F5XL/EIsZDykdElt+G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEurKS8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEurKS8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDA9C19424;
	Tue, 16 Dec 2025 12:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887264;
	bh=Hth0uIq+5qKOoFZTzNePkFpsCxyV+D7bjV76mynB8UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEurKS8OTM6KbELU++gJ6zWPNlewydyThChiuhglnojR+z4HI89H1Jel7zfyngR0O
	 coP1n8fzbL/ikcsSIt88KDJA1eVfVLjRX1tGck9iuwq3EKCp3mK1z0XVBdH4ld0tbI
	 Um9PgI82+ert0Pxw0yIh92/l14wiZNLuC+i75ETs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 178/614] power: supply: rt5033_charger: Fix device node reference leaks
Date: Tue, 16 Dec 2025 12:09:05 +0100
Message-ID: <20251216111407.822549361@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 6cdc4d488c2f3a61174bfba4e8cc4ac92c219258 ]

The device node pointers `np_conn` and `np_edev`, obtained from
of_parse_phandle() and of_get_parent() respectively, are not released.
This results in a reference count leak.

Add of_node_put() calls after the last use of these device nodes to
properly release their references and fix the leaks.

Fixes: 8242336dc8a8 ("power: supply: rt5033_charger: Add cable detection and USB OTG supply")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20250929113234.1726-1-vulab@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt5033_charger.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/power/supply/rt5033_charger.c b/drivers/power/supply/rt5033_charger.c
index 2fdc584397075..de724f23e453b 100644
--- a/drivers/power/supply/rt5033_charger.c
+++ b/drivers/power/supply/rt5033_charger.c
@@ -701,6 +701,8 @@ static int rt5033_charger_probe(struct platform_device *pdev)
 	np_conn = of_parse_phandle(pdev->dev.of_node, "richtek,usb-connector", 0);
 	np_edev = of_get_parent(np_conn);
 	charger->edev = extcon_find_edev_by_node(np_edev);
+	of_node_put(np_edev);
+	of_node_put(np_conn);
 	if (IS_ERR(charger->edev)) {
 		dev_warn(charger->dev, "no extcon device found in device-tree\n");
 		goto out;
-- 
2.51.0



