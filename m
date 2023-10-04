Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9DF1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pk49Txd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D09DC433C8;
	Wed,  4 Oct 2023 18:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443868;
	bh=eIj9k+0ASQUzJpYjFG1JqE2VRea8CeUj3aHPysVpR7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pk49Txd6GJTF9nQXYMxtPCMQ4JRYGrwGLD5VdolTzEEBVBd0m8oRZEiLt37UoQZds
	 mR9igNPjNI8E7lT7EyIZruL8zPj4l6OWwH/1rZJev9HxjxTfZ3083IKjxdlsUK5gc/
	 R5N9in717YPJ4OYkyZeSiHuoFC2xiGLLkd9JiGeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 048/321] net: microchip: sparx5: Fix memory leak for vcap_api_rule_add_actionvalue_test()
Date: Wed,  4 Oct 2023 19:53:13 +0200
Message-ID: <20231004175231.396160010@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

[ Upstream commit 39d0ccc185315408e7cecfcaf06d167927b51052 ]

Inject fault while probing kunit-example-test.ko, the field which
is allocated by kzalloc in vcap_rule_add_action() of
vcap_rule_add_action_bit/u32() is not freed, and it cause
the memory leaks below.

unreferenced object 0xffff0276c496b300 (size 64):
  comm "kunit_try_catch", pid 286, jiffies 4294894224 (age 920.072s)
  hex dump (first 32 bytes):
    68 3c 62 82 00 80 ff ff 68 3c 62 82 00 80 ff ff  h<b.....h<b.....
    3c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  <...............
  backtrace:
    [<0000000028f08898>] slab_post_alloc_hook+0xb8/0x368
    [<00000000514b9b37>] __kmem_cache_alloc_node+0x174/0x290
    [<000000004620684a>] kmalloc_trace+0x40/0x164
    [<000000008b41c84d>] vcap_rule_add_action+0x104/0x178
    [<00000000ae66c16c>] vcap_api_rule_add_actionvalue_test+0xa4/0x990
    [<00000000fcc5326c>] kunit_try_run_case+0x50/0xac
    [<00000000f5f45b20>] kunit_generic_run_threadfn_adapter+0x20/0x2c
    [<0000000026284079>] kthread+0x124/0x130
    [<0000000024d4a996>] ret_from_fork+0x10/0x20
unreferenced object 0xffff0276c496b2c0 (size 64):
  comm "kunit_try_catch", pid 286, jiffies 4294894224 (age 920.072s)
  hex dump (first 32 bytes):
    68 3c 62 82 00 80 ff ff 68 3c 62 82 00 80 ff ff  h<b.....h<b.....
    3c 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  <...............
  backtrace:
    [<0000000028f08898>] slab_post_alloc_hook+0xb8/0x368
    [<00000000514b9b37>] __kmem_cache_alloc_node+0x174/0x290
    [<000000004620684a>] kmalloc_trace+0x40/0x164
    [<000000008b41c84d>] vcap_rule_add_action+0x104/0x178
    [<00000000607782aa>] vcap_api_rule_add_actionvalue_test+0x100/0x990
    [<00000000fcc5326c>] kunit_try_run_case+0x50/0xac
    [<00000000f5f45b20>] kunit_generic_run_threadfn_adapter+0x20/0x2c
    [<0000000026284079>] kthread+0x124/0x130
    [<0000000024d4a996>] ret_from_fork+0x10/0x20
unreferenced object 0xffff0276c496b280 (size 64):
  comm "kunit_try_catch", pid 286, jiffies 4294894224 (age 920.072s)
  hex dump (first 32 bytes):
    68 3c 62 82 00 80 ff ff 68 3c 62 82 00 80 ff ff  h<b.....h<b.....
    3c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  <...............
  backtrace:
    [<0000000028f08898>] slab_post_alloc_hook+0xb8/0x368
    [<00000000514b9b37>] __kmem_cache_alloc_node+0x174/0x290
    [<000000004620684a>] kmalloc_trace+0x40/0x164
    [<000000008b41c84d>] vcap_rule_add_action+0x104/0x178
    [<000000004e640602>] vcap_api_rule_add_actionvalue_test+0x15c/0x990
    [<00000000fcc5326c>] kunit_try_run_case+0x50/0xac
    [<00000000f5f45b20>] kunit_generic_run_threadfn_adapter+0x20/0x2c
    [<0000000026284079>] kthread+0x124/0x130
    [<0000000024d4a996>] ret_from_fork+0x10/0x20
unreferenced object 0xffff0276c496b240 (size 64):
  comm "kunit_try_catch", pid 286, jiffies 4294894224 (age 920.092s)
  hex dump (first 32 bytes):
    68 3c 62 82 00 80 ff ff 68 3c 62 82 00 80 ff ff  h<b.....h<b.....
    5a 00 00 00 01 00 00 00 32 54 76 98 00 00 00 00  Z.......2Tv.....
  backtrace:
    [<0000000028f08898>] slab_post_alloc_hook+0xb8/0x368
    [<00000000514b9b37>] __kmem_cache_alloc_node+0x174/0x290
    [<000000004620684a>] kmalloc_trace+0x40/0x164
    [<000000008b41c84d>] vcap_rule_add_action+0x104/0x178
    [<0000000011141bf8>] vcap_api_rule_add_actionvalue_test+0x1bc/0x990
    [<00000000fcc5326c>] kunit_try_run_case+0x50/0xac
    [<00000000f5f45b20>] kunit_generic_run_threadfn_adapter+0x20/0x2c
    [<0000000026284079>] kthread+0x124/0x130
    [<0000000024d4a996>] ret_from_fork+0x10/0x20
