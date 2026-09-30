Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872C54E06FC;
	Wed, 30 Sep 2026 16:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785493; cv=none; b=j/dpTOqRHXggl7ZRJf8w/4lZbiXK0Z6xqWNjcdQV/ztKKJu969kR27gJvzEoK2oHorKDL414PBvZZ/WsD+6Yj5sWHQj1dN5A2M93z7dqxT97pfASYAx5hKtuh8bInXFYuSM2ATAOW42ZVMIbcRf/l8nVWr4Fwk+SfQdJMteTpcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785493; c=relaxed/simple;
	bh=2pt01wNne0sh2npo8K4OKekrhH4jvZEuts8UFmwv5sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDmcEupcboAggENamwc4L33OI/8ibMd5jbcioMd/x9KenSCA3yAWoUqZKG3O84hH5L3h41sKPq+1RV1o+Qb/0FWDpk0wg1i2pMWw1t4xB/TI/AqRz87/8V5iWuX8ATFndslDLWICrBvus4RKPVe60cPqeKm62wpxyqz/3Uw/eEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xS0Z4jSj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xS0Z4jSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2D91F000FF;
	Wed, 30 Sep 2026 16:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785486;
	bh=M2MQnoZRAIaGNzJprisJfJJftScnxYLO+NLQt5WkLxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xS0Z4jSjD24hm9cJ2/OgRwBYuQ6Tc7GTbY9y1oRJejek5c4rbJDJQg4CesMmPW9C+
	 jqKdtzG8oIB/71EY74+FeB+clg39XwmJU7XI0/Xx35Gzqh4oqG6EZtz5zIegQRxK+V
	 nK0b970B5WXn+1eMjgQ5MKwGrs28lUAnebCnaAYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 6.1 525/982] ieee802154: 6lowpan: fix NULL dereference in lowpan_newlink
Date: Wed, 30 Sep 2026 17:21:01 +0200
Message-ID: <20260930152428.052316041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


