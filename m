Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626D01F63C4;
	Tue, 21 Jan 2025 17:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482120; cv=none; b=iKpSY9RSfRTX6imxTraLTtJ2zFwwbLiHKDAP4ViDTd7Ld/wkwrXa5uyTw3XdvWQDGIJ87q1v+mtyGsmypeVyi04wPLnythNMv69PKCWF3pGTTr+yaWWiUq7pCiSsD2A9ZjEeUiEw9QQf1YdrNIPT8FDddq2gqoHt9GcoP+IztZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482120; c=relaxed/simple;
	bh=nBkRJmcWaRG8n5NTTnI8f56I2/NgzX84fKLkMV5T4xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBVV/mT46BpfNJ63tC0f1Ax9H9tjbIpt8rfluGkoASxKDhnO60uOd6kPl0jJjkgMhjrI2nQNjjqyCR7TvLhALjOh/2jNvBRc3CXF7IsB1VwhegVBM/IGlDtFM/LsOQSTQY8dg8qoQ4N94kHlVUTyHo68CMXjlxbRUTbBkgd1R1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRUn2fI6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRUn2fI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0D8C4CEE0;
	Tue, 21 Jan 2025 17:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482120;
	bh=nBkRJmcWaRG8n5NTTnI8f56I2/NgzX84fKLkMV5T4xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRUn2fI6tHszIYaQkfKpfV9grXDcasggNQRDWGmQFtyNWU2qZVtVpo7oP2Rkae9cD
	 CYQaMRo2NgboAYbeFliKitBsQBIlNdy8YM2V00KpmkySB8bJZeR9ODAd05C0NuFlv/
	 Zrh2CLOqU/7aej/Qa1HAOACV22RAQqyD0BppWOr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.6 40/72] i2c: atr: Fix client detach
Date: Tue, 21 Jan 2025 18:52:06 +0100
Message-ID: <20250121174524.966219903@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


