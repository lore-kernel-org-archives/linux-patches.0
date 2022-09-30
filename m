Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837661363
	for <patches@lists.linux.dev>; Fri, 30 Sep 2022 00:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DC4C433D7;
	Fri, 30 Sep 2022 00:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664499020;
	bh=xeoSzNuqPluHkoak2Kt2ZcLQHxT/FauXizeyldfJSO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StZehtKYnEQuryaZA9/cyN6tSYSlHkb77b2RNpIF2Uf8mSJhFb7uhi1QrCfLXuD/L
	 60r9qcxcIBWdiKI20bC6pUFtd7lXIDSxDAC3pn7gsnx9LyZgmKneNQa/cLB1pZhMVu
	 4cvClIfxTKSTqXbm80nKyUiELgixA7VLI8h9X+TT5lBEaKY9thyMDfczGa9nYHtK5H
	 Fh3bSnG+P9KFvN9y5E/C5e1wG/dpcmG6yWe2DNTi/mnO9jOgsnR0ecyeFNxfblVe93
	 uB0GO8ijxeIksbeQN+hgiFhvv+3zyu0dbMAc5QsF6vd9X6zdqr/flI2cADPA59R9b2
	 Aum3wenBsNa+w==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: keliu <liuke94@huawei.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/9] drivers: spmi: Directly use ida_alloc()/free()
Date: Thu, 29 Sep 2022 17:50:10 -0700
Message-Id: <20220930005019.2663064-2-sboyd@kernel.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220930005019.2663064-1-sboyd@kernel.org>
References: <20220930005019.2663064-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: keliu <liuke94@huawei.com>

Use ida_alloc()/ida_free() instead of deprecated
ida_simple_get()/ida_simple_remove() .

Signed-off-by: keliu <liuke94@huawei.com>
Link: https://lore.kernel.org/r/20220527071338.2359733-1-liuke94@huawei.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spmi/spmi.c b/drivers/spmi/spmi.c
index a456ce5141e1..55381592bb5a 100644
--- a/drivers/spmi/spmi.c
+++ b/drivers/spmi/spmi.c
@@ -35,7 +35,7 @@ static void spmi_ctrl_release(struct device *dev)
 {
 	struct spmi_controller *ctrl = to_spmi_controller(dev);
 
-	ida_simple_remove(&ctrl_ida, ctrl->nr);
+	ida_free(&ctrl_ida, ctrl->nr);
 	kfree(ctrl);
 }
 
@@ -457,7 +457,7 @@ struct spmi_controller *spmi_controller_alloc(struct device *parent,
 	ctrl->dev.of_node = parent->of_node;
 	spmi_controller_set_drvdata(ctrl, &ctrl[1]);
 
-	id = ida_simple_get(&ctrl_ida, 0, 0, GFP_KERNEL);
+	id = ida_alloc(&ctrl_ida, GFP_KERNEL);
 	if (id < 0) {
 		dev_err(parent,
 			"unable to allocate SPMI controller identifier.\n");
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

