Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0CD2FDC5C;
	Tue, 26 Aug 2025 13:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215842; cv=none; b=aItp/rvR5VwmH3XUinkDHxJIudDi9zTzj2lwFUtg5vVWorY4rIcibHzff6CqtquA4Dy65vY8YyCtoZJ5NIO0m8176gdAZ0nI8ixCU1wcsxkpt4eBhpKwpcAeSjCMMkxSB/Nr8T/5IJMW7ugdccZp4R0AWd38Ut4M4b44K0LFYc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215842; c=relaxed/simple;
	bh=Ut6u+hGDHqIJ5eMznf8wVnJGWUaonHy6+C63LWxnTNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDseD3DNjNkGMAB5yAjM2dlKbWoSKDe1X+C2CAzMXdQTl8mZ9P9Mwn8a2dAIporBx2oQzLvoWm7ctyKqCa71IoIwDFRYDaMfFXrDjbnP7woCJ0SNYK71sHPRBxltYTziI66YfSgB3VSSk0JUYt0o9QiN/8a6u9Kpnr38edGoajA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvsDTYPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvsDTYPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B664C4CEF1;
	Tue, 26 Aug 2025 13:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215841;
	bh=Ut6u+hGDHqIJ5eMznf8wVnJGWUaonHy6+C63LWxnTNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvsDTYPOEdXoHBIzqsBzPAo27K4ugSG6OoXs0R9m91uthakHMh/U0NA37+fWsMd6/
	 8m5ZLZui/sx2X3dffq8c781PGQ3p/7eg2/Vea6KIw0wz3XR63oBhW1c2cxNxoN7Q8x
	 WpcsBvieHLGBnDaMyL6OFL9EZNPmfu+uALqsBLH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 186/644] watchdog: ziirave_wdt: check record length in ziirave_firm_verify()
Date: Tue, 26 Aug 2025 13:04:37 +0200
Message-ID: <20250826110951.069335535@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c5a9b820d43a..48c68c66e530 100644
--- a/drivers/watchdog/ziirave_wdt.c
+++ b/drivers/watchdog/ziirave_wdt.c
@@ -302,6 +302,9 @@ static int ziirave_firm_verify(struct watchdog_device *wdd,
 		const u16 len = be16_to_cpu(rec->len);
 		const u32 addr = be32_to_cpu(rec->addr);
 
+		if (len > sizeof(data))
+			return -EINVAL;
+
 		if (ziirave_firm_addr_readonly(addr))
 			continue;
 
-- 
2.39.5



