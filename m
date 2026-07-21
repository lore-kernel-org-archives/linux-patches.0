Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B04F47044A;
	Tue, 21 Jul 2026 20:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665476; cv=none; b=NKnZdvJ0mAYCVuVnycsL315y/fw2pxN9rSfPny0Ye3jOIGeXnPsjFIn2EKrFoPwf/nZxF3XvM/dR8uHapU7XXMntCIIxjrNuxjIyvg5FIRWvy9UUa4nbsGQYTEDOSZtMM01Y6WkdR/v91zXoAHPOsJ9i7IB6EfPRiU3WcbYE5sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665476; c=relaxed/simple;
	bh=Nex07NwKyY218aDhJXE03KMQ8WRrlENrncGKFr7XZ3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Io/xQmQZGhtyn4kuvTbRdk2rY1HEyNivm4qchzPwQcgasy8pZL0/i1HVL2JWW4S7TJmP84GIZx66+3rM4LqLYAmCkp2hn0vT9tjLeCFeNf6WnMu3N0Q7PmJdQcNw2uaxboq4rQOqc5kyHb4Q1o/gQ2W9SFrcnTPwXQKPd4JtTdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1pf4lJ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1pf4lJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA361F000E9;
	Tue, 21 Jul 2026 20:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665475;
	bh=9nZfZ0KUBEVTS+NpaUDPNgq1PoirPwX/lX0BuujcfVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C1pf4lJ4r9pgfm6dZ4B1/xqJ5nyx2FOlhebcQUAdJNFlrV/TQEE0adMuFRpbz+hI2
	 yAtcbrzZ0tfx0AhG5TSDmavGVftkCnAA88SfgT8XMRjn8Y30dyBY4xNjCPjBy0475M
	 mgJLpPsGZWxulEdRk08Y9mWd0XiKXG3Ci5k8j7H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0316/1266] Input: maple_keyb - set driver data before registering input device
Date: Tue, 21 Jul 2026 17:12:33 +0200
Message-ID: <20260721152448.906992211@linuxfoundation.org>
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


