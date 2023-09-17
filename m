Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA456FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568C1C433C7;
	Sun, 17 Sep 2023 19:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978975;
	bh=nhHYxWOE6uAhSAbYQREaPc7ug703pcA6OQf/fPAtZmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nUkOXlAVkUsHo9mEtfyTKU/XmrhHCyYhaRhaGD12HWeogDrIMYqOjphPBQEQxqN5c
	 0wsiUNqOMQVQTWm4XGATJFRfO7sC/aOZyWKj3xaPdE88Ck/b5ANXb4MQTzVE/w3O6C
	 z1+UDica7ao+ePpGiBLJXrP2qeDCDuP82pxKNVc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/406] clk: qcom: reset: Use the correct type of sleep/delay based on length
Date: Sun, 17 Sep 2023 21:10:32 +0200
Message-ID: <20230917191105.894023140@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 181b66ee7cdd824797fc99b53bec29cf5630a04f ]

Use the fsleep() helper that (based on the length of the delay, see: [1])
chooses the correct sleep/delay functions.

[1] https://www.kernel.org/doc/Documentation/timers/timers-howto.txt

Fixes: 2cb8a39b6781 ("clk: qcom: reset: Allow specifying custom reset delay")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230726-topic-qcom_reset-v3-1-5958facd5db2@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/reset.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/reset.c b/drivers/clk/qcom/reset.c
index 0e914ec7aeae1..e45e32804d2c7 100644
--- a/drivers/clk/qcom/reset.c
+++ b/drivers/clk/qcom/reset.c
@@ -16,7 +16,8 @@ static int qcom_reset(struct reset_controller_dev *rcdev, unsigned long id)
 	struct qcom_reset_controller *rst = to_qcom_reset_controller(rcdev);
 
 	rcdev->ops->assert(rcdev, id);
-	udelay(rst->reset_map[id].udelay ?: 1); /* use 1 us as default */
+	fsleep(rst->reset_map[id].udelay ?: 1); /* use 1 us as default */
+
 	rcdev->ops->deassert(rcdev, id);
 	return 0;
 }
-- 
2.40.1



