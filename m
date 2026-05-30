Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8479261B9E;
	Sat, 30 May 2026 17:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163633; cv=none; b=eelpT3GOT5uvBI1aSdx6NnrY1e7j97Jj42a8gXYCWfrSvb0KikuTlsk8omjK4aV3UccorqEfI12MxOtT99vEhjeeJAbd0X+PTlUGY5uskTFom6lISDgfoGd7srKU1AUBsLhk0pw7CoPEqodouAvYcZiLb4/VoieLxw4LMaFZAdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163633; c=relaxed/simple;
	bh=55BokbEya7vSf49bapvD8GJAzj/nfEBSafoZkv7pH+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoDYFQAC4db7cu2NF+z18WPqL9zVXfpzwH77G4fr3TDKgPEOHjq7K3EvHi0GTCeFcZEsAteLWD60yPCSJOyp7S749jKjbIhnlwxfTlmyMgotxlc992cHY9z2FEOp+j5WI3VnnLs3z174GvYUpf6oA7WVJxwdNmVnLYFQroGf1Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFo5jNPT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFo5jNPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056C11F00893;
	Sat, 30 May 2026 17:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163632;
	bh=7EMPRDkFtdWv0sTzF8+3NA/4I69gslQGmrSpW8GMuZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eFo5jNPT8tHaneM9U1cmgSB3nWQtgsNFghlBTw9DdxZWch+8QAr42K2yePl0Y9QA1
	 tHUvc4NzmCGuteg0LtTcVBGero2xPSBFPfBp5CBD8jErx3ncnki4hzTMNyTjbaAE+Q
	 ucDat0v1L2tK2qx4APVwsUHst7/haZlwQqrZxIrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Wilken Gottwalt <wilken.gottwalt@posteo.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 316/776] hwmon: (corsair-psu) Close HID device on probe errors
Date: Sat, 30 May 2026 18:00:30 +0200
Message-ID: <20260530160248.737134522@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 174606451fbb17db506ebaacdd5e203e57773d5f upstream.

corsairpsu_probe() opens the HID device before sending the device init
and firmware-info commands. If either command fails, the error path jumps
directly to fail_and_stop and skips hid_hw_close().

Use the existing fail_and_close label for those post-open failures so the
open count and low-level close callback are balanced before hid_hw_stop().

Fixes: d115b51e0e56 ("hwmon: add Corsair PSU HID controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Link: https://lore.kernel.org/r/20260424135107.13720-1-mhun512@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/corsair-psu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/corsair-psu.c
+++ b/drivers/hwmon/corsair-psu.c
@@ -716,13 +716,13 @@ static int corsairpsu_probe(struct hid_d
 	ret = corsairpsu_init(priv);
 	if (ret < 0) {
 		dev_err(&hdev->dev, "unable to initialize device (%d)\n", ret);
-		goto fail_and_stop;
+		goto fail_and_close;
 	}
 
 	ret = corsairpsu_fwinfo(priv);
 	if (ret < 0) {
 		dev_err(&hdev->dev, "unable to query firmware (%d)\n", ret);
-		goto fail_and_stop;
+		goto fail_and_close;
 	}
 
 	corsairpsu_get_criticals(priv);


