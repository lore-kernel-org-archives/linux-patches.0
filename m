Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD403264E0;
	Sun,  7 Jun 2026 10:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827813; cv=none; b=mbw4F+AF4NTu6WMQcVKiGUXzYOpbtRVLKYfODJfFFjHw/fHDV1uyuFj1HeRMpDpLooZQY5EVAG0D9zSQAZC2HIo4hsG8ITQdt14qDB/ptBpPfoxu3WQB73kiiE7vNoZNgUdOXc5CWRGRUKgsQMvMLIKtupyCgIPBOSngYlSD7m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827813; c=relaxed/simple;
	bh=pUv6jaGk8QPiO9u9cr+YbgMLR7Zn6UO+Eis9wbrPkRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZY5KGYe8yxHqUkFB00FDV+YHuEBd1SiljOIjN0UlliEdqQgKZGepI/kONJoUq76EB1X8EBLSRChVckF+n3+aVJYdmtKltskVOfTVhN4ETQr+/1DusDyTXg0NoVckBHE9QDadlTF7PBfnZ7uExr9oMcmyX6zIkM8Zy62fGdcORyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfCG8nVV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfCG8nVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06FA1F00893;
	Sun,  7 Jun 2026 10:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827811;
	bh=Bv8Kw+JAIuwDXT7O/QDI/ctgr9sWFNioXX/E3aBK2hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EfCG8nVVCiKrarSjiZT9wqHh3kFjYyVOe5/9uRNMYS16sdugt1wOS0Sf8LBV30pwk
	 C8M16vOlL8Kl5yk6ayRw+pgoLOVQ5tr8IA+xV12sp0iXdq/1q/Od9RKMaX1SWScMH1
	 MLbdUkFLiwkwR7E+aVdwQe7KMtzO3CNrmJrNY0lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Scardovi <scardracs@disroot.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 103/332] gpio: rockchip: convert bank->clk to devm_clk_get_enabled()
Date: Sun,  7 Jun 2026 11:57:52 +0200
Message-ID: <20260607095731.912781481@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Scardovi <scardracs@disroot.org>

[ Upstream commit 3e46c18d5d87f063a93ae0fe7662fbf6660459d5 ]

The bank->clk was previously obtained via of_clk_get() and manually
prepared/enabled. However, it was missing a corresponding clk_put() in
both the error paths and the remove function, leading to a reference leak.

Convert the allocation to devm_clk_get_enabled(), which also properly
propagates failures from clk_prepare_enable() that were previously ignored.

The GPIO bank device uses the same OF node as the previous of_clk_get()
call, so devm_clk_get_enabled(dev, NULL) correctly resolves the same
clock provider entry.

Fix the reference leak and simplify the code by removing the manual
clk_disable_unprepare() calls in the probe error paths and in the
remove function.

Fixes: 936ee2675eee ("gpio/rockchip: add driver for rockchip gpio")
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Marco Scardovi <scardracs@disroot.org>
Link: https://patch.msgid.link/20260526171050.12785-2-scardracs@disroot.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-rockchip.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index 0fff4a699f12d1..f910220141f712 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -656,11 +656,10 @@ static int rockchip_get_bank_data(struct rockchip_pin_bank *bank)
 	if (!bank->irq)
 		return -EINVAL;
 
-	bank->clk = of_clk_get(bank->of_node, 0);
+	bank->clk = devm_clk_get_enabled(bank->dev, NULL);
 	if (IS_ERR(bank->clk))
 		return PTR_ERR(bank->clk);
 
-	clk_prepare_enable(bank->clk);
 	id = readl(bank->reg_base + gpio_regs_v2.version_id);
 
 	switch (id) {
@@ -672,7 +671,6 @@ static int rockchip_get_bank_data(struct rockchip_pin_bank *bank)
 		bank->db_clk = of_clk_get(bank->of_node, 1);
 		if (IS_ERR(bank->db_clk)) {
 			dev_err(bank->dev, "cannot find debounce clk\n");
-			clk_disable_unprepare(bank->clk);
 			return -EINVAL;
 		}
 		break;
@@ -751,7 +749,6 @@ static int rockchip_gpio_probe(struct platform_device *pdev)
 
 	ret = rockchip_gpiolib_register(bank);
 	if (ret) {
-		clk_disable_unprepare(bank->clk);
 		mutex_unlock(&bank->deferred_lock);
 		return ret;
 	}
@@ -792,7 +789,6 @@ static void rockchip_gpio_remove(struct platform_device *pdev)
 {
 	struct rockchip_pin_bank *bank = platform_get_drvdata(pdev);
 
-	clk_disable_unprepare(bank->clk);
 	gpiochip_remove(&bank->gpio_chip);
 }
 
-- 
2.53.0



