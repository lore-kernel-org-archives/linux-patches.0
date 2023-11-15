Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E3918C27
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+BdLW/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF00C4E763;
	Wed, 15 Nov 2023 20:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081524;
	bh=JojXOYgurHY0k8kr6fjNMYqy790RBaIfvRRwjb2u4gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+BdLW/cJTRYIpV1klspaLdttYzep3mF1w+jiTlRfPXJgf7I8OVIG1IgwIZX39q71
	 EkClF7J6eUMGrSowR8xufLFfXbwzcIfl4mlGAIhM8lvInojQ07RuU73vw2x1RWumyA
	 3FLQB8W9A6ZKNhT5wPF9xL0t4DsFFxzEIBnyhAHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 206/244] media: cedrus: Fix clock/reset sequence
Date: Wed, 15 Nov 2023 15:36:38 -0500
Message-ID: <20231115203600.719030906@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 36fe515c1a3cd5eac148e8a591a82108d92d5522 ]

According to H6 user manual, resets should always be de-asserted before
clocks are enabled. This is also consistent with vendor driver.

Fixes: d5aecd289bab ("media: cedrus: Implement runtime PM")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/sunxi/cedrus/cedrus_hw.c    | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
index e2f2ff609c7e6..0904aea782b1e 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
@@ -147,12 +147,12 @@ int cedrus_hw_suspend(struct device *device)
 {
 	struct cedrus_dev *dev = dev_get_drvdata(device);
 
-	reset_control_assert(dev->rstc);
-
 	clk_disable_unprepare(dev->ram_clk);
 	clk_disable_unprepare(dev->mod_clk);
 	clk_disable_unprepare(dev->ahb_clk);
 
+	reset_control_assert(dev->rstc);
+
 	return 0;
 }
 
@@ -161,11 +161,18 @@ int cedrus_hw_resume(struct device *device)
 	struct cedrus_dev *dev = dev_get_drvdata(device);
 	int ret;
 
+	ret = reset_control_reset(dev->rstc);
+	if (ret) {
+		dev_err(dev->dev, "Failed to apply reset\n");
+
+		return ret;
+	}
+
 	ret = clk_prepare_enable(dev->ahb_clk);
 	if (ret) {
 		dev_err(dev->dev, "Failed to enable AHB clock\n");
 
-		return ret;
+		goto err_rst;
 	}
 
 	ret = clk_prepare_enable(dev->mod_clk);
@@ -182,21 +189,14 @@ int cedrus_hw_resume(struct device *device)
 		goto err_mod_clk;
 	}
 
-	ret = reset_control_reset(dev->rstc);
-	if (ret) {
-		dev_err(dev->dev, "Failed to apply reset\n");
-
-		goto err_ram_clk;
-	}
-
 	return 0;
 
-err_ram_clk:
-	clk_disable_unprepare(dev->ram_clk);
 err_mod_clk:
 	clk_disable_unprepare(dev->mod_clk);
 err_ahb_clk:
 	clk_disable_unprepare(dev->ahb_clk);
+err_rst:
+	reset_control_assert(dev->rstc);
 
 	return ret;
 }
-- 
2.42.0



