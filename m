Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A042882C9;
	Thu, 27 Nov 2025 14:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255200; cv=none; b=HKN7L8jV4dBOLelYTpGNF7YaF5sNuZpqgrbH8SoFKlgXpIUU3nb2Pmg1FkXchkOVKIj9LeVDfI7dFwGP0cl1ejDGRptU8KOIxw6/8M3tNN8DML8YsXV4nWrSS2acwTAtWsZTyjIQEYG86VbMxIFM/tlXzw1atGcZw4jhPIom/4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255200; c=relaxed/simple;
	bh=O1YA3zk2Ry9cdskEn+kMjeM313H22u6w2Wszb1MpXEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4KjEWVO2DTHg13t7K14ikLaoISPlBCjXZO4LSlrbwsPaPscpT4WExUJX3uCx1Kcu7qP8dSa7TVqVCgCfwpXsXbxd0kxUhSuszhfRm2l75a5yxy4qcrM9p08iyCw6rp7Li+az4qclB0jlSMc7MiBH0YIO2mFqNy5bNjyzZXo1W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7zld9PK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7zld9PK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52DCC4CEF8;
	Thu, 27 Nov 2025 14:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255200;
	bh=O1YA3zk2Ry9cdskEn+kMjeM313H22u6w2Wszb1MpXEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7zld9PKqEefCYWX7C7fZiFjNVoaPqRIUFgxo3fddArZzdhVp+2ozm9gNlpimLhS/
	 4YzIqQm+gbO562HHtUKkalezub2dMBdTvnBRuq2ZEVzJb8weOV6uaS93Q/w/MVIN3Z
	 X38c31/cw/vZHWnwKOKCfvedyBA5eUTsP4EQB+Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 025/112] Input: imx_sc_key - fix memory corruption on unload
Date: Thu, 27 Nov 2025 15:45:27 +0100
Message-ID: <20251127144033.760335705@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


