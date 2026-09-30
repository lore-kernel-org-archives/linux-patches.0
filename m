Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06F53CF039;
	Wed, 30 Sep 2026 19:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795656; cv=none; b=q+PieZRf0RNipo2IA7B/4tH9BkLy4PQrS8TDJJ7ilJqOrk49jE02mJ0XLIPMu3r7xVdsKhzyiSVc6Kicub/+XOjcDO16dXNv7pKlhsq01DwGsbdOMtG4ISYHIUKowAMcgz07O3p+qAq2oUU+FKBL2cDBYh7QxJJ5cjXeQpFb4w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795656; c=relaxed/simple;
	bh=WXDLCARlb5ZRFkPWYzJV9/UYWhSMChEigOPEHw956/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noM0839AhQNiMwt/V8j077/DXzZ0a06MLp0YfbjvgsmlG3ce1bPXljYgZAKSRksGyKtJ4e5fNcUxyi7gwC2spxxX3vHEvCGgQ/tm/7lW7H9LkrPlLB8GikaL9TnV7tliWDYVEMN1BuQy90ZMoMyjrgsAQ6bBh1dngzEaw1dCp1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=szzY1OHk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szzY1OHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6591F000FF;
	Wed, 30 Sep 2026 19:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795654;
	bh=iwr/Uq+21Y7kRo/O2r1mjtpgQcwidJymOWbniDCEfxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=szzY1OHk8p1DDVbT7tT0Fua4TMvMO787g3FZYhQ9D2qg34JbdmlfgnjSPL/DICi6T
	 IC7oIUAj6Pg5GZSccTJOYLIADjGUnG7m/axY7OBxTG3uRQYM2Eisu4JaSmhGbEdNn1
	 sTTLseX7LhKFoi/6B3o+Pc6CsRxJMWB0f7F1iiKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 6.6 0637/1193] ieee802154: 6lowpan: fix NULL dereference in lowpan_newlink
Date: Wed, 30 Sep 2026 17:22:01 +0200
Message-ID: <20260930152448.398098964@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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


