Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5009248BAE;
	Wed, 15 Jan 2025 10:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938484; cv=none; b=RCDVA2+x69ueIt0BVbtFIbI+3jNhgjMTKkpdPi1iCscOeM2UNOVztTsr0iVTk6U0bZ3cRwKiNTFv3eYy2R8SICelaGNlVefJg0BSrI+mWQoysvTRhvY/uzVdx/kvBY7uWZRJXzXY5thEmUIGVgkp8KjrjMCaW3NixQ6MbnKoq08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938484; c=relaxed/simple;
	bh=VbTQAEh+SQhx6LItcLPKB7Z1BzhCWNWVYeZepFsECYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxiuQhIhJMXSyhYUMNfvUppUd9WbUd6TBIqMXCpfd9phnwidjn5XUDL1PQ9JnJ6UPNEMi4otDuncStoGmmhkQrUnzMAJ6Kat202SHqt4g0JJilgvAJVF3D3F2GKXbyNlvc4nsifqL1haqu/TiErudIhQ5LIjAiLeCVB7Bj0jwkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njfVw1z+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njfVw1z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B4EC4CEDF;
	Wed, 15 Jan 2025 10:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938484;
	bh=VbTQAEh+SQhx6LItcLPKB7Z1BzhCWNWVYeZepFsECYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njfVw1z+QUfYAUIRfOSdHl98ibEcvLrP+So7rSaCnEG/WLq1ycbZUm91m+6PhqXhp
	 AcyQSWZ5fcjKXr7bioywKjH72/duzNYzpJeyrPNlmFEONlWbH0R2IMHa6UJy6i4h7z
	 pmtANPJviN4fXwyAizn+nX/kikONE5J2DVO7Of+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 167/189] iio: adc: ti-ads1298: Add NULL check in ads1298_init
Date: Wed, 15 Jan 2025 11:37:43 +0100
Message-ID: <20250115103613.067542862@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

commit bcb394bb28e55312cace75362b8e489eb0e02a30 upstream.

devm_kasprintf() can return a NULL pointer on failure. A check on the
return value of such a call in ads1298_init() is missing. Add it.

Fixes: 00ef7708fa60 ("iio: adc: ti-ads1298: Add driver")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://patch.msgid.link/20241118090208.14586-1-hanchunchao@inspur.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads1298.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/ti-ads1298.c
+++ b/drivers/iio/adc/ti-ads1298.c
@@ -613,6 +613,8 @@ static int ads1298_init(struct iio_dev *
 	}
 	indio_dev->name = devm_kasprintf(dev, GFP_KERNEL, "ads129%u%s",
 					 indio_dev->num_channels, suffix);
+	if (!indio_dev->name)
+		return -ENOMEM;
 
 	/* Enable internal test signal, double amplitude, double frequency */
 	ret = regmap_write(priv->regmap, ADS1298_REG_CONFIG2,


