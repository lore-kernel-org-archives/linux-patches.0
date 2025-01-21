Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40B9E571;
	Tue, 21 Jan 2025 18:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482445; cv=none; b=llhBMKf/XC3oWzFuzjbGSObxy1ttwVMMd8q+scfRE+Dkhr+1CWpRgBwC0oMFPkubXuzB03CEkPnKHLUSA83Cw7RLnh1IR/cKxKWgsWqNAtXVKZF2auSlDwxpiW23bzzzAhd1sd/ZdaYO2UZ7c7Wh+5Z7U8DIw3HcjjEndeVZkls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482445; c=relaxed/simple;
	bh=lxNB6wjNj9ivgM16p2AVrmX/ai1uVuOVsAUGi+LZUHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWg34UYYcmst39trxYXh68WmnkATwtdqBWr3Yrt2VaheG1oLZ/dwgeLO8QtJ2okbiHywlTBKYkM7QN5O2UPXYOgndQSCxFNfuJi5KkMN326ir/BLpr880mFLVwQ0rI2buE0RIsnkUq+mSDgG+NkPX+WW6v3U6ia8hsMAO58TVSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpErZ6YY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpErZ6YY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD467C4CEDF;
	Tue, 21 Jan 2025 18:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482443;
	bh=lxNB6wjNj9ivgM16p2AVrmX/ai1uVuOVsAUGi+LZUHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpErZ6YYg02IPUHpR7uQhu5dkX9dVj6IJUuhtziTI1GJpTOGW6E9PAtZ11ri0E5OD
	 S6sj7c6kJTtfFEthyV+wSHe2vnbrqf4L9OmOoyl40CrsObqD+ykHt3sxmN6DtOVuCs
	 ZmXXEPozJ8SuB/Dy0iUhVV6MnzHEyV9XLxx+YCN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.12 079/122] i2c: atr: Fix client detach
Date: Tue, 21 Jan 2025 18:52:07 +0100
Message-ID: <20250121174536.057648686@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>

commit cefc479cbb50399dec0c8e996f3539c48a1ee9dd upstream.

i2c-atr catches the BUS_NOTIFY_DEL_DEVICE event on the bus and removes
the translation by calling i2c_atr_detach_client().

However, BUS_NOTIFY_DEL_DEVICE happens when the device is about to be
removed from this bus, i.e. before removal, and thus before calling
.remove() on the driver. If the driver happens to do any i2c
transactions in its remove(), they will fail.

Fix this by catching BUS_NOTIFY_REMOVED_DEVICE instead, thus removing
the translation only after the device is actually removed.

Fixes: a076a860acae ("media: i2c: add I2C Address Translator (ATR) support")
Cc: stable@vger.kernel.org
Signed-off-by: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Romain Gantois <romain.gantois@bootlin.com>
Tested-by: Romain Gantois <romain.gantois@bootlin.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-atr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/i2c-atr.c
+++ b/drivers/i2c/i2c-atr.c
@@ -412,7 +412,7 @@ static int i2c_atr_bus_notifier_call(str
 				dev_name(dev), ret);
 		break;
 
-	case BUS_NOTIFY_DEL_DEVICE:
+	case BUS_NOTIFY_REMOVED_DEVICE:
 		i2c_atr_detach_client(client->adapter, client);
 		break;
 


