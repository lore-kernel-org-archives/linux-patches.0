Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0960569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFCFC433EF;
	Sun, 28 May 2023 19:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301944;
	bh=/L9xyTnPn+BKdKWocArP4ngXjwmC11n4naVmulvANkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=brP12FOO7HsoSintxSM5PwFTmXyPQlBGtQOGSGsXOhVFYJHAmRiwAN+XYzRfPjvgS
	 t8V7Xfl/tg+8/Aey3ls3+fwnRyYHTctZAHZMi8LHun+UsqbXSjNRAY+CYTllbzZAr1
	 oq26aIe129VnhvfEleK8XqqVXFX+/2RBLpoM5G4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Hao Lan <lanhao@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/161] net: hns3: fix reset delay time to avoid configuration timeout
Date: Sun, 28 May 2023 20:09:55 +0100
Message-Id: <20230528190839.413859932@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 814d0c786068e858d889ada3153bff82f64223ad ]

Currently the hns3 vf function reset delays 5000ms before vf rebuild
process. In product applications, this delay is too long for application
configurations and causes configuration timeout.

According to the tests, 500ms delay is enough for reset process except PF
FLR. So this patch modifies delay to 500ms in these scenarios.

Fixes: 6988eb2a9b77 ("net: hns3: Add support to reset the enet/ring mgmt layer")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 48956c30d2eee..ec3d98595198e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1432,7 +1432,10 @@ static int hclgevf_reset_wait(struct hclgevf_dev *hdev)
 	 * might happen in case reset assertion was made by PF. Yes, this also
 	 * means we might end up waiting bit more even for VF reset.
 	 */
-	msleep(5000);
+	if (hdev->reset_type == HNAE3_VF_FULL_RESET)
+		msleep(5000);
+	else
+		msleep(500);
 
 	return 0;
 }
-- 
2.39.2



