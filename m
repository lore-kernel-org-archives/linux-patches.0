Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA24E129EFE;
	Mon, 18 Dec 2023 13:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sC2DRMtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A18C433C9;
	Mon, 18 Dec 2023 13:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907673;
	bh=oW4+LXlorb6SANWjhSkZElqQaUeJydqtlYOWVkRRsMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sC2DRMtOtTyK37SqfTpiEWgogMlarzDJ04ixqSMSHuNq4/3XxHYMx/T5DrcdjyGdw
	 OcOw2P/YTxH5viIN1xKUgZIh4vfYorSJioIDL+2KFzh/U4NVrOAxoVw+i57BaBWss3
	 nhBvyL5QgZCxX2qJcqgw3Q/TZVELdzZWPXKTlE+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/36] net: stmmac: use dev_err_probe() for reporting mdio bus registration failure
Date: Mon, 18 Dec 2023 14:51:23 +0100
Message-ID: <20231218135042.347406314@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135041.876499958@linuxfoundation.org>
References: <20231218135041.876499958@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit 839612d23ffd933174db911ce56dc3f3ca883ec5 ]

I have a board where these two lines are always printed during boot:

   imx-dwmac 30bf0000.ethernet: Cannot register the MDIO bus
   imx-dwmac 30bf0000.ethernet: stmmac_dvr_probe: MDIO bus (id: 1) registration failed

It's perfectly fine, and the device is successfully (and silently, as
far as the console goes) probed later.

Use dev_err_probe() instead, which will demote these messages to debug
level (thus removing the alarming messages from the console) when the
error is -EPROBE_DEFER, and also has the advantage of including the
error code if/when it happens to be something other than -EPROBE_DEFER.

While here, add the missing \n to one of the format strings.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Link: https://lore.kernel.org/r/20220602074840.1143360-1-linux@rasmusvillemoes.dk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e23c0d21ce92 ("net: stmmac: Handle disabled MDIO busses from devicetree")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4428,7 +4428,7 @@ int stmmac_dvr_probe(struct device *devi
 		ret = stmmac_mdio_register(ndev);
 		if (ret < 0) {
 			dev_err(priv->device,
-				"%s: MDIO bus (id: %d) registration failed",
+				"%s: MDIO bus (id: %d) registration failed\n",
 				__func__, priv->plat->bus_id);
 			goto error_mdio_register;
 		}


