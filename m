Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D58F27FD76;
	Tue, 27 May 2025 17:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368319; cv=none; b=McpokHLzn1BASmkPYHzVrRXxkMOGd5B3dW+RGDOu9m7Ri/DQQRHIXu4XgGv0GjadZHElAivR7zf653HS57nQ0keYA7C6iQOu/iYk98Rs/Ma4T2QQeIt3L8kLggWA04ZVooeeyq8YuI7USBJFXaYQWZ6v4r15phRNmV11OLhzPy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368319; c=relaxed/simple;
	bh=leg0yBgssGT0IX4ODoxtWRagMHHon7swK23f+56+OJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bzk+qmpYdeNQR4OnLW0XfrqkAW9ZnHa74ZFeO5EQlYz9Eq5Tu9YvRBUWYGWkyHu/2kicjKFVx8TNBucA/oFfXEhjKxkcQbD/8Bi4oWdZwQ1IixlV0RJpLSXdDRQEye4Dx6AKsx8w/RMhC7+bzsW7MH4cfPCHfj6eWA2IBEPworU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjYMO2ZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjYMO2ZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8061AC4CEE9;
	Tue, 27 May 2025 17:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368318;
	bh=leg0yBgssGT0IX4ODoxtWRagMHHon7swK23f+56+OJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjYMO2ZWMoYuYvE91spwC97ypsHBd9DKvQz6q6PTFBEAXmZxAFblOl3sPLrG1NG8H
	 nirrWY9JG5CwLJF8C95wxTHA12GUgf6p6qwlFNpH9N1/qkfuB3KeJ1rLb7ubPAXjXe
	 t3O2nVtfgyc8YJ+Wf1lrZSj/Vtg797P/kd96o6V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 669/783] iio: imu: st_lsm6dsx: Fix wakeup source leaks on device unbind
Date: Tue, 27 May 2025 18:27:46 +0200
Message-ID: <20250527162540.366568170@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 4551383e78d59b34eea3f4ed28ad22df99e25d59 ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250406-b4-device-wakeup-leak-iio-v1-3-2d7d322a4a93@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index 4fdcc2acc94ed..96c6106b95eef 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -2719,8 +2719,11 @@ int st_lsm6dsx_probe(struct device *dev, int irq, int hw_id,
 	}
 
 	if (device_property_read_bool(dev, "wakeup-source") ||
-	    (pdata && pdata->wakeup_source))
-		device_init_wakeup(dev, true);
+	    (pdata && pdata->wakeup_source)) {
+		err = devm_device_init_wakeup(dev);
+		if (err)
+			return dev_err_probe(dev, err, "Failed to init wakeup\n");
+	}
 
 	return 0;
 }
-- 
2.39.5



