Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860FC3AEF2D;
	Sat, 17 Oct 2026 17:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258342; cv=none; b=Z2YQoFSwcQdzS0WKQsB3c13Xxpj7ED9YFgNAbUZKrbJRaIOGsahoBPZE29O3cyg3zM3LKK2IaEKG41nwkU3DO71XF8xTsJdTc8k5JO9xqT5j5T0zloluFz8s/DtSrdf1k0Pv7y8OtQ82OeMnPo/r78kHXFLSONgO2zdJKEylNMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258342; c=relaxed/simple;
	bh=csqHF9VTi8E3vJDC0zn1ZCyLkjs98CR3bzxkBhBXwlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvzjXDI6R2zCUjp6gw/4QPtuEAIPQYzX7C8qoxPPOE81zxWnxIckVCa6JMPfxxIQ+M9VUSrqnKlPs8Fgzo3ktdPoF2zQtrWuMvz7zg7cKF/AB2FnRWdIdnReLG8N/gs3geDp38KFT0InmBpIUfIxyer7pRzuLtnE0cd38fsVP38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5YtmHiS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5YtmHiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC7F1F000C4;
	Sat, 17 Oct 2026 17:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258341;
	bh=qm8WxS9fkfjD9Lk91NFAfi/CtfrZoAGDiSOFz1dFZKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w5YtmHiS4O4AYUCnM+3F0TGbSE4ojK1dGCqe0B40W1P8xX9uJBbZrW8HcpwhMUPE5
	 wdg1vz3eISNIbyHgC0G31qj5sYjHZDKysYU9GnldJxYzWCUJvBgPz71FNW8PqIOUjV
	 5bX/x8Wpc3LQ0DnmjscS4881UzMFiNrLpiRika0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0853/1674] of: unittest: Fix memory leak in unittest_data_add()
Date: Sat, 17 Oct 2026 17:52:05 +0200
Message-ID: <20261017160453.017956478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/of/unittest.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 9af9d3f7418f1..9109667a35105 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1636,7 +1636,6 @@ static void attach_node_and_children(struct device_node *np)
  */
 static int __init unittest_data_add(void)
 {
-	void *unittest_data;
 	void *unittest_data_align;
 	struct device_node *unittest_data_node = NULL, *np;
 	/*
@@ -1655,7 +1654,7 @@ static int __init unittest_data_add(void)
 	}
 
 	/* creating copy */
-	unittest_data = kmalloc(size + FDT_ALIGN_SIZE, GFP_KERNEL);
+	void *unittest_data __free(kfree) = kmalloc(size + FDT_ALIGN_SIZE, GFP_KERNEL);
 	if (!unittest_data)
 		return -ENOMEM;
 
@@ -1665,12 +1664,10 @@ static int __init unittest_data_add(void)
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
 
@@ -1693,6 +1690,7 @@ static int __init unittest_data_add(void)
 		of_aliases = of_find_node_by_path("/aliases");
 		of_chosen = of_find_node_by_path("/chosen");
 		of_overlay_mutex_unlock();
+		(void)no_free_ptr(unittest_data);
 		return 0;
 	}
 
@@ -1715,6 +1713,7 @@ static int __init unittest_data_add(void)
 
 	of_overlay_mutex_unlock();
 
+	(void)no_free_ptr(unittest_data);
 	return 0;
 }
 
-- 
2.53.0



