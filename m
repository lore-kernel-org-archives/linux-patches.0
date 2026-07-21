Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF3745A285;
	Tue, 21 Jul 2026 22:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672577; cv=none; b=rltHWBZwlkPMiw16b/z6Xmk5SlF8AJfqvx2X2Zx6Qi4o15478axqvz8M64lfTdhVIRZNxdER6GNaJgqDRWrpVEQVssoFWk33/086VT9Rwrnv2MQ6x2zuaBXKlabhJv5mx1ngJUQPfGxcSzsyY5sGb1X6el+4J3MksXkw1AoDLKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672577; c=relaxed/simple;
	bh=LHiP4QAryHlD038VqNUP6PEqYCVmYlCytRP+HERRnMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgoRTr32PIBi+XGiyz82HFbnsp/M+Depf7TYjWtr8jqQDleKv2E0boDxqbYQ7bvF6y1tiexIVjOEiVVmlDRXv+ciAfqzzd4C9psiiIYj24qgFqLn3X5kiRGzc/QGwI6ilM0GcH9icEssAXY2bsGS4vbh7G9gFdT+F9VaRwuxjmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKu8Q2C2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKu8Q2C2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0611F000E9;
	Tue, 21 Jul 2026 22:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672576;
	bh=1MLEa1KO7/PbYo1pEXqiZ//fFYrlIHFnEhxyS62o0go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKu8Q2C27JWAgOWkt+AGRnTKZUSE3OsxvQkIQu6kBGIk0TvkogJhJfFqu7T1Jp/QL
	 l+qk9bWdGf4H+70SZKYTwCO1TCW5M/y8/zrdVU3qe76uVAxrAlITXw0sow3kRFiGGv
	 AGW2kSJ+BZMQ3IZFdabEzo8x+D/Ae0TdizdYUScY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 675/843] Input: ims-pcu - fix type confusion in CDC union descriptor parsing
Date: Tue, 21 Jul 2026 17:25:10 +0200
Message-ID: <20260721152421.244794881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1713,7 +1713,7 @@ static int ims_pcu_parse_cdc_data(struct
 
 	pcu->ctrl_intf = usb_ifnum_to_if(pcu->udev,
 					 union_desc->bMasterInterface0);
-	if (!pcu->ctrl_intf)
+	if (pcu->ctrl_intf != intf)
 		return -EINVAL;
 
 	alt = pcu->ctrl_intf->cur_altsetting;


