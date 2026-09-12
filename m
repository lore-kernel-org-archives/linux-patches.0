Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E94436B923;
	Sat, 12 Sep 2026 18:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239595; cv=none; b=iTiVLggIb5UUxzRLc+i4+8OXBrrrXlfFppxfGnVojh1CzCHnfsJTqHGczWBI8aI6PRCRA6ARPORSlVrj/JsRyoQZeEUzJUsAwWOV7SGRNtY+kwVI93BBS/DguUjP+c755P5677h6HHoDUSbI/IVWGlcEa1cpLaTJXEIvf+YhyaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239595; c=relaxed/simple;
	bh=HFAIzvOeIMFIrEmQq0930BNdphM80GQ6KUjT13BfvOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnNbspGoFjx4VPPIJl+EkxeYEztBbKg4pa/VBhYzPyash360Eb+To288VSk+KwlI5d8HNzj069JW+b2Uvgh7ITFaprNDZBkLHkT8CgsbjMqxLwzpQdybADaXgzTBMl5zG4RsGYbJrumQvTD5IEefLlPpBHtqghphLoh6crc8yII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jph5zd3i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jph5zd3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C611F000FF;
	Sat, 12 Sep 2026 18:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239593;
	bh=VQfaNuYGvkKVjsVkS+JSAeIZ5mVrJEbj8caVON4aGOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jph5zd3i21C8vVbSeynwHKiJKKZGsiYZP5MjL12vwI4jSyGzVE1mtS//kOBpDZBtR
	 A3+Rb0QiMXLSFoZlgUCOml54q2oxN/hbuGU5HizpTKuFidHAyDis9PsQgUwKYrbtat
	 4+lmjk+MPqpFVGNJGvnw0HeRooAJ3H/ZRWPUiZY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 696/935] drm/omap: dsi: Do not copy isr table
Date: Sat, 12 Sep 2026 09:02:06 +0200
Message-ID: <20260912065542.804203201@linuxfoundation.org>
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
index 41da86cd8b64c..ef632c71cb412 100644
--- a/drivers/gpu/drm/omapdrm/dss/dsi.c
+++ b/drivers/gpu/drm/omapdrm/dss/dsi.c
@@ -455,15 +455,10 @@ static irqreturn_t omap_dsi_irq_handler(int irq, void *arg)
 		del_timer(&dsi->te_timer);
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



