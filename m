Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035541CAA4;
	Tue, 14 May 2024 11:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686151; cv=none; b=Rp0WG3ZJMUZqnNgbnT2PUyIz+sapMv1OrOSUz4fahZpRzxCxfMdsEFngmi5NH/JZNhb6gV+ccBNpc1PBCcD/uGtOgJx3LpEe4aEOscNBFeBvFabzYVSBbGBhC5MYJEBeYJxiIDT6Vr9E6nexj3yGBgiMFzwHgLx62uEnzFP26QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686151; c=relaxed/simple;
	bh=pmBmqqtuTUTQyJ2oQRWVtZFU58a8T9mqxKGppAHVWgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NP/SMTKnqVhgDAOkVx8SHTHAexP1nqZUXHn3JIAPgUMzGyWnDOj/tKxrMK/Ire5olkGWk1opjr6i+U8fMPx214wPP5ct1IpS1PWR2vjM/CkqurMeXcDgyoYnDvEDrPwtW2jo5nB4EIsAYGU3rIZZuf6J/dvICQZJK80dXRIlCuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LqyoGUGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LqyoGUGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8052AC2BD10;
	Tue, 14 May 2024 11:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686150;
	bh=pmBmqqtuTUTQyJ2oQRWVtZFU58a8T9mqxKGppAHVWgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LqyoGUGk1ukjsyInT2watfGhCVc2dIZpEVUxl5Kc+qXA/1pD3S/cnQCy1WwKXZKVj
	 YlTz+nBYMovhQoTJsg8xWacAZw3DRe0lqC27OOhi1hge9wRrrrwpY7/YyMKK9H2/Hf
	 XnWmmzYJlGyZn47ISDGXw/BSpJga6fw0EuEnUdqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Aleksander Mazur <deweloper@wp.pl>,
	Guenter Roeck <linux@roeck-us.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/236] regulator: change stubbed devm_regulator_get_enable to return Ok
Date: Tue, 14 May 2024 12:16:40 +0200
Message-ID: <20240514101021.788814284@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ee3b4a0146119..eea165685588a 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -361,7 +361,7 @@ devm_regulator_get_exclusive(struct device *dev, const char *id)
 
 static inline int devm_regulator_get_enable(struct device *dev, const char *id)
 {
-	return -ENODEV;
+	return 0;
 }
 
 static inline int devm_regulator_get_enable_optional(struct device *dev,
-- 
2.43.0



