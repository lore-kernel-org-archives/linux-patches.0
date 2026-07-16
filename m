Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EB041A55A;
	Thu, 16 Jul 2026 14:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211510; cv=none; b=MTHzo9z4twc4/6iaimwryAwy0vbNnRoSwkPKejdAfLyWrK4eySqsmHt1z3zTx5XWsP3Y/Lrs+pFaLQ5VVj5TiXaFj+PKUw/a0CgAhNE8N3XjAB0XvkyAX296M0ffIqoWbS/JDtRbTn98Z29c/tci9EEALn6XpvNXjPxQqRUX5BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211510; c=relaxed/simple;
	bh=lmrMsa2gnYAlfR2Gv0U20HsuWfiRkr2Nkrcdow6h33U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0eU3iwMQ+q7WqzpTaPeAGJFTPoYgWL9jVIZ42UEaNQvU8kMOklpoWf5MLbdLajUTAkQAnTGBCoRUBErLI+rp696p2diLxsgmxtJ3QHleeFQZsZ1oVdvoEIiXXSlL12Pzh3IrVi9bSf58SYJWM0MRi+abboHWcqrzOo+B7876yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jSVVC95; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jSVVC95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866CE1F000E9;
	Thu, 16 Jul 2026 14:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211509;
	bh=3pO7jNQvLJ069nGL6wQ2LsM6mkmb8wGHjvat4OZBSUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1jSVVC955ng7X6fvd7oCJYXdN1R87M4p7327jMaDEd3GSpQBwxxr2gjyLSchI8Poj
	 Rgw7edGOuDdNmZc7pVGFre1DQotGZNeXQnU97Zuu8DFK2l1EuPp/yxemQJSBx0CJEy
	 1P+fJg3RwofUfM6iPNh5BSH+mmyP9sBQvWMONe4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 454/480] Input: maplemouse - fix NULL pointer dereference in open()
Date: Thu, 16 Jul 2026 15:33:21 +0200
Message-ID: <20260716133054.643657328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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


