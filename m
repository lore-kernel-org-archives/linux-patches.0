Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E7822578A;
	Thu,  3 Jul 2025 14:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554569; cv=none; b=n8zl6C09i6cPJdBtHSBkxLTdMtgKIp+/JLgGZ6O0FtLF+X9UE1pDh25TWqxeX8BcDnkCdpbsWvxJOjMBSOQ3yse53vNAjYM4EM+2Dj3naFYvyTsfXs74W2seRB3YDbl3VUMhpnWof56GJAyhgOKymP6cbdzA4ZJWbNk1lmONsBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554569; c=relaxed/simple;
	bh=K4Z9CQJBlDwZM2B6Qs7zIPpjcWbQKr+S9WkvFxxC2Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bxmt75wSdIj0D45pJmqMFg3waZ2ioWTVyIjUxzx5BuxGuIDVLmfYQzxBFU/kGitdeZWWo7HJ3UaKQz5stmwNSHP11Sgu7S0sa5uKfrimT8LpxG9KbFHB/VamARTaZ+Yrtt1BYe9BkAhx7QTGhrZ2WkjF39/iCg9mGnaeqTRsjrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGNSd5AC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGNSd5AC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC26AC4CEE3;
	Thu,  3 Jul 2025 14:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554569;
	bh=K4Z9CQJBlDwZM2B6Qs7zIPpjcWbQKr+S9WkvFxxC2Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGNSd5AC5J3jUsb6bwR9U4vWB7mj+ch53bithfha1YGDb6YBnJxcNjg/TjJl2/uGA
	 iry2VlHceNuHxa6Gx8Bb95aoi55f3+P4jAod4JKDvufVaSXPTWzXH0PHEwBUtIck23
	 fK1gVW/IqruPiBbbaTx4a4gbtHfRsvhnh3/D03ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Karel Balej <balejk@matfyz.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 011/263] mfd: 88pm886: Fix wakeup source leaks on device unbind
Date: Thu,  3 Jul 2025 16:38:51 +0200
Message-ID: <20250703144004.744977177@linuxfoundation.org>
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

[ Upstream commit 6d0b2398b2638208d68ba06601f776cd5d983b75 ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Karel Balej <balejk@matfyz.cz>
Link: https://lore.kernel.org/r/20250406-mfd-device-wakekup-leak-v1-1-318e14bdba0a@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/88pm886.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/88pm886.c b/drivers/mfd/88pm886.c
index 891fdce5d8c12..177878aa32f86 100644
--- a/drivers/mfd/88pm886.c
+++ b/drivers/mfd/88pm886.c
@@ -124,7 +124,11 @@ static int pm886_probe(struct i2c_client *client)
 	if (err)
 		return dev_err_probe(dev, err, "Failed to register power off handler\n");
 
-	device_init_wakeup(dev, device_property_read_bool(dev, "wakeup-source"));
+	if (device_property_read_bool(dev, "wakeup-source")) {
+		err = devm_device_init_wakeup(dev);
+		if (err)
+			return dev_err_probe(dev, err, "Failed to init wakeup\n");
+	}
 
 	return 0;
 }
-- 
2.39.5



