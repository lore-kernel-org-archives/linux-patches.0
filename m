Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C032ED157;
	Thu,  3 Jul 2025 14:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554572; cv=none; b=ohKfl/6KPoAGRUnJIKVUcP9QNcdnMO7kQzxm0GQ0INX/vMNOzh5y8UQZPBwUs8M2oOh1xGuD+CNvWUnt6tmsKibF3HIuwyyeY+7x/MLBJqO74ehVhtz2Gmu3uKz2XyP0mUYbA71I3yO47EBmozmzV0O770d9UCPGcY9xQlUbTiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554572; c=relaxed/simple;
	bh=kpqbUfhf+q+WKT4PMExBkGQMcd+mruJw0o1QBspImdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hieq1VNspdv8UvwEVLTZg7NhYuphJwdMC5ztgjtLkX05Vh82ipvvMsyKXq/D5DAjyZ3IgHMFmAK31YJWIRCQNg59Fh+ydg3CWRYqU2QPe3AncIlN5os36Ddcc09VJmbeRFWz1ceVg9BxYVLEn+UvHkMqhrLDknPhmSoWTrx3tN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnZHtGQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnZHtGQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00B2C4CEE3;
	Thu,  3 Jul 2025 14:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554572;
	bh=kpqbUfhf+q+WKT4PMExBkGQMcd+mruJw0o1QBspImdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnZHtGQuYFWabQOXdRS7qqbcmuHEPvejUy+AtDgUuTmHotg/srtlWtW/Urq7+c1pm
	 fTumqog3XoNsJm8q3PWKIiJqZHz9M3OgVc7RGdoTHnf4+5q9ukRsK1HWWX8L03dhIC
	 BNZ/15larHP7k7RKUqZdFNNuehzQZpH9UWjNyrNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 012/263] mfd: sprd-sc27xx: Fix wakeup source leaks on device unbind
Date: Thu,  3 Jul 2025 16:38:52 +0200
Message-ID: <20250703144004.782664429@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 37ef4aa4039c42f4b15dc7e40d3e437b7f031522 ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250406-mfd-device-wakekup-leak-v1-8-318e14bdba0a@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/sprd-sc27xx-spi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/sprd-sc27xx-spi.c b/drivers/mfd/sprd-sc27xx-spi.c
index 7186e2108108f..d6b4350779e6a 100644
--- a/drivers/mfd/sprd-sc27xx-spi.c
+++ b/drivers/mfd/sprd-sc27xx-spi.c
@@ -210,7 +210,10 @@ static int sprd_pmic_probe(struct spi_device *spi)
 		return ret;
 	}
 
-	device_init_wakeup(&spi->dev, true);
+	ret = devm_device_init_wakeup(&spi->dev);
+	if (ret)
+		return dev_err_probe(&spi->dev, ret, "Failed to init wakeup\n");
+
 	return 0;
 }
 
-- 
2.39.5



