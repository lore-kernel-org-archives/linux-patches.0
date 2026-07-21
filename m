Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DEC44AB96;
	Tue, 21 Jul 2026 21:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668732; cv=none; b=HvZ6Yhx8Y7q37AXYA4ew0jUwoK+6Ye3ZZX/ASPl5EvzB+g9UpRE6WMJ0cO2qNkgMh1uxIAkdfGZxDdlFubnrSfQrUoLiED4qqdmhURLAs4MRyQYVHecWlfW0j9XrcnpE1d/92fyu84RMExPJGM8db7irhKMD+dGmBv2LWY55FuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668732; c=relaxed/simple;
	bh=EuKiU5LlOo4Ok+COzjWe26up2N5r7OaI9p/buFskhqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPt1USwPpXrh3pw9SV12un2OIq0uAuXMXcE7wNtCfweSwm3DJSIpHHYeQY/jumfx8SbSxnjDna9TtZV/bIja3Ai/2KzNkYHj5XaUS/gr7GEUX7qHYeq9nuq5kllGW1Xvg72FbgBrBti0byyNAUIaASDoczZu51vO5OGV22GQxM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZfIC8h/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZfIC8h/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A82A1F000E9;
	Tue, 21 Jul 2026 21:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668731;
	bh=sZULFIlZFpKd6DxXrj0+0AHamT3XnsRtq4yrVvClaRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZfIC8h/qhhDs5aZJ6l1KfsnOg9yLxXFbdBd0XbWjOIFufvfqWm/tCtyyLWsx9qMef
	 z/LQlGO5K/FywRmxXfp9xqGCLGuc0y9/+HSLLWyVwzWmgTqn0TXHC4kvHzm9UWwWi6
	 ReuFGjig/VkexNI7RD1+YeUZz/wP0tL6AsFK+fpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 0244/1067] Input: maplemouse - set driver data before registering input device
Date: Tue, 21 Jul 2026 17:14:05 +0200
Message-ID: <20260721152430.058725943@linuxfoundation.org>
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

commit 738f24bbbc95dd50cb4229d1ed62a05f29db2bda upstream.

Set maple driver data before calling input_register_device() to
ensure that it is available if the device is opened immediately and
the callback is triggered.

Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Tested-by: Florian Fuchs <fuchsfl@gmail.com>
Link: https://patch.msgid.link/akNXw45L_8bxD6QV@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/maplemouse.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/input/mouse/maplemouse.c
+++ b/drivers/input/mouse/maplemouse.c
@@ -88,6 +88,8 @@ static int probe_maple_mouse(struct devi
 	mse->dev = input_dev;
 	mse->mdev = mdev;
 
+	maple_set_drvdata(mdev, mse);
+
 	input_set_drvdata(input_dev, mse);
 	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
 	input_dev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
@@ -103,12 +105,12 @@ static int probe_maple_mouse(struct devi
 		goto fail_register;
 
 	mdev->driver = mdrv;
-	maple_set_drvdata(mdev, mse);
 
 	return error;
 
 fail_register:
 	input_free_device(input_dev);
+	maple_set_drvdata(mdev, NULL);
 fail_nomem:
 	kfree(mse);
 fail:


