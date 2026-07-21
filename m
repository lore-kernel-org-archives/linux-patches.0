Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B838A4582D5;
	Tue, 21 Jul 2026 20:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667475; cv=none; b=ZgXFYHI4RQ7Ks9Nye/J8ZEbn1QStVw7LL0pYwOX5yJpytAnxxA5nqR0kFlb46Sy1wF6YOpYC+1rXrzKp/XcYM3wTXshr4skl3OA/dhZC835VBvR4yLl9OXmUtOUQbWGmdqnjOS2YKk8Ah9P6ZGvdOTen9thKmGbrJyUt8usaFn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667475; c=relaxed/simple;
	bh=Z6m1UtNxp5BQt5v+6N4FgOxofh2hOGzc/boYajRBmrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3dhCxKubs8kOuqOMV286VVEsxjL01fFLYcBO9TYl43P+hLbOxD7AezMNBHnRaSIwEwfhb+ZbUc0FKg1Rc8z2MUQlU5nD8onH2vw06oirEXWstNBYRFrvoDiG9TB8Jvn7RBYUmskl2jIx7bDe2xlTQ4Cly9Yg3dzw2zoXMBcLVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnHZlO1g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnHZlO1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE5C1F00A3F;
	Tue, 21 Jul 2026 20:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667466;
	bh=/ncalvtlWDXgwRSdXW3IhRHEJg3zgGmhr6qBBmOkHCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rnHZlO1g8XchRR7ZF7ngrla4hbqkM7I/qTIbhdzzO+Z3hVQFzEQRm21F7NGW8hQUD
	 0DC3bdS6CrkkcKF6ebHW/BKESK7Kn4Jn7kegwhlYYRYprhEQWpSKtuGGPurKwLw0Ug
	 /rJMGXf3/r+4+N6T7w9X9i8PCdUvVspxdZ7gELEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 1073/1266] Input: ims-pcu - fix type confusion in CDC union descriptor parsing
Date: Tue, 21 Jul 2026 17:25:10 +0200
Message-ID: <20260721152505.828364858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


