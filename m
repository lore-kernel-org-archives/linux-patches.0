Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF63F1FC7C9;
	Tue, 15 Oct 2024 13:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998468; cv=none; b=mDRJZ5EugD/UqQ9CEPBaJWfeVp+OMW5eXxsEeCFq9D7BV3cm0X7iGPa9VNeW1hKfV1ibJmIucisYAjeBvKaNrMaktpL/xN2GLBIujg7DMlnJgJK/wFwcufLWT57se3RtYtHCptTXHIxzYSzh37p44A+TnSEkUlScfPVikF8C/QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998468; c=relaxed/simple;
	bh=QsQQMPJP4pn93n7MnPNlCsWK0Qy53Mp/R463dIrI67Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ive3jcfLuwMXFDXLSyZFOiTRisZrWgoftXJ1T57PoGxHpuSNggsLQJOsrHqteFU9ZR4eeBabKEWl6H+2jlrTXw4Y7FiGSmDU+iPEiDXEwjboX/jmF53/sgDYMgHoenF6MBDUhkpzURgthWhU60nwx58jZZFsmST4Q2IdSyHlV/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyjlZojb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyjlZojb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3851C4CED1;
	Tue, 15 Oct 2024 13:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998468;
	bh=QsQQMPJP4pn93n7MnPNlCsWK0Qy53Mp/R463dIrI67Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyjlZojbatNxlS3UFGQ6aESI7vl3NGJU5Ouka4XpiLw/FUXxOUvFB5y9A20Cy6dHc
	 c6wXvBodNtLwajjGgNru3OgoQw9neY7eid6yR6OMV5cGUPLi1GxG8vcay2eA2MA+E1
	 fApvaSVijSeEmFwVpO95cjpnOlZGRJ48C8eJj/7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 486/518] net: dsa: b53: fix jumbo frames on 10/100 ports
Date: Tue, 15 Oct 2024 14:46:30 +0200
Message-ID: <20241015123935.756497148@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 459caaf6aa613..2fc33019e814a 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2188,7 +2188,7 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 		return 0;
 
 	enable_jumbo = (mtu > ETH_DATA_LEN);
-	allow_10_100 = (dev->chip_id == BCM583XX_DEVICE_ID);
+	allow_10_100 = !is63xx(dev);
 
 	return b53_set_jumbo(dev, enable_jumbo, allow_10_100);
 }
-- 
2.43.0



