Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74F927456;
	Sat, 12 Sep 2026 19:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241451; cv=none; b=Jn+tY700XTmTpuVK+TRuUIC7zJmZaor3HWn9YQdGJyGJvjv2HQXKilDSWYTR29eAQohyF2Yfc/iL0Cyv1b07PkCqWexz3c9xaIUvjBEHuGDRxRf8Y/7KrsBSPHR/tRi4iqlsCwUsWX6jvB7ASMHGaxvzlQhYQ66XNpvqvI9SN00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241451; c=relaxed/simple;
	bh=5XcULo4JW8ryXSefGosrqd1nkXH9mNl+OVMu0RxLGhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScPzHGYUqPNG2y92Eb5csCYU5eO06+UxOE7Bw0kq8smjxYx/1zehA+u8GO5r1zJ+GiuXxFMM4SacmY2tTv4ZjsAgrKOkokDXV6yINieFKj4uPGOKzLka3EurFU639r5g7M7d7SnlMujWpC6u8u+8gDJ3jkMElIu9O7C4FPHcO70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vdWPrhc+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdWPrhc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3471F000FF;
	Sat, 12 Sep 2026 19:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241449;
	bh=LTCJDQ8A0gqaL20GnXueDrYgm//1vjJQl0FVBySsxPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vdWPrhc+lqmv0unKJQyc5U+1OTF0VPnTMXpAgFbwl6/nGs6od4mKcWfOIDAHBgqbV
	 hYlg6W8c0yIL1LbKzFCtCo3qAZYiYoIhTacoVn9EjaqTi7h3Hx7d0fCnSu9cOFMMWu
	 ZIztSGaXskKQ2uEizrC9q9P/ZXjEOLDB/j4AnxCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.10 137/798] power: supply: lp8727: fix use-after-free in lp8727_release_irq()
Date: Sat, 12 Sep 2026 08:56:05 +0200
Message-ID: <20260912065520.117982056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit ceb6ac43b0f591722401922ceb958ce2616935e0 upstream.

lp8727_isr_func(), the threaded IRQ handler, is the only caller that arms
pchg->work via schedule_delayed_work().  lp8727_release_irq() currently
cancels the work before freeing the IRQ, so an IRQ delivered in between
can re-arm the work through the threaded handler.  After .remove returns
the devm layer frees pchg while lp8727_delayed_func() may still run and
dereference it.

Free the IRQ first so the threaded handler is quiesced and can no longer
queue work, then cancel the delayed work to drain the final generation.

This issue was found by an in-house static analysis tool.

Fixes: d71fda016102 ("lp8727_charger: Clean up the interrupt handler")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260807033520.8551-1-fanwu01@zju.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/lp8727_charger.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/power/supply/lp8727_charger.c
+++ b/drivers/power/supply/lp8727_charger.c
@@ -280,10 +280,10 @@ static int lp8727_setup_irq(struct lp872
 
 static void lp8727_release_irq(struct lp8727_chg *pchg)
 {
-	cancel_delayed_work_sync(&pchg->work);
-
 	if (pchg->irq)
 		free_irq(pchg->irq, pchg);
+
+	cancel_delayed_work_sync(&pchg->work);
 }
 
 static enum power_supply_property lp8727_charger_prop[] = {


