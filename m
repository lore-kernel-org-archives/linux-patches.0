Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8751232D7F8;
	Sat, 12 Sep 2026 18:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236929; cv=none; b=THNh+Hn28z3SWGCS/bYWduQWX6nxyw4ONEQDdumfl9ybQ5P16ZVNjdX6OR7hz5VW3X+3RKX1QbaxvZVnuDDukluZb6KW+WvUPoY1O6uVF/JpHKSmnL0eNXfxPKB7xvZAUuZFsaiLYjNWjudYRlf20F8sSk5hQo3xNN/2l2tiurw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236929; c=relaxed/simple;
	bh=QwybWYh9QF7etRnshQV2CY6xMVC4/RZ7qAD9dcq64mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcVeLbNmTz/pI6k6ybLbDH+QIXkv26wgjMIzYd5b7K0c24evj0+EFnSXlc6eT4prfrcoqyajm6Q2CCZkI0NFfOropHcojXXDGZY8EdtPP40vidCCesVPVx5E4VzlSvmYXw36bXslLACVBYHo5TG45jTinb9RYhYM0qQ/jn+kcZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIoz3r6H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIoz3r6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3BC1F000FF;
	Sat, 12 Sep 2026 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789236927;
	bh=mHqIvTB2CiGtS+hoDRTQe6ygDo8vpZEto968qwKf6po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIoz3r6HCaAcEgOnOnRxR77BfA3/oA1UehukT9hIXq3MkEK7V2UV2POgHqvQZF55C
	 thi8Dx3srQPIWZvOGaFCm9PXnZFjrxkH19PDu0oi8YRuCPMctVqum4RT9N3mKNToFq
	 vUKcLbHjIUV+80wZYe1KBzVjD7ytF74F4Gd6sNSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.15 154/935] power: supply: lp8727: fix use-after-free in lp8727_release_irq()
Date: Sat, 12 Sep 2026 08:53:04 +0200
Message-ID: <20260912065530.355718981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


