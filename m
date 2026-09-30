Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F5830D401;
	Wed, 30 Sep 2026 19:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796387; cv=none; b=nw83s7M3v+fzIGFkQj9O+rPUJpEiPMOB/aGH5XDorJPS7GEZCssBznTraIAX0/pWU9ggkX88GUxgdvf8+F4B5CWeqCXipWLj1skPa44+03F7/zA6bny7O6M6P3xJWSXLeuM+E8MX5mD70WO1KTYMfRUVYT3iSUzi/h0M3ScN/Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796387; c=relaxed/simple;
	bh=QAvy74FN7IAjSO9/jnE9FQzhKD8lLRA+q+1Fi2V03TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r/HYw/JYziQ3XLrQdqp6hJosl2teMEVgnJgXpaPALzbKrec0BFH6L2oqPnCtM53XSxUuo12OLv29gKrUX/lazM60saTN7gY61rJWGKLr7+DaWOC86qS72ZwXzHxZvVDJi8/dos1nFEjSmFgHkzKhOQTRrN7y5gOZif58q7MPepU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Br4nJTeT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Br4nJTeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863081F000FF;
	Wed, 30 Sep 2026 19:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796386;
	bh=LyhJvUNQNBeLnaJOaNEiM0DL9RpyZ/ED7qJD1o4+sWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Br4nJTeTkmHZCRVuLu3u0ZXVV1zQ8c80GMJZzg9cyDi447aZugkosKWfrHnYAc7Ld
	 l5uf4XpZ3PSuS6zMFdARo0SyrXqwFlQlYHwrRSM7nQneaSEF7KuOrECMaCrALIbPR1
	 Nj9xJeP7+OvjsL1MNAbVbTCushAoMGVD5Wvd7l6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0893/1193] Input: adp5588-keys - cache GPIO state before registering the gpiochip
Date: Wed, 30 Sep 2026 17:26:17 +0200
Message-ID: <20260930152454.083582638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -453,12 +453,6 @@ static int adp5588_gpio_add(struct adp55
 
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
@@ -466,6 +460,12 @@ static int adp5588_gpio_add(struct adp55
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
 


