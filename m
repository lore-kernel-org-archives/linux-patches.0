Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF3144AB7B;
	Tue, 21 Jul 2026 22:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671283; cv=none; b=XB8ZBnPS1/8I/AcXYaO49p6MnLCQOE5/+iEBYCLVcpAzelffLYI+mfvqFglAG7X+90Lz1Njqm6Kicp7/wnYzz0MyxBV4ZMYeYnndsXkue8CiXIbLjzSTjc3fJLRdmk6RtxmI/tHTXkwdkPKz9xFf6l8hr+rkM0Sk+37F2TINxhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671283; c=relaxed/simple;
	bh=XVCIP3bb+QVPvLkouJ5nomSHbvuFzsLh8NcBQcrI/4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6WTGuTPt1Rp3DKP0k6Tb8i1j91XAOVTgO4uIFWz+k75b7pWEd4r/are4CwGKcKvXnDMrFzbkveGzIOvqgVYYo9FAzjIb8qPfEvwOi/EBDZWrxqZ2nCZ9Lxm7aOk90Sbmps/2Nw1+NeHO5dSP3F25iUAkjYCKa8rKDJFUuWcjkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=he9qfMvg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="he9qfMvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C8B1F00A3A;
	Tue, 21 Jul 2026 22:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671281;
	bh=31GI+5/ZF5lftd9IhaLBhkwrq405xwftt4FU6agOd4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=he9qfMvgKt/3XpgN1c5RXrAzYzsWnZk/FehKlfX/km/sdMp8/GKKYCt8FEaZQdctP
	 MiWpGCv1W8+yZuTyFYxGxNyQo2l4H+If6aZGEw2Rz5cdzVHkxuJu46sM0hVPoaWyLy
	 Ez5j7u5wWC6GVO0a/yJpI+xNeBP5Vik930aYTzT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 188/843] Input: maplemouse - fix NULL pointer dereference in open()
Date: Tue, 21 Jul 2026 17:17:03 +0200
Message-ID: <20260721152410.244341812@linuxfoundation.org>
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

From: Florian Fuchs <fuchsfl@gmail.com>

commit ee89db004238bd0b034f2a6176e175561658750b upstream.

Commit 555c765b0cc2 ("Input: mouse - drop unnecessary calls to
input_set_drvdata") dropped the input_set_drvdata() call in probe
because the data appeared to be unused. However, dc_mouse_open() and
dc_mouse_close() were using maple_get_drvdata(to_maple_dev(&dev->dev)).
This appears to be accessing the data attached to an instance of
maple_device structure, while in reality this actually retrieves driver
data from the input device's embedded struct device (doing invalid
conversion of input device structure to maple device). After
input_set_drvdata() was removed, that lookup started returning NULL and
opening the input device dereferences mse->mdev.

Restore input_set_drvdata() and convert open() and close() to use
input_get_drvdata() so the dependency is no longer hidden.

Fixes: 6b3480855aad ("maple: input: fix up maple mouse driver")
Fixes: 555c765b0cc2 ("Input: mouse - drop unnecessary calls to input_set_drvdata")
Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
Link: https://patch.msgid.link/20260628230715.2982552-1-fuchsfl@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/maplemouse.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/input/mouse/maplemouse.c
+++ b/drivers/input/mouse/maplemouse.c
@@ -48,7 +48,7 @@ static void dc_mouse_callback(struct map
 
 static int dc_mouse_open(struct input_dev *dev)
 {
-	struct dc_mouse *mse = maple_get_drvdata(to_maple_dev(&dev->dev));
+	struct dc_mouse *mse = input_get_drvdata(dev);
 
 	maple_getcond_callback(mse->mdev, dc_mouse_callback, HZ/50,
 		MAPLE_FUNC_MOUSE);
@@ -58,7 +58,7 @@ static int dc_mouse_open(struct input_de
 
 static void dc_mouse_close(struct input_dev *dev)
 {
-	struct dc_mouse *mse = maple_get_drvdata(to_maple_dev(&dev->dev));
+	struct dc_mouse *mse = input_get_drvdata(dev);
 
 	maple_getcond_callback(mse->mdev, dc_mouse_callback, 0,
 		MAPLE_FUNC_MOUSE);
@@ -88,6 +88,7 @@ static int probe_maple_mouse(struct devi
 	mse->dev = input_dev;
 	mse->mdev = mdev;
 
+	input_set_drvdata(input_dev, mse);
 	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
 	input_dev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
 		BIT_MASK(BTN_RIGHT) | BIT_MASK(BTN_MIDDLE);


