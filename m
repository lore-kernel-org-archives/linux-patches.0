Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB63136672;
	Tue, 14 May 2024 11:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684452; cv=none; b=AJq/DGfKM6bXRLacDBD/4kTcrYjt9KGeOlnxwPsFIt7u+NPUOv4FM+GKMhjaGnKh1WM86LS+P0FAISOgnQ925/OpWYG9q8rLDcNJJKpIWa92McsXzmLVo+8YA3dE142cXJwyG/r0vWHqo7Pl6QYXCVR8ad6w0RXaJAdjsctZfvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684452; c=relaxed/simple;
	bh=18gU+Vc/Hn5LyDZcFD14q6SoKkhLFEItosHPd7vc7Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcrBJ6i+ErFz52dUFrHJPQc85YYbvcG33GMJFAh1uBCeRDY/Sg/kktEqbr48trynDNQTOM7HZn7EOFyRd0WdRmMEdLBB5OtsQq/buh8qpwBXyz007Or9IKvW9S9WNVZ+/wg2Q8DwybBeT6gLA6+sfoPaobIdcCsO5dPRDfyVRTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIToCth2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIToCth2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5D4C2BD10;
	Tue, 14 May 2024 11:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684452;
	bh=18gU+Vc/Hn5LyDZcFD14q6SoKkhLFEItosHPd7vc7Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wIToCth2xAbnz9VqT3up0eHZUO3jw1G50/x6G//RWcIJT0IsVvcvYkK5U72bhp+Fh
	 AhStEoKgEyDslGVRG/kjwY4fjOIk8jCZWOrdEruQjYChX/HfDoy7rAKeaMBbbfHWgM
	 3tIEuvo6H1A3+tZqWGQPya8IwFBx50v53BTnqaso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Aleksander Mazur <deweloper@wp.pl>,
	Guenter Roeck <linux@roeck-us.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/301] regulator: change stubbed devm_regulator_get_enable to return Ok
Date: Tue, 14 May 2024 12:14:57 +0200
Message-ID: <20240514101033.232937406@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 96e20adc43c4f81e9163a5188cee75a6dd393e09 ]

The devm_regulator_get_enable() should be a 'call and forget' API,
meaning, when it is used to enable the regulators, the API does not
provide a handle to do any further control of the regulators. It gives
no real benefit to return an error from the stub if CONFIG_REGULATOR is
not set.

On the contrary, returning and error is causing problems to drivers when
hardware is such it works out just fine with no regulator control.
Returning an error forces drivers to specifically handle the case where
CONFIG_REGULATOR is not set, making the mere existence of the stub
questionalble. Furthermore, the stub of the regulator_enable() seems to
be returning Ok.

Change the stub implementation for the devm_regulator_get_enable() to
return Ok so drivers do not separately handle the case where the
CONFIG_REGULATOR is not set.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reported-by: Aleksander Mazur <deweloper@wp.pl>
Suggested-by: Guenter Roeck <linux@roeck-us.net>
Fixes: da279e6965b3 ("regulator: Add devm helpers for get and enable")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/ZiYF6d1V1vSPcsJS@drtxq0yyyyyyyyyyyyyby-3.rev.dnainternet.fi
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/regulator/consumer.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 39b666b40ea61..e3e58d5a84e2a 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -365,7 +365,7 @@ devm_regulator_get_exclusive(struct device *dev, const char *id)
 
 static inline int devm_regulator_get_enable(struct device *dev, const char *id)
 {
-	return -ENODEV;
+	return 0;
 }
 
 static inline int devm_regulator_get_enable_optional(struct device *dev,
-- 
2.43.0



