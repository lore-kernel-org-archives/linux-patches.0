Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359873F1AB8;
	Fri,  4 Sep 2026 06:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502761; cv=none; b=pxr8Nb+9yBNbaGQU1UnU33PIMh1WZToaKwEnPtfw1Q90mNaZm8mO0KnWdNIDmcB2DnnPlptMTKWjP7V4Cabpk8fehSNb/JDZvUZ4nBD+vu64fIpHs1jK+CvB/26UD6ZEqGrQbAsqLQuw86GCIrIU75Mpx5Y/NTMn3at8k6Mx72k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502761; c=relaxed/simple;
	bh=bXbRDEKhV3/YirUv/cdp+9tE41e/ATGA1r/YuVi1B90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdu/6mD4SoOeW+aWLVoecacO8Br8Xy+fF3CJSMgSiBqi7HpnGN8wS1oy2/q7/TmmUF7ZsI2/BgHzgSqvpuSTBrXUmxNo7ZXtUeDkwlKuzK7P/Q6Mtm5pU9Cen0SreyyPc/J6M9qI9yd/pQ3K70l9chH+okj9a81gnIdPi8XBckc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwnZy+3U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwnZy+3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA6F1F00A3D;
	Fri,  4 Sep 2026 06:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502759;
	bh=ca4My48HfriWM8c7Z++DBtiJvMvZZ7jQjtihfs73Ygg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uwnZy+3UsQs5H5jBf+6f+FetGxhmrmwk+JE9eTo34np7ocDhnroXIfIP0YOGXltFW
	 sQNyd5MxVmwDYGCEPxGuatLwaL1itgGY7AoOgq9Y6nv0MOpxUqjUWvALB3IGruKLFZ
	 YhFWgI/3c6sYPFtk4EY6HoA6geXZmyq7vshucos8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 277/403] power: supply: lp8788-charger: fix use-after-free on remove
Date: Fri,  4 Sep 2026 07:01:20 +0200
Message-ID: <20260904045741.160335708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


