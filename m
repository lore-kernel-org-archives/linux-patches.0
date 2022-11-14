Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FDD4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B40CC433D6;
	Mon, 14 Nov 2022 12:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430135;
	bh=tMIl7KQkgUxOEDY7mEGyyrmoOTGOfKG67tEPgS4yr7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=df/zWs2OCI9ZBlybplRc/FMphk013uqhmRS2MtM2fG8XpugKaP+IgNkxcKhaoQh1J
	 wpnEmCDkVfUo7WUnXnEAExjKPAO5+UNNLxArnAfKnLbJvHNJ5kqQnnbhJsVOP7C2ms
	 QZNBJ/LFscPgdB4YZyMoSA9D2mMhJiQ5yYx0g85c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Vadym Kochan <vadym.kochan@plvision.eu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/95] net: marvell: prestera: fix memory leak in prestera_rxtx_switch_init()
Date: Mon, 14 Nov 2022 13:45:31 +0100
Message-Id: <20221114124444.102169764@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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

[ Upstream commit 519b58bbfa825f042fcf80261cc18e1e35f85ffd ]

When prestera_sdma_switch_init() failed, the memory pointed to by
sw->rxtx isn't released. Fix it. Only be compiled, not be tested.

Fixes: 501ef3066c89 ("net: marvell: prestera: Add driver for Prestera family ASIC devices")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Vadym Kochan <vadym.kochan@plvision.eu>
Link: https://lore.kernel.org/r/20221108025607.338450-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
index 2a13c318048c..59a3ea02b8ad 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
@@ -771,6 +771,7 @@ static netdev_tx_t prestera_sdma_xmit(struct prestera_sdma *sdma,
 int prestera_rxtx_switch_init(struct prestera_switch *sw)
 {
 	struct prestera_rxtx *rxtx;
+	int err;
 
 	rxtx = kzalloc(sizeof(*rxtx), GFP_KERNEL);
 	if (!rxtx)
@@ -778,7 +779,11 @@ int prestera_rxtx_switch_init(struct prestera_switch *sw)
 
 	sw->rxtx = rxtx;
 
-	return prestera_sdma_switch_init(sw);
+	err = prestera_sdma_switch_init(sw);
+	if (err)
+		kfree(rxtx);
+
+	return err;
 }
 
 void prestera_rxtx_switch_fini(struct prestera_switch *sw)
-- 
2.35.1



