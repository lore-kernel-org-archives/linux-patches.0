Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A333B3C15;
	Tue, 21 Jul 2026 20:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666563; cv=none; b=nIPEQnmCD1yqGpfgn1B/AjTspfpwmt6Yjse2FyYrXtypuVaaLp+Mu+7klBwZQblzM1Hi8+EvDSjle4Xk9wwU2IWQDOzExPcw/NKppK88DxzJXv6nycVbPHzhZu+h+2NPqoMQPxjv+9LzI+KGs4F/nQNBpDlHkshir9DVkUTr7Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666563; c=relaxed/simple;
	bh=a61HCTSwxIYwfuYv4CBV64pfbu/Wj70FyFP/z9D1LqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJGbJAIMDmyZ5k7e5ppkWB9j5f6kTV3FO+uwtsgBHAfF2xrGJf2ouWCVxKOA/60X4fNqUnnTTcpjv5tk3CZcTcYPY3MIrb1g7+ekbBzCURQOluXci4F9E4XZfyF8J1ftznst7A5slGbPTcxv7uoi+9CK+hkRWRDMpwTjfrT20Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTX4xY8F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTX4xY8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4401F000E9;
	Tue, 21 Jul 2026 20:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666562;
	bh=PeZI483/mmDBW9+++L+BN5Ewu2tNk70J8u7dxoGDRZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KTX4xY8FFV5wDhaPR7W4aNZSQW3ba198Aqru9tgh8uSdRnlgBNuIRw5Niy5uXMJn/
	 rQOkB6nYUm/IFoH/LitUxDJCU0tbqy6EuY9WeNwDBBPoG07OsbhKE+ZIdYBN+LOPGG
	 Hh7ImydXJaf2DOv7TVDmo0WdKhXtmt2G+V8Kl/Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quang Nguyen <quang.nguyen.wx@renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0728/1266] spi: rpc-if: Use correct device for hardware reinitialization on resume
Date: Tue, 21 Jul 2026 17:19:25 +0200
Message-ID: <20260721152458.161097583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Quang Nguyen <quang.nguyen.wx@renesas.com>

[ Upstream commit 7b25dbafa2fce50b1a48c1d057adb35da3563f9b ]

rpcif_spi_resume() currently passes the SPI controller device to
rpcif_hw_init(), but the function should be called with the RPC
interface device.

Retrieve the rpcif private data from the SPI controller and pass
rpc->dev instead. Also propagate the return value of rpcif_hw_init() so
that a failure during resume is properly reported rather than silently
ignored.

Fixes: ad4728740bd6 ("spi: rpc-if: Add resume support for RZ/G3E")
Signed-off-by: Quang Nguyen <quang.nguyen.wx@renesas.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260618081932.172168-1-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rpc-if.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rpc-if.c b/drivers/spi/spi-rpc-if.c
index a1696672d12fea..2de7ae058c2931 100644
--- a/drivers/spi/spi-rpc-if.c
+++ b/drivers/spi/spi-rpc-if.c
@@ -192,8 +192,12 @@ static int __maybe_unused rpcif_spi_suspend(struct device *dev)
 static int __maybe_unused rpcif_spi_resume(struct device *dev)
 {
 	struct spi_controller *ctlr = dev_get_drvdata(dev);
+	struct rpcif *rpc = spi_controller_get_devdata(ctlr);
+	int ret;
 
-	rpcif_hw_init(dev, false);
+	ret = rpcif_hw_init(rpc->dev, false);
+	if (ret)
+		return ret;
 
 	return spi_controller_resume(ctlr);
 }
-- 
2.53.0



