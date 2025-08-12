Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFBB221FAC;
	Tue, 12 Aug 2025 17:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020938; cv=none; b=PWJr8VoLr6YVKCPPw7vNVGh5n8QOLUhg8Gsd2eO2Q/WfZb3v6r+0aDH0SFcF7ZHIu5q6wXvvco37U+yFfBTh5BzCi1LF5ZV0jeYPrVI6Nlry9gcwj+Hg4iEVxKjN4o95svPPPwG2T+0wNmrhAKFphKwo0uMFinQPC+2HtVSx7ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020938; c=relaxed/simple;
	bh=2VaFDV1li8e+nsEunJ6nNyh61cP4sPbUE24P+JCr9QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9BtXnYye/Xuxk1Ha9gFt3ENg09TMW5haVOT11k+pZdX2cCOW0yNcVn7qbzCtl8iHMrw1js9i5dyx5gkqnoYLEMuRcccztmX2e5KTIXBzVNvftgzNRGenPMmQIwEM3a4NmgmQqJlYYp6dBDRzzlLRc37u/2ppMQGTwMg5orpDBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bQCW2z2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bQCW2z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5122C4CEF0;
	Tue, 12 Aug 2025 17:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020938;
	bh=2VaFDV1li8e+nsEunJ6nNyh61cP4sPbUE24P+JCr9QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1bQCW2z2gaHeGEvfwWBeT51EkzoJHLOYXjt9OOoElQPiaGdKkwWCpXxZh0Igd6nOm
	 rmUIwR0AzOhz+nIy/x1Svl5D1+RFCd840GctiM+xjJ2hr0qRm8apZ0J9cR0i4ZznHV
	 BHO3XKSxVK1Qd0u3HumSHSlzrBc4vNqfAZrKkvDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/253] watchdog: ziirave_wdt: check record length in ziirave_firm_verify()
Date: Tue, 12 Aug 2025 19:29:13 +0200
Message-ID: <20250812172955.739249979@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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
index d0e88875443a..06d59805c9c0 100644
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



