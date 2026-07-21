Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9E843E06C;
	Tue, 21 Jul 2026 22:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671296; cv=none; b=SBqpt/OXkjupH2z5BdeLTA5ZalwTrCS8kDY0BKvgGzRzn4r+KNuVcN1ND0ydoh5AJI/sT+b9Ctn5CBlyygO2Zrm4SxyCh3dOV9hgx3sXil2rruRZxieBTtcZpmTVcLlgLlMXtaF9PVdiRt6P/N2JNGWTp/rwF6YGMjSINp+LzZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671296; c=relaxed/simple;
	bh=/luuSTGE4KhxShexszCQjsegiDKs3DtfgDUIo/Cucdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFmSXFiYRwPhmx/LiQJnGHrBKWeg2Top6r1WPOrXmNdiHu979PotgZ7nxXahQR6GKW8xV1BNMqkOqgQeMay9La20Q7gmU66I78RlquKwPrBFpPYPpwYRBBhaq3msxmt/H7QS41BBb1m720rAKtVGGwOwrqZJLaeL/chWrviuxSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6IL60Qx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6IL60Qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840261F000E9;
	Tue, 21 Jul 2026 22:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671295;
	bh=I2qa8xRmeUm9sBxOCeGjmaddNQ4mJwcs+zC8cbdG/v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6IL60QxbSKXNyEPv6d7wib5hzTn37mjWmfuAiY7lJox+ELtHTPvkL5P0KU+NaI8o
	 o5Dpor5WFCHtOK2fkC3T8v8jeZqHVRG6tUaDFmFM0WUhIR7HrCqkwF3O2ynfePFRvw
	 mnFFjUQJ7AW+GTIBu3jEezpg2c3egiluOf2X4LyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 192/843] Input: maplecontrol - set driver data before registering input device
Date: Tue, 21 Jul 2026 17:17:07 +0200
Message-ID: <20260721152410.334522781@linuxfoundation.org>
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

commit fe938ee497d58c644f6910cfe6ae155f6fb3e523 upstream.

Set maple driver data before calling input_register_device() to
ensure that it is available if the device is opened immediately and
the callback is triggered.

Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Tested-by: Florian Fuchs <fuchsfl@gmail.com>
Link: https://patch.msgid.link/akNYib9hQFNN1fA9@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/maplecontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/input/joystick/maplecontrol.c
+++ b/drivers/input/joystick/maplecontrol.c
@@ -112,6 +112,8 @@ static int probe_maple_controller(struct
 	pad->dev = idev;
 	pad->mdev = mdev;
 
+	maple_set_drvdata(mdev, pad);
+
 	idev->open = dc_pad_open;
 	idev->close = dc_pad_close;
 
@@ -146,7 +148,6 @@ static int probe_maple_controller(struct
 		goto fail;
 
 	mdev->driver = mdrv;
-	maple_set_drvdata(mdev, pad);
 
 	return 0;
 


