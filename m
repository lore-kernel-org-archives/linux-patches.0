Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43FE200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B19C433C7;
	Fri, 21 Jul 2023 19:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966247;
	bh=QI5qMOurc9gYaqovOLPCtbjWe1yRZiSoHClNmCcwJvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L40eZkZHSxJ4/kynRLjv3TptXi+z6IQl51Y8V5hbPqWB1Y1MYZnRKkoVwqperve51
	 /0lstE2qxgoUFJZ2jee6R7HlzcM1aSsiKnhkagzfXLIIFFKiVJKgoSTWd7A92QXsJM
	 5H5JjNF1Ym1VC9l3hWad6GIDhCXCTK5dFiqTAi38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 276/532] clk: qcom: reset: Allow specifying custom reset delay
Date: Fri, 21 Jul 2023 18:03:00 +0200
Message-ID: <20230721160629.353657698@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stephan Gerhold <stephan.gerhold@kernkonzept.com>

[ Upstream commit 2cb8a39b6781ea23accd1fa93b3ad000d0948aec ]

The amount of time required between asserting and deasserting the reset
signal can vary depending on the involved hardware component. Sometimes
1 us might not be enough and a larger delay is necessary to conform to
the specifications.

Usually this is worked around in the consuming drivers, by replacing
reset_control_reset() with a sequence of reset_control_assert(), waiting
for a custom delay, followed by reset_control_deassert().

However, in some cases the driver making use of the reset is generic and
can be used with different reset controllers. In this case the reset
time requirement is better handled directly by the reset controller
driver.

Make this possible by adding an "udelay" field to the qcom_reset_map
that allows setting a different reset delay (in microseconds).

Signed-off-by: Stephan Gerhold <stephan.gerhold@kernkonzept.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220706134132.3623415-4-stephan.gerhold@kernkonzept.com
Stable-dep-of: 349b5bed539b ("clk: qcom: ipq6018: fix networking resets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/reset.c | 4 +++-
 drivers/clk/qcom/reset.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/reset.c b/drivers/clk/qcom/reset.c
index 819d194be8f7b..2a16adb572d2b 100644
--- a/drivers/clk/qcom/reset.c
+++ b/drivers/clk/qcom/reset.c
@@ -13,8 +13,10 @@
 
 static int qcom_reset(struct reset_controller_dev *rcdev, unsigned long id)
 {
+	struct qcom_reset_controller *rst = to_qcom_reset_controller(rcdev);
+
 	rcdev->ops->assert(rcdev, id);
-	udelay(1);
+	udelay(rst->reset_map[id].udelay ?: 1); /* use 1 us as default */
 	rcdev->ops->deassert(rcdev, id);
 	return 0;
 }
diff --git a/drivers/clk/qcom/reset.h b/drivers/clk/qcom/reset.h
index 2a08b5e282c77..b8c113582072b 100644
--- a/drivers/clk/qcom/reset.h
+++ b/drivers/clk/qcom/reset.h
@@ -11,6 +11,7 @@
 struct qcom_reset_map {
 	unsigned int reg;
 	u8 bit;
+	u8 udelay;
 };
 
 struct regmap;
-- 
2.39.2



