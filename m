Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B726A288B9;
	Sat, 12 Sep 2026 16:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230774; cv=none; b=ksM8oNhL+As+W4J8Q/UwvnCter2rmnV9yCaS+KYbJTHd1XepGtN8nzNa454a92Bn5HXWGocxCAix6GlrzHxHkP+V1dgK77DmTGTeso/Pz9v5TlOGZv91HkMBns4kXUUT1U7ygkFMQ38Rm/ZHFSdTBxuDDG23PEFs3ox8Fqdfp6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230774; c=relaxed/simple;
	bh=lSGvNkBHH1V6xW9I5qrxx7GTQ0L1zT3UllJ78sp45Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0p2S2A28OdeX7pakzx+NEhvAamvrc29bT/Wjf2+kdjWYVyZ06VxjxJJ3DJ/8+n/7wBlyVoEUSMislOMgZCGRoMPPeZDY2lKMVx3KlsJ/md6jB2dknFSK2CHBQ2HLS3Xc7R7jtQGIugtSiKHAG/KXvgmTEMcCUmxmN96cKfBT+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14Mugthf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14Mugthf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4501B1F000FF;
	Sat, 12 Sep 2026 16:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230773;
	bh=3QpGgSOdDys8aqLyjlaA9y3wvWbHGDY2YQ5r40PI0iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14Mugthf08pOqHl+gao+9Kv+fDk1cuUMHF+l4UNnXIINk/mRvAMjDJxQ/eAne2vk9
	 GkOhGpd32S3+mc/VSC/aQJ0kQhtTW47J3h/K/5Gx+eAeLXhWuZwGmFib2rKa8R7W9b
	 V84ayNB2f8/3by/DNB/nmUIkgBB71A38pjwFtVzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0862/1191] drm/omap: dsi: Do not copy isr table
Date: Sat, 12 Sep 2026 08:59:50 +0200
Message-ID: <20260912065607.612722791@linuxfoundation.org>
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
index 4c1084eb01759..708520e5d4525 100644
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



