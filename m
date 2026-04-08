Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3E93C5552;
	Wed,  8 Apr 2026 18:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674752; cv=none; b=EG/6aDNMMnCMRj1f0fyKPenWDBNHL3qh7yzCoajJmnKUkvSbi3xP1AWNnWY5bv0zA+vSJPzJ34obowmXycBO0wr4o7H3iAHQOGknjg7Ayrs+9C5kstLFiIJc4iqVoaIufbJvnZSyk/c8yQYVtcWAvePoSPCQS+Gy+fkjab5nSnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674752; c=relaxed/simple;
	bh=uF9HU7ZhEushT8vj2noIf6GitvwtmvtgGNtnh4KZvFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKk0gqpeLzl9E1QoSPWb9kVUWT+2CcZzW2DLDG7/5z21mhtdfsZrXE/kcn/nKdoQ4UrvwXp16BF9ynX5equtP25n4/HlOEviOsatpWfwcGu7Y3y/D67aTpxZiDvykIu9u1rGIyrHvBHAEl9BcltA6PHcdiSys8CLI0G6o/NkRes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjNN2DlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjNN2DlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D468DC19421;
	Wed,  8 Apr 2026 18:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674752;
	bh=uF9HU7ZhEushT8vj2noIf6GitvwtmvtgGNtnh4KZvFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjNN2DlGfPGW7mIvwcalQgDTNMhEkbguH8aEE49IXAyicml7WJXcLEoAJIi6akd6W
	 /EMSX9t8AwZ2apAnfaReK/Ns7q1qYzvfVDRVEAHpKkvt/NdzLOXVRGq3HjtFJ7WBeN
	 cYndfPuFGMG/XjcU+Aj/ecWbH2N1g2NJnwYeLzVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 220/311] iio: adc: aspeed: clear reference voltage bits before configuring vref
Date: Wed,  8 Apr 2026 20:03:40 +0200
Message-ID: <20260408175947.617542489@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


