Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCF912F5A7;
	Tue, 23 Jan 2024 00:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969015; cv=none; b=qvpr6XcOl+5rijFYBBJk+shRrDZGobQay5WS/2lrqw7zkzeXQleHV+sn3N/XnLGrufCDgloMoNSVmiuyTqb4mSAmbOVejA+9PMkQ5FXqlzacYO+FQXJ/agTeYk5hc48xIwcJVoOxYQHg8hoydUUVyKQR201CJ0HxLZSXhKmkguU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969015; c=relaxed/simple;
	bh=GbdwCxX9xta8Vvu07jwLxpMR6yZVGeiGET7KIwNklnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jpf6CaWAUSyAf5N+n0/Fblgw3c4UfFBKxXJleaotl50jxVEjFfP+WbOYoGc9xsSi88efLjk9lE0u8lw4mSr7ADOmgVwftNZ0tvuPCIX3bYFieJe8luU64meiaXfmqkN+dctyeV5JJrArnmev/pUylzRLe0+sUKw7Ziv4oX8I0FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4h9MiDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4h9MiDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17452C433F1;
	Tue, 23 Jan 2024 00:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969015;
	bh=GbdwCxX9xta8Vvu07jwLxpMR6yZVGeiGET7KIwNklnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4h9MiDlodJQlNN3n3UtiGst62s2Kfg3eIbBT9ku7IShVtaGBCx54VDNP+5Pjn+vV
	 Qog+G/8RjwcSo1XNSfKUkbB7r9oC3eYgLvbc23E1N19RA+brKUU5XHtIC1B1VR0ahR
	 DRse/ujRU6eUSR2H4Fg0AjNOxGGXR7Kp1GlRPOPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <stephen.boyd@linaro.org>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 137/194] of: Fix double free in of_parse_phandle_with_args_map
Date: Mon, 22 Jan 2024 15:57:47 -0800
Message-ID: <20240122235725.106498173@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

[ Upstream commit 4dde83569832f9377362e50f7748463340c5db6b ]

In of_parse_phandle_with_args_map() the inner loop that
iterates through the map entries calls of_node_put(new)
to free the reference acquired by the previous iteration
of the inner loop. This assumes that the value of "new" is
NULL on the first iteration of the inner loop.

Make sure that this is true in all iterations of the outer
loop by setting "new" to NULL after its value is assigned to "cur".

Extend the unittest to detect the double free and add an additional
test case that actually triggers this path.

Fixes: bd6f2fd5a1 ("of: Support parsing phandle argument lists through a nexus node")
Cc: Stephen Boyd <stephen.boyd@linaro.org>
Signed-off-by: "Christian A. Ehrhardt" <lk@c--e.de>
Link: https://lore.kernel.org/r/20231229105411.1603434-1-lk@c--e.de
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/base.c                           |  1 +
 drivers/of/unittest-data/tests-phandle.dtsi | 10 ++-
 drivers/of/unittest.c                       | 74 ++++++++++++---------
 3 files changed, 53 insertions(+), 32 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index c8af9a65f98b..6fa209b3557b 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1744,6 +1744,7 @@ int of_parse_phandle_with_args_map(const struct device_node *np,
 		out_args->np = new;
 		of_node_put(cur);
 		cur = new;
+		new = NULL;
 	}
 put:
 	of_node_put(cur);
diff --git a/drivers/of/unittest-data/tests-phandle.dtsi b/drivers/of/unittest-data/tests-phandle.dtsi
index 6b33be4c4416..aa0d7027ffa6 100644
--- a/drivers/of/unittest-data/tests-phandle.dtsi
+++ b/drivers/of/unittest-data/tests-phandle.dtsi
@@ -38,6 +38,13 @@ provider4: provider4 {
 				phandle-map-pass-thru = <0x0 0xf0>;
 			};
 
