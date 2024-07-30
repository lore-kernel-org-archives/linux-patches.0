Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21ED18B495;
	Tue, 30 Jul 2024 17:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359246; cv=none; b=os+xxxcvtTUAfUwS/SnVKhOnPHJ/y9rnm7luj0JBcjewE126Xo9TDUBio9qEVJm06d15ze3rfbKE+HuyF9jsnvm0R8Rm2rj9dag6KPo2dSuux+OTvwJvfn3zBII3hsW4WLooCa/XZcsnsdIXqQDXzb0PtE0kFbw/68RRHMjVJ+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359246; c=relaxed/simple;
	bh=I6gvBc1D9mF0gy4wnPiaTDvxcJSemGHeCq5KgwJLWMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXGf/7JIVkdq6ZEU/+ezA60Z2nELQUTD0Ocm0YjiqBkNJZmHkdGZg7qSoQdiEFMfxE34ZeUDfPsVoVxAZFXzbtULuu95v1F+HnpcXe9FACYulbGyQUMI/BKj2D4f1Kts8AkB4oFlbRlMmIWkAb2KD+ufWZ1qzdEGA4i4zYDmfhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zdzfnx3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zdzfnx3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF87BC4AF10;
	Tue, 30 Jul 2024 17:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359246;
	bh=I6gvBc1D9mF0gy4wnPiaTDvxcJSemGHeCq5KgwJLWMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zdzfnx3HD7JTLS5zixOCqUxGc9TbLnZ+iAWkctH8qPPXk/dYhjPc5B7dFOrl/3VSs
	 JDIonSRT3L2aJGl0XqsNkPWyKeSsHwH/CnUPKZ00/u7RdH/3bpL+KfFL5kPT0EXouH
	 JM4VBwieOkI1AhjgYRGBSVXwNWZsWz3xnLeoUf30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 6.6 453/568] devres: Fix memory leakage caused by driver API devm_free_percpu()
Date: Tue, 30 Jul 2024 17:49:20 +0200
Message-ID: <20240730151657.717185675@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1225,7 +1225,11 @@ EXPORT_SYMBOL_GPL(__devm_alloc_percpu);
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


