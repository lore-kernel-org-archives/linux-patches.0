Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539B630FC1C;
	Wed,  3 Dec 2025 15:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776559; cv=none; b=M3rRjsah7YdLaInZRiL0CjiTz/EC1eu3Hj8LiCieuk2vw8aNVnxj0N0si3P5EoHLhcLUFPj9rCP++G87/UJL6/cG5wyESfJYHfRU1Q+PBGDeE+mCMN6esuks9c+lG7fc5kRpGXWZAw0FHaydq8LWBS2XsVwIdui4QNnoWMOm+zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776559; c=relaxed/simple;
	bh=hqlEG8wxrAXU0Sv1Ee9QqPrj9YzeROdQQALT4WheQzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAp8YDf3lN8L0JYtGE62F2WJkASq899kXD1t4uFHKQ/c26BvpeyaB1TWfX0NkCyGT4bR5X1cG8RUyW2dRodOv+0KBZcOgEfDCrZKLtKTQntPdygUYLIha6Q6LDVEh10eyjqn9KqZCymTiflWCGKj+zM1/IKeznEX7OQ7K+Tw9DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsasjNrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsasjNrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12A0C4CEF5;
	Wed,  3 Dec 2025 15:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776559;
	bh=hqlEG8wxrAXU0Sv1Ee9QqPrj9YzeROdQQALT4WheQzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WsasjNrGWz5CnQRMOh0T0KpFVBR0gi8G/S/3yGWwqByVes/iuHjAVIRDlr+/ghIco
	 tLS9wNvXT689JpjJ7qwDQMB7MLlutxTQ0GiiHNFF1fH5YdDeyB6UFDdw6rytsLOr2/
	 VRB38sMlFjq4vAcD0PA90foYU9oipvXuf28w31MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 220/300] Input: imx_sc_key - fix memory corruption on unload
Date: Wed,  3 Dec 2025 16:27:04 +0100
Message-ID: <20251203152408.774384644@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit d83f1512758f4ef6fc5e83219fe7eeeb6b428ea4 upstream.

This is supposed to be "priv" but we accidentally pass "&priv" which is
an address in the stack and so it will lead to memory corruption when
the imx_sc_key_action() function is called.  Remove the &.

Fixes: 768062fd1284 ("Input: imx_sc_key - use devm_add_action_or_reset() to handle all cleanups")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/aQYKR75r2VMFJutT@stanley.mountain
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/imx_sc_key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/keyboard/imx_sc_key.c
+++ b/drivers/input/keyboard/imx_sc_key.c
@@ -158,7 +158,7 @@ static int imx_sc_key_probe(struct platf
 		return error;
 	}
 
-	error = devm_add_action_or_reset(&pdev->dev, imx_sc_key_action, &priv);
+	error = devm_add_action_or_reset(&pdev->dev, imx_sc_key_action, priv);
 	if (error)
 		return error;
 


