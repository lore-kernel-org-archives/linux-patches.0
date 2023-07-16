Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF808F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F21C433C8;
	Sun, 16 Jul 2023 20:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538733;
	bh=E/83GT2Yh6gB5M00dSWsw4qpqdS/Zp2L1iZb8b9Pfxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3b+wqP6LpcBqcNr7QbddG5bN6rO2xVfzgfU8KvVdRy8TIbZZsfTI1Vq2P/6g8ysc
	 l4qD2T5EWMCivtSVFEJ+4qAJrvOscwtxeoAW25a9mhhR9vtS+DfZ7UJ1ZYAYtJNb97
	 w8hEaHaDoPSZsbjYEOskcNIqDtA1OiyJC7QQBCwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 556/800] usb: dwc2: Fix some error handling paths
Date: Sun, 16 Jul 2023 21:46:49 +0200
Message-ID: <20230716195002.005041234@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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
index 5aee284018c00..5cf025511cce6 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -203,6 +203,11 @@ int dwc2_lowlevel_hw_disable(struct dwc2_hsotg *hsotg)
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
@@ -213,6 +218,10 @@ static int dwc2_lowlevel_hw_init(struct dwc2_hsotg *hsotg)
 				     "error getting reset control\n");
 
 	reset_control_deassert(hsotg->reset);
+	ret = devm_add_action_or_reset(hsotg->dev, dwc2_reset_control_assert,
+				       hsotg->reset);
+	if (ret)
+		return ret;
 
 	hsotg->reset_ecc = devm_reset_control_get_optional(hsotg->dev, "dwc2-ecc");
 	if (IS_ERR(hsotg->reset_ecc))
@@ -220,6 +229,10 @@ static int dwc2_lowlevel_hw_init(struct dwc2_hsotg *hsotg)
 				     "error getting reset control for ecc\n");
 
 	reset_control_deassert(hsotg->reset_ecc);
+	ret = devm_add_action_or_reset(hsotg->dev, dwc2_reset_control_assert,
+				       hsotg->reset_ecc);
+	if (ret)
+		return ret;
 
 	/*
 	 * Attempt to find a generic PHY, then look for an old style
@@ -339,9 +352,6 @@ static int dwc2_driver_remove(struct platform_device *dev)
 	if (hsotg->ll_hw_enabled)
 		dwc2_lowlevel_hw_disable(hsotg);
 
-	reset_control_assert(hsotg->reset);
-	reset_control_assert(hsotg->reset_ecc);
-
 	return 0;
 }
 
-- 
2.39.2



