Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163021D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ci5cbxMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1A8C433C7;
	Wed,  4 Oct 2023 18:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443865;
	bh=gZed04jCmP9xFJ6x+EQXHT5VSDlSfn7lwpeLM6Jl9Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ci5cbxMmCu7oc/CoVhBUHgGPDt5AV1i9T67krDHbPxAA7eswcC8JD6zLiib4dVFxq
	 ToysKDw4/9b3JW59MW1UVj/4udoah1pLM4GeJmuAE3ImOkAtUsjpMXWsAAMJVCp2vQ
	 2ypkLBB8YcXtv0Kup8YAOLFqY3cOWVniqJKZct18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 047/321] net: microchip: sparx5: Fix memory leak for vcap_api_rule_add_keyvalue_test()
Date: Wed,  4 Oct 2023 19:53:12 +0200
Message-ID: <20231004175231.345066638@linuxfoundation.org>
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

[ Upstream commit f037fc9905ffa6fa19b89bfbc86946798cede071 ]

Inject fault while probing kunit-example-test.ko, the field which
is allocated by kzalloc in vcap_rule_add_key() of
vcap_rule_add_key_bit/u32/u128() is not freed, and it cause
the memory leaks below.

unreferenced object 0xffff0276c14b7240 (size 64):
  comm "kunit_try_catch", pid 284, jiffies 4294894220 (age 920.072s)
  hex dump (first 32 bytes):
    28 3c 61 82 00 80 ff ff 28 3c 61 82 00 80 ff ff  (<a.....(<a.....
    67 00 00 00 00 00 00 00 00 01 37 2b af ab ff ff  g.........7+....
  backtrace:
    [<0000000028f08898>] slab_post_alloc_hook+0xb8/0x368
    [<00000000514b9b37>] __kmem_cache_alloc_node+0x174/0x290
    [<000000004620684a>] kmalloc_trace+0x40/0x164
    [<0000000059ad6bcd>] vcap_rule_add_key+0x104/0x180
    [<00000000ff8002d3>] vcap_api_rule_add_keyvalue_test+0x100/0xba8
    [<00000000fcc5326c>] kunit_try_run_case+0x50/0xac
    [<00000000f5f45b20>] kunit_generic_run_threadfn_adapter+0x20/0x2c
    [<0000000026284079>] kthread+0x124/0x130
    [<0000000024d4a996>] ret_from_fork+0x10/0x20
unreferenced object 0xffff0276c14b7280 (size 64):
  comm "kunit_try_catch", pid 284, jiffies 4294894221 (age 920.068s)
  hex dump (first 32 bytes):
    28 3c 61 82 00 80 ff ff 28 3c 61 82 00 80 ff ff  (<a.....(<a.....
    67 00 00 00 00 00 00 00 01 01 37 2b af ab ff ff  g.........7+....
  backtrace:
    [<0000000028f08898>] slab_post_alloc_hook+0xb8/0x368
    [<00000000514b9b37>] __kmem_cache_alloc_node+0x174/0x290
    [<000000004620684a>] kmalloc_trace+0x40/0x164
    [<0000000059ad6bcd>] vcap_rule_add_key+0x104/0x180
    [<00000000f5ac9dc7>] vcap_api_rule_add_keyvalue_test+0x168/0xba8
    [<00000000fcc5326c>] kunit_try_run_case+0x50/0xac
    [<00000000f5f45b20>] kunit_generic_run_threadfn_adapter+0x20/0x2c
    [<0000000026284079>] kthread+0x124/0x130
    [<0000000024d4a996>] ret_from_fork+0x10/0x20
unreferenced object 0xffff0276c14b72c0 (size 64):
  comm "kunit_try_catch", pid 284, jiffies 4294894221 (age 920.068s)
  hex dump (first 32 bytes):
    28 3c 61 82 00 80 ff ff 28 3c 61 82 00 80 ff ff  (<a.....(<a.....
    67 00 00 00 00 00 00 00 00 00 37 2b af ab ff ff  g.........7+....
  backtrace:
    [<0000000028f08898>] slab_post_alloc_hook+0xb8/0x368
    [<00000000514b9b37>] __kmem_cache_alloc_node+0x174/0x290
    [<000000004620684a>] kmalloc_trace+0x40/0x164
    [<0000000059ad6bcd>] vcap_rule_add_key+0x104/0x180
    [<00000000c918ae7f>] vcap_api_rule_add_keyvalue_test+0x1d0/0xba8
    [<00000000fcc5326c>] kunit_try_run_case+0x50/0xac
    [<00000000f5f45b20>] kunit_generic_run_threadfn_adapter+0x20/0x2c
    [<0000000026284079>] kthread+0x124/0x130
    [<0000000024d4a996>] ret_from_fork+0x10/0x20
unreferenced object 0xffff0276c14b7300 (size 64):
  comm "kunit_try_catch", pid 284, jiffies 4294894221 (age 920.084s)
  hex dump (first 32 bytes):
    28 3c 61 82 00 80 ff ff 28 3c 61 82 00 80 ff ff  (<a.....(<a.....
    7d 00 00 00 01 00 00 00 32 54 76 98 ab ff 00 ff  }.......2Tv.....
  backtrace:
    [<0000000028f08898>] slab_post_alloc_hook+0xb8/0x368
    [<00000000514b9b37>] __kmem_cache_alloc_node+0x174/0x290
    [<000000004620684a>] kmalloc_trace+0x40/0x164
    [<0000000059ad6bcd>] vcap_rule_add_key+0x104/0x180
    [<0000000003352814>] vcap_api_rule_add_keyvalue_test+0x240/0xba8
    [<00000000fcc5326c>] kunit_try_run_case+0x50/0xac
    [<00000000f5f45b20>] kunit_generic_run_threadfn_adapter+0x20/0x2c
    [<0000000026284079>] kthread+0x124/0x130
    [<0000000024d4a996>] ret_from_fork+0x10/0x20
unreferenced object 0xffff0276c14b7340 (size 64):
  comm "kunit_try_catch", pid 284, jiffies 4294894221 (age 920.084s)
  hex dump (first 32 bytes):
    28 3c 61 82 00 80 ff ff 28 3c 61 82 00 80 ff ff  (<a.....(<a.....
    51 00 00 00 07 00 00 00 17 26 35 44 63 62 71 00  Q........&5Dcbq.
  backtrace:
    [<0000000028f08898>] slab_post_alloc_hook+0xb8/0x368
    [<00000000514b9b37>] __kmem_cache_alloc_node+0x174/0x290
    [<000000004620684a>] kmalloc_trace+0x40/0x164
    [<0000000059ad6bcd>] vcap_rule_add_key+0x104/0x180
    [<000000001516f109>] vcap_api_rule_add_keyvalue_test+0x2cc/0xba8
    [<00000000fcc5326c>] kunit_try_run_case+0x50/0xac
    [<00000000f5f45b20>] kunit_generic_run_threadfn_adapter+0x20/0x2c
    [<0000000026284079>] kthread+0x124/0x130
    [<0000000024d4a996>] ret_from_fork+0x10/0x20

Fixes: c956b9b318d9 ("net: microchip: sparx5: Adding KUNIT tests of key/action values in VCAP API")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microchip/vcap/vcap_api_kunit.c  | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index c07f25e791c76..2fb0b8cf2b0cd 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -995,6 +995,16 @@ static void vcap_api_encode_rule_actionset_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, (u32)0x00000000, actwords[11]);
 }
 
+static void vcap_free_ckf(struct vcap_rule *rule)
+{
+	struct vcap_client_keyfield *ckf, *next_ckf;
+
+	list_for_each_entry_safe(ckf, next_ckf, &rule->keyfields, ctrl.list) {
+		list_del(&ckf->ctrl.list);
+		kfree(ckf);
+	}
+}
+
 static void vcap_api_rule_add_keyvalue_test(struct kunit *test)
 {
 	struct vcap_admin admin = {
@@ -1027,6 +1037,7 @@ static void vcap_api_rule_add_keyvalue_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, VCAP_FIELD_BIT, kf->ctrl.type);
 	KUNIT_EXPECT_EQ(test, 0x0, kf->data.u1.value);
 	KUNIT_EXPECT_EQ(test, 0x1, kf->data.u1.mask);
+	vcap_free_ckf(rule);
 
 	INIT_LIST_HEAD(&rule->keyfields);
 	ret = vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS, VCAP_BIT_1);
@@ -1039,6 +1050,7 @@ static void vcap_api_rule_add_keyvalue_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, VCAP_FIELD_BIT, kf->ctrl.type);
 	KUNIT_EXPECT_EQ(test, 0x1, kf->data.u1.value);
 	KUNIT_EXPECT_EQ(test, 0x1, kf->data.u1.mask);
+	vcap_free_ckf(rule);
 
 	INIT_LIST_HEAD(&rule->keyfields);
 	ret = vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS,
@@ -1052,6 +1064,7 @@ static void vcap_api_rule_add_keyvalue_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, VCAP_FIELD_BIT, kf->ctrl.type);
 	KUNIT_EXPECT_EQ(test, 0x0, kf->data.u1.value);
 	KUNIT_EXPECT_EQ(test, 0x0, kf->data.u1.mask);
+	vcap_free_ckf(rule);
 
 	INIT_LIST_HEAD(&rule->keyfields);
 	ret = vcap_rule_add_key_u32(rule, VCAP_KF_TYPE, 0x98765432, 0xff00ffab);
@@ -1064,6 +1077,7 @@ static void vcap_api_rule_add_keyvalue_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, VCAP_FIELD_U32, kf->ctrl.type);
 	KUNIT_EXPECT_EQ(test, 0x98765432, kf->data.u32.value);
 	KUNIT_EXPECT_EQ(test, 0xff00ffab, kf->data.u32.mask);
+	vcap_free_ckf(rule);
 
 	INIT_LIST_HEAD(&rule->keyfields);
 	ret = vcap_rule_add_key_u128(rule, VCAP_KF_L3_IP6_SIP, &dip);
@@ -1078,6 +1092,7 @@ static void vcap_api_rule_add_keyvalue_test(struct kunit *test)
 		KUNIT_EXPECT_EQ(test, dip.value[idx], kf->data.u128.value[idx]);
 	for (idx = 0; idx < ARRAY_SIZE(dip.mask); ++idx)
 		KUNIT_EXPECT_EQ(test, dip.mask[idx], kf->data.u128.mask[idx]);
+	vcap_free_ckf(rule);
 }
 
 static void vcap_api_rule_add_actionvalue_test(struct kunit *test)
-- 
2.40.1



