Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378AF2AE68;
	Mon, 30 Dec 2024 15:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573730; cv=none; b=aLnbcqceZRcgO14tQBbpo8rEJIgeavsJeD3sKrPHmodvSSnm/VJ+ihAzdcQfRhJjLk8dobj07vXSCa4QkKNYRsYlBXIgK1tJJxquP6ZxiLDSpNQLB9Nq9d0TQLPhjC06LkRuUPzKOc6mhXeky+DpOgpuYRwY487rA37f5MziRjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573730; c=relaxed/simple;
	bh=H09v3M/+kQoGaWp9yfCFYxMY/qY0Zt/feeooo0BUKK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4R0dt2j8J6nTxwYpVL2EjiItoDy8wfVWF3MB+0GEFKlAMRfruRppsyR4j7bknGubrSG/k8BqYTJPwqOBOK4giWYEXNlg51cWEj5N1LK+AQJR3a6gunMT7pSJkeiidGOrEZAiuGSgclydlC1Tk3pYHiOB8PxPmj2Yuek/u16NAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7Llz/Sc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7Llz/Sc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95654C4CED0;
	Mon, 30 Dec 2024 15:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573730;
	bh=H09v3M/+kQoGaWp9yfCFYxMY/qY0Zt/feeooo0BUKK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7Llz/Sc5n3QxUTx93EHzVe1h/2av+kztYfCiA4zmqODeS9QaZLWNx74r6QvVOtIK
	 niEvkEpVAnfH3CKiXRI3cA7yDmOAc1LKuH3jraQSQ+b/QUuLNgURehhYnDKrhiz11N
	 7LBoylMjaxQN0idL6kLhGpsVVorKmANrw9txnXv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 19/86] phy: core: Fix that API devm_phy_destroy() fails to destroy the phy
Date: Mon, 30 Dec 2024 16:42:27 +0100
Message-ID: <20241230154212.453884238@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 4dc48c88fcf82b89fdebd83a906aaa64f40fb8a9 upstream.

For devm_phy_destroy(), its comment says it needs to invoke phy_destroy()
to destroy the phy, but it will not actually invoke the function since
devres_destroy() does not call devm_phy_consume(), and the missing
phy_destroy() call will cause that the phy fails to be destroyed.

Fortunately, the faulty API has not been used by current kernel tree.
Fix by using devres_release() instead of devres_destroy() within the API.

Fixes: ff764963479a ("drivers: phy: add generic PHY framework")
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241213-phy_core_fix-v6-3-40ae28f5015a@quicinc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/phy-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -1074,7 +1074,7 @@ void devm_phy_destroy(struct device *dev
 {
 	int r;
 
-	r = devres_destroy(dev, devm_phy_consume, devm_phy_match, phy);
+	r = devres_release(dev, devm_phy_consume, devm_phy_match, phy);
 	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
 }
 EXPORT_SYMBOL_GPL(devm_phy_destroy);


