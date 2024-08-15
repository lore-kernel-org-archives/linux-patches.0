Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169B61714A1;
	Thu, 15 Aug 2024 13:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729598; cv=none; b=Ujek39mHddI9Fv3wFdAlwtvyDzLZNsRvnWkrbotRKq35ZQETT2nlGXr2ubMqjZZPLOcKKP8luvyOn9sd/fJti55hTjyZbzcZLaXv3lXFC6INYMuXo4txqvvUFgnFkNCtmKs3mDEAh71l0dicuhpa7uByiKt1gHDHBoQZo4b68Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729598; c=relaxed/simple;
	bh=Jg+cgE9cYZjbN4rKsLdUGv/9XtlEME83Ek7UqxWfAyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRGfR3kgbvP6RTM4WzrPZLNUuilRWawwZucjgXAsTZu74pYrRRAaKHlUHiWQn/Lm86GBuQz+WjeU+AkJY2AU3PYOt5DzNrg4AUz5cTOnVjui+efMW5ehVOUmtK9Jhu+SSZ8Ezje7RGE20sVsScR9D6rm6gx+vI5P9mS4UC9jRYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k57ITQma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k57ITQma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D1AC32786;
	Thu, 15 Aug 2024 13:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729598;
	bh=Jg+cgE9cYZjbN4rKsLdUGv/9XtlEME83Ek7UqxWfAyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k57ITQmaFI7UfBnBtO1FfWuwUa0fu+4ipGTYKaBIYs0DJieD+lUobV7j58ySJ/75q
	 dhy8ggnTQH6AoKV6FxetyevJWjg8IyyO/uTnEmKv72N+/a9ZioVaybn1p8XWD3hbBJ
	 G7PbRrMHotyb4Iv+ftb3cWVfMR/uaYw2cPVvcfrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Martin Willi <martin@strongswan.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/484] net: dsa: b53: Limit chip-wide jumbo frame config to CPU ports
Date: Thu, 15 Aug 2024 15:20:06 +0200
Message-ID: <20240815131947.134129856@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Willi <martin@strongswan.org>

[ Upstream commit c5118072e228e7e4385fc5ac46b2e31cf6c4f2d3 ]

Broadcom switches supported by the b53 driver use a chip-wide jumbo frame
configuration. In the commit referenced with the Fixes tag, the setting
is applied just for the last port changing its MTU.

While configuring CPU ports accounts for tagger overhead, user ports do
not. When setting the MTU for a user port, the chip-wide setting is
reduced to not include the tagger overhead, resulting in an potentially
insufficient chip-wide maximum frame size for the CPU port.

As, by design, the CPU port MTU is adjusted for any user port change,
apply the chip-wide setting only for CPU ports. This aligns the driver
to the behavior of other switch drivers.

Fixes: 6ae5834b983a ("net: dsa: b53: add MTU configuration support")
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Martin Willi <martin@strongswan.org>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 604f541126654..e23f184ffdda7 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2223,6 +2223,9 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 	if (is5325(dev) || is5365(dev))
 		return -EOPNOTSUPP;
 
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
 	enable_jumbo = (mtu >= JMS_MIN_SIZE);
 	allow_10_100 = (dev->chip_id == BCM583XX_DEVICE_ID);
 
-- 
2.43.0



