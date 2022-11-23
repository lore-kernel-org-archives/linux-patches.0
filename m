Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217147B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EE9C433D6;
	Wed, 23 Nov 2022 08:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193589;
	bh=WBZ/XOKvDwNSQvD8wia+y+RG8tMBt0GVWn4WMRO9rdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbx8XX1CPzIZ4DYw/9DTBegQ47PYJdwz31ulIMcAKtgkaBz2bSuFRYE6NIlVKtybB
	 8y1uKMzH8uZKWCCdSLtUXbCsbdpMsLdLbzqmIZq6TR/hZSSRaViXeFdZZC+9wgqOrg
	 GeYbhCP9mcDH+6kPgmtnzj7FF3Gs35RqYOHp2u7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 10/76] dmaengine: mv_xor_v2: Fix a resource leak in mv_xor_v2_remove()
Date: Wed, 23 Nov 2022 09:50:09 +0100
Message-Id: <20221123084547.076928639@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 081195d17a0c4c636da2b869bd5809d42e8cbb13 ]

A clk_prepare_enable() call in the probe is not balanced by a corresponding
clk_disable_unprepare() in the remove function.

Add the missing call.

Fixes: 3cd2c313f1d6 ("dmaengine: mv_xor_v2: Fix clock resource by adding a register clock")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/e9e3837a680c9bd2438e4db2b83270c6c052d005.1666640987.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mv_xor_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/mv_xor_v2.c b/drivers/dma/mv_xor_v2.c
index be1f5c26fae8..9eb5647fef3e 100644
--- a/drivers/dma/mv_xor_v2.c
+++ b/drivers/dma/mv_xor_v2.c
@@ -847,6 +847,7 @@ static int mv_xor_v2_remove(struct platform_device *pdev)
 	tasklet_kill(&xor_dev->irq_tasklet);
 
 	clk_disable_unprepare(xor_dev->clk);
+	clk_disable_unprepare(xor_dev->reg_clk);
 
 	return 0;
 }
-- 
2.35.1



