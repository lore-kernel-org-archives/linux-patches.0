Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08697433BE;
	Tue, 14 May 2024 10:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682174; cv=none; b=GNknlFtaUIPGZwBljs+4MpZ4KfvUsvHDb8Pzj9aQrso+EPW2RmbkNXnjUNNvVOMEqzxDY9jkQT62l4jpcfn9iJm5ov0t0qcDwGuZ2XLKeKrYSkrdxiagtHVHHj+qrJCp0LZeZiRJTnrf3Jlh7sOV7Is3853I1tR8oISisfWAILw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682174; c=relaxed/simple;
	bh=rcL29BkXqnHFLJ3MscXEkxHoQ/av5ALLAuF8hAD+M88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrKH0W1lyKr4REKT0MYGGIegOi/IjPN1pyiSf+URX4Kpxpei3gdDik5u680l0fdmiwxkU2M2qg7LMJoehcK9iwZ7FmpwwbRK3TbI/NOdkxYXHn2jIKGn41IOJsrqvTdohmcglLH5KjS3evTgrwgFrI1Rb/etR8gJ5rPN//stOuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YB0uBbwh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YB0uBbwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D297AC2BD10;
	Tue, 14 May 2024 10:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682173;
	bh=rcL29BkXqnHFLJ3MscXEkxHoQ/av5ALLAuF8hAD+M88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YB0uBbwhHp1E2AVhdOH+EAjxkp8vvisSkwUphSF6S28XW91YJ+ElVt70oslZcj4Bu
	 2btWS4KGiOgdyvkBcTRdYy+TIkxTVr/1obT3ssXjiVEq8Syhr5G5roUEDb/fpPA88m
	 7pRHgBoJWB2986gWVT2QB/Y8bQSpMkbLsyBMde1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 024/336] regulator: change devm_regulator_get_enable_optional() stub to return Ok
Date: Tue, 14 May 2024 12:13:48 +0200
Message-ID: <20240514101039.518663873@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit ff33132605c1a0acea59e4c523cb7c6fabe856b2 ]

The devm_regulator_get_enable_optional() should be a 'call and forget'
API, meaning, when it is used to enable the regulators, the API does not
provide a handle to do any further control of the regulators. It gives
no real benefit to return an error from the stub if CONFIG_REGULATOR is
not set.

On the contrary, returning an error is causing problems to drivers when
hardware is such it works out just fine with no regulator control.
Returning an error forces drivers to specifically handle the case where
CONFIG_REGULATOR is not set, making the mere existence of the stub
questionalble.

Change the stub implementation for the
devm_regulator_get_enable_optional() to return Ok so drivers do not
separately handle the case where the CONFIG_REGULATOR is not set.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: da279e6965b3 ("regulator: Add devm helpers for get and enable")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/ZiedtOE00Zozd3XO@fedora
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/regulator/consumer.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 71232fb7dda31..ed180ca419dad 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -326,7 +326,7 @@ static inline int devm_regulator_get_enable(struct device *dev, const char *id)
 static inline int devm_regulator_get_enable_optional(struct device *dev,
 						     const char *id)
 {
-	return -ENODEV;
+	return 0;
 }
 
 static inline struct regulator *__must_check
-- 
2.43.0



