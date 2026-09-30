Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443922F8E91;
	Wed, 30 Sep 2026 15:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783286; cv=none; b=LrJK7CetFLHh936ZCyUzfb5G+/OTEtDhjICMrebWjnzXTiygAYDiFtvF2JLEHKkoGRZXiyl/TenrZ54TnwdtpebNSVPYUvtcW/gVd9Z57iD3XYbz6qUP9hVaCoFLz5rHAO8Y1NSkaUGnpNkV2aUkU5aT237bSOl+cCtrYvCBP6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783286; c=relaxed/simple;
	bh=ihoF+Nk1wbaw9zZcmJ5EYS1risjn/62j2eQ5YFT5zAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUXTYChU0PbaTz6oQia5M1y4LLlNxL1aTrHyn6BIhep3iRdjkMPU40H8k0Y0UyOI/lCqKnD+tDDOYwBEWX8Zr5uKZMwNRKpHmuczL8lvHs31R65ttxScLMNlbuFMSgfWfWXgI9DUQ7SlRL3wPEQM12JwkpzDiTp1V62ypOwxVwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OkyQlI0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OkyQlI0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E264F1F000FF;
	Wed, 30 Sep 2026 15:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783282;
	bh=YSGwRNoMh7dcgbnXZSwE1dDXpi9wVWHHQu2S3ZyGgWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OkyQlI0mnHLDJW3PzTXnpRJWqBC3wIK57NSdJFQQAcATh5uFy2E1mhfJQAV+Y1PPQ
	 /O8i/GYgzchnv4g2hvYIJ4tLVTPGwOjkOwQEYHqwbKhyVLGrwO87KfJNZZwCAPUUS+
	 NearOZwmF+bvCR0PctXZC9kob7wgqTO31o5TpEi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.10 307/595] ieee802154: 6lowpan: fix NULL dereference in lowpan_newlink
Date: Wed, 30 Sep 2026 17:23:20 +0200
Message-ID: <20260930152354.291480930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


