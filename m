Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA4B2D8378;
	Sun,  7 Jun 2026 10:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829404; cv=none; b=JK2RK/LaQAKm0nlmzQiYAcKgd7VFUs9x3fQiSjzHqP/u5BH0NGXtaEv9TjSCS4/IPAANeT/jTHS+HxSx2qL239P/xH5TcnXwPKNUX+8Y3VlTbUYmTUvC/wO98lsxftF8Ku/rl11HBTHEsFxB9U5M/95/apingLpPYpqyXT1lN60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829404; c=relaxed/simple;
	bh=PzWQ/qh8PtmNxocsCEZTGpIC6ZC0Hp7n78HAKIiUfJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QV1sMMA6jJ803mwk6KKqmWDYzqoI46nABv9UvY1mfGgD0gLvo0D7RnFMefty/lTtLwG84QwZqq9zPXrhW8fNN/FnH9pAm6sUUMjN5GO6LD2s1yo2Y4PxPcbv6E8V/7jvDrSdSa02owCTDQfEaIl5J6ynn6rDY+fDOLMlWgfiri0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxzDFj5Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxzDFj5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120A71F00893;
	Sun,  7 Jun 2026 10:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829403;
	bh=oYJwRtJO4sfiTff5UajtZGBbxHxS1NukCaHI8flAXhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dxzDFj5ZjcPdbSI/UYMlaI+gj1tKLRMcW/XCYqKfMaJaIqjBej5FRpq+mj1usXZ1g
	 VHTxZIREeZtLDl+veQgeSAmY03hk0xT2V2WLjp8r5eTg4zMIFE80Q5BeYqZdYjgCNe
	 kSUDF3ZHxAaQzC1GxbZwhevuGHyKd3XieRcuElQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michal Pecio <michal.pecio@gmail.com>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 6.12 221/307] usb: usbtmc: reject interrupt endpoints with small wMaxPacketSize
Date: Sun,  7 Jun 2026 12:00:18 +0200
Message-ID: <20260607095735.829207870@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Heitor Alves de Siqueira <halves@igalia.com>

commit 121d2f682ba912b1427cddca7cf84840f41cc620 upstream.

The USB488 subclass specification requires interrupt wMaxPacketSize to
be 0x02, unless the device sends vendor-specific notifications.
Endpoints that advertise less than 2 bytes for wMaxPacketSize are
unlikely to work with the current driver, as URBs will not have enough
space for interrupt headers. Considering that any notification URBs will
be ignored by the driver, reject these endpoints early during probe.

Fixes: 041370cce889 ("USB: usbtmc: refactor endpoint retrieval")
Cc: stable <stable@kernel.org>
Suggested-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Link: https://patch.msgid.link/20260505-usbtmc-iin-size-v3-2-a36113f62db7@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -2444,6 +2444,12 @@ static int usbtmc_probe(struct usb_inter
 		data->iin_ep = int_in->bEndpointAddress;
 		data->iin_wMaxPacketSize = usb_endpoint_maxp(int_in);
 		data->iin_interval = int_in->bInterval;
+		/* wMaxPacketSize should be 0x02 or more as per USB488 Table 22 */
+		if (iface_desc->desc.bInterfaceProtocol == 1 &&
+		    data->iin_wMaxPacketSize < 2) {
+			retcode = -EINVAL;
+			goto err_put;
+		}
 		dev_dbg(&intf->dev, "Found Int in endpoint at %u\n",
 				data->iin_ep);
 	}


