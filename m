Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9005B42DFEC;
	Tue, 21 Jul 2026 19:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664000; cv=none; b=JcxasU6pCkRIRbw2ipUxh4ysFG3D+RdSMEvmwcAtG00Y0mrDqrW9LjWrdsoh/taxY0wZ1SQFMTnzco/eOuimBvkvqIme2eY3UpWZSxniiQSYAblbGwGfNfvB0xaR7WOhq9JgF1bSObL2y7RffvJI4Pw82ABYZD+0zmf+qtKT9Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664000; c=relaxed/simple;
	bh=qH4/l/sSDaajCwcmQCLUegwulQ5stY33EpYzfRo4qtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdCm41LuEDtSNiOrsa5mY3CrwOiMqcSTUY353DplVVX4uI7E+ASMThJnKBTyH06Z2ZVrBAVKq4FVPCoMtNaR96X6QlF4nLCEK1XLQfHEjW0WbeO6XWpP4TVnR0U8OASLxniCV7HhST1Sz9Js97AGnpcwaWYlPo7Ycc8PqDK9EQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+dqF0EE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+dqF0EE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF46F1F000E9;
	Tue, 21 Jul 2026 19:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663999;
	bh=fSXAeT3E4EtGG4BsE6Cl4J/Bi+tSt4UFBgC7X8cSIBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i+dqF0EE/35R2SQGu7rw6vu00H57qNSR0Ju9/TzU0+Y4YBMeMTuQhhAaO3frkIw4m
	 XuLk5j+gHmxHOkLZEdjOjMdJjo5Hm1ZU88qL9KSLiG1H7THZzy7xFx1Eht5TynRN/t
	 Jo4eNO4NCWn+tVTngXKkntQFQBrG7ZXul2lBTrBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 1035/1276] Input: ims-pcu - fix type confusion in CDC union descriptor parsing
Date: Tue, 21 Jul 2026 17:24:38 +0200
Message-ID: <20260721152509.150556180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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


