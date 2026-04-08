Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722AE331A44;
	Wed,  8 Apr 2026 18:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673351; cv=none; b=Ph8luieMRc9Uiux6DKdzTNc8Zk9tYxe2acfihjy2x+1RhtDKPflAQAd+DDncs977HD4j+G3e438nVvQd8krIOmZ6oBdmLbmIg9fq5doqDXUhctehiz1lU8/KbKIsTfrFipGtcTGlya2W/743qwq9w6GGftNakr3dviW79fo2ZwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673351; c=relaxed/simple;
	bh=N7eAFyYbA3ngynmuxRbo5/fjMA0a8D/tK3uKk3Id4n0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rgii+kdKAYq4OkErFHXsySQf/lMAtXcxPag/bS3jx5oFRqT3xj/+zTgmdfsU6mW//JSFcKe80KIMA4TFTBF9tVQ/z1aZd6G/4armWKWLKNLSSnmjWqEpap5K27Za+DZ09TOGISeDMp3UyXVeB/tCqOiSjLaasPbmR9b3HaD04uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OX1QFD3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OX1QFD3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A813C19421;
	Wed,  8 Apr 2026 18:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673351;
	bh=N7eAFyYbA3ngynmuxRbo5/fjMA0a8D/tK3uKk3Id4n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OX1QFD3Rwevf1+COHjf04Kq1N0Vql9Y6oNeF1UOqFS2v4irY/lgS/j3g/PwXTDvtc
	 UAoVXZt4nFWJdfSd+yuIxtH8CfHrNpmpybkF4ky7Ve5acv/cP/RE7S0mD90ZJPD3QT
	 /TvY+erEaKrgrFaxW9YdM3FESCDcaa72cDaS/skA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 181/277] iio: adc: aspeed: clear reference voltage bits before configuring vref
Date: Wed,  8 Apr 2026 20:02:46 +0200
Message-ID: <20260408175940.622321112@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Billy Tsai <billy_tsai@aspeedtech.com>

commit 7cf2f6ed8e7a3bf481ef70b6b4a2edb8abfa5c57 upstream.

Ensures the reference voltage bits are cleared in the ADC engine
control register before configuring the voltage reference. This
avoids potential misconfigurations caused by residual bits.

Fixes: 1b5ceb55fec2 ("iio: adc: aspeed: Support ast2600 adc.")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/aspeed_adc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -415,6 +415,7 @@ static int aspeed_adc_vref_config(struct
 	}
 	adc_engine_control_reg_val =
 		readl(data->base + ASPEED_REG_ENGINE_CONTROL);
+	adc_engine_control_reg_val &= ~ASPEED_ADC_REF_VOLTAGE;
 
 	ret = devm_regulator_get_enable_read_voltage(data->dev, "vref");
 	if (ret < 0 && ret != -ENODEV)