+			provider5: provider5 {
+				#phandle-cells = <2>;
+				phandle-map = <2 7 &provider4 2 3>;
+				phandle-map-mask = <0xff 0xf>;
+				phandle-map-pass-thru = <0x0 0xf0>;
+			};
+
 			consumer-a {
 				phandle-list =	<&provider1 1>,
 						<&provider2 2 0>,
@@ -64,7 +71,8 @@ consumer-b {
 						<&provider4 4 0x100>,
 						<&provider4 0 0x61>,
 						<&provider0>,
-						<&provider4 19 0x20>;
+						<&provider4 19 0x20>,
+						<&provider5 2 7>;
 				phandle-list-bad-phandle = <12345678 0 0>;
 				phandle-list-bad-args = <&provider2 1 0>,
 							<&provider4 0>;
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 42acbb3668b2..b1924062c939 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -430,6 +430,9 @@ static void __init of_unittest_parse_phandle_with_args(void)
 
 		unittest(passed, "index %i - data error on node %pOF rc=%i\n",
 			 i, args.np, rc);
+
+		if (rc == 0)
+			of_node_put(args.np);
 	}
 
 	/* Check for missing list property */
@@ -471,8 +474,9 @@ static void __init of_unittest_parse_phandle_with_args(void)
 
 static void __init of_unittest_parse_phandle_with_args_map(void)
 {
-	struct device_node *np, *p0, *p1, *p2, *p3;
+	struct device_node *np, *p[6] = {};
 	struct of_phandle_args args;
+	unsigned int prefs[6];
 	int i, rc;
 
 	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-b");
@@ -481,34 +485,24 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 		return;
 	}
 
-	p0 = of_find_node_by_path("/testcase-data/phandle-tests/provider0");
-	if (!p0) {
-		pr_err("missing testcase data\n");
-		return;
-	}
-
-	p1 = of_find_node_by_path("/testcase-data/phandle-tests/provider1");
-	if (!p1) {
-		pr_err("missing testcase data\n");
-		return;
-	}
-
-	p2 = of_find_node_by_path("/testcase-data/phandle-tests/provider2");
-	if (!p2) {
-		pr_err("missing testcase data\n");
-		return;
-	}
-
-	p3 = of_find_node_by_path("/testcase-data/phandle-tests/provider3");
-	if (!p3) {
-		pr_err("missing testcase data\n");
-		return;
+	p[0] = of_find_node_by_path("/testcase-data/phandle-tests/provider0");
+	p[1] = of_find_node_by_path("/testcase-data/phandle-tests/provider1");
+	p[2] = of_find_node_by_path("/testcase-data/phandle-tests/provider2");
+	p[3] = of_find_node_by_path("/testcase-data/phandle-tests/provider3");
+	p[4] = of_find_node_by_path("/testcase-data/phandle-tests/provider4");
+	p[5] = of_find_node_by_path("/testcase-data/phandle-tests/provider5");
+	for (i = 0; i < ARRAY_SIZE(p); ++i) {
+		if (!p[i]) {
+			pr_err("missing testcase data\n");
+			return;
+		}
+		prefs[i] = kref_read(&p[i]->kobj.kref);
 	}
 
 	rc = of_count_phandle_with_args(np, "phandle-list", "#phandle-cells");
-	unittest(rc == 7, "of_count_phandle_with_args() returned %i, expected 7\n", rc);
+	unittest(rc == 8, "of_count_phandle_with_args() returned %i, expected 7\n", rc);
 
-	for (i = 0; i < 8; i++) {
+	for (i = 0; i < 9; i++) {
 		bool passed = true;
 
 		memset(&args, 0, sizeof(args));
@@ -519,13 +513,13 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 		switch (i) {
 		case 0:
 			passed &= !rc;
-			passed &= (args.np == p1);
+			passed &= (args.np == p[1]);
 			passed &= (args.args_count == 1);
 			passed &= (args.args[0] == 1);
 			break;
 		case 1:
 			passed &= !rc;
-			passed &= (args.np == p3);
+			passed &= (args.np == p[3]);
 			passed &= (args.args_count == 3);
 			passed &= (args.args[0] == 2);
 			passed &= (args.args[1] == 5);
@@ -536,28 +530,36 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 			break;
 		case 3:
 			passed &= !rc;
-			passed &= (args.np == p0);
+			passed &= (args.np == p[0]);
 			passed &= (args.args_count == 0);
 			break;
 		case 4:
 			passed &= !rc;
-			passed &= (args.np == p1);
+			passed &= (args.np == p[1]);
 			passed &= (args.args_count == 1);
 			passed &= (args.args[0] == 3);
 			break;
 		case 5:
 			passed &= !rc;
-			passed &= (args.np == p0);
+			passed &= (args.np == p[0]);
 			passed &= (args.args_count == 0);
 			break;
 		case 6:
 			passed &= !rc;
-			passed &= (args.np == p2);
+			passed &= (args.np == p[2]);
 			passed &= (args.args_count == 2);
 			passed &= (args.args[0] == 15);
 			passed &= (args.args[1] == 0x20);
 			break;
 		case 7:
+			passed &= !rc;
+			passed &= (args.np == p[3]);
+			passed &= (args.args_count == 3);
+			passed &= (args.args[0] == 2);
+			passed &= (args.args[1] == 5);
+			passed &= (args.args[2] == 3);
+			break;
+		case 8:
 			passed &= (rc == -ENOENT);
 			break;
 		default:
@@ -566,6 +568,9 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 
 		unittest(passed, "index %i - data error on node %s rc=%i\n",
 			 i, args.np->full_name, rc);
+
+		if (rc == 0)
+			of_node_put(args.np);
 	}
 
 	/* Check for missing list property */
@@ -591,6 +596,13 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 	rc = of_parse_phandle_with_args_map(np, "phandle-list-bad-args",
 					    "phandle", 1, &args);
 	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
+
+	for (i = 0; i < ARRAY_SIZE(p); ++i) {
+		unittest(prefs[i] == kref_read(&p[i]->kobj.kref),
+			 "provider%d: expected:%d got:%d\n",
+			 i, prefs[i], kref_read(&p[i]->kobj.kref));
+		of_node_put(p[i]);
+	}
 }
 
 static void __init of_unittest_property_string(void)
-- 
2.43.0



