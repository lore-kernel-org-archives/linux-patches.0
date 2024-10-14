Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6225C19E802;
	Mon, 14 Oct 2024 14:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917017; cv=none; b=mgf4BkSXM5nThG+USENaHoEFWW3ASK3FBQ6xuL1jleBEfq01rJWFnMiSR+4fkIXvQu2cLwX3niyob8VHnRR3gTFeBNfP6xup11JFkDmj+/LZMiaJCqCv2ZNM7nbnZxT3LgFsJymkZE2c5qaa2gkDoNX6EDN0KY78959a8WJbICo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917017; c=relaxed/simple;
	bh=/801QHqFeQEIl9RLF0pM9A80qVyA0ye/PeaSkoiHZmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNPK6y6zB2GTFxfj6ihmzFjKnlZB2d1u29l2Qt/JsQjfJFauLjTyb9VvBfyW4qY8BvlAtc8aH/9KszutzniFPyMd3WmmyTV4kDIrrF3Lj8Y7Uh7AIniBCH7AjofLVDNT9sK6tWgfQE9y6HRsuZQPWo7ck1bcUao+pNbX/b6YtxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tzzg6iAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tzzg6iAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD840C4CEC7;
	Mon, 14 Oct 2024 14:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917017;
	bh=/801QHqFeQEIl9RLF0pM9A80qVyA0ye/PeaSkoiHZmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tzzg6iAuSrVPERs8PPdh9AUSoNyW6tCpXljbheydo2sCX1IjaFc50fCmUcTIgeAHm
	 G7RxFrPFEkuCZi4q8SdrhEV3uY/zxHE2jU1Q2uVcertPdq4rxCsMeRpDLLp4epiKWF
	 ofnq9ILEpQi7Iul9hT3+NV74SQg54YawFGwPc4mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/213] net: dsa: b53: fix jumbo frame mtu check
Date: Mon, 14 Oct 2024 16:20:34 +0200
Message-ID: <20241014141047.965203489@linuxfoundation.org>
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

[ Upstream commit 42fb3acf6826c6764ba79feb6e15229b43fd2f9f ]

JMS_MIN_SIZE is the full ethernet frame length, while mtu is just the
data payload size. Comparing these two meant that mtus between 1500 and
1518 did not trigger enabling jumbo frames.

So instead compare the set mtu ETH_DATA_LEN, which is equal to
JMS_MIN_SIZE - ETH_HLEN - ETH_FCS_LEN;

Also do a check that the requested mtu is actually greater than the
minimum length, else we do not need to enable jumbo frames.

In practice this only introduced a very small range of mtus that did not
work properly. Newer chips allow 2000 byte large frames by default, and
older chips allow 1536 bytes long, which is equivalent to an mtu of
1514. So effectivly only mtus of 1515~1517 were broken.

Fixes: 6ae5834b983a ("net: dsa: b53: add MTU configuration support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index ae1c4dc35fe33..492e5eb931a6f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2268,7 +2268,7 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 	if (!dsa_is_cpu_port(ds, port))
 		return 0;
 
-	enable_jumbo = (mtu >= JMS_MIN_SIZE);
+	enable_jumbo = (mtu > ETH_DATA_LEN);
 	allow_10_100 = (dev->chip_id == BCM583XX_DEVICE_ID);
 
 	return b53_set_jumbo(dev, enable_jumbo, allow_10_100);
-- 
2.43.0



