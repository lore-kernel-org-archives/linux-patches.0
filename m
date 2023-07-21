Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40302200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3493C433C8;
	Fri, 21 Jul 2023 19:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966222;
	bh=EIAn2JUUCUq2MrFuOL8GPXe0oP1N3e/slTzw+FQMeW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrLcsDiB0lQJ6OW8OqxVbcAugkku2A/08hjBhip5n+lkTg++FClczzQuSXrEZn/c+
	 lMES8FYH9/Ty8dGJGaKHaETInUzHjksCO72T/XKasM4qw74/ELbfdKvXFwrGy0B+kz
	 PqCyIZg2vyGD1BTp/ilV7O4MRwFu+DUin+maIIkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 268/532] usb: dwc2: Fix some error handling paths
Date: Fri, 21 Jul 2023 18:02:52 +0200
Message-ID: <20230721160628.879848669@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ada050c69108bc34be13ecc11f7fad0f20ebadc4 ]

dwc2_driver_probe() calls dwc2_lowlevel_hw_init() which deassert some reset
lines.
Should an error happen in dwc2_lowlevel_hw_init() after calling
reset_control_deassert() or in the probe after calling
dwc2_lowlevel_hw_init(), the reset lines remain deasserted.

Add some devm_add_action_or_reset() calls to re-assert the lines if needed.

Update the remove function accordingly.

This change is compile-tested only.

Fixes: 83f8da562f8b ("usb: dwc2: Add reset control to dwc2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/c64537b5339342bd00f7c2152b8fc23792b9f95a.1683306479.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/platform.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index ad8c7de4bfb19..6496bfbd34ed9 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -205,6 +205,11 @@ int dwc2_lowlevel_hw_disable(struct dwc2_hsotg *hsotg)
 	return ret;
 }
 
+static void dwc2_reset_control_assert(void *data)
+{
+	reset_control_assert(data);
+}
+
 static int dwc2_lowlevel_hw_init(struct dwc2_hsotg *hsotg)
 {
 	int i, ret;
@@ -217,6 +222,10 @@ static int dwc2_lowlevel_hw_init(struct dwc2_hsotg *hsotg)
 	}
 
 	reset_control_deassert(hsotg->reset);
+	ret = devm_add_action_or_reset(hsotg->dev, dwc2_reset_control_assert,
+				       hsotg->reset);
+	if (ret)
+		return ret;
 
 	hsotg->reset_ecc = devm_reset_control_get_optional(hsotg->dev, "dwc2-ecc");
 	if (IS_ERR(hsotg->reset_ecc)) {
@@ -226,6 +235,10 @@ static int dwc2_lowlevel_hw_init(struct dwc2_hsotg *hsotg)
 	}
 
 	reset_control_deassert(hsotg->reset_ecc);
+	ret = devm_add_action_or_reset(hsotg->dev, dwc2_reset_control_assert,
+				       hsotg->reset_ecc);
+	if (ret)
+		return ret;
 
 	/*
 	 * Attempt to find a generic PHY, then look for an old style
@@ -352,9 +365,6 @@ static int dwc2_driver_remove(struct platform_device *dev)
 	if (hsotg->ll_hw_enabled)
 		dwc2_lowlevel_hw_disable(hsotg);
 
-	reset_control_assert(hsotg->reset);
-	reset_control_assert(hsotg->reset_ecc);
-
 	return 0;
 }
 
-- 
2.39.2



