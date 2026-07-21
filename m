Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138933DDB03;
	Tue, 21 Jul 2026 22:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673411; cv=none; b=Rxec40pRkZsQXPxcaIuT8NWahA1ThCI+paUC8gql/PayZbZbAB45prA6hMiYr9inKfadHIN5vjzTL4c2/GX09gt2UtHma7FtXOX0akPyVCyinvu8p4/wddzxFpHl0eGSGCsCjlgRJM6QoNzLukfZ9iF9Kft6saTY2gEBC/NSBVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673411; c=relaxed/simple;
	bh=57YqnaXjMxmpq8USdtE5nD6BW8yhYlCs/9MkCWu6DrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eH7/rO51tmUFVYJMbyNs3Q46rZya97AivjrwuPI/n8jm0V3VG0DxFaIF0+4pHsZH+VNEij3BLShCXh+0TLNmDZm9mgXrytxvwnUqP5uUKFST9LRRymCGAohFdqU3iMrE61zNRYWYnfvsi17NUMfVBHZgNFZAnrWSOrnMCbiP1R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CqTTjbQV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CqTTjbQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BE91F000E9;
	Tue, 21 Jul 2026 22:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673410;
	bh=vw6ldJWqhESW9iJ0wdt4RY2ZWlauoDOIBjAaudFGpKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqTTjbQVmpL9Sx3tWws9Ynp0z24qX6anTZ3TfGK0eGyN+oohMMGc9Mo6UuGPiwit8
	 lMs42YapokUmxLfzFH72qH47i7rWSfnMVGT3g1Xj5oYq/72P8bBTm3GempfNBAJX7H
	 VsAOir8FYvaAoDJP1y23kGLpgQ1fJu8UB7c8zGUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 152/699] Input: maple_keyb - set driver data before registering input device
Date: Tue, 21 Jul 2026 17:18:31 +0200
Message-ID: <20260721152359.130759082@linuxfoundation.org>
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

commit 536394ec81419b67d9f4f0028812c4372397be1b upstream.

Set maple driver data before calling input_register_device() to
ensure that it is available if the device is opened immediately and
the callback is triggered.

Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/maple_keyb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/keyboard/maple_keyb.c
+++ b/drivers/input/keyboard/maple_keyb.c
@@ -169,6 +169,8 @@ static int probe_maple_kbd(struct device
 	kbd->dev = idev;
 	memcpy(kbd->keycode, dc_kbd_keycode, sizeof(kbd->keycode));
 
+	maple_set_drvdata(mdev, kbd);
+
 	idev->name = mdev->product_name;
 	idev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
 	idev->keycode = kbd->keycode;
@@ -193,8 +195,6 @@ static int probe_maple_kbd(struct device
 
 	mdev->driver = mdrv;
 
-	maple_set_drvdata(mdev, kbd);
-
 	return error;
 
 fail_register:


