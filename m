Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6600A35AAD5;
	Tue, 26 Aug 2025 14:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218817; cv=none; b=eHoR3tB4bW++lZkgw/rcHhKfb9u5IqENzQiaOsDfGXdO1GQQRQX4+2FMwKvREADMQOdnrHNL8RJIsXENd1X7ZSdlMqIn0IYieIVpN1sGWD4yiDU90IB8qaoM8N7hgjRg1nOa831L17qw+jdeTy4RHKENfngxVmNFEFwyrQCyIKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218817; c=relaxed/simple;
	bh=YMKsOgyOOsIyy3wHuLPt0XRP/Eab940ZvFneTW+hTYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hj0STMw2s2K89b2lioVFLk2vH+UFkUu5DosBnnCS3jl3clqv6Sm1cf3wEfg7MSjw/IbgfR7sCFQowSP5Fd+l3ft3yKmxvqDKWLxn97xhnWaHWIsJIjWy+v1VkHg81wXxXhfvd+6VBpQJp2MAsGUIsxdDDCd3AmtUonQgk33Cabg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpMSTlAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpMSTlAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC97C4CEF1;
	Tue, 26 Aug 2025 14:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218817;
	bh=YMKsOgyOOsIyy3wHuLPt0XRP/Eab940ZvFneTW+hTYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vpMSTlAJVildnevyo7+GP94sI3NR8sIfzctXnYDzOBcSEDGvQOUg/YdUSBOIJV8b6
	 gCs4seKU9nsgwNYV1uV9uRY4qsnuEoy/3ot2c65l364qI3Mbh6Uo6i6Ajqsd3M67dA
	 cBlfyyBCFnsGxvNB8FvPev3XdjbisZpTwCCkDr6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/403] watchdog: ziirave_wdt: check record length in ziirave_firm_verify()
Date: Tue, 26 Aug 2025 13:07:23 +0200
Message-ID: <20250826110909.966800217@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 8b61d8ca751bc15875b50e0ff6ac3ba0cf95a529 ]

The "rec->len" value comes from the firmware.  We generally do
trust firmware, but it's always better to double check.  If
the length value is too large it would lead to memory corruption
when we set "data[i] = ret;"

Fixes: 217209db0204 ("watchdog: ziirave_wdt: Add support to upload the firmware.")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/3b58b453f0faa8b968c90523f52c11908b56c346.1748463049.git.dan.carpenter@linaro.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/ziirave_wdt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/watchdog/ziirave_wdt.c b/drivers/watchdog/ziirave_wdt.c
index 4a363a8b2d20..84c98c4c510c 100644
--- a/drivers/watchdog/ziirave_wdt.c
+++ b/drivers/watchdog/ziirave_wdt.c
@@ -306,6 +306,9 @@ static int ziirave_firm_verify(struct watchdog_device *wdd,
 		const u16 len = be16_to_cpu(rec->len);
 		const u32 addr = be32_to_cpu(rec->addr);
 
+		if (len > sizeof(data))
+			return -EINVAL;
+
 		if (ziirave_firm_addr_readonly(addr))
 			continue;
 
-- 
2.39.5



