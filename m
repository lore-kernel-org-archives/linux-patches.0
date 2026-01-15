Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04B925228D;
	Thu, 15 Jan 2026 16:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496077; cv=none; b=i403C4WMpF+hWMtc4RqcEpyXAN/Oi8bpnCfCZKfcttpYe9CMc4YpCColbrCD5gSQW9F6KkBzSWVVRZBhnHPn+iV3NjYFdUOXU59dG4C4h3czEtxWJAS7MA4+B0lRJLsGSVAiWwpTuF9ayySAzAL/5WLwRTV3QtRg9CiuX0imOP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496077; c=relaxed/simple;
	bh=/nHNGzqh6rZo32F/FYsSEtlrr5IUthFiOZf+ED946CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZRrE0sBqsjbfrlIYenLgTioCJWyblEnez/gDY1yyVW+yKwtizgCu0AaSkdFVbGs7NcK93myafDGBuoH2hnzLTLqIbmMMNMGDgADGOO+PuscS8qnrLpPVyTCiR4p5p0poj1vOXIMLzZnKsu4cTl+slQ7Er+fjSszzcOCXMaAu7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtJoIRnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtJoIRnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3135BC116D0;
	Thu, 15 Jan 2026 16:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496077;
	bh=/nHNGzqh6rZo32F/FYsSEtlrr5IUthFiOZf+ED946CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtJoIRnl0xR8LCVbiGVaqbqD8u+u++9slYi+IXU6WZ5Z+Ex0z660wP4nKsjGfXoPo
	 L+eohaUTR7NYVbWPnOy2RageCRoB7UpCtdJdMKwCFmc15QD7UrQW+P7SH3vBHAVCJN
	 ZerBg+eJtGaVUtYE8SX/O4ftw3lTl2JXXBfQohDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/181] of: unittest: Fix memory leak in unittest_data_add()
Date: Thu, 15 Jan 2026 17:46:45 +0100
Message-ID: <20260115164204.780250888@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 388e9ec2cccf8..3b773aaf9d050 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1985,7 +1985,6 @@ static void attach_node_and_children(struct device_node *np)
  */
 static int __init unittest_data_add(void)
 {
-	void *unittest_data;
 	void *unittest_data_align;
 	struct device_node *unittest_data_node = NULL, *np;
 	/*
@@ -2004,7 +2003,7 @@ static int __init unittest_data_add(void)
 	}
 
 	/* creating copy */
-	unittest_data = kmalloc(size + FDT_ALIGN_SIZE, GFP_KERNEL);
+	void *unittest_data __free(kfree) = kmalloc(size + FDT_ALIGN_SIZE, GFP_KERNEL);
 	if (!unittest_data)
 		return -ENOMEM;
 
@@ -2014,12 +2013,10 @@ static int __init unittest_data_add(void)
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
 
@@ -2038,7 +2035,6 @@ static int __init unittest_data_add(void)
 	/* attach the sub-tree to live tree */
 	if (!of_root) {
 		pr_warn("%s: no live tree to attach sub-tree\n", __func__);
-		kfree(unittest_data);
 		rc = -ENODEV;
 		goto unlock;
 	}
@@ -2059,6 +2055,8 @@ static int __init unittest_data_add(void)
 	EXPECT_END(KERN_INFO,
 		   "Duplicate name in testcase-data, renamed to \"duplicate-name#1\"");
 
+	retain_and_null_ptr(unittest_data);
+
 unlock:
 	of_overlay_mutex_unlock();
 
-- 
2.51.0



