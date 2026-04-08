Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF7532A3FD;
	Wed,  8 Apr 2026 18:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674760; cv=none; b=VCdSJ4oRXISBJiiCZUf5yjvin83IIqifZpVxZnuw7ETDITIY/hjWRjRLrdTYu6P3T+XV2v2E/1U0SQ4wBy58LbY/GzjgOw0ptbk7IK1oveQ7AvBJ+Beag7xf+WAtQv1IlZM+SopMCa7RphggIE3QB0Nr8rYUsNQq3wT4l70XyPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674760; c=relaxed/simple;
	bh=ejuTBnM8jy+KPxVXIZYnujK8lPw9l//CVDmCPRkvYso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bS2FfrzmqL788cf2RpqnetAZUBcp0ntKa3wrWY+DPx7DMsR39xYWVdII6ZOIW76XJSnw/lfBBvAZhwyITQdH4QUEIAB3K8cdtDYvcdeXWUqi407L8hPx766sHHrzX+I0AXkjUqR9dxhMLc3ZcXncOktNSyhe3QiX6rkAiGR9VRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5b+j/Ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5b+j/Ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9049EC19421;
	Wed,  8 Apr 2026 18:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674759;
	bh=ejuTBnM8jy+KPxVXIZYnujK8lPw9l//CVDmCPRkvYso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5b+j/YeMkg3nkxgFbVJwucV9LRoFPSY53ZF93ic58NcTvbQeDkYRovLDQ3rIdFax
	 zVIoWvh6e4tRaoTVwMrRy2sqA/uItdH+8ZSorAo1JwH7xMighuqbG36/jzzmFCSzSr
	 fflPJew4jwmPGhOY9wM/ZBR2NA4Zzaf1/sYvtSE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 223/311] iio: accel: adxl313: add missing error check in predisable
Date: Wed,  8 Apr 2026 20:03:43 +0200
Message-ID: <20260408175947.728564296@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit 9d3fa23d5d55a137fd4396d3d4799102587a7f2b upstream.

Check the return value of the FIFO bypass regmap_write() before
proceeding to disable interrupts.

Fixes: ff8093fa6ba4 ("iio: accel: adxl313: add buffered FIFO watermark with interrupt handling")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/adxl313_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/accel/adxl313_core.c
+++ b/drivers/iio/accel/adxl313_core.c
@@ -998,6 +998,8 @@ static int adxl313_buffer_predisable(str
 
 	ret = regmap_write(data->regmap, ADXL313_REG_FIFO_CTL,
 			   FIELD_PREP(ADXL313_REG_FIFO_CTL_MODE_MSK, ADXL313_FIFO_BYPASS));
+	if (ret)
+		return ret;
 
 	ret = regmap_write(data->regmap, ADXL313_REG_INT_ENABLE, 0);
 	if (ret)


