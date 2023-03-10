Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAB38820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091A3C4339B;
	Fri, 10 Mar 2023 14:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459693;
	bh=7VPYRnb5vE2aLXoWpqGSZZdB4gNPvy0oN1oHrm9nH6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSWhF/OcnmuchGHh1AMTX1zMF68dbLGha1PUuaxBNW2im1VjNiSfkRIwHtfT5BJwD
	 AvR5QMAE7Qo2XuRWAnHZGbZMfp0DU/U4WxTvG+G8ubnE0XivlN38vWwWeiUk1hxsLs
	 iLEpwq8NjvArOhwPplwISGNhSnnMZXK9IygdjKk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Simon Horman <simon.horman@corigine.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/529] wifi: rsi: Fix memory leak in rsi_coex_attach()
Date: Fri, 10 Mar 2023 14:33:12 +0100
Message-Id: <20230310133807.270746583@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 956fb851a6e19da5ab491e19c1bc323bb2c2cf6f ]

The coex_cb needs to be freed when rsi_create_kthread() failed in
rsi_coex_attach().

Fixes: 2108df3c4b18 ("rsi: add coex support")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221205061441.114632-1-yuancan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_coex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_coex.c b/drivers/net/wireless/rsi/rsi_91x_coex.c
index a0c5d02ae88cf..7395359b43b77 100644
--- a/drivers/net/wireless/rsi/rsi_91x_coex.c
+++ b/drivers/net/wireless/rsi/rsi_91x_coex.c
@@ -160,6 +160,7 @@ int rsi_coex_attach(struct rsi_common *common)
 			       rsi_coex_scheduler_thread,
 			       "Coex-Tx-Thread")) {
 		rsi_dbg(ERR_ZONE, "%s: Unable to init tx thrd\n", __func__);
+		kfree(coex_cb);
 		return -EINVAL;
 	}
 	return 0;
-- 
2.39.2



