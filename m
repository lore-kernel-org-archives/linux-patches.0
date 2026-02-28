Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3B9344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301719; cv=none; b=N29yQQjEahpWzseKAFyBz8HOetgxuvlkEvkL2/LGtGYTfUY2/cj9KaD92T7SRgM6l45vcdbBL0g5ztJf9ZkLU7mXkEqaP6mvprFYK5KoVpiZL6rzxZM4Hleyd90Mjg6HwPN0jnK7wEZMTOrr3p4oEqLBYMyenudRdaVhwEXI9BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301719; c=relaxed/simple;
	bh=FX8WZdV09wKxMzdGfHw6UfDVHvE3q7SvkkgUS7jJ810=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MO3cdOiWyPZp016g/y0dwUjiBFazCimjMifz5VFF08LZPTJqaF0w1nq8dXqbomNaNTPfo/0tq8SoGVk/N1jtfbfVp48qD/B9OLiuplDLHrxvRi1791AMIJuwehyUaF8Xhyyy9gJE9iEYxmi96eZCHDWnxOgL2SPrxQMV3qYbJAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLlsu3mJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLlsu3mJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD8AC19423;
	Sat, 28 Feb 2026 18:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301719;
	bh=FX8WZdV09wKxMzdGfHw6UfDVHvE3q7SvkkgUS7jJ810=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLlsu3mJkXGqQPW9dba/kDSsRdSZj15GaNO5f6f9uG7TWBRnpXULIzoq/jpXLVzjA
	 AUQFyEIO+qNgwLfcGO0CuBo76TMh0VNh9/p1iCRCoK+5ISfDJp9y6lRXwVZfBImSQt
	 JEDgqSb/ObShNEhAKdl3hklD7CybmdjWqJUonocOU77gMp3pwf8mg68UDSMyE1zFdg
	 dprUhjp/x4RFpcj4a7rdu0pDOHhDNw+HnKqpEWNquUc88emnY4gCYeZRZctWNjFJli
	 vsjelyVY0u8wly9mFlKZR6n50vsRn30kQ83S0DUgj1dPkM1YbO5H2zENu8UXaro/sn
	 e7CIgq9AhR4vA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/385] hwspinlock: omap: Handle devm_pm_runtime_enable() errors
Date: Sat, 28 Feb 2026 12:55:38 -0500
Message-ID: <20260228180011.1568201-116-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 3bd4edd67b034f8e1f61c86e0eb098de6179e3f2 ]

Although unlikely, devm_pm_runtime_enable() can fail due to memory
allocations. Without proper error handling, the subsequent
pm_runtime_resume_and_get() call may operate on incorrectly
initialized runtime PM state.

Add error handling to check the return value of
devm_pm_runtime_enable() and return on failure.

Fixes: 25f7d74d4514 ("hwspinlock: omap: Use devm_pm_runtime_enable() helper")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251124104805.135-1-vulab@iscas.ac.cn
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwspinlock/omap_hwspinlock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwspinlock/omap_hwspinlock.c b/drivers/hwspinlock/omap_hwspinlock.c
index 27b47b8623c09..2d8de835bc242 100644
--- a/drivers/hwspinlock/omap_hwspinlock.c
+++ b/drivers/hwspinlock/omap_hwspinlock.c
@@ -88,7 +88,9 @@ static int omap_hwspinlock_probe(struct platform_device *pdev)
 	 * make sure the module is enabled and clocked before reading
 	 * the module SYSSTATUS register
 	 */
-	devm_pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
 	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		return ret;
-- 
2.51.0

