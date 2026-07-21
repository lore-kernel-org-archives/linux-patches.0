Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4AF42DFEC;
	Tue, 21 Jul 2026 21:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670274; cv=none; b=upY8rlP2QqYD0xKosvjwShOWiWJZzwXMs33XB9QhZgxBi8FMRcLUt/3LY61w2m5zNuIGz+KELemiUyUYbxNUMz8iVUI5WUtlwLv9GrKhr/CxOyTvNZhKP4SZdBCDbu/Qqlm5M4NCS3roXCliYhZh8TqIr3fi6MmSteYZ7ddXYWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670274; c=relaxed/simple;
	bh=2V/RjRYO9EZmATpyPLsT7WSmttEDnTNvyxaEbD/forE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZ18trr9NMQ5SpaCfug0iXdQbtXEk5lFJWLfGEcyRIH1QWY3Lw85czWEl0avPK33qNQNYgpNEWOiTTJJvzQacs8LS0SSydvzC1RdL7KBqanJKqf08md42ndqCvHhH7PHxCKpSdfyY+WCSGLQjtCmm6z3FzkXwcPpTRvhzxjGi/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PN85qne4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PN85qne4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AFC1F000E9;
	Tue, 21 Jul 2026 21:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670272;
	bh=chLu7Ndmdbjvq9hXCcjwTDevMa9lRZL321+SdFJJ/EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PN85qne4AJ1HdlNKj6mPFPeae+/BRYEgSlL9+iCyhbvUsmQ7PSavXDltcj4XGtBg5
	 VpjJBuG4dIVHUVI6tX1zsNsfcgeV5XBUmSTse51uwpCGWmpTPb5RbAg2rsW/x9XyX0
	 qh3X8aYsVPn41tHSmf73fuQNQaw1gPX9/vNsMNzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 0869/1067] Input: ims-pcu - fix type confusion in CDC union descriptor parsing
Date: Tue, 21 Jul 2026 17:24:30 +0200
Message-ID: <20260721152443.977148601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -1715,7 +1715,7 @@ static int ims_pcu_parse_cdc_data(struct
 
 	pcu->ctrl_intf = usb_ifnum_to_if(pcu->udev,
 					 union_desc->bMasterInterface0);
-	if (!pcu->ctrl_intf)
+	if (pcu->ctrl_intf != intf)
 		return -EINVAL;
 
 	alt = pcu->ctrl_intf->cur_altsetting;


