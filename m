Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B099219E7F7;
	Sat, 12 Sep 2026 07:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198438; cv=none; b=gNvRvZdw7VxKYU20buoAiCdkT0W42bkN7m1V8F1H+ipA4Cr8x29SKa5sP4UxSLSTin0Wkx7hvWeccXOD5gcRDq88e91IqPul9uV+lcpIPc+NKEO9Q0TNrgbwhDdVCoBsd1FIRbodaevi9oKvmEQVNOZKpCznJKUoFo0Zb/WukTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198438; c=relaxed/simple;
	bh=0luar+du3Ky9R2zd+8eb2en+OcSl1mjaUhykf2+K/x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLT9wjfNr/AsxJ4OjH6gyLv8WKHrL9ClDwX73j7JN+EnIFd0N125ULeAPL0/vxPI4B0UcBnngRkcaAzJ/5Ka31JoAacNdQGBymq765hDqFM6/VVbVwD0kUcsB4TvIgcL3Pxrr4enEAx3a1gXQpTZM3wHr8TFdS4/7Uno5yuNG0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+9GGlwH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+9GGlwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803CE1F000FF;
	Sat, 12 Sep 2026 07:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198437;
	bh=1iHj1qT5rqjtLWtO5jNoCOmahcyqibbYYql1tYnhhMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E+9GGlwHrJI8DL6r4pOFbLIrH5FKyq2BJLj0a6YAFxIrP1c3x5Vq9H7zQNcwF/9+7
	 RU0gRkjoYfD8qmryw45Ez8C9/qRSggFk4H03lXWwSvpmCVoqBKONdRecp4X/iXV3NQ
	 lSbkwLl2NXlJMigApPFBJK5VYf79n5dn1aLfJaZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ming <ming.li@zohomail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0381/1815] cxl/test: Rework cxl_type2_mem_init() to use cxl_mock_platform_device_add()
Date: Sat, 12 Sep 2026 08:35:31 +0200
Message-ID: <20260912065657.842881162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Ming <ming.li@zohomail.com>

[ Upstream commit 9515af581da976911aea820175afb05be803ae8c ]

cxl_type2_mem_init() is used to set up mock CXL type2 memory device for
cxl testing, it introduces a known bug fixed by the following commit:

commit d90f236f8b9e ("cxl/test: Update mock dev array before calling platform_device_add()")

Mock CXL devices require updating the mock device array prior to
platform_device_add(), otherwise, the CXL subsystem could fail to
recognize the newly added mock device. Switch to
cxl_mock_platform_device_add() helper to resolve this ordering issue.

Besides, this patch also includes two minor changes.
1. Preserve the original error code returned by
   cxl_mock_platform_device_add(), rather than unconditionally
   overriding it with -ENOMEM.
2. Drop redundant NULL check before platform_device_unregister(), as the
   function internally handles NULL pointer.

Fixes: 6b2e585142e6 ("cxl/test: Add hierarchy enumeration support for type2 device")
Signed-off-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260713061531.56322-1-ming.li@zohomail.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/cxl.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 8a4248207fe32..a0d75a0761337 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -1799,25 +1799,16 @@ static int cxl_type2_mem_init(void)
 		pdev->dev.parent = &dport->dev;
 		set_dev_node(&pdev->dev, i % 2);
 
-		rc = platform_device_add(pdev);
-		if (rc) {
-			rc = -ENOMEM;
-			platform_device_put(pdev);
+		rc = cxl_mock_platform_device_add(pdev, &cxl_mem[i]);
+		if (rc)
 			goto err_mem;
-		}
-		cxl_mem[i] = pdev;
 	}
 
 	return 0;
 
 err_mem:
-	for (i = NR_CXL_TYPE2_ACCEL - 1; i >= 0; i--) {
-		struct platform_device *pdev = cxl_mem[i];
-
-		if (!pdev)
-			continue;
-		platform_device_unregister(pdev);
-	}
+	for (i = NR_CXL_TYPE2_ACCEL - 1; i >= 0; i--)
+		platform_device_unregister(cxl_mem[i]);
 	return rc;
 }
 
-- 
2.53.0



