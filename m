Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DD06FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D7CC433D2;
	Mon,  3 Apr 2023 14:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532657;
	bh=NE99H+N2fc5lPLf+0ydmjzBy2LHMWhPInpLgsCfHzbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXZmZs5hGN4MlB4TCAMTDyrrW+MPmJljpwbwXWvPJnJnKQpK4dxzGs4G11i6vzT2O
	 ylOs0dmuOvc89jBvngWcCp4rKB5IywhZ3k7ZFMmr+VHbYf/dnEH5VqdH41rmagn7qE
	 bYfILkafXqCGzbfmvw+SYitwtmBEJj3uUekPeZP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/181] mtd: nand: mxic-ecc: Fix mxic_ecc_data_xfer_wait_for_completion() when irq is used
Date: Mon,  3 Apr 2023 16:08:22 +0200
Message-Id: <20230403140417.309433653@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
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

[ Upstream commit 75dce6a941e3f16c3b4878c8b2f46d5d07c619ce ]

wait_for_completion_timeout() and readl_poll_timeout() don't handle their
return value the same way.

wait_for_completion_timeout() returns 0 on time out (and >0 in all other
cases)
readl_poll_timeout() returns 0 on success and -ETIMEDOUT upon a timeout.

In order for the error handling path to work in both cases, the logic
against wait_for_completion_timeout() needs to be inverted.

Fixes: 48e6633a9fa2 ("mtd: nand: mxic-ecc: Add Macronix external ECC engine support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/beddbc374557e44ceec897e68c4a5d12764ddbb9.1676459308.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/ecc-mxic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/ecc-mxic.c b/drivers/mtd/nand/ecc-mxic.c
index 8afdca731b874..6b487ffe2f2dc 100644
--- a/drivers/mtd/nand/ecc-mxic.c
+++ b/drivers/mtd/nand/ecc-mxic.c
@@ -429,6 +429,7 @@ static int mxic_ecc_data_xfer_wait_for_completion(struct mxic_ecc_engine *mxic)
 		mxic_ecc_enable_int(mxic);
 		ret = wait_for_completion_timeout(&mxic->complete,
 						  msecs_to_jiffies(1000));
+		ret = ret ? 0 : -ETIMEDOUT;
 		mxic_ecc_disable_int(mxic);
 	} else {
 		ret = readl_poll_timeout(mxic->regs + INTRPT_STS, val,
-- 
2.39.2



