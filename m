Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0D31AC426;
	Mon, 14 Oct 2024 14:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917031; cv=none; b=Fbgndn9y4klB4QuW2u8IcCHe4oQSzPe105rP9f8k9eAaMl7Bn3XeaMLslm8c5iLBRTSp673iXT0+0DlOyqoiuP0mBX5J9HLA6D1CuEv5RvXKY2xdD6iBXAec2uo0PBHKMmV6Mu4lUUSdJ/+1ouRbPMqSEb3qhO65ubws59STY1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917031; c=relaxed/simple;
	bh=LYpt2sqCjISsYz2MqXJ1LzmVKGdbky7tiMutPVv3DEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+ZQtbp678dAqliPXZPEx+Vrdb5OJR16Ry04uS5lxLuCPi+1GCSGE/fryHahNimCrD5qGghmYQ5la6mv3lVv0rk9G6TNcC5RQg1Nnq6OM3MunjdOq1YmvFpYEK8uyX7TCVNDMdX73MK0CmU8J5i5ytEpSBlmg3F79RugdL3kQL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=030OgEam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="030OgEam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FC1C4CECF;
	Mon, 14 Oct 2024 14:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917031;
	bh=LYpt2sqCjISsYz2MqXJ1LzmVKGdbky7tiMutPVv3DEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=030OgEamVka8LVVxQ5P6JpSq0yTRZCjrfcbBvPkE0q1skCjnC3CsJIFcHzsP9kZbo
	 /vQF64/aYaVnVT4vrvpFgYvOahwA+9ZapvaqHdnZfqVdKSqAi6BpFzcHABkAVtPW15
	 EKgIbOyS1ZJKSlI1CGgb8bfBVWT21sCPJoO0IZ1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/213] net: dsa: b53: fix jumbo frames on 10/100 ports
Date: Mon, 14 Oct 2024 16:20:38 +0200
Message-ID: <20241014141048.121929163@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 51b41eb660134..4a2c9a9134d8c 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2273,7 +2273,7 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 		return 0;
 
 	enable_jumbo = (mtu > ETH_DATA_LEN);
-	allow_10_100 = (dev->chip_id == BCM583XX_DEVICE_ID);
+	allow_10_100 = !is63xx(dev);
 
 	return b53_set_jumbo(dev, enable_jumbo, allow_10_100);
 }
-- 
2.43.0



