Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CE319E7C9;
	Thu,  6 Jun 2024 14:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683512; cv=none; b=oI0b345D85xCGBIGm/Xe00vSE/eGa2D77x4AYSOM/gcqflg9ok0IvbXhmaF0wuk3ou9X7GBXulf0MaSZE5tXcUurfRKlVnNgwPqc0i2xIJLRZgq3AQu+ML1IfgU8tQY8eOxQE5zYrYkqX/nkUrvfz5SU6XYT7nIVqXbT2k9HK9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683512; c=relaxed/simple;
	bh=GmIrOUTL7+2L+LB28W1ja+975h9XEc1xKuR7sjvJGzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYvWI0d9brOpMv/kH7hrzU3cBvePGB/CSaRZ7nA8XWscANQ+im1TTD+ZSYpMYMx7raHdVc1l7RF6uOtkgHwQnYqSmaQSHnuj2uZitH9vl7xS0c3vSaNYfO8UdCAYwxQPHuoa1wYB5oh7WUKST043yvX5CM1Vi52/vN/BRxMEKPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDD0PsYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDD0PsYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEBAC2BD10;
	Thu,  6 Jun 2024 14:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683512;
	bh=GmIrOUTL7+2L+LB28W1ja+975h9XEc1xKuR7sjvJGzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDD0PsYXlVnSi07gNcV+Do6XzFBri6tjFqXU3ejYphwtgWnRycjf5NIbDLCDGBVvC
	 jwYBJOknkdPjqUQ1oIim01lNpxUfr6uq20t6Zop0BoXMFFDyprVt/AtNgQzsPKnnDj
	 495wvmpOSFUv0+8D0BKn6vbFpIj70YB3SpksiN3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 453/744] iio: adc: adi-axi-adc: only error out in major version mismatch
Date: Thu,  6 Jun 2024 16:02:05 +0200
Message-ID: <20240606131747.012353584@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit cf1c833f89e7c8635a28c3db15c68ead150ea712 ]

The IP core only has breaking changes when there major version changes.
Hence, only match the major number. This is also in line with the other
core ADI has upstream. The current check for erroring out
'expected_version > current_version"' is then wrong as we could just
increase the core major with breaking changes and that would go
unnoticed.

Fixes: ef04070692a2 ("iio: adc: adi-axi-adc: add support for AXI ADC IP core")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240419-ad9467-new-features-v1-2-3e7628ff6d5e@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/adi-axi-adc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/adi-axi-adc.c b/drivers/iio/adc/adi-axi-adc.c
index 4156639b3c8bd..a543b91124b07 100644
--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -207,9 +207,9 @@ static int adi_axi_adc_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	if (*expected_ver > ver) {
+	if (ADI_AXI_PCORE_VER_MAJOR(ver) != ADI_AXI_PCORE_VER_MAJOR(*expected_ver)) {
 		dev_err(&pdev->dev,
-			"IP core version is too old. Expected %d.%.2d.%c, Reported %d.%.2d.%c\n",
+			"Major version mismatch. Expected %d.%.2d.%c, Reported %d.%.2d.%c\n",
 			ADI_AXI_PCORE_VER_MAJOR(*expected_ver),
 			ADI_AXI_PCORE_VER_MINOR(*expected_ver),
 			ADI_AXI_PCORE_VER_PATCH(*expected_ver),
-- 
2.43.0



