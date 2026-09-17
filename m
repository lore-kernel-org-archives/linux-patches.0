Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17817547041;
	Thu, 17 Sep 2026 17:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666421; cv=none; b=DQI46kmAfAwGSoRI2+6vwXmjmtB8DxTFF5BO3zigZfozNTDmOE0Ji9a3bzkdwemOAcw4L6ls9CvEZ8WZcR8zX/tr7uiYPpQFPrKQk78iN2OIeV3RpDTYxJ+OuTcumKH5TIExGHzQVEUOirJoETh7TFfLRyqyBnlHSCyCUj/HWws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666421; c=relaxed/simple;
	bh=SX+XFf71TVrJ7m/Mb9DARMqhky5fbsbnoDVMEtd+X7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhKN2tQesh69mTTcZqszGr+T2M5aScgURU4GV2b1k0IbycWT4Vi1yuC7Vp2OwkqH10EM+yAm1RRxCaJBDoEnwnmNAQbdOhq7yc5AacD4DLRC2HM5cO0VUMdjVLiWqd2BRS6HEICxG5Mh+VopxHhv2DXVqVMugKGFZllr495tXlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZT7Flgr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZT7Flgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7BF1F000FF;
	Thu, 17 Sep 2026 17:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666420;
	bh=rm0gLHzo3+G+39auXpcuwTY76gyVyFjQ1hN/D11KVdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ZT7FlgrWPE3yy3ZukZaehBqdiBhjF8Aqfmh4oo2C77sadVVxFGpfPgDHdQGPoOcF
	 8OI23bdgos7cU4ACLMpSKYuNc+ghi/ytceaIaxS8teZEOg+aXnkAIpRlNvgRlvAR3/
	 LRxtNWfHiQrpYp3konI5OQx9yoEaEBj1v8TQBV1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 6.18 1032/1250] ieee802154: 6lowpan: fix NULL dereference in lowpan_newlink
Date: Thu, 17 Sep 2026 16:13:47 +0100
Message-ID: <20260917151620.047262189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
@@ -150,7 +150,7 @@ static int lowpan_newlink(struct net_dev
 	wdev = dev_get_by_index(dev_net(ldev), nla_get_u32(tb[IFLA_LINK]));
 	if (!wdev)
 		return -ENODEV;
-	if (wdev->type != ARPHRD_IEEE802154) {
+	if (wdev->type != ARPHRD_IEEE802154 || !wdev->ieee802154_ptr) {
 		dev_put(wdev);
 		return -EINVAL;
 	}


