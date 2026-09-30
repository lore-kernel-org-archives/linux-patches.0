Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACEC4FB9AF;
	Wed, 30 Sep 2026 17:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788751; cv=none; b=CVex2utDvr7ocKO+WItOdrZBh8zgteZlYgyswoyIDDBPabtZ837DOFOml7kYhvWQsVvdNmHwVJpEl0jIWJQGZCIwB1q39/JmHHYUUtf1PY2tRGlkOmQFQYnUW0rE7xwvRB5gMLQDahhW8Zg3QI4qilVLEUQzv2UZ+J4wWsJnuzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788751; c=relaxed/simple;
	bh=aokAEZgYIOD7TchfSuPnVBddyeDQ/DHannT6KTcjIk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bqY5B6n6DqOQ8GAZaKmkmecUP1ReSxRwrQBBQ1xMFf5Ok4Ql8CpnnNY88aT1X7RvCtsklMIuUjfSZmMyw0fRAZFxuUohOTeHFVJ1WXfpALdURFIRIpUkV9yI0HO7v5k3yLzADi2dlN4B6CyeuACxOMU5ArPsrxfnZOZq6HTACGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL+ENqD2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL+ENqD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C3A1F000FF;
	Wed, 30 Sep 2026 17:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788750;
	bh=yVs8Cug1fD1WNburKSrhbBUAD4TTmam7rFBbfx8e/z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eL+ENqD2owP2dWNd4zUzZp5pdWVZvwNYwfLTEx+jWZe0y+6r5iDpMybV5mPOGPHbp
	 mSBHepxSTN5U5Ttcpzz7cPxltdd7QUxKPshzxB89/X4Oc/Mg/lJ0JkInt1khh7X2fB
	 U9EmmRVxny+W6XBxTA/bhjVcQPxR+zDNI2WvbcI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 235/877] Input: adp5588-keys - cache GPIO state before registering the gpiochip
Date: Wed, 30 Sep 2026 17:19:06 +0200
Message-ID: <20260930152419.798247571@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alvin Šipraga <alvin.sipraga@analog.com>

commit 21efadc62272cabee9bec27777ae75d84a9ca8a8 upstream.

So as not to clobber any pre-programmed GPIO state in the execution
of its gpiochip ops, the driver caches things during probe time.
However, since those ops can be called both during and immediately after
the call to devm_gpiochip_add_data(), it is imperative that things are
cached before that. That's not the case right now, so reorder the two
steps to prevent any clobbering.

In the concrete example which motivated this change, a bootloader was
preconfiguring an important GPIO output to HIGH before booting the
kernel. Linux would then inadvertently set that output to LOW while
configuring a GPIO hog on a discrete GPIO line within the same 8-bit
bank (because the cached value was 0=LOW).

Fixes: ba9f507a1bea ("Input: adp5588-keys - export unused GPIO pins")
Signed-off-by: Alvin Šipraga <alvin.sipraga@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20260818-adp5588-gpio-cache-v1-1-650a2674fc0d@analog.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/adp5588-keys.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -446,12 +446,6 @@ static int adp5588_gpio_add(struct adp55
 
 	mutex_init(&kpad->gpio_lock);
 
-	error = devm_gpiochip_add_data(dev, &kpad->gc, kpad);
-	if (error) {
-		dev_err(dev, "gpiochip_add failed: %d\n", error);
-		return error;
-	}
-
 	for (i = 0; i <= ADP5588_BANK(ADP5588_MAXGPIO); i++) {
 		kpad->dat_out[i] = adp5588_read(kpad->client,
 						GPIO_DAT_OUT1 + i);
@@ -459,6 +453,12 @@ static int adp5588_gpio_add(struct adp55
 		kpad->pull_dis[i] = adp5588_read(kpad->client, GPIO_PULL1 + i);
 	}
 
+	error = devm_gpiochip_add_data(dev, &kpad->gc, kpad);
+	if (error) {
+		dev_err(dev, "gpiochip_add failed: %d\n", error);
+		return error;
+	}
+
 	return 0;
 }
 


