Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61171352092;
	Tue, 26 Aug 2025 14:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217430; cv=none; b=JAmSOcpWA6TUBURrXbOZGij2beUWLu8Ks/ZcGL3idLgg+IjQM9okI+CxPBr+r/RUb1JvNhr1xjIFyYfAseYrx9HlSq7GBhmvRJz0wnrvjlZ+d4YZnwRP7kRoWwGmWhK+LZRoSA40JHLiosppRpX9I9ncmorNnGtqEk0G3GvZrCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217430; c=relaxed/simple;
	bh=6gBoW7TwdzgHG4NmQygTTqW/CuldRgTkcMvDp4Jz0KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLAZ/YF2gq3HB/0bm4/9C8rMLekZ/a+P3UFiraZL1ILq9bMNhSnJyUgoBEzlyVLdyyFu6/e683NxtcWB8+Tpe/S50KPNqv7Rcrl5yINfY7tk6ovFMeXg0Ub6raRAHGi1+Wm/qy2g2eA4Sv8w6WD4JfbCnyxc3n1poOEImvQ3UK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9cfL6Yi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9cfL6Yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AF4C4CEF1;
	Tue, 26 Aug 2025 14:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217430;
	bh=6gBoW7TwdzgHG4NmQygTTqW/CuldRgTkcMvDp4Jz0KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9cfL6YifNyUYfEbAnVYYeyscPVmFZGPGRu3iXOm6/F19eru66KRXbLLwONmI+0HK
	 fPOEsQ+n7HXHwiaRPnScWbtfYlpOy+gPzF0y6jLwDYdbBjIoWTIHs0KipOrqnKo/l+
	 LK/ufztuJYixEjFyYVX1EYSU/0qSSOd+Ihp7bHLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/523] watchdog: ziirave_wdt: check record length in ziirave_firm_verify()
Date: Tue, 26 Aug 2025 13:05:43 +0200
Message-ID: <20250826110927.783120701@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cab86a08456b..3cfab859e507 100644
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



