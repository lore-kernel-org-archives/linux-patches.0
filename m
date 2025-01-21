Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060981F0E36;
	Tue, 21 Jan 2025 18:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482620; cv=none; b=Scm8w915xk/rn7RizKXUpyTGwJY9velCAxGIQJWRwXn4FILMTDdold4SPsUKcInmR+GVxG9IH0wWL2YEIiPvGwelJNftjVQo9BAqTrumF4qVGHsE//UMUVJ59HsURtYIzteflxNl5byugQ26tgT/90myZnl4Tn1Gon/3HTJD0+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482620; c=relaxed/simple;
	bh=qv6zUguRZ/0WG7qJWvk//ckyW5cUNvHoRyGwrghbpAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G87Gp+A5mn/A6bxJeLFJBDNWZP0WengIyUS44xQpZ3j1opxhjkLGG4HMXZ3FtdEcvtPEsuxtWy62sb1SK5HyyXsJMhOWl5oClgitSS73p/935W9uwTkB80bs6SrdJCHCf9SMy/BehRIt/3SE2C/80IdH9iG9BVSsh9iOb14cSgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zo1Gy9Z/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zo1Gy9Z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DDAC4CEE3;
	Tue, 21 Jan 2025 18:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482618;
	bh=qv6zUguRZ/0WG7qJWvk//ckyW5cUNvHoRyGwrghbpAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zo1Gy9Z/PVUI/odjflnKOrCegSt0nuZCGPsiC0LVDizPdQc3i20SARBa8sLwhwPVt
	 pNnumy/YVYsXqh1fAiVg9p6C8VPkEm4AnwvEDjdEzcKbKV1wMoF5vYsE3WmgaEXbdx
	 U9w7hgbjJehuXgV9BYeutYHA191roVTcTtzFdGuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 16/64] i2c: mux: demux-pinctrl: check initial mux selection, too
Date: Tue, 21 Jan 2025 18:52:15 +0100
Message-ID: <20250121174522.179002150@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit ca89f73394daf92779ddaa37b42956f4953f3941 ]

When misconfigured, the initial setup of the current mux channel can
fail, too. It must be checked as well.

Fixes: 50a5ba876908 ("i2c: mux: demux-pinctrl: add driver")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/muxes/i2c-demux-pinctrl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/muxes/i2c-demux-pinctrl.c b/drivers/i2c/muxes/i2c-demux-pinctrl.c
index 45a3f7e7b3f68..cea057704c00c 100644
--- a/drivers/i2c/muxes/i2c-demux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-demux-pinctrl.c
@@ -261,7 +261,9 @@ static int i2c_demux_pinctrl_probe(struct platform_device *pdev)
 	pm_runtime_no_callbacks(&pdev->dev);
 
 	/* switch to first parent as active master */
-	i2c_demux_activate_master(priv, 0);
+	err = i2c_demux_activate_master(priv, 0);
+	if (err)
+		goto err_rollback;
 
 	err = device_create_file(&pdev->dev, &dev_attr_available_masters);
 	if (err)
-- 
2.39.5



