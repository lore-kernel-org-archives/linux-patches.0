Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190122AB29
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B066C433CA;
	Wed, 20 Sep 2023 12:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211344;
	bh=FtHNR7RSxJcBj+E7JBmCUyQRIGReUr6MdwWzJXw96pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCekj3RSnZlRaEJdcpRb2lk99MFSuWLBW40rcoSMAEH0r5gBdGeG4S7el9zeGY7my
	 v89sbEQpYv3EKGTuw2zBYZc9wzjKt41amxEoHL1UXm+60CLBR0eZbNQUnF8zGrWCoR
	 TaI6wlavlS49HQ9/Ab8/91WwEpqYm3raMpu4BPSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruan Jinjie <ruanjinjie@huawei.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 059/186] of: unittest: fix null pointer dereferencing in of_unittest_find_node_by_name()
Date: Wed, 20 Sep 2023 13:29:22 +0200
Message-ID: <20230920112839.029631955@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruan Jinjie <ruanjinjie@huawei.com>

[ Upstream commit d6ce4f0ea19c32f10867ed93d8386924326ab474 ]

when kmalloc() fail to allocate memory in kasprintf(), name
or full_name will be NULL, strcmp() will cause
null pointer dereference.

Fixes: 0d638a07d3a1 ("of: Convert to using %pOF instead of full_name")
Signed-off-by: Ruan Jinjie <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20230727080246.519539-1-ruanjinjie@huawei.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 55c98f119df22..89d1011d5b327 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -51,7 +51,7 @@ static void __init of_unittest_find_node_by_name(void)
 
 	np = of_find_node_by_path("/testcase-data");
 	name = kasprintf(GFP_KERNEL, "%pOF", np);
-	unittest(np && !strcmp("/testcase-data", name),
+	unittest(np && name && !strcmp("/testcase-data", name),
 		"find /testcase-data failed\n");
 	of_node_put(np);
 	kfree(name);
@@ -62,14 +62,14 @@ static void __init of_unittest_find_node_by_name(void)
 
 	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
 	name = kasprintf(GFP_KERNEL, "%pOF", np);
-	unittest(np && !strcmp("/testcase-data/phandle-tests/consumer-a", name),
+	unittest(np && name && !strcmp("/testcase-data/phandle-tests/consumer-a", name),
 		"find /testcase-data/phandle-tests/consumer-a failed\n");
 	of_node_put(np);
 	kfree(name);
 
 	np = of_find_node_by_path("testcase-alias");
 	name = kasprintf(GFP_KERNEL, "%pOF", np);
-	unittest(np && !strcmp("/testcase-data", name),
+	unittest(np && name && !strcmp("/testcase-data", name),
 		"find testcase-alias failed\n");
 	of_node_put(np);
 	kfree(name);
@@ -80,7 +80,7 @@ static void __init of_unittest_find_node_by_name(void)
 
 	np = of_find_node_by_path("testcase-alias/phandle-tests/consumer-a");
 	name = kasprintf(GFP_KERNEL, "%pOF", np);
-	unittest(np && !strcmp("/testcase-data/phandle-tests/consumer-a", name),
+	unittest(np && name && !strcmp("/testcase-data/phandle-tests/consumer-a", name),
 		"find testcase-alias/phandle-tests/consumer-a failed\n");
 	of_node_put(np);
 	kfree(name);
@@ -966,6 +966,8 @@ static void attach_node_and_children(struct device_node *np)
 	const char *full_name;
 
 	full_name = kasprintf(GFP_KERNEL, "%pOF", np);
+	if (!full_name)
+		return;
 
 	if (!strcmp(full_name, "/__local_fixups__") ||
 	    !strcmp(full_name, "/__fixups__")) {
-- 
2.40.1



