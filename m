Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6DC1C10
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqrsfL7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2153C433C7;
	Mon, 23 Oct 2023 11:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061280;
	bh=l3F/tDcw4HGDn8SlOzCLarPRvD5/wuvkI+XIHA+rk7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqrsfL7V5cgxnDtQ8maZE3o/L9ekYQD14dNJUT/p8lUjeSCE1dHqQZMOEvnDA1AI+
	 081Gax3But/CXHTx5vpS4mEyjH1d73gQXJvQX4ZEe0XgigXoP2dP/qXYmmtLSIY/zB
	 yDKq/zHOeHXzwpjDdKSu2kCfxPQ6ffTRYzaANlrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Merlijn Wajer <merlijn@wizzup.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	Pavel Machek <pavel@ucw.cz>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Tony Lindgren <tony@atomide.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/137] phy: mapphone-mdm6600: Fix runtime disable on probe
Date: Mon, 23 Oct 2023 12:58:09 +0200
Message-ID: <20231023104825.145218977@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 719606154c7033c068a5d4c1dc5f9163b814b3c8 ]

Commit d644e0d79829 ("phy: mapphone-mdm6600: Fix PM error handling in
phy_mdm6600_probe") caused a regression where we now unconditionally
disable runtime PM at the end of the probe while it is only needed on
errors.

Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Miaoqian Lin <linmq006@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Fixes: d644e0d79829 ("phy: mapphone-mdm6600: Fix PM error handling in phy_mdm6600_probe")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20230913060433.48373-1-tony@atomide.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/motorola/phy-mapphone-mdm6600.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/motorola/phy-mapphone-mdm6600.c b/drivers/phy/motorola/phy-mapphone-mdm6600.c
index 3cd4d51c247c3..436b5ab6dc6d5 100644
--- a/drivers/phy/motorola/phy-mapphone-mdm6600.c
+++ b/drivers/phy/motorola/phy-mapphone-mdm6600.c
@@ -627,10 +627,12 @@ static int phy_mdm6600_probe(struct platform_device *pdev)
 	pm_runtime_put_autosuspend(ddata->dev);
 
 cleanup:
-	if (error < 0)
+	if (error < 0) {
 		phy_mdm6600_device_power_off(ddata);
-	pm_runtime_disable(ddata->dev);
-	pm_runtime_dont_use_autosuspend(ddata->dev);
+		pm_runtime_disable(ddata->dev);
+		pm_runtime_dont_use_autosuspend(ddata->dev);
+	}
+
 	return error;
 }
 
-- 
2.42.0



