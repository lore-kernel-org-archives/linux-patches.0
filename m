Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C98D403AFB;
	Tue, 21 Jul 2026 17:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654948; cv=none; b=fMGAqbUSxHUAZ2QWVd8NFNG+tEa3o4Q2yVtKwYGhOihhS3I2gW4PJiiDxB65mT5p3tENCJ9wDgPE1A2olgBCctLrSR584X/qbdrd9DnEtf3+0J792CDWzPUICirfoZcTwPhTUM6u1BlGbzWGJ5dHPEvUN2e/2fPsVW2wc4dNaAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654948; c=relaxed/simple;
	bh=Y+i5G41tbzqiPZSurugHLf80OlzPJx0/lBXRxrXI44s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsSMRm0tBzDlJXc7t1VOT0Ki086SqHaAr5bKqqaWq0ctOVwk6oD2f79b75SBCjSew5nHxTLWjRTSYdy5AAglrZqqHRHxVSZNYCFuMQmLIvxt+vibQcE2vJ4VkS2ajoHjRhShv9Oul6JKkst9RwczYZ304NtfWhZjYzB/Mlewtrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvftANpu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvftANpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67871F000E9;
	Tue, 21 Jul 2026 17:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654947;
	bh=SD/rDG6rMlrY3cD31H+k9JunlydcttHf3HcGKCvw11g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BvftANpuj9uQKBGP4TyH0y5NXg/mdxjcW0ZrKnPfXfRl2CwP3huEpgh+p60lxv/e9
	 gSYAto6wbDGLzxiFxuTuNgknRk3ca+b1PXYya101Zs1907DM0nkkqnxS7SDRx+Xs9m
	 TcTrxkf6qwTF4kbSc6kBpuI4DgSfxgGnvbovn0uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 1891/2077] Input: ims-pcu - fix type confusion in CDC union descriptor parsing
Date: Tue, 21 Jul 2026 17:26:04 +0200
Message-ID: <20260721152637.325603441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1747,7 +1747,7 @@ static int ims_pcu_parse_cdc_data(struct
 
 	pcu->ctrl_intf = usb_ifnum_to_if(pcu->udev,
 					 union_desc->bMasterInterface0);
-	if (!pcu->ctrl_intf)
+	if (pcu->ctrl_intf != intf)
 		return -EINVAL;
 
 	alt = pcu->ctrl_intf->cur_altsetting;


