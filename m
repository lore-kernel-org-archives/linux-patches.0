Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBB83A1E92;
	Sat, 17 Oct 2026 17:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259627; cv=none; b=Rd9wKud+RtfLNjqgiO/+5U3G6BODv9fDA+9zIlfDS877opLb/nKEY1xmZKjPanr20ZYgigJNcqzEh8/ZiZnBMDLRe9YbRxciPeKWLWIWiGQOq3bNfznyARFOhShOsn+FeujufUK6UBFMCUGVNmFO9WnlRiVfzt1/Xh6wqidUhic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259627; c=relaxed/simple;
	bh=fEb+ts7nnZwyvxStn0nID5fqttTaVA6Lwc39Q6BwK8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGmfaIFrhKOJTUkmj3R5s7qZgEtZdWk3H1/fOLf7fH6yuW53JRudTsPoaO8uwhOv19VkPCBFRYh9RY5FHNsp2GC0yN6CPOfcltGI02ypgP2Q9o++se3n9F1pugDJlrJsCUH6lX9NSuOltZKdwpUE3yPIJSyGJ6j/gPH4GDwDvkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSe6uq3S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSe6uq3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F761F000C4;
	Sat, 17 Oct 2026 17:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259625;
	bh=RRrSOA95a8oHzdiK9mTMFUR9rTCPvA+40j13T/xvdMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZSe6uq3Sqd/zvskIQkOkXue8efqqITuU71Pc6A+CIBtlAEkwrmBA0wNsM/TwjUAJb
	 zcPfcnsvweE8y8FzQHauKYzNYgOd2OrB3n0yO874VLcwXv0K4DAqv5E7T+P+bldW9J
	 zHhqF2ZgITM6UlwrGANIZGRfapI/ojm7nZzaL6+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1274/1674] power: supply: lp8788-charger: fix use-after-free on remove
Date: Sat, 17 Oct 2026 17:59:06 +0200
Message-ID: <20261017160503.843861014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 831c29a12d560f8a3225f43050b3fbb5dfd79c66 ]

lp8788_charger_remove() flushes charger_work before unregistering the
IRQs. An IRQ thread can queue charger_work after flush_work() has
returned. The work can then run after devres frees pchg and dereference
it in lp8788_charger_event().

Unregister the IRQs first. free_irq() waits for any running threaded
handler, so no handler can queue more work afterwards. Then use
cancel_work_sync() to cancel pending work or wait for running work to
finish.

This issue was found by an in-house static analysis tool.

Fixes: 98a276649358 ("power_supply: Add new lp8788 charger driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260802035442.421697-1-fanwu01@zju.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/lp8788-charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/lp8788-charger.c b/drivers/power/supply/lp8788-charger.c
index 72b170b4ac46a..8d9a60d2f7da3 100644
--- a/drivers/power/supply/lp8788-charger.c
+++ b/drivers/power/supply/lp8788-charger.c
@@ -710,8 +710,8 @@ static void lp8788_charger_remove(struct platform_device *pdev)
 {
 	struct lp8788_charger *pchg = platform_get_drvdata(pdev);
 
-	flush_work(&pchg->charger_work);
 	lp8788_irq_unregister(pdev, pchg);
+	cancel_work_sync(&pchg->charger_work);
 }
 
 static struct platform_driver lp8788_charger_driver = {
-- 
2.53.0



