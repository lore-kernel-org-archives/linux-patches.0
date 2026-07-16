Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8358722301;
	Thu, 16 Jul 2026 13:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210317; cv=none; b=W+hsWsvI9W1OPNOib1WLc6fup5a/Ik4otOxn44VBGt6BSU7lhj7iB77Rgt1t9+Zv2Kp04RBCtZU1ANzyy1G2cJEGf+vbfIdII7Xj7uSlyzNLqYeDSLwfYJX6OTYfZn83gyrB39Iq9OJYeBi4MqfUR3Hm/i7evpHKoAgJNQKOarY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210317; c=relaxed/simple;
	bh=18Y6kkt+JuzC9CNkL4COygmBMQL9Calo4SE9qA80cjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAEI5crF24f02sGRb0+1EzfN9AK5/4z48y8xnvk8G1DM9zbaooH5Di34TYaV1YAyQZNGHNfy3vP17cAh+UNvSiBqjqZ/KS9+mkE2vk/9nS1IHzSwF8OwA4OOgasob7qIiSL2s1fWW8qa3yhALUFwqFjDZ+49v5tCeoNN0Sfw7nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdFABHSF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdFABHSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E964F1F000E9;
	Thu, 16 Jul 2026 13:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210316;
	bh=T7mVmlBipLWfPZDNvq+hr8z+KKLKwxWX8U427XYjJ6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PdFABHSFPJiIVMUEF2kmbN4XInWh+qQj1PxQRDNmKabOIXTjeln+cvlJP3IhGd19o
	 2KL5QHwUvtWHoffC2K8P83qmORuNQaZEhxRXZVKXXdABNKke811NXAEPqaVAowdWzV
	 5Nt3x3mg/b95kx7/91XkAbjIhl+ncvW5WeJ11Guk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 494/518] Input: maplemouse - set driver data before registering input device
Date: Thu, 16 Jul 2026 15:32:42 +0200
Message-ID: <20260716133058.653071217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


