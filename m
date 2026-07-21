Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A087342EEB8;
	Tue, 21 Jul 2026 22:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671288; cv=none; b=HUktVByYOul1ncRFEStHJDxEAAO4T4STKIzOAadmv0u8mfmyBNVzAVOvlNXat6Uxud4Dka5teREMj8dTr0nFgv5zJmDFnLtQWQO5MtZbSYb/JKONTNxD624PRMLyeN4LhtBlywlr7/EV2Fi9in/OfCVd9K8GQplEyqiLvd28NdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671288; c=relaxed/simple;
	bh=Mg47zu3a0OaN677LdB5QK+zefyRhTlbEyDtxcwC31wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZE8gBWbGPeoqhajvtAJ4QnKkZnW+ATQXcVJydoHrSjwGmfzDDZOtq4bAc/Ol29HdKGzT1CELBW0Up9ej/+9ol+/KRo/7LVeO0pV80ro+QAm2c75PA+c867sps4A8C57lP3/eR04MpeYrQ/9QCb7bUqXhip57toHQ9vhH1p4BIPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gjeANnm2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gjeANnm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889F31F000E9;
	Tue, 21 Jul 2026 22:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671287;
	bh=s4CbgjfWw1m9254RtvyaiNOXMM9wEaN+LPhkODIw59c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gjeANnm2nhV4MEioETUKe3+CPTKEvMUrScZSWwM+CF17jqqweVWRIbgTfN5Ow/AXe
	 5GqgF3txkSECru5x8xUAFvaBc6LSBXxhwNDDd4+AhwtsI7UFoVZtiBwW5eyo75hs7T
	 p9wvKpp2KnRbDgeyEwqW7EstcH+w/4LrfhUGwZn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 190/843] Input: maple_keyb - set driver data before registering input device
Date: Tue, 21 Jul 2026 17:17:05 +0200
Message-ID: <20260721152410.288460679@linuxfoundation.org>
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


