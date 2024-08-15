Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5572719E808;
	Thu, 15 Aug 2024 14:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731640; cv=none; b=dGJhGQKmrS+2jM9jZTIgRNdqBGanPw2eR4kHkIFmQylzzbKoCg4nKb5Ib1yqPZEhOPceAWDghw17pwrg3zaGU4uJC0Bu6HLRWdWyUgYTpFRzAncahLil1tfY0MJZWEcB4S/r6H0MDlnnWGHhpg9wPY7MClF3KuOo3DMOBKbmZzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731640; c=relaxed/simple;
	bh=l1hIH9Yd09Tq+5hQd0PNLJQNU5QTXS7PbEIkqnoBqEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=botGy+HrkTFa+Zbmk2JGGL9V3nDtPE6Q3BKEXEf/bTBcAEomV9j1SvFq349z3mVCaCvV4cD0bd8Wyusi8HfqFRG2u4Ri/RQRhC2sXZHpywFFOU1uAVk2SXbcIGf3c0eOkpKKwF2rp64naT78Qi3BrNdGVRLW0l6f27eDFaqPSa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLJIt54S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLJIt54S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7036C32786;
	Thu, 15 Aug 2024 14:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731640;
	bh=l1hIH9Yd09Tq+5hQd0PNLJQNU5QTXS7PbEIkqnoBqEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLJIt54S4Am6fYffQZTm0Z1cEx0kbxf9r65SGp0IgXxX52KKuyfFeEWUQhPe4engf
	 9tABjZoinev+B8KCSXj1wRD7uec0VcuO/fJArFvmOFNbSwy0+/C4PvRJLXyZU0u3jP
	 hEeFk6au9irh4gL15pMoE1z9wRjpLxgMz4aDxSs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 165/259] devres: Fix memory leakage caused by driver API devm_free_percpu()
Date: Thu, 15 Aug 2024 15:24:58 +0200
Message-ID: <20240815131909.155058835@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit bd50a974097bb82d52a458bd3ee39fb723129a0c ]

It will cause memory leakage when use driver API devm_free_percpu()
to free memory allocated by devm_alloc_percpu(), fixed by using
devres_release() instead of devres_destroy() within devm_free_percpu().

Fixes: ff86aae3b411 ("devres: add devm_alloc_percpu()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/1719931914-19035-3-git-send-email-quic_zijuhu@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devres.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index e8ad6a41ad4ce..5a84bafae3288 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -1111,7 +1111,11 @@ EXPORT_SYMBOL_GPL(__devm_alloc_percpu);
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
-- 
2.43.0



