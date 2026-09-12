Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FBF361DA6;
	Sat, 12 Sep 2026 15:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227029; cv=none; b=TuhBjdUvfVvfowzsKelu+W3okYezsCJkT1tu0E4eVf7oAw9CIv46GdFBYc37bpbhB56DBbba1OJnLaLmiW21p3IKezLQBtynqsM3hQjIDA+uMXhB+E3fV6cM+/07kYQ/yiI15qugZVBdg5b+H1BvEXH7bNYwO3LYumoQgut2sgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227029; c=relaxed/simple;
	bh=eN5LQWSvnKk9jvpeyHSF2FiQLMow6JsmMqL41xnezdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsce/d+KOxBcRhKpE69ceESbe4YWFCV5DtdoEeRwo/9dTSOXM7s8SH/G/Ngtggmd3a+wsTOAbrOGAMPtor0lYt1r+Whc6CHDcCd61jVxq/+gft7KRl5pDnJfvovgb3NNgIylmXfLOy+raj55M553mQBz7TS5L6thb+syI91450E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdXyxSbu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdXyxSbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D381F000FF;
	Sat, 12 Sep 2026 15:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227028;
	bh=ivM02eSGmgcO8bEz0bOAV/SLLuGNZeydSZTe8w0Ce4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GdXyxSbuE5ZjGiVMn5cM9p0zRWtgxyTde3h/FmAMsi/ie+a96Sdq5elju2kDROHJ6
	 wCOMxLvWcQK6F8Onk4/BU90mW92t8S9k0YHDLAcxVG6mScvf3xQFje9JTXt5YcGVyb
	 ULusOTz2iSmC5RN+H4yvkHb9XOEG3rErbsBIJHEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>
Subject: [PATCH 6.1 0095/1191] alpha: marvel: Fix irq_set_status_flags to use correct IRQ number
Date: Sat, 12 Sep 2026 08:47:03 +0200
Message-ID: <20260912065550.314208802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


