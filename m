Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55CB46EF7D;
	Tue, 21 Jul 2026 20:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665706; cv=none; b=B65HDX8u9bBURyX9vIr1TVJeE7ospIaETnZfmCCAuzX1D/yFBL+gcSdW9M461cL4X4t7we+jxzeQFvZg3QlzAg3ZUil9oGpD5kmbzw7HXoL5OsBni1Gon86GlPQtGBW9NJzHp70rwM2C42xaTaamD0YSzBeXFOJYcduywCevQSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665706; c=relaxed/simple;
	bh=h5CQlT2+uJ+XdV53Ws7g8IbW8sVCpgFRLqwnHML0X2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j62T9EH2XCv8+oQJQMzKr13H0xxYwNNWt9TbsoA8Z93G23owz926pzRXPmtrAmAX8knTG9HgoqxKS6PZ16tKHDmeRoDwkejepgwPzlQNrgMVovZ6qM968eS5A0gZZnRTbTDM+iDPLJuGLZcg374pJXhavj5bWRtHw280MG6w5zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clu+Ijop; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clu+Ijop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686B71F00A3A;
	Tue, 21 Jul 2026 20:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665702;
	bh=05bjQ7qnv2AbbZUKX5h0Eo+Rb73Ip4oyh7mJZNsUOlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=clu+Ijoptsq+kY3OmNJl/7xG5rr62dx5wrHZix7eh18JmMEF5rjOM6cKhyaaFe4Cz
	 6vllQLqqF4NijEWff06DWxHnJLi0mJT7CjSMBUs8zwZAnRBQ27eHVamygaAnBKZ8NG
	 qaVa+5rZZfuKDN3XZ+iDIOlxlljwZspSwldGte4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0403/1266] spi: hisi-kunpeng: Use dev_err_probe() for host registration failure
Date: Tue, 21 Jul 2026 17:14:00 +0200
Message-ID: <20260721152450.850387815@linuxfoundation.org>
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

From: Qiang Ma <maqianga@uniontech.com>

[ Upstream commit 59b991990a04b1d1ce95373983b7c8b65bdf7acc ]

When the SPI core registers the Kunpeng controller it may need to acquire
chip-select GPIO descriptors. If the GPIO provider has not probed yet,
spi_register_controller() returns -EPROBE_DEFER.

On a Kunpeng system this currently prints an alarming error even though the
next deferred-probe retry succeeds:

  hisi-kunpeng-spi HISI03E1:00: failed to register spi host, ret=-517
  hisi-kunpeng-spi HISI03E1:00: hw version:0x30 max-freq:12500 kHz

Use dev_err_probe() so that -EPROBE_DEFER is reported through the deferred
probe mechanism instead of as a hard error, while preserving normal error
reporting for real registration failures.

Fixes: c770d8631e18 ("spi: Add HiSilicon SPI Controller Driver for Kunpeng SoCs")

Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Link: https://patch.msgid.link/20260515102620.1926930-1-maqianga@uniontech.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-hisi-kunpeng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-hisi-kunpeng.c b/drivers/spi/spi-hisi-kunpeng.c
index 77526f7940688d..6afa37d10c7c1b 100644
--- a/drivers/spi/spi-hisi-kunpeng.c
+++ b/drivers/spi/spi-hisi-kunpeng.c
@@ -518,10 +518,8 @@ static int hisi_spi_probe(struct platform_device *pdev)
 	}
 
 	ret = spi_register_controller(host);
-	if (ret) {
-		dev_err(dev, "failed to register spi host, ret=%d\n", ret);
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to register spi host\n");
 
 	if (hisi_spi_debugfs_init(hs))
 		dev_info(dev, "failed to create debugfs dir\n");
-- 
2.53.0



