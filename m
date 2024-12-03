Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840D01F4276;
	Tue,  3 Dec 2024 15:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239716; cv=none; b=Odkj80tdDn0GVBcK6IiB3u+yLQyGTivxh6qfiBhu97k9TOTGk8gYklbEjSiF+MhWH3iao2Ng5lmJdgVigc6mlZePt2DYYVxHpKXPWP3ZUgZq9+QrtsCC+9/RuSZQtP5D/wKul11qQ6lB/uRICrmS1wWiYbGmWuZuhptmtHlWCwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239716; c=relaxed/simple;
	bh=BBHxwRwH7aJlHeyMmyA31+kGgspyYz5QTGZ2C2+h4+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMdcl9FIYihi/503a1QHKEHLD2NL73fsia+BS/N8+KnNllBMrXx6UTxgepigzR4F7rDUtGl+5dKHRCu6QuEQpCbmioF1D9ok4UzkLuEn41joyRVbo4B8ROkHujXcrYdkz8Ztfz5Ft3hHLRvolcUVsppJO4a0dzvCQ2JsYJVnCZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lR6A+bYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lR6A+bYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4389C4CECF;
	Tue,  3 Dec 2024 15:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239716;
	bh=BBHxwRwH7aJlHeyMmyA31+kGgspyYz5QTGZ2C2+h4+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lR6A+bYhZqIhNW4coqVktRfG18D0Yqz4RaGKaU3uxEH2gTExA67/4pUETJeiHVUmX
	 bFnjZ06uUH4y0gGzcELV9ORJeQ2ll3th953v8M1HMiMe439hys/28aKAwFbMLQfp3M
	 nncRWZipTg5CqVkTitN0lSuoxDAinf1FB3h/mMDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.11 708/817] irqchip/irq-mvebu-sei: Move misplaced select() callback to SEI CP domain
Date: Tue,  3 Dec 2024 15:44:40 +0100
Message-ID: <20241203144023.619761295@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 12aaf67584cf19dc84615b7aba272fe642c35b8b upstream.

Commit fbdf14e90ce4 ("irqchip/irq-mvebu-sei: Switch to MSI parent")
introduced in v6.11-rc1 broke Mavell Armada platforms (and possibly others)
by incorrectly switching irq-mvebu-sei to MSI parent.

In the above commit, msi_parent_ops is set for the sei->cp_domain, but
rather than adding a .select method to mvebu_sei_cp_domain_ops (which is
associated with sei->cp_domain), it was added to mvebu_sei_domain_ops which
is associated with sei->sei_domain, which doesn't have any
msi_parent_ops. This makes the call to msi_lib_irq_domain_select() always
fail.

This bug manifests itself with the following kernel messages on Armada 8040
based systems:

 platform f21e0000.interrupt-controller:interrupt-controller@50: deferred probe pending: (reason unknown)
 platform f41e0000.interrupt-controller:interrupt-controller@50: deferred probe pending: (reason unknown)

Move the select callback to mvebu_sei_cp_domain_ops to cure it.

Fixes: fbdf14e90ce4 ("irqchip/irq-mvebu-sei: Switch to MSI parent")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/E1tE6bh-004CmX-QU@rmk-PC.armlinux.org.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-mvebu-sei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-mvebu-sei.c b/drivers/irqchip/irq-mvebu-sei.c
index f8c70f2d100a..065166ab5dbc 100644
--- a/drivers/irqchip/irq-mvebu-sei.c
+++ b/drivers/irqchip/irq-mvebu-sei.c
@@ -192,7 +192,6 @@ static void mvebu_sei_domain_free(struct irq_domain *domain, unsigned int virq,
 }
 
 static const struct irq_domain_ops mvebu_sei_domain_ops = {
-	.select	= msi_lib_irq_domain_select,
 	.alloc	= mvebu_sei_domain_alloc,
 	.free	= mvebu_sei_domain_free,
 };
@@ -306,6 +305,7 @@ static void mvebu_sei_cp_domain_free(struct irq_domain *domain,
 }
 
 static const struct irq_domain_ops mvebu_sei_cp_domain_ops = {
+	.select	= msi_lib_irq_domain_select,
 	.alloc	= mvebu_sei_cp_domain_alloc,
 	.free	= mvebu_sei_cp_domain_free,
 };
-- 
2.47.1



