Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D853242BD;
	Fri,  4 Sep 2026 05:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501335; cv=none; b=lc9wN5dcbFyqDjgjBGvzOCyZA/nnNEjO2umY+Vp9wmujYwNHBdm7TNcKNq/i9edLAL6dpLGyQZD/HOIxyF0y0yzKKfXIeeEZ6hNeTlZu/Wu7lIVFutCFsVpGQW3UOFX2x0kVGmymZ2no8Ss+IGb1Gb3M6UFYPPQnyo9CjzzVypE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501335; c=relaxed/simple;
	bh=NSx243XVkoDROxdGlQS9Q97dGOBOaP8UcQjv8DZB4vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ah+R5P+Z8tqctLR4ZATXcAuWgj5neN5GKm1j+kRnr/1+UjwgZjYHdV/eYMzJGZC1+XY+7dhMl3REFWVJFMYzqo2sx2VDZLZFhVhfiJQFDSHzhcnJpnz+wsFmV5RNDxmTpegHjaBntup5/2cdLtQIE0Ok+ol0x8Z5UXEMB+CNa3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfsSu/5n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfsSu/5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E091F00A3D;
	Fri,  4 Sep 2026 05:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501333;
	bh=0atVxI04X99k0f8SuRSPuWHmLVVG7E1GwsA0HUU+FkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfsSu/5nqu/FRLD4BUUozv2e6xI6xfDzTxPQi4quxwAGHxxm5gVrYh462U3MxvF7S
	 GoZ8zJYIT2+2WTtuc9BWczUE2q4ePCMnPGwBuqqy4bk4Fhzk8aen4KNOc5kGBnLGVr
	 T1JSLU1jeo63hu7BMWG4E8HgGDBMrXGuXowsZArk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.18 373/552] power: supply: lp8788-charger: fix use-after-free on remove
Date: Fri,  4 Sep 2026 06:58:50 +0200
Message-ID: <20260904045758.679804980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 831c29a12d560f8a3225f43050b3fbb5dfd79c66 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/lp8788-charger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/lp8788-charger.c
+++ b/drivers/power/supply/lp8788-charger.c
@@ -710,8 +710,8 @@ static void lp8788_charger_remove(struct
 {
 	struct lp8788_charger *pchg = platform_get_drvdata(pdev);
 
-	flush_work(&pchg->charger_work);
 	lp8788_irq_unregister(pdev, pchg);
+	cancel_work_sync(&pchg->charger_work);
 }
 
 static struct platform_driver lp8788_charger_driver = {


