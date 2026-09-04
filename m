Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C59C4195A3;
	Fri,  4 Sep 2026 06:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502289; cv=none; b=DDYuRqd7hG/ZZIMaR8HOqwodvtQVvNuEo7S0cVRdXbHD/gp7RbFUUB2C6WG+T3OgN+u9aUqZ7dO4y+FBgIFGzmSINAv+qc8AwEaAidOW+jF6KEoLTeztAMJHIDGZQ8OA5zoHVYDQri5UbhBERAKnYLZDVTMFuG0lOtPtCULJx0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502289; c=relaxed/simple;
	bh=vTAEgbXc6F1NNZfUekW/khjejTgEhlNjQlu70plGeho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KonMUATFjjQfAaIR0my+Bas3XMthKvTiE+qEc6SVFyeKyHLde3X1mEEsDy06n27nnMGLkOgJ5cgMZWRIzeG3sbyh6osSQtbXbrt0f89BYVk9naLRjqoX+x9xsg3AJEcbcFFpW59uSe5FtrVZwMjMcXP2K104GcveUofgIHNCUxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ty4U1p3w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ty4U1p3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74BE1F00A3D;
	Fri,  4 Sep 2026 06:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502288;
	bh=feE8KKD0mW7Gtk9HnjzmFpChStLeuiRQy4shDZCswsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ty4U1p3wKVyHzsRksaDaMF3FO4fMNZiUri7Km6kaSll4zvVX/GlEbWPtAKluU94bk
	 5yJ0LVhXx47bYa2z4SGCrxl6zq977WLNeP+yUUaaOqspaJrpUo/33NO9rxSwdFIYtv
	 pgCBMwgUDR1BmN/n8RtE1pP2dGZteHhkWxWUF72Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>
Subject: [PATCH 6.12 155/403] alpha: marvel: Fix irq_set_status_flags to use correct IRQ number
Date: Fri,  4 Sep 2026 06:59:18 +0200
Message-ID: <20260904045738.378170965@linuxfoundation.org>
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

From: Matt Turner <mattst88@gmail.com>

commit 3a3ac1f6c6a67b3803f2643584310f78301e58a8 upstream.

Pass base + i to irq_set_status_flags() to match the IRQ number
used in irq_set_chip_and_handler(). Previously, IRQ_LEVEL was set
on the wrong (low-numbered) IRQ descriptors rather than the IO7
IRQs at base + i.

Cc: stable@vger.kernel.org
Fixes: 08876fe8519c ("alpha: marvel: Convert irq_chip functions")
Signed-off-by: Matt Turner <mattst88@gmail.com>
Reviewed-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20260528230516.1839694-1-mattst88@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/sys_marvel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -275,7 +275,7 @@ init_io7_irqs(struct io7 *io7,
 	/* Set up the lsi irqs.  */
 	for (i = 0; i < 128; ++i) {
 		irq_set_chip_and_handler(base + i, lsi_ops, handle_level_irq);
-		irq_set_status_flags(i, IRQ_LEVEL);
+		irq_set_status_flags(base + i, IRQ_LEVEL);
 	}
 
 	/* Disable the implemented irqs in hardware.  */
@@ -289,7 +289,7 @@ init_io7_irqs(struct io7 *io7,
 	/* Set up the msi irqs.  */
 	for (i = 128; i < (128 + 512); ++i) {
 		irq_set_chip_and_handler(base + i, msi_ops, handle_level_irq);
-		irq_set_status_flags(i, IRQ_LEVEL);
+		irq_set_status_flags(base + i, IRQ_LEVEL);
 	}
 
 	for (i = 0; i < 16; ++i)


