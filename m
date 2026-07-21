Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0478C46D57C;
	Tue, 21 Jul 2026 18:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659083; cv=none; b=huNLcKSerB4Xzz09AIE3Y1Y/KGTtZB0/QVSt8z5lpQ1kiQcZpS+UFegRCrsWOiX1W1ays64+0XgB1EsyN6mY754+AEyS9YFyIYqxGsdWecUMyu1lYFQ5Om54bU0QJzVqZ3nVbeLdR+FXvCENFpcjFYsydjI8mGlPEnLnRnpSD6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659083; c=relaxed/simple;
	bh=yqxzK8jYYaA0gVCEnv506IagpiuRDCQuGHwqbZ2TYG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdC7RYh3U9qKCZGWeGSVaupoxsLhZBuC6osVb+OIjBgIJ3H9l2bTHYktPZY61Vz/zove0Y3BauUbAsOOlmac2A3L1lvJ1pWjtgNAYa7316EKL3m0sPZ2eGpUm9K1eP58A8INMrKfYZ+rwUSiVdl3+sewAy07no6JChXoY9P6GlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bC+tpXl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bC+tpXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9451F000E9;
	Tue, 21 Jul 2026 18:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659080;
	bh=Iwsprzr4m9UK57jjFbM51xGo/2ExSRVQR2+h9Vvuwmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bC+tpXlblvEVVz9NyDqBCwK9hb44qM+cJiZM3cANzZYKo/40jex2yEYa2EBiRbfN
	 CeQPi3mnPanMlaXTua/Jw3rtvRtO6OMXNDmvL6NEqqJDzkf3ttruA8iig+mHn8UGqR
	 mgNkni3BvlTWhQ12gCCXe3bcf3cZVP7DWOJe1MR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 1384/1611] Input: ims-pcu - fix type confusion in CDC union descriptor parsing
Date: Tue, 21 Jul 2026 17:25:00 +0200
Message-ID: <20260721152546.573080962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit ca459e237bc49567649c56bc72e4c602fb92fd67 upstream.

The driver currently trusts the bMasterInterface0 from the CDC union
descriptor without verifying that it matches the interface being
probed. This could lead to the driver overwriting the private data of
another interface.

Validate that the control interface found in the descriptor is indeed
the one we are probing.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1727,7 +1727,7 @@ static int ims_pcu_parse_cdc_data(struct
 
 	pcu->ctrl_intf = usb_ifnum_to_if(pcu->udev,
 					 union_desc->bMasterInterface0);
-	if (!pcu->ctrl_intf)
+	if (pcu->ctrl_intf != intf)
 		return -EINVAL;
 
 	alt = pcu->ctrl_intf->cur_altsetting;


