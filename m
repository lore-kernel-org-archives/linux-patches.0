Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211453;
	b=V39sjv41AsazyyCrv/FehdXlU8TcNPATVu9Vp0fP5fzDMTYiYBV3CH2ZJ8IM++iO0614
	 gyPmo+j7d+Y78zV2WuQtPvi3nYxeYGlOmTaVKX669LHBOXC01wesW0X4N1/C5wYtzKfnh
	 tqspRw1tjZpEGTyCbP/GUx2suuJjKMS99OUpY0vk+3PO2sY924ajCNFmpwubpb55hxSsr
	 bhlnP9I2twU9WqFIX/GC5JwOhEpincAcgC1zC06riHDRo1DoCeH7XjoBsaruqpVC9CE7d
	 +FiRQauh4rx8B7EDmo9HUuddO9BjDvjl0UP1L1YYUQIJpejs8pt1xeOmFVyOuAt7fdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fwqyWZ0DbnliVszS5zbMFhdQu29UltdRjtPdgTqi0gA=;
	b=tT6FdZouAM5Byh+QOpWyBxejf2anyWoyAuQglfgOeZL+Ymb9iSUCgACoOmAZpDfEwBas
	 2pGsiIcdqVOOC770DeyFQMxZbutrXCTbmg322JsxnqJMvxy37Uobf89flvKLg1adCCuo0
	 ZcbosN/fUoNODnx8HGKeZNXlaCmmdGFuA6y1jL9wnAcqa5JeB5l0yCumxG8/7OhJtImLW
	 PRpErzVthNaUVCq3EFzLTN+Tr5UOpPjHWyuXYB4ibOXwJzsxkUqVsr/q+bToRM8XmF7dz
	 Zy5mPg5BPJ9Exx3g7aBZn1kkaEGiZI5JYB0zOXWHfq9QVauDShXEyPjMPGCxJcjukag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1UTw5IF7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D60A606A31C;
	Wed, 28 Oct 2026 18:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1UTw5IF7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAE21F01825;
	Wed, 28 Oct 2026 18:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211453;
	bh=fwqyWZ0DbnliVszS5zbMFhdQu29UltdRjtPdgTqi0gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1UTw5IF7HJQSJgxAElFA3Cgaecfn6moT21fIez5iTze3VYMoaiVAm9Baga3gE9faT
	 b06nzfk8WN11XHoTeVV6WYGCjj2u468IYq51UBnse+jAgxAVeAUPVhU1s1pGLQvPbR
	 k0O8w+NaoPlJsy7jo4HUET8uK1ZZ/Xy17oAcvSpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 5.15 384/571] drm/vc4: drain the hangcheck timer and works on V3D unbind
Date: Wed, 28 Oct 2026 17:58:51 +0100
Message-ID: <20261028170017.126111464@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -476,8 +477,15 @@ static void vc4_v3d_unbind(struct device
 
 	pm_runtime_disable(dev);
 
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


