Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A3C3B0ADE;
	Thu, 16 Jul 2026 14:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211520; cv=none; b=Na8bucobj9om9X8RwqZAK7WkaaxkKnkJEn71ksVMQB2c9hmoLo1q3Vt7Z3h52OCjIcnb96YhBqmNSF4lJ96Llfp8Y5HRTmaQcNFXvY2KzM3Ukw5LEMMwikOdvam++/SPk0cwxnM6OujuyPLL8WSRz6zOSD8eNl2V7K+WQWagdSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211520; c=relaxed/simple;
	bh=FKfpQbfFkhxoPsU5Hw/yfXPGdgWsjWFEZGApJ4fcTbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvDlvqa0fZGwF0TSCzgdCksJdp3ZGIS8C6LrbKW94D9chR9ltLkzyW2Ati8I2sfyA8jzcgTpwU4D2relmqsCVT/McJSvm0QPEhP4SIfRe9Yg8aMxsXtLlpdV7M0PAzKR8OJKVIVmNYFj9rA72jFfB+dNn+QP60FpvjlFm6O3+SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyD+Y/sO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyD+Y/sO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AFE1F000E9;
	Thu, 16 Jul 2026 14:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211519;
	bh=uhkd/X6ejbA98n7PLMM+CIb+pDs+kEJPLNi6U30GD8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kyD+Y/sOOXjRlT8HArjF+DcODRqDNJkwURO7Qbriu48KNID0MK2/EbyqymvapkmQp
	 1s1FGs/eWcddOVnzUyITFEdwioF//FOXlYovfJowsQsd9kMZe7Q/QuOLJe8oXc+7MM
	 TaQbUNijjUgBZsbRoeVIP1Jt8KUv9YPQGyx971xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 457/480] Input: maplemouse - set driver data before registering input device
Date: Thu, 16 Jul 2026 15:33:24 +0200
Message-ID: <20260716133054.710957276@linuxfoundation.org>
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


