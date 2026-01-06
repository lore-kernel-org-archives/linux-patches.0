Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AED9349AFA;
	Tue,  6 Jan 2026 17:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719920; cv=none; b=SAjk3xBfxvreNikbFJjdpcURpSyoZffbtolLflD5J0G34j8KmDkWjMQb+tIt8TVmvBx2Y1MsYNdk2cviIBLd3H+CR5hsz4pDoCZ5Y2NWnb2UdrcVHXAm7mYfn2C1Ef0Kk2GRJgs4wAuWS6nPnMYqu6d9ps4I7VBwxHWHJ1los00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719920; c=relaxed/simple;
	bh=jhrD5kEQH+quu7q0ux761LWh1ABUjowNoO8UALsg70c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YH/DDt+EOZRnli8dVNVDskAIF5xN+bvCUfC2fD4JIEgdrdSD2peDo7A/v/5eHYVD/osXnovmUP7LP2BoFJ9t/nIBghF6Qh+Zp3rwUwSkIPrq1HIwLNq6R2JAaxUKULCBkK9n58utyit0loU6AeIYhscMXmwgQPCq2UgNm1KgneQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mbwJ/iej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mbwJ/iej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C992C116C6;
	Tue,  6 Jan 2026 17:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719920;
	bh=jhrD5kEQH+quu7q0ux761LWh1ABUjowNoO8UALsg70c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mbwJ/iejc0q2kjdNkMdJsSSmQ12pv7yDnxIPop+/RZ0wyiBQ1X+VBt98rKLEsXWja
	 6UO+6jHLBQFak/UAqiK/mXkHIS2rsm6AmUYxii1fJEfEtdflsTVHeCaamA4wjjseO2
	 EmDCfIBeL/UaXb+48LY+LZioGxXAfKmflFypsTrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoli Zhang <baoli.zhang@intel.com>,
	Junxiao Chang <junxiao.chang@intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/567] drm/me/gsc: mei interrupt top half should be in irq disabled context
Date: Tue,  6 Jan 2026 17:57:43 +0100
Message-ID: <20260106170454.327538423@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxiao Chang <junxiao.chang@intel.com>

[ Upstream commit 17445af7dcc7d645b6fb8951fd10c8b72cc7f23f ]

MEI GSC interrupt comes from i915 or xe driver. It has top half and
bottom half. Top half is called from i915/xe interrupt handler. It
should be in irq disabled context.

With RT kernel(PREEMPT_RT enabled), by default IRQ handler is in
threaded IRQ. MEI GSC top half might be in threaded IRQ context.
generic_handle_irq_safe API could be called from either IRQ or
process context, it disables local IRQ then calls MEI GSC interrupt
top half.

This change fixes B580 GPU boot issue with RT enabled.

Fixes: e02cea83d32d ("drm/xe/gsc: add Battlemage support")
Tested-by: Baoli Zhang <baoli.zhang@intel.com>
Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20251107033152.834960-1-junxiao.chang@intel.com
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
(cherry picked from commit 3efadf028783a49ab2941294187c8b6dd86bf7da)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_heci_gsc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_heci_gsc.c b/drivers/gpu/drm/xe/xe_heci_gsc.c
index 65b2e147c4b9..894a6bd33285 100644
--- a/drivers/gpu/drm/xe/xe_heci_gsc.c
+++ b/drivers/gpu/drm/xe/xe_heci_gsc.c
@@ -230,7 +230,7 @@ void xe_heci_gsc_irq_handler(struct xe_device *xe, u32 iir)
 	if (xe->heci_gsc.irq < 0)
 		return;
 
-	ret = generic_handle_irq(xe->heci_gsc.irq);
+	ret = generic_handle_irq_safe(xe->heci_gsc.irq);
 	if (ret)
 		drm_err_ratelimited(&xe->drm, "error handling GSC irq: %d\n", ret);
 }
@@ -250,7 +250,7 @@ void xe_heci_csc_irq_handler(struct xe_device *xe, u32 iir)
 	if (xe->heci_gsc.irq < 0)
 		return;
 
-	ret = generic_handle_irq(xe->heci_gsc.irq);
+	ret = generic_handle_irq_safe(xe->heci_gsc.irq);
 	if (ret)
 		drm_err_ratelimited(&xe->drm, "error handling GSC irq: %d\n", ret);
 }
-- 
2.51.0



