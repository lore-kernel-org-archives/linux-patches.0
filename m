Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33944028F7;
	Tue, 21 Jul 2026 17:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654362; cv=none; b=V+ZX+g/8Koay7O5IOHXUDSL+h9roGiF5lwWsjypLad0QQvvWrK3vpgJpVLwL0/+cVhjoQr4fzYambQKjU00YJrWKTKBpHXBXH0TJAJLsQwqjqWhNGUq4AzS7KUgUg7PmrswxAo2b/y+PIVBBxEWMSrrZxzu2EEXjBgTurTrWIDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654362; c=relaxed/simple;
	bh=LHV2hsN7s/K+gksMT5Y/7hxAP5NleNapUDVWTNwTWSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPLxvkPnk6NyvX/UDDQvKHdswR8+n/kCzydCaeHqP4b1DgLyCUjUtI75WgFCfZNLTbYDExJU/JzYYC6pawN3zHzEn4+BUAPegaiYVCkpvX/9InuyNlO59HO6saliBBz2S5u2OlTr3aUreEnVKoYk0vnE6OAz59dvL751iacEeU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZrVwvxv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZrVwvxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547581F000E9;
	Tue, 21 Jul 2026 17:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654359;
	bh=7SRqSqmjsPp3B0XYaqlq6so6hNowBJ9wM3pMeCpRlaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZrVwvxvgrIDTqfo3/AbutYzIq5m8fRS7K/wZ5lHIu24s9jyBv5pZX+yoF5WRZtS7
	 bLdiiFDcockTEMQlIrBjRdjZRInXfYFdrn0b9C6puIEqPKd/rdnFIlETJStv+wkOUq
	 XetkGWXCMzeutMNlqKggQbBsGYEfjr9LuEs1PhnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.1 1676/2077] power: supply: max17042: fix OF node reference imbalance
Date: Tue, 21 Jul 2026 17:22:29 +0200
Message-ID: <20260721152632.276922148@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 68d234144b7dffd1f50b07ba74d0d6e833ef43a4 upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: 0cd4f1f77ad4 ("power: supply: max17042: add platform driver variant")
Cc: stable@vger.kernel.org	# 6.14
Cc: Dzmitry Sankouski <dsankouski@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260407123338.2677375-1-johan@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/max17042_battery.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -1254,7 +1254,8 @@ static int max17042_platform_probe(struc
 	if (!i2c)
 		return -EINVAL;
 
-	dev->of_node = dev->parent->of_node;
+	device_set_of_node_from_dev(dev, dev->parent);
+
 	id = platform_get_device_id(pdev);
 	irq = platform_get_irq(pdev, 0);
 


