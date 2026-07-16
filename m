Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0F5319601;
	Thu, 16 Jul 2026 14:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212477; cv=none; b=uUvvzpdqY+Xhn3AP/NScGi/0sgGMDgnvkzXwMz3wXAomdY3P1Z0+GUF+ObWDG6P94Eq/ts8gcq4dYk5zzbGnpG3hFAE8GPU+XAfVU0NBebWpOzg5Gy5zP80wMyjLGmMMYCSVJ2WEufoT7EYKVeKOfvCHc0iUfCtYrds9rA2P9h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212477; c=relaxed/simple;
	bh=Ktpasy7Jk9DnUCrY8g59EB/aeBq1fKQ528XbMecr/v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQu1FM/26mk19MAvFvzas0E1HTrHudJLLFSQrP1OTiWJb+PIzl7XpIWkzfQzuqo5h8X/D3Be8aHwLgBs5mFUkwzcSfl05gQZCQjU2rcVmVCc59hZSWiTdD7Hbuh6NyCHshuExgxPi+TjSopmHgux+hhgEfxyv5LBrSqodbWX4NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmfz42X4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmfz42X4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38231F000E9;
	Thu, 16 Jul 2026 14:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212476;
	bh=wbAOkp75+L2b8miBAF3z7H0WEtm62vkCcIV8HvAbKxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmfz42X4u3NemQgH0IM5e2hylktDgjMrWK7So6LdVjVMEnLjWaQ6WF0Xw8jcTnLF7
	 UeQPrFPeT1VFH6K0gRBXt2s6x0JiBiGLdlOtiF4OZRvIvmbEreK0nw2KSAmxWBteOs
	 zjMlKz8Ps1RWecUdXdoFB5ua62nvA7OadJjggJ8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 343/349] Input: maplecontrol - set driver data before registering input device
Date: Thu, 16 Jul 2026 15:34:37 +0200
Message-ID: <20260716133040.983592580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


