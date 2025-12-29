Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC7226FD9B;
	Mon, 29 Dec 2025 16:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025180; cv=none; b=uX8+Cd7sckQDfTO6swOS9MfqW5XScPGPAQpvWNbRt6OEQjLxzVNtkR0t7BLPqNonS/CIp/Nzpol0W6ukYNfIlF2i3XxIaYhiv2y62LYwvfvyc1JpmzHYouD5YXwINUJzPyEQJSBm96Afuaa9rKDMORY8lV0Eo86pJfTvl0qrYno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025180; c=relaxed/simple;
	bh=ibI2VCs5ETYkpbmmvghgqD5ivR/5/9wdaKkXHDYt/t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YJp9hUqZlV5FdmUPpsJyeVd5DVKfy/QHypyogTOdF08BFzKBS0XgTeFe0K/AOdlo8fs9xkD6lXkCddN+zNqJpeP6g8Mtl5OH2yeKmTlhh3sT2IN4MIfvOwmaxbIYtzktBGAoUmGXL2SwJ6wdRe+fxnr+wcOkkFgV9Q/MrHU73Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+1LneYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+1LneYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFB5C4CEF7;
	Mon, 29 Dec 2025 16:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025180;
	bh=ibI2VCs5ETYkpbmmvghgqD5ivR/5/9wdaKkXHDYt/t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+1LneYr+4JQq5uMjtCnfFuanwPte78OyANqbdkm/GASiYMN75MGFLIGPGdvjywm+
	 7Hc55eGsRsuW2Knx8nUq/AcNTW5k+dD6fSwhRdMSm84LFf4RKsVDJTunrlLaXIJH6j
	 CMgwl0llwjvr6DfzfjtIMLASqfiQvAiokI1q6zBM=
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
Subject: [PATCH 6.18 122/430] drm/me/gsc: mei interrupt top half should be in irq disabled context
Date: Mon, 29 Dec 2025 17:08:44 +0100
Message-ID: <20251229160728.855560457@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a415ca488791..32d509b11391 100644
--- a/drivers/gpu/drm/xe/xe_heci_gsc.c
+++ b/drivers/gpu/drm/xe/xe_heci_gsc.c
@@ -221,7 +221,7 @@ void xe_heci_gsc_irq_handler(struct xe_device *xe, u32 iir)
 	if (xe->heci_gsc.irq < 0)
 		return;
 
-	ret = generic_handle_irq(xe->heci_gsc.irq);
+	ret = generic_handle_irq_safe(xe->heci_gsc.irq);
 	if (ret)
 		drm_err_ratelimited(&xe->drm, "error handling GSC irq: %d\n", ret);
 }
@@ -241,7 +241,7 @@ void xe_heci_csc_irq_handler(struct xe_device *xe, u32 iir)
 	if (xe->heci_gsc.irq < 0)
 		return;
 
-	ret = generic_handle_irq(xe->heci_gsc.irq);
+	ret = generic_handle_irq_safe(xe->heci_gsc.irq);
 	if (ret)
 		drm_err_ratelimited(&xe->drm, "error handling GSC irq: %d\n", ret);
 }
-- 
2.51.0



