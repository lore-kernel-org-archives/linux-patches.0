Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78066FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4954AC433CB;
	Sun, 17 Sep 2023 19:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980642;
	bh=AeRU7ACPx2273fB8d3gX06sYlurApcW17HMfUVDpviY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=01QH/XyXN4tUMvEdBusJF9tSJlw9ZRERFo1UIfqKOKyagyt1KF2flLohuOqRtmjER
	 /uRmlIL5N+B9Ls7szhKtl5p0dK9MxJTuAtZuwGg3U+rFrHgAmrsgTqT7D+tqhCjr3p
	 YFpZnqMSaucTNj9/4hw6qi8W+zo/OnXjp0WRn9yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 251/285] net: microchip: vcap api: Fix possible memory leak for vcap_dup_rule()
Date: Sun, 17 Sep 2023 21:14:11 +0200
Message-ID: <20230917191059.993455359@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 281f65d29d6da1a9b6907fb0b145aaf34f4e4822 ]

Inject fault When select CONFIG_VCAP_KUNIT_TEST, the below memory leak
occurs. If kzalloc() for duprule succeeds, but the following
kmemdup() fails, the duprule, ckf and caf memory will be leaked. So kfree
them in the error path.

unreferenced object 0xffff122744c50600 (size 192):
  comm "kunit_try_catch", pid 346, jiffies 4294896122 (age 911.812s)
  hex dump (first 32 bytes):
    10 27 00 00 04 00 00 00 1e 00 00 00 2c 01 00 00  .'..........,...
    00 00 00 00 00 00 00 00 18 06 c5 44 27 12 ff ff  ...........D'...
  backtrace:
    [<00000000394b0db8>] __kmem_cache_alloc_node+0x274/0x2f8
    [<0000000001bedc67>] kmalloc_trace+0x38/0x88
    [<00000000b0612f98>] vcap_dup_rule+0x50/0x460
    [<000000005d2d3aca>] vcap_add_rule+0x8cc/0x1038
    [<00000000eef9d0f8>] test_vcap_xn_rule_creator.constprop.0.isra.0+0x238/0x494
    [<00000000cbda607b>] vcap_api_rule_remove_in_front_test+0x1ac/0x698
    [<00000000c8766299>] kunit_try_run_case+0xe0/0x20c
    [<00000000c4fe9186>] kunit_generic_run_threadfn_adapter+0x50/0x94
    [<00000000f6864acf>] kthread+0x2e8/0x374
    [<0000000022e639b3>] ret_from_fork+0x10/0x20

Fixes: 814e7693207f ("net: microchip: vcap api: Add a storage state to a VCAP rule")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/vcap/vcap_api.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index a418ad8e8770a..15a3a31b15d45 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1021,18 +1021,32 @@ static struct vcap_rule_internal *vcap_dup_rule(struct vcap_rule_internal *ri,
 	list_for_each_entry(ckf, &ri->data.keyfields, ctrl.list) {
 		newckf = kmemdup(ckf, sizeof(*newckf), GFP_KERNEL);
 		if (!newckf)
-			return ERR_PTR(-ENOMEM);
+			goto err;
 		list_add_tail(&newckf->ctrl.list, &duprule->data.keyfields);
 	}
 
 	list_for_each_entry(caf, &ri->data.actionfields, ctrl.list) {
 		newcaf = kmemdup(caf, sizeof(*newcaf), GFP_KERNEL);
 		if (!newcaf)
-			return ERR_PTR(-ENOMEM);
+			goto err;
 		list_add_tail(&newcaf->ctrl.list, &duprule->data.actionfields);
 	}
 
 	return duprule;
+
+err:
+	list_for_each_entry_safe(ckf, newckf, &duprule->data.keyfields, ctrl.list) {
+		list_del(&ckf->ctrl.list);
+		kfree(ckf);
+	}
+
+	list_for_each_entry_safe(caf, newcaf, &duprule->data.actionfields, ctrl.list) {
+		list_del(&caf->ctrl.list);
+		kfree(caf);
+	}
+
+	kfree(duprule);
+	return ERR_PTR(-ENOMEM);
 }
 
 static void vcap_apply_width(u8 *dst, int width, int bytes)
-- 
2.40.1



