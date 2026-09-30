Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B080F30CD95;
	Wed, 30 Sep 2026 18:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791694; cv=none; b=HNRpcn4pKw0rZjd9UOw8EeackqggiKIsIaM+cP69cd4wdk6XQtV4+wvfZK5ze7oicCJ0idxU4K1/1tU+Xaw+LOnOCWQeZF6EbjqveptN7UBovMz5qQexbRLweOJoZwJLQNZ4hvS3fdz4G0gEDfaPtZnSsl76zvrq0lD1aN69nS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791694; c=relaxed/simple;
	bh=yJmIp5aenRe5H80IaVsajHxdRAnpKECxFtx18MY5FTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbrxPkZchRqnvrXqsQZchzP/kgB+2DcweeDFP9zDA409Il82idCvIUqVEWueEQIVp07OTimBzv6UoDwfc4WgOlfVvvAszFacAXKG+8QhKt7XVF7n5ZbPyiY8nahCMz81Dc2kl7tQTz0a984x+IBFRA5yfXu8x2NacIINbps9Dp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdcSnn2t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdcSnn2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A03C1F00898;
	Wed, 30 Sep 2026 18:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791692;
	bh=lsojPYPehmXen6sWqAlXcXBqj2NkkjtktGfUncOhCCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DdcSnn2tjATE3yR+ZsUyprdNwz+/gnUXIy61+8aAUJ8sJC+y8k6JGI7GSnEMUmvGJ
	 s62+3w39GWrRu4qW0HjycgFXGan0ebfGvHeYYX7Zw4gsFPYbb40LMbIq0rKor7xuMf
	 kmg4Y01U+ZM2SzQdO/YGOTdcM0h1uZR7uE0TNNAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.15 392/752] ieee802154: 6lowpan: fix NULL dereference in lowpan_newlink
Date: Wed, 30 Sep 2026 17:24:22 +0200
Message-ID: <20260930152406.760789098@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -145,7 +145,7 @@ static int lowpan_newlink(struct net *sr
 	wdev = dev_get_by_index(dev_net(ldev), nla_get_u32(tb[IFLA_LINK]));
 	if (!wdev)
 		return -ENODEV;
-	if (wdev->type != ARPHRD_IEEE802154) {
+	if (wdev->type != ARPHRD_IEEE802154 || !wdev->ieee802154_ptr) {
 		dev_put(wdev);
 		return -EINVAL;
 	}


