Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18AD28D8E8;
	Thu, 27 Nov 2025 14:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255567; cv=none; b=EueYg7pz/Q2NQiPPsWabiLfzebDUk5OhBP6t+kDoC8zKAX5QQBEt4TbH5svQnm+oMtr/jiKRAQalnAgesO1v+oUr+h+y+xKDl7jvINkmkMbY8fuSLu9JnXkAa2jPDpP/XEJG0OBExcuruMrgdG0fubhfFJHCEWO2g5VilJibGG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255567; c=relaxed/simple;
	bh=cJYr8aDihlR4doW1cmnjhaqW5SI2dh9qC5zOc602Fpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiPYaKdtB/f2SEpYuF/SSV+SCOD3Wt4b5T4C9wm1IW6RJYla4wtgGK3VGuYtiryoKA5PsxGbgddER7iT6xDBt43IHmfkYaScuK0ipiUBY1OU37a3PPB3qciKkxYCSdslTF0liN4T2t02AAhVSxR8tvPKxC6QHLflGFl4Ci+1ROo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGC+O7As; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGC+O7As"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638D2C4CEF8;
	Thu, 27 Nov 2025 14:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255566;
	bh=cJYr8aDihlR4doW1cmnjhaqW5SI2dh9qC5zOc602Fpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGC+O7Ascig+p3ScBgHg3xDMFO3u6Ks8NOurYAh2cfaBLAVFoIzSX7QU3uZA4y/TE
	 n+yQX+0l/F8cPd2y6xRg5HwOJHHoEjIeXte3HO/F1Nh2SwjBXFjIKUau/d4omS4hTH
	 VPZ5ablEjcSlsZwRdvR034IYn+lPyjquePWoOhqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.17 038/175] Input: imx_sc_key - fix memory corruption on unload
Date: Thu, 27 Nov 2025 15:44:51 +0100
Message-ID: <20251127144044.356582874@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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
 


