Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A19438424C;
	Sat, 17 Oct 2026 17:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257027; cv=none; b=aEiJf7Ibt7xE5tWaNOerPveWPPnH1cw0Vyim/+CpG3ZDuLwgfBqv2gXPd7HT2RmJgI4bWnIYn3WEI8dyIXgQuKdoyp0cV01wmEN02sGmnrC7uY1TxWGfDHICTxdHNTttWO1wCxBLTFPxBQsrxtJf66y3ocXBOmKbe04r0H4CUXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257027; c=relaxed/simple;
	bh=7KcFgDeOrORh7T8mJ2Ia+kSDR4TuR4UQef3l7P4hOFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMNWMXk3Awmucp0J7zdf7+pKVWQNjjxjT/dKbp54gngOzoFT+FajXokLWeKJgqCuoU2+DfCtyJct7SAzDkyAt+P6uTyrfHaD90D+GX9z5LH1GS5QdeWkkDLarhYdA5eMtOdLfoBeuVH2e4pL0pimgl19rauM2wrKzT8lOF5pnic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbaoGM0k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbaoGM0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31B11F000C4;
	Sat, 17 Oct 2026 17:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257026;
	bh=MaesOHtQDp6UBpJ7EMCe0ArTRISt7UL9a1ScDemagTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JbaoGM0keAh8MQAlLtYe6lLxPtFLbfJf8F7hTDaW+v5hokpUhNKxBP//cVez7N3vw
	 0qre2Iby4UpwapIswo+TyfXVr3eBln/pIxgNesNRRzLJ2JOs6pcXYbGhbKa7WZfbGt
	 ZS+cwjtqfR4Nrj7UWu2R0C5mPJKqYFXSkYW8CL4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Scardovi <scardracs@disroot.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0426/1674] gpio: rockchip: fix generic IRQ chip leak on remove
Date: Sat, 17 Oct 2026 17:44:58 +0200
Message-ID: <20261017160442.063030254@linuxfoundation.org>
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

From: Marco Scardovi <scardracs@disroot.org>

[ Upstream commit 1c1e0fc88d6ef65bf15d517853251f75ab9d18c3 ]

The driver allocates domain generic chips using
irq_alloc_domain_generic_chips() during probe. However, on driver
remove/teardown, the generic chips are not automatically freed when the
IRQ domain is removed because the domain flags do not include
IRQ_DOMAIN_FLAG_DESTROY_GC.

This causes both the domain generic chips structure and the associated
generic chips to be leaked. Additionally, the generic chips remain on
the global gc_list and may later be visited by generic IRQ chip suspend,
resume, or shutdown callbacks after the GPIO bank has been removed,
potentially resulting in a use-after-free and kernel crash.

Fix the resource leak by explicitly calling
irq_domain_remove_generic_chips() before removing the IRQ domain in
rockchip_gpio_remove().

[ Backport to 6.6.y: Use the upstream teardown helper on 6.6. Defer 6.1
  because irq_domain_remove_generic_chips() is absent and needs a
  prerequisite or reviewed target-native cleanup. ]

Fixes: 936ee2675eee ("gpio/rockchip: add driver for rockchip gpio")
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Marco Scardovi <scardracs@disroot.org>
Link: https://patch.msgid.link/20260607230504.35392-2-scardracs@disroot.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-rockchip.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index e0e4f3ed5fdd4..86cf3cbcdb403 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -786,8 +786,10 @@ static int rockchip_gpio_remove(struct platform_device *pdev)
 	struct rockchip_pin_bank *bank = platform_get_drvdata(pdev);
 
 	irq_set_chained_handler_and_data(bank->irq, NULL, NULL);
-	if (bank->domain)
+	if (bank->domain) {
+		irq_domain_remove_generic_chips(bank->domain);
 		irq_domain_remove(bank->domain);
+	}
 	gpiochip_remove(&bank->gpio_chip);
 
 	return 0;
-- 
2.53.0



