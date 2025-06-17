Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE6B2F2352;
	Tue, 17 Jun 2025 16:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176456; cv=none; b=qnB7jnsnOFc9Qz//hCCI80prfXhWvHnDe+rX13XURTtxsyZuLy9rcLOL/MSZYl4FJVZwEFSrS8tBHHfMW4e7Dw3huBmvwlRx68kSV4E1hi+PjM4G//PhVH21xhJbc0LSrwr6kDfXDhQUpCRtLhw5TZasS/Jvll+bkgyQuwYvUQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176456; c=relaxed/simple;
	bh=0AB6L39gnb4xRJ00a3ghUpMx6km0S6vLhD0M4EQX6ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/+inMmZdPvFotuYKt1axcqgJPDXy/++hroGnHjfLLAXiVgR2P7JrnbGlXXKcx5AHxkuq1iC25WeXSqbZ9NFSVAC73pF8x2IzcTMfPWUOy4eG/93NJOyN+6d32RJzn00fpQsZNFKB/t9dkFuTYoICQzPRioYMMqkUYsZkEnTUSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APZcOwVS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APZcOwVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BCEC4CEE3;
	Tue, 17 Jun 2025 16:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176456;
	bh=0AB6L39gnb4xRJ00a3ghUpMx6km0S6vLhD0M4EQX6ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APZcOwVSnGlW9OrAMhcabHzcLrtrF7w2LqUAzU/drsw6tcfmi0rRscZ2/Yr6Y78R7
	 X37CaH1PcvHtX9UIfW0J63/sS0hWyZq18AovZ4bAY3s6xYgCZzi2NeJVyGIAr5OAjh
	 CCZrSP8m6yFdpSu4Hf8joO60lwH4yTcE1C41u4Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 191/780] pinctrl: qcom: tlmm-test: Fix potential null dereference in tlmm kunit test
Date: Tue, 17 Jun 2025 17:18:19 +0200
Message-ID: <20250617152459.254103623@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 1938be9fbad1bd87a1dcd9c3ca88e454565f0609 ]

kunit_kzalloc() may return a NULL pointer, dereferencing it without
NULL check may lead to NULL dereference.
Add a NULL check for grp.

Fixes: c7984dc0a2b9 ("pinctrl: qcom: Add test case for TLMM interrupt handling")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/20250325094932.4733-1-hanchunchao@inspur.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/tlmm-test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/qcom/tlmm-test.c b/drivers/pinctrl/qcom/tlmm-test.c
index fd02bf3a76cbc..7b99e89e0f670 100644
--- a/drivers/pinctrl/qcom/tlmm-test.c
+++ b/drivers/pinctrl/qcom/tlmm-test.c
@@ -547,6 +547,7 @@ static int tlmm_test_init(struct kunit *test)
 	struct tlmm_test_priv *priv;
 
 	priv = kunit_kzalloc(test, sizeof(*priv), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, priv);
 
 	atomic_set(&priv->intr_count, 0);
 	atomic_set(&priv->thread_count, 0);
-- 
2.39.5



