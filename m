Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540FA19DF9A;
	Thu, 15 Aug 2024 13:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729830; cv=none; b=AS8MYDZmDSqTz9Jr7t+U4MlxtUF4AyV2zZOw5fWZviZn4VOhS+kfdMmSmt2DVeRz4+64rGP04c/8T1rLzeWXyWmY+V3aOgSqNIb72IW2wJySBqdVMhgFpIdcej1Mr9UU6QF25L2Iav87i5V/NBYVdUi+9ZQ9Ig5RbsLTQ8WX2m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729830; c=relaxed/simple;
	bh=XiCf7rF5yvZBlpXc7wmx/Y2H2Dz6p9JgiLXiRp+IcBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+JS/lttQLSoC05OCzDvlSPj/w7E7wqXZDDUiLPArsjoBR3nmAyhpMy68mQh3Q+z9Isf5Yhvon4ToVV48oUWy4gj1dfWoqsFhnXIef1QGoSmoZz5iu5Chpb7I06nHPCZhesfMuAXjaRZBlsOTYZcZNuH3G/c5t18+LrysiASalQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5tw5oG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5tw5oG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA092C32786;
	Thu, 15 Aug 2024 13:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729830;
	bh=XiCf7rF5yvZBlpXc7wmx/Y2H2Dz6p9JgiLXiRp+IcBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5tw5oG0enUJVGupBcQTO+UVUECgetpRf0npwnz+uo3XOHk36ZddI+jksC4W4VRC0
	 WjSqKwXt5hV1KEr+iJj0ZbB43Epa/+mzwHIqhYmVGgfe6QK4r1N+Iy6G6tcYOl+OFG
	 HZlnTlsBD8fDApPudiT2p3TSodwOQYYum0KvCCnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 5.15 220/484] devres: Fix memory leakage caused by driver API devm_free_percpu()
Date: Thu, 15 Aug 2024 15:21:18 +0200
Message-ID: <20240815131949.909094329@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit bd50a974097bb82d52a458bd3ee39fb723129a0c upstream.

It will cause memory leakage when use driver API devm_free_percpu()
to free memory allocated by devm_alloc_percpu(), fixed by using
devres_release() instead of devres_destroy() within devm_free_percpu().

Fixes: ff86aae3b411 ("devres: add devm_alloc_percpu()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/1719931914-19035-3-git-send-email-quic_zijuhu@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/devres.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -1219,7 +1219,11 @@ EXPORT_SYMBOL_GPL(__devm_alloc_percpu);
  */
 void devm_free_percpu(struct device *dev, void __percpu *pdata)
 {
-	WARN_ON(devres_destroy(dev, devm_percpu_release, devm_percpu_match,
+	/*
+	 * Use devres_release() to prevent memory leakage as
+	 * devm_free_pages() does.
+	 */
+	WARN_ON(devres_release(dev, devm_percpu_release, devm_percpu_match,
 			       (__force void *)pdata));
 }
 EXPORT_SYMBOL_GPL(devm_free_percpu);


