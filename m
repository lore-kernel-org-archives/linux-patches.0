Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD5C749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32421C433EF;
	Thu, 12 Jan 2023 14:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532667;
	bh=Vi7dUtHrEAaNYM9bMxRmH2PMGgJCsA4wijDta0PzS5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfRWM9c0GIn8FZNEr1wvwHI1c5sl7dUXh0GGAZXbqXCh7D0un6vvQ2BK68bizKqxM
	 ODnf9VMQkUDMwHOP+d/o0XjHyfzhG6GkImgwTl9CIWkrv/bEM6XvBWQMJ0tAZd2NER
	 LyK80wbjOHNDWYqdvGiIhLJznOdFleDXSGgVfoks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 206/783] clk: qcom: clk-krait: fix wrong div2 functions
Date: Thu, 12 Jan 2023 14:48:42 +0100
Message-Id: <20230112135533.885319980@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit d676d3a3717cf726d3affedbe5ba98fc4ccad7b3 ]

Currently div2 value is applied to the wrong bits. This is caused by a
bug in the code where the shift is done only for lpl, for anything
else the mask is not shifted to the correct bits.

Fix this by correctly shift if lpl is not supported.

Fixes: 4d7dc77babfe ("clk: qcom: Add support for Krait clocks")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221108215625.30186-1-ansuelsmth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-krait.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/qcom/clk-krait.c b/drivers/clk/qcom/clk-krait.c
index 90046428693c..e74fc81a14d0 100644
--- a/drivers/clk/qcom/clk-krait.c
+++ b/drivers/clk/qcom/clk-krait.c
@@ -98,6 +98,8 @@ static int krait_div2_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	if (d->lpl)
 		mask = mask << (d->shift + LPL_SHIFT) | mask << d->shift;
+	else
+		mask <<= d->shift;
 
 	spin_lock_irqsave(&krait_clock_reg_lock, flags);
 	val = krait_get_l2_indirect_reg(d->offset);
-- 
2.35.1



