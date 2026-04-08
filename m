Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAA23624B0;
	Wed,  8 Apr 2026 18:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673902; cv=none; b=tux3Lhpdjzv32JZdyTsq6OAfqDn1GahT3ZuD29jSah5A6qRUuZvfVJKgmPdFHA9Aasfg6KhwU02Tv4fuRIPP2HWIc9nhXZxMv7KOmFrno0GiyyHsOgwXcgSLODTfWiMAcnV0gs0DpU2NsdtcBCMSLiJ9O3GFUcMCLrCuhHDX1Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673902; c=relaxed/simple;
	bh=mazdgVNQfl+W8y9Y+p/tKW+3zis3WsRX/autgB31b8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjP0PTgtfirF1HA2287OqmlbeieLfex62F6NmkIKyA8SlCLDNrjf4cXjW+6epiWeMiGnNqTGLtdUDq0cyteyIBT5JvYA3c26StztI/RLvli7MmRsQOw6Tlux4YtOBgFZCumURiXYqPPi8AyVgQ/ivKp3QcMpgnKqG/DxXu325Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRF3hMFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRF3hMFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582CDC2BCB4;
	Wed,  8 Apr 2026 18:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673902;
	bh=mazdgVNQfl+W8y9Y+p/tKW+3zis3WsRX/autgB31b8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRF3hMFRHqf4RiMWA07MnapzfbSxSGQs7IGyukZdJtuAI2pvrqbSIUkByYdYU1RJO
	 YU4LGoFjyg0o1P6o9hW58trUMH8su8x9JN7oZoZ0pYfO6ZZCtA88S1DKfT1Jzeq0ud
	 EF3G8ZlfQ67fIyY/MMmG+Dyb2aZJs1PiMlyxnUHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 133/242] iio: adc: ti-ads1119: Reinit completion before wait_for_completion_timeout()
Date: Wed,  8 Apr 2026 20:02:53 +0200
Message-ID: <20260408175932.067070754@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 2f168094177f8553a36046afce139001801ca917 upstream.

The completion is not reinit before wait_for_completion_timeout(),
so wait_for_completion_timeout() will return immediately after
the first successful completion.

Fixes: a9306887eba4 ("iio: adc: ti-ads1119: Add driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads1119.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/adc/ti-ads1119.c
+++ b/drivers/iio/adc/ti-ads1119.c
@@ -280,6 +280,9 @@ static int ads1119_single_conversion(str
 	if (ret)
 		goto pdown;
 
+	if (st->client->irq)
+		reinit_completion(&st->completion);
+
 	ret = i2c_smbus_write_byte(st->client, ADS1119_CMD_START_SYNC);
 	if (ret)
 		goto pdown;


