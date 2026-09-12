Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A11779DA;
	Sat, 12 Sep 2026 08:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201731; cv=none; b=f5+YRmp0xXc6msdGQU2pY88SHC2o7zci0eSfpBiPxIVvhRzmFpytszfjTTwSw0MYYrNPWirzPxjeQI0lK14TGUhU8enfOsB4z6les0u/3t6uPvPxoY+6EhMHcTB65sOq+cmShUaAbrYMbAo1JBIyopAtTJ7YEKyH5b7Z/oRHnDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201731; c=relaxed/simple;
	bh=KBJBIFaXArkMoTlGF7/eWOg8PXc4AgeNKKcFTZ5GBXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsLLyhEUPNF7Lg7JpMRwH0Fg8TWHcRsQIzBxLk/pWv76ZiLtW2SwWWJf+pyXYfPyr3/Eteem9ZwT/cmbuJNZvlfvas6YGWxH61i2zm7pkLLuoGK/23z9CJqdd+6lLS38GVVoRXAxKIrrSE2fIByYJYFRC8bqjwPEOyyvLx6IKT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Dm9fMOU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Dm9fMOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69ADF1F000FF;
	Sat, 12 Sep 2026 08:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201730;
	bh=iEEDfDYmUvYu1+jGutPHX/i+MZE5k8UvO/Ox79iKYHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Dm9fMOUvZ1QsOaRe75MUEHEt5MPfAIk3BBhUjG7IeqTUouR/6CjdsBrz9aawEayb
	 bvchiP23CbqqABuZZnFZ+tiAni/aDkJ8QKmwn3V0TNt5z0jS5GB74pk931ZrZxmULd
	 ZACAWtf5OnPf8W4V/xdjRaKdUpWkm85yyt5zYRFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1049/1815] drm/omap: dsi: Do not copy isr table
Date: Sat, 12 Sep 2026 08:46:39 +0200
Message-ID: <20260912065713.642982555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 27fe7bca9e2cf..70cfb779d6ae5 100644
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



