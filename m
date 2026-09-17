Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8730F49D59C;
	Thu, 17 Sep 2026 18:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671059; cv=none; b=pmaHhNylMiiOnTClN1oluFrvjmOl48l2DspiOTQtqQRVnYbabj0P9JC/D8xhDPgDAdT0qzhxuObMpiFzQTXQGyuO4mNSW5fupm0R5qAGZ+rjUd+pUm8JHQSiZzZ/eAHU0KQXR8uQJic2nvblbXceLvZoQ5meDSfE0x1V39rQxuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671059; c=relaxed/simple;
	bh=payvh8koTNOxaOcI8T+oHiqahN1sdHum1YPrEd60fNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEpkDaH/8RWvAjAgp+jwJt543ltoSKMcd0d9HSXKJhgxQRlgRo5DAnLj0dK1h3J2PK5NAS6JyteeZeG3fhEAqF0vbuHqI92idIBcCmBmVfHisuKzkw5W9whVJ/PNudVytKKKDUvpdVDDB1fHdppw60GnFUGiQpezOe1MSGebAfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNQNe7lI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNQNe7lI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155001F000FF;
	Thu, 17 Sep 2026 18:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671057;
	bh=WC5l+xPj400xbml6zJ44trr8BEQbDjVEp8R6JwLfd3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNQNe7lITSUt28nWoPrx0iSBK/tWlb2zURSMdfxHZ8rGb82QwMjvqTnqzH0FdgtFf
	 MYYmY4MMXQ6qog27BwcVPQs3e09Hwy1/NTDYD5kYe7xRk44bMfU1jdkQVTjG6JGgFD
	 rv5ZMun99P5WOcVZrl10LVVpxYakcAtO6vk0MiTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 6.12 0855/1102] ieee802154: 6lowpan: fix NULL dereference in lowpan_newlink
Date: Thu, 17 Sep 2026 16:13:18 +0100
Message-ID: <20260917151602.007473767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

commit bf79662bc85e820ac3b846e2f347da29fbf6ac95 upstream.

TUNSETLINK allows a TUN device to change its link-layer type to
ARPHRD_IEEE802154 without initializing ieee802154_ptr. lowpan_newlink()
checks only the device type before dereferencing the pointer, so an
RTM_NEWLINK request can trigger a NULL pointer dereference.

Reject devices without ieee802154_ptr along with devices of the wrong type.

Fixes: 51e0e5d8124e ("ieee802154: 6lowpan: remove multiple lowpan per wpan support")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Link: https://lore.kernel.org/0b715da69bd15a86ddc47dad5cf12da648211050.1787997209.git.zhilinz@nebusec.ai
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/6lowpan/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ieee802154/6lowpan/core.c
+++ b/net/ieee802154/6lowpan/core.c
@@ -146,7 +146,7 @@ static int lowpan_newlink(struct net *sr
 	wdev = dev_get_by_index(dev_net(ldev), nla_get_u32(tb[IFLA_LINK]));
 	if (!wdev)
 		return -ENODEV;
-	if (wdev->type != ARPHRD_IEEE802154) {
+	if (wdev->type != ARPHRD_IEEE802154 || !wdev->ieee802154_ptr) {
 		dev_put(wdev);
 		return -EINVAL;
 	}


