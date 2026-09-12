Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A232429803;
	Sat, 12 Sep 2026 10:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209834; cv=none; b=YpNWBnYldrmvW55nFm8CNzf/zMhRC+VVywhG706TZyN8KzxyjGP0CnADD2yLuC9QnmcN1uHTAEPwUYstT5pr2qL0LOjkKN+wVLZCVv1If6ww13P2YatCU8l7KFaT1fqRBmFhxLkGRbBkLC9+Wq0BTUQQ5sbhpbAUJOb6OpXyc0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209834; c=relaxed/simple;
	bh=1DUxndb7521CtbnU1/EeGKWZwtro2RUlbNlgK5kxlc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZLjUoMuDCTYzlQUGIjETrZMe5EzYdFSfRPi4Ja9d9tGRXD2X3ZV6Jkbs8AGUCiqT/63fOUwwSW63VZFjjBWL1gdQbUFMUKL4KRwnxI1hKuUphlqUBGo/k7NmzhchJRw9Ht5rPlGEifPMLw7FTEorPz5rkrg71JEb7xLAOfGSW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dX0+UVZo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dX0+UVZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8E21F00893;
	Sat, 12 Sep 2026 10:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209833;
	bh=nzQAJEQEnTqkLCs0epPox8JhNLHc9sn1SFq7Mz1sgK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dX0+UVZoxMg/dJmjyle9Q6bqhW5vZ2JKOzyxm9gWeunEZEuddSe8994hEpj12wRst
	 l0Ah/f28VOPxY0Rk0xT9n+M5roVLe0JTON1KBILBcA/f9J89r5UhWnIozcWl8Jjyng
	 MS6Xuj3gzEuKR7/gLF/ZFQEHjYldhwR1ZiENrgrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0875/1518] drm/omap: dsi: Do not copy isr table
Date: Sat, 12 Sep 2026 08:50:44 +0200
Message-ID: <20260912065643.243511321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 97c03b32b28a9f7f13f768f2b06e1eaafe850e66 ]

To be able to unregister stuff from isrs, the corresponding table was
copied.  Nobody seems to unregister stuff that way, so it does not help.
But there are stack-allocated objects passed to these isrs giving chances
of UAF of these objects if irqs are unregistered while they are handled,
so better do not copy that table.

Fixes: 4ae2ddddf44cd ("OMAP: DSS2: DSI: Add ISR support")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20260702-dsi-uaf-v2-1-dbb4aa0f0b8e@kemnade.info
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/dss/dsi.c | 7 +------
 drivers/gpu/drm/omapdrm/dss/dsi.h | 2 --
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/dsi.c b/drivers/gpu/drm/omapdrm/dss/dsi.c
index b129e5a8d7915..7bfd7eb32eba3 100644
--- a/drivers/gpu/drm/omapdrm/dss/dsi.c
+++ b/drivers/gpu/drm/omapdrm/dss/dsi.c
@@ -455,15 +455,10 @@ static irqreturn_t omap_dsi_irq_handler(int irq, void *arg)
 		timer_delete(&dsi->te_timer);
 #endif
 
-	/* make a copy and unlock, so that isrs can unregister
-	 * themselves */
-	memcpy(&dsi->isr_tables_copy, &dsi->isr_tables,
-		sizeof(dsi->isr_tables));
+	dsi_handle_isrs(&dsi->isr_tables, irqstatus, vcstatus, ciostatus);
 
 	spin_unlock(&dsi->irq_lock);
 
-	dsi_handle_isrs(&dsi->isr_tables_copy, irqstatus, vcstatus, ciostatus);
-
 	dsi_handle_irq_errors(dsi, irqstatus, vcstatus, ciostatus);
 
 	dsi_collect_irq_stats(dsi, irqstatus, vcstatus, ciostatus);
diff --git a/drivers/gpu/drm/omapdrm/dss/dsi.h b/drivers/gpu/drm/omapdrm/dss/dsi.h
index 601707c0ecc4e..2b25247ea8935 100644
--- a/drivers/gpu/drm/omapdrm/dss/dsi.h
+++ b/drivers/gpu/drm/omapdrm/dss/dsi.h
@@ -379,8 +379,6 @@ struct dsi_data {
 
 	spinlock_t irq_lock;
 	struct dsi_isr_tables isr_tables;
-	/* space for a copy used by the interrupt handler */
-	struct dsi_isr_tables isr_tables_copy;
 
 	int update_vc;
 #ifdef DSI_PERF_MEASURE
-- 
2.53.0



