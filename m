Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431BF37FF60;
	Sat, 12 Sep 2026 11:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214290; cv=none; b=jKKBVhJdv7ZEgBWQwZ6mgqDunlw/5H+ptWUNDbuDUuUF+4Y5FLWJTFLmAHMvp1RAp9AsezuECZrERQMdQHg57llx34MWbWxSuGmBN0DDx8eeUcEe+e12GimazEpkRQpKXmEXPeb2r3ppCJsD9/ntNeACK/4sziqKP5eXb/yono8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214290; c=relaxed/simple;
	bh=/+GLBmUA5QL5XnN5ZjEwz47j+nzoWQ9lOK5MN/Gyhps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lThvWL16yhHnODUfr9DAnrSe8C81cF9nsN1Utznw3knAuJJHfMOgsR2xrgc27htfEowtAqqTG/6aIZuU/R1xJ0pCOtA6mGFjF62AuUHQC/aKEBMM5h76CW+E6+EiWWtgSivM2V83Lt9EsAXNK5Ut0u4p51i8WLDMSUGi6Lbvb8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rp72EbYF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rp72EbYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227101F000FF;
	Sat, 12 Sep 2026 11:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214289;
	bh=VhFgbMwyBlMy/1iLY5E5POpqP+F+bG7Z2b1gZFRQQXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rp72EbYF4mK6PhU/tc23HPkPbXnfMXip0Q9iRrT9kf9jCLm+YCnoA6LjnQuDIs4Xh
	 y6zWMHkXLEBI0g/dzjnnMeOmiYkqTh9FcqUFjSZ0A088emdPp7nwgeG2p3R4FxQDrB
	 5HoMkqOZB/2VNn6c1AHSpZi68bqkK8QGXOPLfJWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0297/1376] of: unittest: Fix memory leak in unittest_data_add()
Date: Sat, 12 Sep 2026 08:45:23 +0200
Message-ID: <20260912065614.168633860@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 235a1eb8d2dcc49a6cf0a5ee1aa85544a5d0054b ]

In unittest_data_add(), if of_resolve_phandles() fails, the allocated
unittest_data is not freed, leading to a memory leak.

Fix this by using scope-based cleanup helper __free(kfree) for automatic
resource cleanup. This ensures unittest_data is automatically freed when
it goes out of scope in error paths.

For the success path, use retain_and_null_ptr() to transfer ownership
of the memory to the device tree and prevent double freeing.

Fixes: 2eb46da2a760 ("of/selftest: Use the resolver to fixup phandles")
Suggested-by: Rob Herring <robh@kernel.org>
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20251231114915.234638-1-zilin@seu.edu.cn
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 96d2e7b63db38..bed3f7538aa99 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1871,7 +1871,6 @@ static void attach_node_and_children(struct device_node *np)
  */
 static int __init unittest_data_add(void)
 {
-	void *unittest_data;
 	void *unittest_data_align;
 	struct device_node *unittest_data_node = NULL, *np;
 	/*
@@ -1890,7 +1889,7 @@ static int __init unittest_data_add(void)
 	}
 
 	/* creating copy */
-	unittest_data = kmalloc(size + FDT_ALIGN_SIZE, GFP_KERNEL);
+	void *unittest_data __free(kfree) = kmalloc(size + FDT_ALIGN_SIZE, GFP_KERNEL);
 	if (!unittest_data)
 		return -ENOMEM;
 
@@ -1900,12 +1899,10 @@ static int __init unittest_data_add(void)
 	ret = of_fdt_unflatten_tree(unittest_data_align, NULL, &unittest_data_node);
 	if (!ret) {
 		pr_warn("%s: unflatten testcases tree failed\n", __func__);
-		kfree(unittest_data);
 		return -ENODATA;
 	}
 	if (!unittest_data_node) {
 		pr_warn("%s: testcases tree is empty\n", __func__);
-		kfree(unittest_data);
 		return -ENODATA;
 	}
 
@@ -1924,7 +1921,6 @@ static int __init unittest_data_add(void)
 	/* attach the sub-tree to live tree */
 	if (!of_root) {
 		pr_warn("%s: no live tree to attach sub-tree\n", __func__);
-		kfree(unittest_data);
 		rc = -ENODEV;
 		goto unlock;
 	}
@@ -1945,6 +1941,8 @@ static int __init unittest_data_add(void)
 	EXPECT_END(KERN_INFO,
 		   "Duplicate name in testcase-data, renamed to \"duplicate-name#1\"");
 
+	retain_and_null_ptr(unittest_data);
+
 unlock:
 	of_overlay_mutex_unlock();
 
-- 
2.53.0



