Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94384139D0B;
	Mon, 14 Oct 2024 15:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919918; cv=none; b=s+G0HK4sZA2M79WlFxJMInZkIEuksANi1GZIMBy37lheB1pETLZxpNjqHkYIJXS4wbExUNgBwYHLSzD8XN/45fK3Jb8NLDPjnGwHc4hu6F1vnZP0dttVljj1S6CxrkqYPQHPKhn5gYLpQSuG9ATYt8FJAngEiaCXHNMy0gz5Uog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919918; c=relaxed/simple;
	bh=fuoA04j9i08+2CIyakncpCoV6HQW2txb3kVTiM6enmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCSHBqAt4ITTt0gm2AJt9nSODg70lNcAvy6ZTdiSAa5dKFNIfU75QV1WhPq+9aoBfLFIUWAEpj6W+7c+6fBA/9IftlmwZQis6wQDwBw92RtuE/vkIbJVAgrjWRbYeuRYzNGGxQalJcVUOvn0kNbxd8AWkYCtmq0ZNdZfQ7gjT44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WxgO2ke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WxgO2ke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023CAC4CEC3;
	Mon, 14 Oct 2024 15:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919918;
	bh=fuoA04j9i08+2CIyakncpCoV6HQW2txb3kVTiM6enmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2WxgO2kebDZejco98AsP3WMJEj6S4jQW88EPp8bMpE68NyddxOlXtXaSd0xdX7XsX
	 yEQ6myItbU2Fvzk+AL4GJCDSosX1yF3bdDpupUySQEl6KtKMCrtEoHS8egmILtVtgM
	 KMWlITifpQiBmfxRRSjjz7y+ZJJX3JClCM9W8dsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 746/798] net: dsa: b53: fix jumbo frames on 10/100 ports
Date: Mon, 14 Oct 2024 16:21:40 +0200
Message-ID: <20241014141247.376788651@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 2f3dcd0d39affe5b9ba1c351ce0e270c8bdd5109 ]

All modern chips support and need the 10_100 bit set for supporting jumbo
frames on 10/100 ports, so instead of enabling it only for 583XX enable
it for everything except bcm63xx, where the bit is writeable, but does
nothing.

Tested on BCM53115, where jumbo frames were dropped at 10/100 speeds
without the bit set.

Fixes: 6ae5834b983a ("net: dsa: b53: add MTU configuration support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 83f71c181a15c..463c6d84ae1b0 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2229,7 +2229,7 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 		return 0;
 
 	enable_jumbo = (mtu > ETH_DATA_LEN);
-	allow_10_100 = (dev->chip_id == BCM583XX_DEVICE_ID);
+	allow_10_100 = !is63xx(dev);
 
 	return b53_set_jumbo(dev, enable_jumbo, allow_10_100);
 }
-- 
2.43.0



