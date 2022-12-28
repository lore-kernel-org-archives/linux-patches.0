Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F54D1875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84989C433D2;
	Wed, 28 Dec 2022 15:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243007;
	bh=MaduEKFH7wJK2FtAh/uuzeU+w+u4AuEb7WtiXz8s/mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vItTvl5zonnkRlmt1SlQIbnVaSX7Z6/OEK+ZhPVjWw+MA0XG2EO/qSYfNGjOmZklA
	 qG3s/6BRhrqNJu4HMBUD6ycd11tRtZHq/vsVLESEtzBSZHFWDph+8i+RZP/pws078i
	 /UHOzgzVVShM6om3I2rj9PeTccoECBp7cSgCgrzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0454/1073] clk: qcom: clk-krait: fix wrong div2 functions
Date: Wed, 28 Dec 2022 15:34:02 +0100
Message-Id: <20221228144340.368922244@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 45da736bd5f4..293a9dfa7151 100644
--- a/drivers/clk/qcom/clk-krait.c
+++ b/drivers/clk/qcom/clk-krait.c
@@ -114,6 +114,8 @@ static int krait_div2_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	if (d->lpl)
 		mask = mask << (d->shift + LPL_SHIFT) | mask << d->shift;
+	else
+		mask <<= d->shift;
 
 	spin_lock_irqsave(&krait_clock_reg_lock, flags);
 	val = krait_get_l2_indirect_reg(d->offset);
-- 
2.35.1



