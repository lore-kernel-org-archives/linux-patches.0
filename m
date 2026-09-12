Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266F229B78F;
	Sat, 12 Sep 2026 13:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218160; cv=none; b=C/EnhYZ/bTJkpWn1CCEhT7AJE9P77KlhThrB6hxM3/YqSRMQq7xC51bDKIam1gB+LVBlCbS5lebbgMaCsyvOcYZlsfdJ5wBnRTc79bJqejcjXIt6CFriKzUKaRL+wlL6hWml5bev74XpM3kDA8uGUrR+CW4rC1HtO4W/Q03Y0QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218160; c=relaxed/simple;
	bh=sqxUACrcf6AkqemGeyBxjchy+EbJn9cgAMBwKb7mYxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvjZNm+q06lDKW7TJyDuz1jNvuBQOpCCvxWAT4T74b9HqYKhuJ2EnxDiMzzzEjUkYmSG0xDlO+uwdSak3CaUua5ZODcShlY3WJQ2UNDZQ9P48IbqOSI74+WxsIk2O/Cvf8m30SzOZiLjDvogxOVB6Bab79TCg/+5QgqIDbPrq4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OkaEtYhK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OkaEtYhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8BB1F000FF;
	Sat, 12 Sep 2026 13:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218159;
	bh=fJ6e2X7A8qPYCe988wqEYv1lMJS2IVPAWPSnzQj0xFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OkaEtYhKemC871ufinGwQQ+Jux/XdG6k7iL+KsQd+vhzpWbvQb1Vbj+uCldjh0aPa
	 6UC9GwaZ404y6Fu0gTplj9ufhTrRAuMYDS4D/XiInNVmENAdE6PKA+R5TAvsJ4pnUY
	 OSmvz8PJrlG+KtR8P+ltqvy2WgQNxkdGHAid4pu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1087/1376] firewire: core: add KUnit tests for failure of tree building
Date: Sat, 12 Sep 2026 08:58:33 +0200
Message-ID: <20260912065631.789380933@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit f744022705b7eb479a1931ddd95aae4e9a4be221 ]

Abdun Nihaal has reported a memory leak when tree building fails in the
middle of self ID sequence enumeration. This is caused by an invalid
self ID sequence and is not a common occurrence.

This commit is intended to assist in fixing the issue by adding KUnit
tests to show the cases in which the memory leak is triggered. The leak
occurs internally in the build_tree() function, therefore it cannot be
detected directly by the tests.

Link: https://lore.kernel.org/r/20260810064119.410324-4-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Stable-dep-of: 05bfb1327dc5 ("firewire: core: fix memory leak in error path of build_tree()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/node-tree-test.c | 84 +++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/firewire/node-tree-test.c b/drivers/firewire/node-tree-test.c
index 6f404df3d50e0..251c0113639f2 100644
--- a/drivers/firewire/node-tree-test.c
+++ b/drivers/firewire/node-tree-test.c
@@ -506,6 +506,86 @@ static void node_tree_test_four_nodes_case3(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, data->release_count, 4);
 }
 
+static void node_tree_test_invalid_extended_self_id_sequence(struct kunit *test)
+{
+	// Use the same node tree as node_tree_test_four_nodes_case1, except for the invalid
+	// content of self ID packet for the phy 3.
+	static const u32 self_id_sequence[] = {
+		0x80000094,
+		0x81000080,
+		0x820000bc,
+		0x830000d1, // Invalid.
+	};
+	struct private_data *data = test->priv;
+	struct fw_card *card = data->card;
+
+	card->node_id = LOCAL_BUS | 0x03;
+
+	// TODO: Memory leak.
+	card->local_node = build_tree(card, self_id_sequence, ARRAY_SIZE(self_id_sequence), 123);
+	KUNIT_EXPECT_NULL(test, card->local_node);
+}
+
+static void node_tree_test_invalid_phy_id(struct kunit *test)
+{
+	// Use the same node tree as node_tree_test_four_nodes_case1, except for the invalid
+	// phy ID for phy 3.
+	static const u32 self_id_sequence[] = {
+		0x80000094,
+		0x81000080,
+		0x820000bc,
+		0x8f0000d0, // Invalid.
+	};
+	struct private_data *data = test->priv;
+	struct fw_card *card = data->card;
+
+	card->node_id = LOCAL_BUS | 0x03;
+
+	// TODO: Memory leak.
+	card->local_node = build_tree(card, self_id_sequence, ARRAY_SIZE(self_id_sequence), 123);
+	KUNIT_EXPECT_NULL(test, card->local_node);
+}
+
+static void node_tree_test_invalid_child_port_count(struct kunit *test)
+{
+	// Use the same node tree as node_tree_test_four_nodes_case1, except for the invalid
+	// count of child ports for phy 3.
+	static const u32 self_id_sequence[] = {
+		0x80000094,
+		0x81000080,
+		0x820000bc,
+		0x830000fc, // Invalid.
+	};
+	struct private_data *data = test->priv;
+	struct fw_card *card = data->card;
+
+	card->node_id = LOCAL_BUS | 0x03;
+
+	// TODO: Memory leak.
+	card->local_node = build_tree(card, self_id_sequence, ARRAY_SIZE(self_id_sequence), 123);
+	KUNIT_EXPECT_NULL(test, card->local_node);
+}
+
+static void node_tree_test_invalid_parent_port_count(struct kunit *test)
+{
+	// Use the same node tree as node_tree_test_four_nodes_case1, except for the invalid
+	// count of parent ports for phy 3.
+	static const u32 self_id_sequence[] = {
+		0x80000094,
+		0x81000080,
+		0x820000bc,
+		0x830000e8, // Invalid.
+	};
+	struct private_data *data = test->priv;
+	struct fw_card *card = data->card;
+
+	card->node_id = LOCAL_BUS | 0x03;
+
+	// TODO: Memory leak.
+	card->local_node = build_tree(card, self_id_sequence, ARRAY_SIZE(self_id_sequence), 123);
+	KUNIT_EXPECT_NULL(test, card->local_node);
+}
+
 static struct kunit_case node_tree_test_cases[] = {
 	KUNIT_CASE(node_tree_test_two_nodes),
 	KUNIT_CASE(node_tree_test_two_nodes_1394a),
@@ -515,6 +595,10 @@ static struct kunit_case node_tree_test_cases[] = {
 	KUNIT_CASE(node_tree_test_four_nodes_case1),
 	KUNIT_CASE(node_tree_test_four_nodes_case2),
 	KUNIT_CASE(node_tree_test_four_nodes_case3),
+	KUNIT_CASE(node_tree_test_invalid_extended_self_id_sequence),
+	KUNIT_CASE(node_tree_test_invalid_phy_id),
+	KUNIT_CASE(node_tree_test_invalid_child_port_count),
+	KUNIT_CASE(node_tree_test_invalid_parent_port_count),
 	{}
 };
 
-- 
2.53.0



