Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215945;
	b=w5XjoHL6wQWWUOX3iySInzdl3TQtbrx9xaELB8e7+iY6CXRcvzRDLEv/0DB52lu9UU+W
	 b/h47R9Bx3xCzJ/p1/+Az8ft3dbeMjmnW/zsv0OLTQ3MgQxFPPXsXyTUUffeSeHJIoHzf
	 k7iUvJalSHq4vKY4hsvJCzHRhejfuC51VGZ4oqfUvK7jxnpBD5QRpeVrWUXaw5vRc7zYr
	 enIFpauqWkj/3o6n9jqxFMIguNGLq7xxKgmQBj8UxDq2Yl/qyxFyq+As4rsc4rBcfim1l
	 mg+phLmYTSFgvdc4sZKcpoFnowAN+TwaBPHOXEH/bYEuk2NPA3LbG8JWmBUfmlyWYGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ohHgZEt6Ham6I3HvGdRhr2I925yI2tkQImrGCax0nAc=;
	b=kir8mo8A/+dgOGvdSrD1pE5ETNIZguVZIOiuqyVMaZpIcKjn+ibzwwUuajNtrGdNSDgf
	 GUCWvOh/IOl4LY7+aGb56BD4hliHFhjD6eOeP9bPYSnBJDGgJ9ysaBNHb1296+jz1U+XO
	 whO6BaCgktTEYsCuNpkCSKtwrqYpeHJP8g3JZT1Z4wjcPZgyTkyuBFWhknTTBCLp4sBbs
	 kr/icoFma8IWX7vHtHYlxmoXAIV0376qEYxK1oHRtWXkGN5TXUy8e+u2ZdX4wBlxAuMW7
	 eeRCD3+Uymq5CsG5lScJk6s0Kp/2mUeoPINLMJ28c1LgvA8GRhpDuuI0ztpFFwShPNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NplQfa53;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB44A606A31E;
	Wed, 28 Oct 2026 19:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NplQfa53
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494421F01825;
	Wed, 28 Oct 2026 19:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215944;
	bh=ohHgZEt6Ham6I3HvGdRhr2I925yI2tkQImrGCax0nAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NplQfa53qBb0RNqVT56f7j9ROAZ0q4DjdtM+3K/pmfGS06wZ9VpHlRReD37P7zrSm
	 OaA2453VIGInyHj5X+oR/GNIhD4R7dDZ5ivj9b9ol1m3c3KlXIiHAI9hjI2EQs8wXE
	 zbAh1nWZdZ3d6w5dZeWCtAJaXAV2YdRVuN8nhgWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1387/1887] power: supply: lp8788-charger: fix use-after-free on remove
Date: Wed, 28 Oct 2026 17:58:03 +0100
Message-ID: <20261028170531.012089812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 98c15b7abfb88..cf797bf7f6484 100644
--- a/drivers/power/supply/lp8788-charger.c
+++ b/drivers/power/supply/lp8788-charger.c
@@ -711,8 +711,8 @@ static void lp8788_charger_remove(struct platform_device *pdev)
 {
 	struct lp8788_charger *pchg = platform_get_drvdata(pdev);
 
-	flush_work(&pchg->charger_work);
 	lp8788_irq_unregister(pdev, pchg);
+	cancel_work_sync(&pchg->charger_work);
 }
 
 static struct platform_driver lp8788_charger_driver = {
-- 
2.53.0



