Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC812D46B3;
	Tue, 12 Aug 2025 18:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022490; cv=none; b=Ac3VCK+N2SuauLsev4n4JYih44htYaejyNrzs3FgbjfO1mDln3UllEpNBVUHqdR4WEniRWiVbGtS2wI7UPkX+5I6cQ7WMfsIAF97405clG2hQUwqFcFbftQ48klwiLBN9AOejbyBbARuw/GrKVXarab050WHH8PcGORZH8nMcXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022490; c=relaxed/simple;
	bh=D4QzpAs0Def+j6MgDDbIxmEBcjumqEn5S5LYBOyjMLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmCfSJ7rQms8sa0cBJc/2AGgcwgi4uVQuDJ7r/tg+Tq6s5szk4TF7aQ8da4+QDMTBGZ30ea+4UDAWWhZOFMosYqOFiQZxzuyxZDSM26nL7XmXyDvW9ztczDG/XIONYpZC8xNvNDEIlsxK6pK2h+tcARGELrRquhUsxkEaYMW14g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PN5eYxJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PN5eYxJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6C9C4CEF1;
	Tue, 12 Aug 2025 18:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022490;
	bh=D4QzpAs0Def+j6MgDDbIxmEBcjumqEn5S5LYBOyjMLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PN5eYxJ9jyoUnHS8BggnMlt8qnFQey5+BpJmD75/3OARRPxNDRZlalbWtOBDA3j1z
	 Smo9fTZogchQxrLHbc60MLSVzus/iefamKDPikCFBSFcp9Ujl6wW+cAV8x4zhiS/zx
	 FtTFuu8EbSbiK5a01pJBV1pkz/srpjQMqesurgRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 169/369] pinctrl: berlin: fix memory leak in berlin_pinctrl_build_state()
Date: Tue, 12 Aug 2025 19:27:46 +0200
Message-ID: <20250812173021.123763778@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 8f6f303551100291bf2c1e1ccc66b758fffb1168 ]

In the original implementation, krealloc() failure handling incorrectly
assigned the original memory pointer to NULL after kfree(), causing a
memory leak when reallocation failed.

Fixes: de845036f997 ("pinctrl: berlin: fix error return code of berlin_pinctrl_build_state()")
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Link: https://lore.kernel.org/20250620015343.21494-1-chenyuan_fl@163.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/berlin/berlin.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/berlin/berlin.c b/drivers/pinctrl/berlin/berlin.c
index c372a2a24be4..9dc2da8056b7 100644
--- a/drivers/pinctrl/berlin/berlin.c
+++ b/drivers/pinctrl/berlin/berlin.c
@@ -204,6 +204,7 @@ static int berlin_pinctrl_build_state(struct platform_device *pdev)
 	const struct berlin_desc_group *desc_group;
 	const struct berlin_desc_function *desc_function;
 	int i, max_functions = 0;
+	struct pinfunction *new_functions;
 
 	pctrl->nfunctions = 0;
 
@@ -229,12 +230,15 @@ static int berlin_pinctrl_build_state(struct platform_device *pdev)
 		}
 	}
 
-	pctrl->functions = krealloc(pctrl->functions,
+	new_functions = krealloc(pctrl->functions,
 				    pctrl->nfunctions * sizeof(*pctrl->functions),
 				    GFP_KERNEL);
-	if (!pctrl->functions)
+	if (!new_functions) {
+		kfree(pctrl->functions);
 		return -ENOMEM;
+	}
 
+	pctrl->functions = new_functions;
 	/* map functions to theirs groups */
 	for (i = 0; i < pctrl->desc->ngroups; i++) {
 		desc_group = pctrl->desc->groups + i;
-- 
2.39.5



