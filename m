Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6A61D54E9;
	Wed, 19 Feb 2025 09:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957319; cv=none; b=Tkbhb428t0MWoNPxhYDPtAAF8S7TePExC7xy0SpLnn5CiU77xmNTPtvGzApwAIVMlThDY2fzQCF+m2abCxFpgLMLGpndG/874R7nx5BUmiNhMztppfFeUu0awPD+SIo8QndmilToCg4QQ+4l0YLKEUd+tFcCEKixeLoYeyvmbuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957319; c=relaxed/simple;
	bh=mxwtZy00aLjPcVVWG92gIstFiXs95GagGtNP/a9TL0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAbiXfEj20ghbQHcQVuWZmdnanLc4h9BcYcUcs6YjSq4tSY4ZgdXTi50zw1Kb9yvOUZg0vACRpv2AlH3XiPcHD+HwzGG3UHwytnyA1EGcSSw8wozQIf4r73bcrjpvcp0RhY91U33Zk2jSZzRv7B5r0r+B9V+7iELOYzCVF8LwNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkFJFz8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkFJFz8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396DFC4CED1;
	Wed, 19 Feb 2025 09:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957319;
	bh=mxwtZy00aLjPcVVWG92gIstFiXs95GagGtNP/a9TL0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkFJFz8hRhkjIdNmxVFKjxWkuc+EJwj1LAmTRDRbxGY9DMEdU3yytno2cbGV2MpVk
	 A43FGTCoKB4xTysMp0RLmFSFfVmqPvlcPZ5Lmft/dFYXMMiK8TY41GnBcwFmkV+JfV
	 TMJ7D/Zo94xAuDUI7ydHQxztfOb9t6lIwb/wfgL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 483/578] media: cxd2841er: fix 64-bit division on gcc-9
Date: Wed, 19 Feb 2025 09:28:07 +0100
Message-ID: <20250219082712.003108609@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 8d46603eeeb4c6abff1d2e49f2a6ae289dac765e ]

It appears that do_div() once more gets confused by a complex
expression that ends up not quite being constant despite
__builtin_constant_p() thinking it is:

ERROR: modpost: "__aeabi_uldivmod" [drivers/media/dvb-frontends/cxd2841er.ko] undefined!

Use div_u64() instead, forcing the expression to be evaluated
first, and making it a bit more readable.

Cc: Dan Carpenter <dan.carpenter@linaro.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Closes: https://lore.kernel.org/linux-media/CA+G9fYvvNm-aYodLaAwwTjEGtX0YxR-1R14FOA5aHKt0sSVsYg@mail.gmail.com/
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/linux-media/CA+G9fYvvNm-aYodLaAwwTjEGtX0YxR-1R14FOA5aHKt0sSVsYg@mail.gmail.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[hverkuil: added Closes tags]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/cxd2841er.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index e9d1eef40c627..798da50421368 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -311,12 +311,8 @@ static int cxd2841er_set_reg_bits(struct cxd2841er_priv *priv,
 
 static u32 cxd2841er_calc_iffreq_xtal(enum cxd2841er_xtal xtal, u32 ifhz)
 {
-	u64 tmp;
-
-	tmp = (u64) ifhz * 16777216;
-	do_div(tmp, ((xtal == SONY_XTAL_24000) ? 48000000 : 41000000));
-
-	return (u32) tmp;
+	return div_u64(ifhz * 16777216ull,
+		       (xtal == SONY_XTAL_24000) ? 48000000 : 41000000);
 }
 
 static u32 cxd2841er_calc_iffreq(u32 ifhz)
-- 
2.39.5



