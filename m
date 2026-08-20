Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED194481AA6;
	Thu, 20 Aug 2026 17:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248308; cv=none; b=VSEk8uXtKlSHN4sfiLjMIOTuBW1OxjQS85ubaj+fZ+u9v/T5REjzUjm0b4S4EeHQukEWcExBOxX4FH/cte2YGDKZHMw73cOBGQ66OaywMBjGmORln87ekTF/00LQMspMvcSmrv8YMKhzAX67wcUeltjzPyReo0zRJkctIwSdGrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248308; c=relaxed/simple;
	bh=ZeEU25onrkCQxaLhcia8/WEDPRvGcMh7BBvRJZxpXt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcPt3ZqQy0k1XGBRq55bpdfiXCbBdrDQHcxI7vmQNqyPjPcc2p4ciQn1X1ZaaqazVPdyaSdn3CgAeLKjrSe0GRqCAsvQiS5SvWbtiGgMWQK/x8h96fAgsh5+xJ8c5vzOtdNY5cVoyWPY4Jcou891h9HwfvbbiJdcE9ChJOidIVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOIzIVzt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOIzIVzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADD81F000E9;
	Thu, 20 Aug 2026 17:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248306;
	bh=b7CBwxrz4gX04ySq3XgEFKxs5gE0sB1+vcTxNUFew6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BOIzIVztOl3KNweYCkQNuZBdfm0QCNPKU1dNOEi4NpBubpSbvsJxwQP8zPSG38H6j
	 IwSekhnzwsfVplhL5ZWS7DkFXiG3WVdzdkd3iO9MZDxEqbQY72m+reDPSjoishWtVl
	 KvtZbVVXo6qQ4p7nmnGWeVgCUGYoYSBVOisGJo3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 181/303] usb: musb: omap2430: Do not put borrowed of_node in probe
Date: Thu, 20 Aug 2026 16:55:17 +0200
Message-ID: <20260820145258.755247377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit c947360ae63eee1c9eacc030dd6f5a53f717addf ]

omap2430_probe() stores pdev->dev.of_node in a local np variable. This is
a borrowed pointer and the probe function does not take a reference to
it.

The success and error paths nevertheless call of_node_put(np). This drops
a reference that is owned by the platform device, and can leave
pdev->dev.of_node with an unbalanced reference count.

Do not put the borrowed platform device node from omap2430_probe().
References taken for the child MUSB device are handled by the device core,
and the ctrl-module phandle reference is still released separately.

Fixes: ffbe2feac59b ("usb: musb: omap2430: Fix probe regression for missing resources")
Cc: stable <stable@kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260713114711.955253-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/omap2430.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -455,7 +455,6 @@ static int omap2430_probe(struct platfor
 		dev_err(&pdev->dev, "failed to register musb device\n");
 		goto err_disable_rpm;
 	}
-	of_node_put(np);
 
 	return 0;
 
@@ -465,7 +464,6 @@ err_put_control_otghs:
 	if (!IS_ERR(glue->control_otghs))
 		put_device(glue->control_otghs);
 err_put_musb:
-	of_node_put(np);
 	platform_device_put(musb);
 
 	return ret;


