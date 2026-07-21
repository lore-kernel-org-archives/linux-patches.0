Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BA8415F0C;
	Tue, 21 Jul 2026 22:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674398; cv=none; b=adwtNEEKd/RV6z5YoQl6zMUxOt96xdPVDCV5fEsnjqN40691WIU3tHvoENbj1/mWWsJwvcYrlwgMX3tTuKy/S33HO74v7b2YJTGE86KTdtB3LwYeMxBrkZptQIa2G8zGe6WAdNqs8vwJhCm2tOb9u4Wi5xf7FsRlF7GgS2RNNAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674398; c=relaxed/simple;
	bh=sNDJDYUGOlI8d6b1XhHvpmLgwXZFU5ttpdtTYyPGRY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKxQOB8iuvVnwzF4ln8jQaj4sEuTR/4E4+1/WSMaaC+CaWgzYxXA+dVDhM/kA55QcXpLFHq26FfHO3bRmeE/H8d/REhNbEAkx04R/6tFv8E1O5cPqwS/vs0U3C1NJsREF8qlH794CxYcaTeFRyUEjF1NkK5xFirWeg5RgDPwhP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SaZme6va; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SaZme6va"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2531F000E9;
	Tue, 21 Jul 2026 22:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674397;
	bh=6S25XXsmdsSYhpMT/KqMAtUDTc6ctX+PvGSswfJdFBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SaZme6va4RbN6m1fScfLLBzGK3Cb1NLoOA6tPwQuSM1bu1KFx0Y23zdclDlWTC1tY
	 ik6iLDrFnLO9dRtC8ni/zwGzqeATxjysY+/+CTEew7RwCfNAD4vtNSs5nBU1zM+M/v
	 0dfFbnvhRqH6ivPqNsRN4fD+mI3xvX72ZTnjHqbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 525/699] Input: ims-pcu - fix type confusion in CDC union descriptor parsing
Date: Tue, 21 Jul 2026 17:24:44 +0200
Message-ID: <20260721152407.537329963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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


