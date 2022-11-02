Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794067E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0A3C433D6;
	Wed,  2 Nov 2022 03:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358432;
	bh=2AlkWGx0bVtwq56NNkz1pgtZWilKWjEeja+i3B320dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7wE1fcZH79qSzykBrkNlyRkwTyjezI8vcGTNx+hpqJZpj+FieD3809T4WRXFnl/Y
	 C/HQezp71GuyXfM+AKTxAO9qKwNaf9j6Xb37zZ6uJkOBj14eETNiDCVPpCZfQ5KNzN
	 wCrUIXp22g4QjPKSk1gijjkbrfxFTwZyxHtA0BCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/132] net: hinic: fix the issue of CMDQ memory leaks
Date: Wed,  2 Nov 2022 03:32:58 +0100
Message-Id: <20221102022101.496975444@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 363cc87767f6ddcfb9158ad2e2afa2f8d5c4b94e ]

When hinic_set_cmdq_depth() fails in hinic_init_cmdqs(), the cmdq memory is
not released correctly. Fix it.

Fixes: 72ef908bb3ff ("hinic: add three net_device_ops of vf")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index a627237f694b..afa816cfcdf4 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -929,7 +929,7 @@ int hinic_init_cmdqs(struct hinic_cmdqs *cmdqs, struct hinic_hwif *hwif,
 
 err_set_cmdq_depth:
 	hinic_ceq_unregister_cb(&func_to_io->ceqs, HINIC_CEQ_CMDQ);
-
+	free_cmdq(&cmdqs->cmdq[HINIC_CMDQ_SYNC]);
 err_cmdq_ctxt:
 	hinic_wqs_cmdq_free(&cmdqs->cmdq_pages, cmdqs->saved_wqs,
 			    HINIC_MAX_CMDQ_TYPES);
-- 
2.35.1



