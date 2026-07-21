Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D672A42F704;
	Tue, 21 Jul 2026 20:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665616; cv=none; b=bfS/yo+K8e0Ga1/BkBYQ4UOF8C0UBbLPvZiIlsYNo2Npg9ZrUxPxScrGQYLfCqP+QEAqRj1m/co9OeQjf+AqvQaTZG19vCUtkHiKrx1aim7zjD+EBghjVjAhLCBh3MIvPRWtGjYVWRkZrgPr0xFhW1MI+CTWiZrKZeKMu6RkKqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665616; c=relaxed/simple;
	bh=2uXPnNg28SQhe64lAV8E1aOJE0Atel1TezxK4/KbGF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcXUU7tw6DbgjQFNzaC80RrTKDLnYOYUMnaO1BYLn2QqiHDAgOrHzoUfz8g23apGBzw9Xjbto9jzEQkqNgfXjj1w1R4SA5N9Nn26ud6RP3vrCxoUJMmy8VvDQ98nxH/BjO6+NNa7qEcc5m9J51m5Ksw1iv1pU2rUyOdjMkZroHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kX6i7UAS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kX6i7UAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058051F000E9;
	Tue, 21 Jul 2026 20:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665615;
	bh=HPqG9BkbPhYn99JCFyUZd6fFzlbKjVuvXcP+Sj3m9Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kX6i7UASo8/z4zwoHV9XUnoKzSei2RSL890Dua7Nm0YmJZFw2Egr8dUJUgMCMQf9T
	 P8oPW7f6a1oellb45LlPsC4DokDqto1/0JPb/Zo6/bW47pQeIibPCJNTEztKOEsdSK
	 LFWKhOTXJpN/xIvBsvgLSai9lv9K4BWPWZ1UptRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0318/1266] Input: maplecontrol - set driver data before registering input device
Date: Tue, 21 Jul 2026 17:12:35 +0200
Message-ID: <20260721152448.955255665@linuxfoundation.org>
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
 


