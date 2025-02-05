Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF4218DF73;
	Wed,  5 Feb 2025 15:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767676; cv=none; b=KRERO5bwXroCuHS8n6xZuyriVaecuIuht7h54evdaf2mn5ZOZ7JhY5M5rpMokBbNzcVqZtUdjSJOQympINRZQ64tC8cgaSK9VenOoEXLVWFYVvkQpl4phQh/O6R7deoL1B3GvdJOF2WYeV9AmbJUj6vYvsoJNo8Kpzd64oevVz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767676; c=relaxed/simple;
	bh=CG06z7MZT10t5mQc268j1MiNbkDaFt875PlF2FenQrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PslM976SZVpof73pVQ2P+YjELUNqA5NO2KbMFfG3tHHsLGtYoSHwABNaxWkTTbwQ7TP2wNCg7NlLGLW3spSa1eLMrtfH+MvF12NHzZ27wZaZTw0EScb2qu7806lcW4Piyrsvxt+9WkuXTDpgXBH11yOw4cF/daXoFPn80j+B/P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNvV3wxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNvV3wxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D59C4CED6;
	Wed,  5 Feb 2025 15:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767676;
	bh=CG06z7MZT10t5mQc268j1MiNbkDaFt875PlF2FenQrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNvV3wxDxcPaqifNThs54iCewZBLaHJ/g8D8V3eIjl0HZlpV99q0ConCeTRFvgHWW
	 BY+PACTOUE/XF41A/4cILYIDi2stIKIy0Sd366AUm0OIzE1JrRlXiRuKxc5kpQtdM9
	 4fd2BCnZiCLTZbA2f2MUD06kZft+1VbU8wFaClQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michal Wilczynski <m.wilczynski@samsung.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 437/623] mailbox: th1520: Fix a NULL vs IS_ERR() bug
Date: Wed,  5 Feb 2025 14:42:59 +0100
Message-ID: <20250205134512.935871690@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit d0f98e14c010bcf27898b635a54c1994ac4110a8 ]

The devm_ioremap() function doesn't return error pointers, it returns
NULL.  Update the error checking to match.

Fixes: 5d4d263e1c6b ("mailbox: Introduce support for T-head TH1520 Mailbox driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Michal Wilczynski <m.wilczynski@samsung.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-th1520.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox-th1520.c b/drivers/mailbox/mailbox-th1520.c
index 4e84640ac3b87..e16e7c85ee3cd 100644
--- a/drivers/mailbox/mailbox-th1520.c
+++ b/drivers/mailbox/mailbox-th1520.c
@@ -387,8 +387,10 @@ static void __iomem *th1520_map_mmio(struct platform_device *pdev,
 
 	mapped = devm_ioremap(&pdev->dev, res->start + offset,
 			      resource_size(res) - offset);
-	if (IS_ERR(mapped))
+	if (!mapped) {
 		dev_err(&pdev->dev, "Failed to map resource: %s\n", res_name);
+		return ERR_PTR(-ENOMEM);
+	}
 
 	return mapped;
 }
-- 
2.39.5



