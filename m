Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6A21AC893;
	Thu, 15 Aug 2024 14:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732815; cv=none; b=CmmDi2wI4MaZEao8/6aVs5UjpQjSVs3qzfGcJ8ZQiE9G5Y5+UBoVzM21H17RHkyCWtFlQuS6J0zpVAdL5CcTBSZ28yetUSoVgQh7jgwLs4e5G3CaOIjeQJRbHR47NyE62dcMJf1a0B7UEHL13z6moa0+Kv+htb5jOyrw9saamBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732815; c=relaxed/simple;
	bh=6iAkeUKZ/Rvd5S4vqK0vqDSpGHYY38Z8JhEu3pmH4iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmkwOXQhVtgEpbpSlEXeD5Yp/dCQvO2UZiRhdtjyS5kLBG0ygrM87Pe9DQ2hjR9eT0mJrmW/ZywZ6+vkQDyQgwQhoJy7UIFlc2YWGgnFlJFOo6S0FkANzbHlUmUjg36DLgJItNBRdQLbKKf5NBhiah7+iXBNiL1NfTZQPpel0/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1kKnejw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1kKnejw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC2BC32786;
	Thu, 15 Aug 2024 14:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732815;
	bh=6iAkeUKZ/Rvd5S4vqK0vqDSpGHYY38Z8JhEu3pmH4iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1kKnejwOJJJyQvYzk8CBSsaDiijiY9ZSTKzKEWMedsmKlDrkibAaADlV0SstZ9j1
	 1qimp6zAiPEn6KGzPdeeYnzlC2t4DD5kpHlB47AHQ6Y/yY739v3EUGkTtUIh4j+ADj
	 O3WJImyYMRwIgB24J1wZi8GtqqUeoENOEmhfN6+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 295/352] ASoC: codecs: wsa881x: Correct Soundwire ports mask
Date: Thu, 15 Aug 2024 15:26:01 +0200
Message-ID: <20240815131930.856495553@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit eb11c3bb64ad0a05aeacdb01039863aa2aa3614b ]

Device has up to WSA881X_MAX_SWR_PORTS number of ports and the array
assigned to prop.sink_dpn_prop has 0..WSA881X_MAX_SWR_PORTS-1 elements.
On the other hand, GENMASK(high, low) creates an inclusive mask between
<high, low>, so we need the mask from 0 up to WSA881X_MAX_SWR_PORTS-1.

Theoretically, too wide mask could cause an out of bounds read in
sdw_get_slave_dpn_prop() in stream.c, however only in the case of buggy
driver, e.g. adding incorrect number of ports via
sdw_stream_add_slave().

Fixes: a0aab9e1404a ("ASoC: codecs: add wsa881x amplifier support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240726-asoc-wcd-wsa-swr-ports-genmask-v1-4-d4d7a8b56f05@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa881x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wsa881x.c b/sound/soc/codecs/wsa881x.c
index 9f66f6dc2c67f..77012979e1319 100644
--- a/sound/soc/codecs/wsa881x.c
+++ b/sound/soc/codecs/wsa881x.c
@@ -1120,7 +1120,7 @@ static int wsa881x_probe(struct sdw_slave *pdev,
 	wsa881x->sconfig.frame_rate = 48000;
 	wsa881x->sconfig.direction = SDW_DATA_DIR_RX;
 	wsa881x->sconfig.type = SDW_STREAM_PDM;
-	pdev->prop.sink_ports = GENMASK(WSA881X_MAX_SWR_PORTS, 0);
+	pdev->prop.sink_ports = GENMASK(WSA881X_MAX_SWR_PORTS - 1, 0);
 	pdev->prop.sink_dpn_prop = wsa_sink_dpn_prop;
 	pdev->prop.scp_int1_mask = SDW_SCP_INT1_BUS_CLASH | SDW_SCP_INT1_PARITY;
 	gpiod_direction_output(wsa881x->sd_n, 1);
-- 
2.43.0



