Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5612D2F6
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 11:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D003C433C8;
	Mon, 19 Jun 2023 11:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172405;
	bh=CHbZjusSHvhm1S3FGdarnEpAyiu+RS/DEBMoN7yQXJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tG7zyy1P3lqdC2IaZ9mmsg/nvBsGbeT9h5mFflr2W5yCiWyDzZyT/dug6cIWR/9Bk
	 fYgj76RucHGNgc4uuqlkK0z0UC+e96MyFEjJe724V4i1EoarR9/Lq8kMUYdOa8F8oF
	 W/l3RK1D7VPDyPeP5k9uUZY607J1ORo1EIp0XGOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/107] irqchip/gic: Correctly validate OF quirk descriptors
Date: Mon, 19 Jun 2023 12:30:15 +0200
Message-ID: <20230619102143.004446119@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 91539341a3b6e9c868024a4292455dae36e6f58c ]

When checking for OF quirks, make sure either 'compatible' or 'property'
is set, and give up otherwise.

This avoids non-OF quirks being randomly applied as they don't have any
of the OF data that need checking.

Cc: Douglas Anderson <dianders@chromium.org>
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Fixes: 44bd78dd2b88 ("irqchip/gic-v3: Disable pseudo NMIs on Mediatek devices w/ firmware issues")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/irqchip/irq-gic-common.c b/drivers/irqchip/irq-gic-common.c
index de47b51cdadbe..afd6a1841715a 100644
--- a/drivers/irqchip/irq-gic-common.c
+++ b/drivers/irqchip/irq-gic-common.c
@@ -16,6 +16,8 @@ void gic_enable_of_quirks(const struct device_node *np,
 			  const struct gic_quirk *quirks, void *data)
 {
 	for (; quirks->desc; quirks++) {
+		if (!quirks->compatible && !quirks->property)
+			continue;
 		if (quirks->compatible &&
 		    !of_device_is_compatible(np, quirks->compatible))
 			continue;
-- 
2.39.2



