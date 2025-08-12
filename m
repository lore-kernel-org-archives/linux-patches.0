Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC04F21A43B;
	Tue, 12 Aug 2025 19:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026275; cv=none; b=AdGBTkQRb0qHvekh87sMG+kdv88ixnY/ideseW++kyfFjc8B0fmD0mD1zKjnhotGCkIsp+xUZPzZgcVIlYHps82f3YGW5oYjMR/Ll/ZGbeyeKAvdnAvxrXH8KUC+Zhr53xBAQIwK5Ifx9moMzPgcNoUoRTc2K2TpFb8po286GUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026275; c=relaxed/simple;
	bh=nJ7hFUe2JXwU0zY7NUZIiMhjcGObUZsn1/HhUjjw9vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcETtbjWG1ZnTh8pCiTnHcNJWA2Hq/havolEcFDn+c5J+hSXfgOrV6gAE9S7Qw9PaQetHjK9ucxIY33r30UmS4djIEL1mUUln//vsEwguQ5UVPIXWemFY8+bJcsjMmwtw9XBiRrjLbilYDfovIWUDubTybKxLbT0/2RMLSOQ7+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdG+twcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdG+twcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD13C4CEF0;
	Tue, 12 Aug 2025 19:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026275;
	bh=nJ7hFUe2JXwU0zY7NUZIiMhjcGObUZsn1/HhUjjw9vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wdG+twcjXqGP0DPyKs1gMLjboDzvuXjqYlHXHNvvFtTU91IpahVw5t9YdhFRZsPih
	 LehEQmLUCOGZHAPbTggyUHe1my5mULHKY38NeB570IwVvG/N7IfObHeHMLWpd4TEQ5
	 WEggyG7xEsBZu73o8Qh/HekyB8yd5wUSPlEcaWJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 288/480] watchdog: ziirave_wdt: check record length in ziirave_firm_verify()
Date: Tue, 12 Aug 2025 19:48:16 +0200
Message-ID: <20250812174409.310895685@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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
index fcc1ba02e75b..5c6e3fa001d8 100644
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