unreferenced object 0xffff0276c496b200 (size 64):
  comm "kunit_try_catch", pid 286, jiffies 4294894224 (age 920.092s)
  hex dump (first 32 bytes):
    68 3c 62 82 00 80 ff ff 68 3c 62 82 00 80 ff ff  h<b.....h<b.....
    28 00 00 00 01 00 00 00 dd cc bb aa 00 00 00 00  (...............
  backtrace:
    [<0000000028f08898>] slab_post_alloc_hook+0xb8/0x368
    [<00000000514b9b37>] __kmem_cache_alloc_node+0x174/0x290
    [<000000004620684a>] kmalloc_trace+0x40/0x164
    [<000000008b41c84d>] vcap_rule_add_action+0x104/0x178
    [<00000000d5ed3088>] vcap_api_rule_add_actionvalue_test+0x22c/0x990
    [<00000000fcc5326c>] kunit_try_run_case+0x50/0xac
    [<00000000f5f45b20>] kunit_generic_run_threadfn_adapter+0x20/0x2c
    [<0000000026284079>] kthread+0x124/0x130
    [<0000000024d4a996>] ret_from_fork+0x10/0x20

Fixes: c956b9b318d9 ("net: microchip: sparx5: Adding KUNIT tests of key/action values in VCAP API")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microchip/vcap/vcap_api_kunit.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index 2fb0b8cf2b0cd..f268383a75707 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -1095,6 +1095,17 @@ static void vcap_api_rule_add_keyvalue_test(struct kunit *test)
 	vcap_free_ckf(rule);
 }
 
+static void vcap_free_caf(struct vcap_rule *rule)
+{
+	struct vcap_client_actionfield *caf, *next_caf;
+
+	list_for_each_entry_safe(caf, next_caf,
+				 &rule->actionfields, ctrl.list) {
+		list_del(&caf->ctrl.list);
+		kfree(caf);
+	}
+}
+
 static void vcap_api_rule_add_actionvalue_test(struct kunit *test)
 {
 	struct vcap_admin admin = {
@@ -1120,6 +1131,7 @@ static void vcap_api_rule_add_actionvalue_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, VCAP_AF_POLICE_ENA, af->ctrl.action);
 	KUNIT_EXPECT_EQ(test, VCAP_FIELD_BIT, af->ctrl.type);
 	KUNIT_EXPECT_EQ(test, 0x0, af->data.u1.value);
+	vcap_free_caf(rule);
 
 	INIT_LIST_HEAD(&rule->actionfields);
 	ret = vcap_rule_add_action_bit(rule, VCAP_AF_POLICE_ENA, VCAP_BIT_1);
@@ -1131,6 +1143,7 @@ static void vcap_api_rule_add_actionvalue_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, VCAP_AF_POLICE_ENA, af->ctrl.action);
 	KUNIT_EXPECT_EQ(test, VCAP_FIELD_BIT, af->ctrl.type);
 	KUNIT_EXPECT_EQ(test, 0x1, af->data.u1.value);
+	vcap_free_caf(rule);
 
 	INIT_LIST_HEAD(&rule->actionfields);
 	ret = vcap_rule_add_action_bit(rule, VCAP_AF_POLICE_ENA, VCAP_BIT_ANY);
@@ -1142,6 +1155,7 @@ static void vcap_api_rule_add_actionvalue_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, VCAP_AF_POLICE_ENA, af->ctrl.action);
 	KUNIT_EXPECT_EQ(test, VCAP_FIELD_BIT, af->ctrl.type);
 	KUNIT_EXPECT_EQ(test, 0x0, af->data.u1.value);
+	vcap_free_caf(rule);
 
 	INIT_LIST_HEAD(&rule->actionfields);
 	ret = vcap_rule_add_action_u32(rule, VCAP_AF_TYPE, 0x98765432);
@@ -1153,6 +1167,7 @@ static void vcap_api_rule_add_actionvalue_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, VCAP_AF_TYPE, af->ctrl.action);
 	KUNIT_EXPECT_EQ(test, VCAP_FIELD_U32, af->ctrl.type);
 	KUNIT_EXPECT_EQ(test, 0x98765432, af->data.u32.value);
+	vcap_free_caf(rule);
 
 	INIT_LIST_HEAD(&rule->actionfields);
 	ret = vcap_rule_add_action_u32(rule, VCAP_AF_MASK_MODE, 0xaabbccdd);
@@ -1164,6 +1179,7 @@ static void vcap_api_rule_add_actionvalue_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, VCAP_AF_MASK_MODE, af->ctrl.action);
 	KUNIT_EXPECT_EQ(test, VCAP_FIELD_U32, af->ctrl.type);
 	KUNIT_EXPECT_EQ(test, 0xaabbccdd, af->data.u32.value);
+	vcap_free_caf(rule);
 }
 
 static void vcap_api_rule_find_keyset_basic_test(struct kunit *test)
-- 
2.40.1



