Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0028A198A3C;
	Thu,  6 Jun 2024 14:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682938; cv=none; b=XxETyNiEnuIsZKk7RCYnANxYPNiZnQ/kx+U66gmXSdyNPvD8/eQWkxhJv3BmRPe/5Ld3ebLQpnVTjpXtB5fqM3+1JEXMNXw5lTdC4fR85m26ET8TrdxX9LzpHB9ueY47G2lcdUdp+xU+ObWyjTeMdIhn68cTBfPzjjr80aEDiCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682938; c=relaxed/simple;
	bh=Z1pejx5v0xMDNtaKzkoj3ExE0OKywZE6XEaHjZQUVvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XslEmNUR5XfyRUekcq5Q2uca4zXs2ypZE55UeRCkQMD+dJSZu4nBNT+MN7sZ9me/zZp9DRnMm3XcJhAQeMq5W+irWd8VMlGF/oFOpbFutzXmdNtKp9rKgjWo5g2awikUROPgs+oJuxohQ83CWtVtDEYnrCR0n52UBQLBkTAlQqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxTcapJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxTcapJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4220C32781;
	Thu,  6 Jun 2024 14:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682937;
	bh=Z1pejx5v0xMDNtaKzkoj3ExE0OKywZE6XEaHjZQUVvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxTcapJ7zVoB69+sdftsR27LGp0pdkVXo12XEsN+J+7eMOzYgJZ07YGQyv3h8f6fv
	 tJ9O7MmMmfJ0AZMrjf00uyLENO4xY2BiLG9AXPrDKU3ZKMKMfEvIDNbZ4QBUwuiAbw
	 +5UmyuvZRZbt4/zZSEZzcYN22UHDwWqVWpay4u2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 054/374] iio: adc: adi-axi-adc: only error out in major version mismatch
Date: Thu,  6 Jun 2024 16:00:33 +0200
Message-ID: <20240606131653.651287102@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



