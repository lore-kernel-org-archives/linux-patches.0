Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30204F68BD;
	Tue, 13 Oct 2026 12:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895900; cv=none; b=iCgg98T4v4+ST0Y7ZkO0h5H66gaAg9w4u8sdTlu32kvCk0p6hrmW3xVuKPRK5XakJAHYLvQErL/c8uLypS+PzMLQy07KMy9nB4icReLcp/tFcHynF6bv1a9+pneD9WYgJl9vkO/o8wHeMcSaZ97zkip4JnpA9o8qFzMeZ5qFndk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895900; c=relaxed/simple;
	bh=/7fel7MLSWDWepat/7ksFkquUwfm3nvqLCuh5BYACpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nE7kFf1cbYJ7dDLZUX8zw5BUpJSQwg3VtnHUuNtNLqN+05O31rqMfdAEwYny2iZbAlT7uRfA7kmZizFfQHIGXGoDx2O5WocKeBhMWxBtBuFRIg65O/DrBcwTG2uK41Kr/yuoILMuiVbZDmeh8LKAbCSs/6Unyz2u6WvgFXA4Cms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJzUMXHh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJzUMXHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271F61F000FF;
	Tue, 13 Oct 2026 12:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895898;
	bh=9m1Se4M4TK29CIXHvyPWelVN4oQcvvx32dBNWHjFu/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tJzUMXHh+e2HfVXqXs6SI6MDJPBIVYIlftfujENB4k8GjV9FkxslJ1IS6G3yuEbzC
	 z4oYdKmK+jp5vXA9abuZ8F+g1ZQJRPqJpL7itzzHDYO5fvrwlGYPaIFcXZgY9lUoGu
	 ZXfKD01dy3kgZT2Y8fnsBcb/LDGDsSduqrjfsuiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.12 431/497] drm/vc4: drain the hangcheck timer and works on V3D unbind
Date: Tue, 13 Oct 2026 13:39:58 +0200
Message-ID: <20261013112918.115855190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 94cf5971b1d04c6382437387c4dc3836cc7a1437 upstream.

Nothing stops the hangcheck timer that submitted jobs arm, or the
job_done_work that the render-done interrupt queues, at teardown:
vc4_irq_disable() cancels only overflow_mem_work, and vc4_gem_destroy()
runs from the drm-managed release, after vc4_v3d_unbind() has already
uninstalled the V3D interrupt and cleared vc4->v3d. A timer still armed
by then reads V3D registers through the NULL vc4->v3d pointer, and the
late callbacks run on the vc4_dev embedding them after it has been
freed.

Drain them in vc4_v3d_unbind(): shut the timer down and cancel
reset_work before the interrupt is taken down, because its
vc4_irq_reset() re-enables it, then flush job_done_work so that
completions queued at teardown still release their jobs.

This issue was found by an in-house static analysis tool.

Fixes: d5b1a78a772f ("drm/vc4: Add support for drawing 3D frames.")
Cc: stable@vger.kernel.org # 6.2+
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260915095103.156007-1-fanwu01@zju.edu.cn
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_v3d.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/vc4/vc4_v3d.c
+++ b/drivers/gpu/drm/vc4/vc4_v3d.c
@@ -9,6 +9,7 @@
 #include <linux/component.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/timer.h>
 
 #include "vc4_drv.h"
 #include "vc4_regs.h"
@@ -495,8 +496,15 @@ static void vc4_v3d_unbind(struct device
 	struct drm_device *drm = data;
 	struct vc4_dev *vc4 = to_vc4_dev(drm);
 
+	/* A straggler vc4_reset() re-enables the interrupt. */
+	timer_shutdown_sync(&vc4->hangcheck.timer);
+	cancel_work_sync(&vc4->hangcheck.reset_work);
+
 	vc4_irq_uninstall(drm);
 
+	/* Flush rather than cancel, so queued completions release their jobs. */
+	flush_work(&vc4->job_done_work);
+
 	/* Disable the binner's overflow memory address, so the next
 	 * driver probe (if any) doesn't try to reuse our old
 	 * allocation.


