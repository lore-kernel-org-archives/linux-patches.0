Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B074521ADAE;
	Tue,  8 Apr 2025 11:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111461; cv=none; b=lvLts7Blp/zMBVVkgVviSDfadSmtzJxBcY3jyOw6XcJznsrjkLSyBBsDiXqO2shX/UAD3/pLN+hVjl2z3Ygw1MHCp8MZHjSRTCWkyd+GC/US+3JPrHg2xPmGQ4DCtXQustvTtCzL71G9xkDwFG/TXVE64rRMTWU6Tl7PAvVIzlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111461; c=relaxed/simple;
	bh=sDmlt128DUT6PboAh7TVGCVq0w6P2SB7KtAys4iPcMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rj7t78wYTHhBG84qNorivBpdPmom/rvd/sQPpWIEcyvn+Gholn29ufMh370p8pbsuC5H8vBwjJoBkl/WMGM77bmcUAP+wSmwr7GGLl8WvIbZHzXz0mFKrTXIX+wmPcsUXyP0dU9jTfRzQsi0VgD7liT6XHl+Qmk7mAvSnxddnyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hU41r+Ir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hU41r+Ir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F82C4CEE5;
	Tue,  8 Apr 2025 11:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111461;
	bh=sDmlt128DUT6PboAh7TVGCVq0w6P2SB7KtAys4iPcMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hU41r+Irgk30yZw9b6/ZHR2lsayVHADpQbXY6knAUlnck8osjIrPr+G1Lv9A27G+7
	 XcnsaNqO4G2xwdLqfz8O4wV0KV3HA4nPqDKLWQIhm+Xe1gkD3x+YNiT/kEzO8hd7n9
	 aZ6Q1+T4qNqjwfw9dGkOBBbzs2OP1aJYSdMidqaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Angelo Dureghello <adureghello@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 440/731] iio: dac: adi-axi-dac: modify stream enable
Date: Tue,  8 Apr 2025 12:45:37 +0200
Message-ID: <20250408104924.506481504@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Angelo Dureghello <adureghello@baylibre.com>

[ Upstream commit 6cc60bc38e8428544f8f4f12ddb6cc05fc83a7da ]

Change suggested from the AXI HDL team, modify the function
axi_dac_data_stream_enable() to check for interface busy, to avoid
possible issues when starting the stream.

Fixes: e61d7178429a ("iio: dac: adi-axi-dac: extend features")
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Signed-off-by: Angelo Dureghello <adureghello@baylibre.com>
Link: https://patch.msgid.link/20250114-wip-bl-ad3552r-axi-v0-iio-testing-carlos-v4-3-979402e33545@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/adi-axi-dac.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/dac/adi-axi-dac.c b/drivers/iio/dac/adi-axi-dac.c
index b143f7ed68472..ac871deb8063c 100644
--- a/drivers/iio/dac/adi-axi-dac.c
+++ b/drivers/iio/dac/adi-axi-dac.c
@@ -585,6 +585,14 @@ static int axi_dac_ddr_disable(struct iio_backend *back)
 static int axi_dac_data_stream_enable(struct iio_backend *back)
 {
 	struct axi_dac_state *st = iio_backend_get_priv(back);
+	int ret, val;
+
+	ret = regmap_read_poll_timeout(st->regmap,
+				AXI_DAC_UI_STATUS_REG, val,
+				FIELD_GET(AXI_DAC_UI_STATUS_IF_BUSY, val) == 0,
+				10, 100 * KILO);
+	if (ret)
+		return ret;
 
 	return regmap_set_bits(st->regmap, AXI_DAC_CUSTOM_CTRL_REG,
 			       AXI_DAC_CUSTOM_CTRL_STREAM_ENABLE);
-- 
2.39.5



