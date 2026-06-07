Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56551FE47B;
	Sun,  7 Jun 2026 10:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828296; cv=none; b=g4Pb8XQomS3iJYrE+NMtk9YgQjuXWtSzJfYHsJNfeQQGOLRlkdBupIbTOIB76VWMWIStRyLKyiEAlczaUkF7MxgJ8ZvZNlqzun9qIFxsqgqR67f4qP6q0CpztKfnsF+pSqlDbuJGgTEiRyM+OtYPdnHp8MiQ4oNbiOkdAnMLPkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828296; c=relaxed/simple;
	bh=UWZmPzdR6U9qYK0CTuPV71f5M+ho1V/nLCBkrImga/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ko2KzZaAB/71tHiVClHWl/PpFgvOwYAhcfvvBKE7tNPEh6SNg2qFMWcXpNMtz2KhAe0AxcCGxB0NL1xaAhXrhGdAQAbeNYEHGl2T7iQrhe+y5MKGWnkvPIEjQThmX7sNP2aa7wCW4m1Wcia/4Onbb5JV2IKD+Uz7/QPyTSntO4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UetzhT8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UetzhT8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E66F1F00893;
	Sun,  7 Jun 2026 10:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828295;
	bh=Hm5DSxfyVesZWi5aPs4veEKLCfDdTmRqHNMhrQ9nmGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UetzhT8YMMuOPheKQjBsZDShJeCOXt1Im4b6M0xdmZutNZHLR0nevPpIwzS5yfliD
	 1bdDKaqqYqXj0sDkEGdNP5gn21fOyBPWlMLlOlOcWh52vpTjmjTrSO48GGp/EikK6E
	 4WGkwNtSkdE5qEGQFnQUazMxrtWeYYXQ5vqlhM9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.0 170/332] gpio: shared: undo the vote of the proxy on GPIO free
Date: Sun,  7 Jun 2026 11:58:59 +0200
Message-ID: <20260607095734.306041030@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit bbec30f7e19d9a1c604da7164b8057ccee590e72 upstream.

When the user of a shared GPIO managed by gpio-shared-proxy calls
gpiod_put() to release it, we never undo the potential "vote" for
driving the shared line "high". In the free() callback, check if this
proxy voted for "high" and - if so - decrease the number of votes and
potentially revert the value to low if this is the last user.

Cc: stable@vger.kernel.org
Fixes: e992d54c6f97 ("gpio: shared-proxy: implement the shared GPIO proxy driver")
Closes: https://sashiko.dev/#/patchset/20260513-gpio-shared-dynamic-voting-v1-1-8e1c49961b7d%40oss.qualcomm.com
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260522-gpio-shared-free-vote-v3-1-8a4fddc6bedb@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-shared-proxy.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpio/gpio-shared-proxy.c
+++ b/drivers/gpio/gpio-shared-proxy.c
@@ -103,9 +103,18 @@ static void gpio_shared_proxy_free(struc
 {
 	struct gpio_shared_proxy_data *proxy = gpiochip_get_data(gc);
 	struct gpio_shared_desc *shared_desc = proxy->shared_desc;
+	int ret;
 
 	guard(gpio_shared_desc_lock)(shared_desc);
 
+	if (proxy->voted_high) {
+		ret = gpio_shared_proxy_set_unlocked(proxy,
+			shared_desc->can_sleep ? gpiod_set_value_cansleep : gpiod_set_value, 0);
+		if (ret)
+			dev_err(proxy->dev,
+				"Failed to unset the shared GPIO value on release: %d\n", ret);
+	}
+
 	proxy->shared_desc->usecnt--;
 
 	dev_dbg(proxy->dev, "Shared GPIO freed, number of users: %u\n",


