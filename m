Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B94403B06;
	Tue, 21 Jul 2026 17:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654855; cv=none; b=RX+1w0jEZoYgqu16tuelepy/M7zBf+Gv3Yw5G46J0ZPjGKFmzYHAveahwKoyAo1+4gJ7J3u4Gpecz3kzoCa6Wr6VJLVNfc35o1NJi1hY2RykEEVtQo5w9Mz5TaVAh0h00vuoESYVacfbyHYsNteOiJLWXsOmVxmNVkDNCilOctg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654855; c=relaxed/simple;
	bh=RxkZGIKf5OTEpxAsQUWoDjEhTTMlHWz2uY91VPQAsN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JC9SVRWIU+vZd75cUfY6NPXA1wLcNPp6VPL3sp3IwBocqQxPjXkTcxGgicaI0OvBSUr94X+I2hivqaM8q7aAz/y9zVWOqQdsFtPCAHhlxbMMIk7bR+FldDfnaTIqJ9ng0QnX36rlPDs21hJSIMq2ssRXWIemNoV0XgofpCM/yuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04xqQihE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04xqQihE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375251F000E9;
	Tue, 21 Jul 2026 17:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654854;
	bh=ZaWvHfwdSfbJv8XEI972LMURJfEGQWvNF/ksJbnLWag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=04xqQihEfdzIOeAXDo5XBkSxge7D7SH5+IOXEAQaWe76syue6Vgw4prkOwAGaYjRe
	 nEnwrynok3BNDVqv2EuwIBtqs8sMA9Mj4GtOwzQzWRUtQuJR9uGbLMjhamPv548dfB
	 qVnJu9FF5ElUnIhSVvnOjFV3nkmjhmzu3eixB/6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Philipp Stanner <phasta@kernel.org>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 7.1 1863/2077] dma-fence: use correct callback in dma_fence_timeline_name()
Date: Tue, 21 Jul 2026 17:25:36 +0200
Message-ID: <20260721152636.674324950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

commit 032a6f6ce21fc701468fd15403d2f53a30107f5b upstream.

dma_fence_timeline_name() is a wrapper around
dma_fence_ops::get_timeline_name(). Since the blamed commit below, it
calls an incorrect callback.

Update it to restore functionality by calling the intended callback.

Fixes: 62918542b7bf ("dma-fence: Fix sparse warnings due __rcu annotations")
Cc: <stable@vger.kernel.org> # v7.1+
[tursulin: added cc stable]
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Reviewed-by: Philipp Stanner <phasta@kernel.org>
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Link: https://lore.kernel.org/r/20260618-linux-drm_crtc_fix-v1-1-801f29c9853d@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-fence.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -1202,7 +1202,7 @@ const char __rcu *dma_fence_timeline_nam
 	/* RCU protection is required for safe access to returned string */
 	ops = rcu_dereference(fence->ops);
 	if (!dma_fence_test_signaled_flag(fence))
-		return (const char __rcu *)ops->get_driver_name(fence);
+		return (const char __rcu *)ops->get_timeline_name(fence);
 	else
 		return (const char __rcu *)"signaled-timeline";
 }


