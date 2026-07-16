Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCF330FC33;
	Thu, 16 Jul 2026 14:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211518; cv=none; b=lA/OKGdb5Z7RwqH85XG/dqvt06I7T4BMfiuGhMvGTBZl2dzZKl3P2ldBE49ZfFwNXW6pYOcoWja+9EoJ9FAZDavEr1Sjo/iTNubIbhwHt9NPfZDRLihpxGDdNXq/+obI3bGa9bvRxTamx+LiFKrqlfctRhB/4q1dItaN6w9T060=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211518; c=relaxed/simple;
	bh=r+3YLoFGGhn8xkm5+PdKDHAWEiw2KLJdUnWKE9otCY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeplGWqafkg7bazNGvTLIZmF6ZLB/HH0sBq0IHS4xCUB/UgE6lxWXvqZei0XwN6OUkoZkmIlpkFydth7eOlZm4uuoHPdJQRo6w2WZy17R7JaYq7vMqRTOPX8lHakC95X6vZQbE6w61KcZlUDeKhICrer4NTWJneg8tcap2ar0II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkUB3QCo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkUB3QCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E631F000E9;
	Thu, 16 Jul 2026 14:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211516;
	bh=rUCD5gSlnglD3GutkW5IpjtoS4KkRSYB1ujJPwZFPj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SkUB3QCoDvs+tYN8hZfXo19EujNgBws3reO7ypQGCKUD8fKCTdW9nyduJJmu0E/F3
	 IwlPCe/dK6yxt/LoDROyYpD3dIweaQy8WPnLCbYKhH8SGM6iWc6QriDMIJZICl5u1R
	 wywI2ad3J3SL7dJWWRryBi8ENqy9YQl0Da12pMMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 456/480] Input: maple_keyb - set driver data before registering input device
Date: Thu, 16 Jul 2026 15:33:23 +0200
Message-ID: <20260716133054.690042855@linuxfoundation.org>
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
@@ -166,6 +166,8 @@ static int probe_maple_kbd(struct device
 	kbd->dev = idev;
 	memcpy(kbd->keycode, dc_kbd_keycode, sizeof(kbd->keycode));
 
+	maple_set_drvdata(mdev, kbd);
+
 	idev->name = mdev->product_name;
 	idev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
 	idev->keycode = kbd->keycode;
@@ -190,8 +192,6 @@ static int probe_maple_kbd(struct device
 
 	mdev->driver = mdrv;
 
-	maple_set_drvdata(mdev, kbd);
-
 	return error;
 
 fail_register:


