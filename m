Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051FA2153DF;
	Thu, 12 Dec 2024 15:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017486; cv=none; b=bdjwtcO4mlhbe5oClMFETjpqNSvVgPH9B+dFR0HQToV/1LQj1xyLG1r247h720thro/1HGzZhJ7vwnd7Lu15bEOGbCZT/sBU4uDujXH5rSSGSsiwyuiE6hbjuoz0Z2oOvtb7SLLPNaRB2wmVgipJGeAeWnECn0DgSIY6VlbmLCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017486; c=relaxed/simple;
	bh=NNSdQmeuZDTut333e4McuLMZNDHkvtBecOxKX2+9oGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4eacrnx1i2FIVXw7Xzc13i5NGDH8/vpi5l/f2s02WGVVGJEOnIaYZ7sBQq6mCc9GDnzB9R7jbYELARd1uhwq1jV2siJWD+e0cSHLxeHUgc9/CPue1fVY8UDb7gUS/ATgCXrzNW/tXS9IFsW+xUi0zvRcRQ4Q6rt2D2vtnzUmSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPpiczTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPpiczTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630DEC4CECE;
	Thu, 12 Dec 2024 15:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017485;
	bh=NNSdQmeuZDTut333e4McuLMZNDHkvtBecOxKX2+9oGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPpiczTScp3abtQHGhviJoQ9q5SiUDUft6eEk2pnfI+PtLWQPK9GeQzPkRFPzhHie
	 sRZ5xjgGeLiYtHZHyudVj4vZTlUpv1btSzKBJhHNIPX8pVEv9oTRKMJr8HWrnsF4QM
	 BeR4Kw5lnj+rn5a0E/T6IzawreZsBElq7w75rlwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nick Chan <towinchenmi@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/356] watchdog: apple: Actually flush writes after requesting watchdog restart
Date: Thu, 12 Dec 2024 15:55:22 +0100
Message-ID: <20241212144244.748072057@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Nick Chan <towinchenmi@gmail.com>

[ Upstream commit 51dfe714c03c066aabc815a2bb2adcc998dfcb30 ]

Although there is an existing code comment about flushing the writes,
writes were not actually being flushed.

Actually flush the writes by changing readl_relaxed() to readl().

Fixes: 4ed224aeaf661 ("watchdog: Add Apple SoC watchdog driver")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Nick Chan <towinchenmi@gmail.com>
Reviewed-by: Guenter Roeck  <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20241001170018.20139-2-towinchenmi@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/apple_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/apple_wdt.c b/drivers/watchdog/apple_wdt.c
index eddeb0fede896..24e457b695662 100644
--- a/drivers/watchdog/apple_wdt.c
+++ b/drivers/watchdog/apple_wdt.c
@@ -130,7 +130,7 @@ static int apple_wdt_restart(struct watchdog_device *wdd, unsigned long mode,
 	 * can take up to ~20-25ms until the SoC is actually reset. Just wait
 	 * 50ms here to be safe.
 	 */
-	(void)readl_relaxed(wdt->regs + APPLE_WDT_WD1_CUR_TIME);
+	(void)readl(wdt->regs + APPLE_WDT_WD1_CUR_TIME);
 	mdelay(50);
 
 	return 0;
-- 
2.43.0



