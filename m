Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFEE28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67540C433EF;
	Mon, 12 Dec 2022 13:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852695;
	bh=YhFrxtbSrPcfAgE8SOiTQf+xOOJPsZvrx38dliz87Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTfgFHwHdcGWN3z1y+gO72lauyFx6T3IySAXEy1xjK+6RbIqt3Wp5BkeGUEEFggNs
	 w3PdmeCut9uWu9rQ867tKuswwqJunEirt+aaY9x42/wwJ2kn/vEyEQn5dP3YC2tI+b
	 R0xTQKvhO6o96xdf7IIcESbfxQtNqPp4q6Qx3Kvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiheng Lin <linqiheng@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 134/157] net: microchip: sparx5: Fix missing destroy_workqueue of mact_queue
Date: Mon, 12 Dec 2022 14:18:02 +0100
Message-Id: <20221212130940.355948738@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qiheng Lin <linqiheng@huawei.com>

[ Upstream commit 7b8232bdb1789a257de3129a9bb08c69b93a17db ]

The mchp_sparx5_probe() won't destroy workqueue created by
create_singlethread_workqueue() in sparx5_start() when later
inits failed. Add destroy_workqueue in the cleanup_ports case,
also add it in mchp_sparx5_remove()

Fixes: b37a1bae742f ("net: sparx5: add mactable support")
Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
Link: https://lore.kernel.org/r/20221203070259.19560-1-linqiheng@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 30815c0e3f76..e58de119186a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -876,6 +876,8 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 
 cleanup_ports:
 	sparx5_cleanup_ports(sparx5);
+	if (sparx5->mact_queue)
+		destroy_workqueue(sparx5->mact_queue);
 cleanup_config:
 	kfree(configs);
 cleanup_pnode:
@@ -900,6 +902,7 @@ static int mchp_sparx5_remove(struct platform_device *pdev)
 	sparx5_cleanup_ports(sparx5);
 	/* Unregister netdevs */
 	sparx5_unregister_notifier_blocks(sparx5);
+	destroy_workqueue(sparx5->mact_queue);
 
 	return 0;
 }
-- 
2.35.1



