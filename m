Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48126310650;
	Mon, 13 Oct 2025 15:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369007; cv=none; b=MKY8KK8nY08AnzHBUIhhAaOXPppyDBAF46r6vZWlWEumFZWNLa/miuAV6yLTu3w/aN+byoTrvoBxDdGiYYc2VG+L4k4pnpXN+GKZIaiY98BYBHJrxyO+Kb8UW6xqM8pRVQi8CF1tQ0XgZHCon4k3tD+gFSwrmh5sXVanoj+5YAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369007; c=relaxed/simple;
	bh=9JywpnzZXaa/49m8N1gmf85DylaKj3cAiFpfJa68gcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UyneaRZI4tFXaXsErSUM2eRE92WJSWm/wcFIlsXvmu77XPEmtRtWLPu+B7im7/DHpigJzvWwC2TN0psPD3W7RvkiEUt/URzw7x9sOYJL4jOy3UJwo4NCcus7T78soCB3LCZYt66tk3ob/ajCXAXAdzIREl1R6WF4+msy1CXrOdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmGGnOQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmGGnOQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDFAC4CEFE;
	Mon, 13 Oct 2025 15:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369006;
	bh=9JywpnzZXaa/49m8N1gmf85DylaKj3cAiFpfJa68gcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmGGnOQ2Ir3HOT2Gtjof9eae7saidmoGMzBTYnkN9/o7m99Mcxq715cY2aKoY1l3G
	 095zI6PVo/T9zVc76Pw8oVKcMM/Law8I9W8LYT9/w1PWhY0vhr6g6aXNmC1vebZzjB
	 +AzWOmQV7ek3XCaY59QKbjYuMPOaGLA67JQF+I7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Bao <len.bao@gmx.us>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 052/563] leds: max77705: Function return instead of variable assignment
Date: Mon, 13 Oct 2025 16:38:33 +0200
Message-ID: <20251013144413.177029267@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Bao <len.bao@gmx.us>

[ Upstream commit 6e3779e3c6f9dcc9267bf98bef70773a0b13dcbb ]

Coverity noticed that assigning value -EINVAL to 'ret' in the if
statement is useless because 'ret' is overwritten a few lines later.
However, after inspect the code, this warning reveals that we need to
return -EINVAL instead of the variable assignment. So, fix it.

Coverity-id: 1646104
Fixes: aebb5fc9a0d8 ("leds: max77705: Add LEDs support")
Signed-off-by: Len Bao <len.bao@gmx.us>
Link: https://lore.kernel.org/r/20250727075649.34496-1-len.bao@gmx.us
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-max77705.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-max77705.c b/drivers/leds/leds-max77705.c
index 933cb4f19be9b..b7403b3fcf5e7 100644
--- a/drivers/leds/leds-max77705.c
+++ b/drivers/leds/leds-max77705.c
@@ -180,7 +180,7 @@ static int max77705_add_led(struct device *dev, struct regmap *regmap, struct fw
 
 		ret = fwnode_property_read_u32(np, "reg", &reg);
 		if (ret || reg >= MAX77705_LED_NUM_LEDS)
-			ret = -EINVAL;
+			return -EINVAL;
 
 		info = devm_kcalloc(dev, num_channels, sizeof(*info), GFP_KERNEL);
 		if (!info)
-- 
2.51.0



