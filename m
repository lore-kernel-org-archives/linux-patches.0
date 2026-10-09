Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0685A3815D5;
	Fri,  9 Oct 2026 14:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557505; cv=none; b=qZOOZi5VNS+rYBCk0iuVyZeLxpdM4/mXJGHdzqPqvNphdZpeS4uvrIKfHm36WMX3y9lquv+NPBlDRivfe6NgIlEJ3k0ZdqItNdDHx1YpKgvCV9fXHIKWIndd7x2gH9kgn2cz1YHMT2OR0mjmMnz1y/oFNHlOV84zFDh+Lz6zMEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557505; c=relaxed/simple;
	bh=3Z4M6B6BLa4ANEBhjvtkynWQfCVIheB5r28o3Mosn5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWTChdh6ye8L6GYNs9oX+IY1hLtAsP6cUaimAi1uYXSDRp7hHaHtoJac+GcpHMDUYwh1OE4E4n4puABwGuGQjzj65jRkidwQHMXTjUHtit1jVE4KzOHNk+8ovYWg12wUFSzrH3ow8N5SJhkab5iVui5OjObYnIMYlqXkZu7A5gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnRNls+h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnRNls+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646A41F000FF;
	Fri,  9 Oct 2026 14:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557503;
	bh=KVJepQb2lYVIyNWHjG6NFByNe/DlG040SDADI0Zt3N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnRNls+hu6bGtSIxgUtQ8DCbLVobFtqZoLbFz4Ltnw9F1NdJi5urn4n+jTaH5zyDq
	 X0YG0rpRySP3cmZbko2QtF3cqvU9+6iFJbYn43uoq/9LJBVrIOL7Z5HsmhwaRpZDkI
	 2L9t5d3JWspbh5ePdusvA1ZH7dp32co6fXw7gIKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 381/428] iio: adc: aspeed: propagate reset deassert errors
Date: Fri,  9 Oct 2026 16:11:58 +0200
Message-ID: <20261009140954.562763295@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 95e4eb426b4bd666fa2f37886c0ddf74a0cc6167 upstream.

aspeed_adc_probe() continues to register ADC resources after deasserting
the shared reset, even if the reset controller reports a failure.

A failed deassertion leaves the hardware unavailable, so stop probing
before installing the cleanup action and enabling the ADC.

Fixes: edf7550a1f93 ("iio: adc: aspeed: Deassert reset in probe")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/aspeed_adc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -585,7 +585,9 @@ static int aspeed_adc_probe(struct platf
 		return dev_err_probe(dev, PTR_ERR(data->rst),
 				     "invalid or missing reset controller device tree entry");
 
-	reset_control_deassert(data->rst);
+	ret = reset_control_deassert(data->rst);
+	if (ret)
+		return ret;
 
 	ret = devm_add_action_or_reset(dev, aspeed_adc_reset_assert, data->rst);
 	if (ret)


