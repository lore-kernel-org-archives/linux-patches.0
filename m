Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B061D0E24;
	Wed,  2 Oct 2024 14:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878835; cv=none; b=jqKWGI/Yx9xxAJSCKxwCon8BAYtfmGh6OeR3LvOVC8Dn9lkA2ySDMhxvdsWFPfcHupqo6Nxsj4dMjK1dR4BX1qvaIMZ1oOViKKflYdCcvklEOPA6RP+mss9Lf8ZLZakSWDwR5OFb0aoo4yjGT9W8/aWOYGaky3kcpeJmxgTYgmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878835; c=relaxed/simple;
	bh=yi1ZG2tn0P+EeupewzybEQH6Bp+yrZmNnBlOaLzQWJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOsLj4iOVVf4pI+UW0CDyPyLgvnxAFiQvnKsRiqVpWIbliexCgAlWgnr2uiVM5Q2LtSGW+dKHlFLFkUO6MYfGMzzQJBKzXtmcrGT1tRbHu3r/CHVhK1rBmhl5X0sGJOvzmmuNBgcHcb00dAnWRtTifzNwSnvwuXFdpwWtZ+CoII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGrVPDSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGrVPDSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7000C4CEC2;
	Wed,  2 Oct 2024 14:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878835;
	bh=yi1ZG2tn0P+EeupewzybEQH6Bp+yrZmNnBlOaLzQWJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGrVPDSOJNtOIXK0yGlH7VzWSRZm6VUlCdVuHR7Iyn62qQWab10knoIT37mXsIjHQ
	 NTeu7rSlRJ0b+0A57dTuMHPrkICVMG53G1HhXOE+EULqwtlcT2ZWWBCUoejE9TuEb5
	 FRHRw4ezc71Qx7NdaK+kOEnjN7/PGJHHXr9RC7FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.10 549/634] wifi: mt76: mt7915: check devm_kasprintf() returned value
Date: Wed,  2 Oct 2024 15:00:49 +0200
Message-ID: <20241002125832.781435488@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 267efeda8c55f30e0e7c5b7fd03dea4efec6916c upstream.

devm_kasprintf() can return a NULL pointer on failure but this returned
value is not checked. Fix this lack and check the returned value.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 6ae39b7c7ed4 ("wifi: mt76: mt7921: Support temp sensor")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://patch.msgid.link/20240903014955.4145423-1-make24@iscas.ac.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -194,6 +194,8 @@ static int mt7915_thermal_init(struct mt
 
 	name = devm_kasprintf(&wiphy->dev, GFP_KERNEL, "mt7915_%s",
 			      wiphy_name(wiphy));
+	if (!name)
+		return -ENOMEM;
 
 	cdev = thermal_cooling_device_register(name, phy, &mt7915_thermal_ops);
 	if (!IS_ERR(cdev)) {


