Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3F234A78B;
	Tue,  6 Jan 2026 17:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719942; cv=none; b=D9atHS3Yh05yeezvyV2zw4WMAt/K4wVD3gi6BOs8jAO0HBXjvY/JL65cHNCxMFGkgSReMr517uNvlqYQvahGa8GUdqZ61Z6PgoE+ktCAutRAU0bBbCRhsuNL5FBVr4/JQ/q2wQvz2D0R6aOZYiXv2BVETYjBBcnb94yyMZlky68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719942; c=relaxed/simple;
	bh=PjAulDDmX6FCDbv95LIw4ABEdgEJmD+tHmTNB956U7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PY1Jpor21tFsXWn0aS3V2Y4iDtuLndjgrOSy6Cyq05zX9+xr9OqOFYUi1T+SZfh2uAF80V9y6fnySOe+wocs/9blG1293rYIn+jB4lzyQHPq30neNnbZx/8+SE9j5PG+duz4IHA8Wrckk727hwvgXNGzxzxKsu3XHLBQxEzA8S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYNdHAco; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYNdHAco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12522C116C6;
	Tue,  6 Jan 2026 17:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719942;
	bh=PjAulDDmX6FCDbv95LIw4ABEdgEJmD+tHmTNB956U7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYNdHAcoO5KtHD/GWEOfUcNyUEqHwdfiYB46mUgTERP8Qg+89CcLL+DpLLBHgHzoV
	 M++oYny9ux24cBy/HT0+xE5pVxIhWCskSVRCE7QDKPPR+u/2Td7Kc5oqGU8BUiLENs
	 uIO3DEZJb6sXnBSXolcRUYzpbVcFwy6ZAiXSAIdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianpeng Chang <jianpeng.chang.cn@windriver.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/567] arm64: kdump: Fix elfcorehdr overlap caused by reserved memory processing reorder
Date: Tue,  6 Jan 2026 17:57:49 +0100
Message-ID: <20260106170454.549107002@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Jianpeng Chang <jianpeng.chang.cn@windriver.com>

[ Upstream commit 3e8ade58b71b48913d21b647b2089e03e81f117e ]

Commit 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved
memory regions are processed") changed the processing order of reserved
memory regions, causing elfcorehdr to overlap with dynamically allocated
reserved memory regions during kdump kernel boot.

The issue occurs because:
1. kexec-tools allocates elfcorehdr in the last crashkernel reserved
   memory region and passes it to the second kernel
2. The problematic commit moved dynamic reserved memory allocation
   (like bman-fbpr) to occur during fdt_scan_reserved_mem(), before
   elfcorehdr reservation in fdt_reserve_elfcorehdr()
3. bman-fbpr with 16MB alignment requirement can get allocated at
   addresses that overlap with the elfcorehdr location
4. When fdt_reserve_elfcorehdr() tries to reserve elfcorehdr memory,
   overlap detection identifies the conflict and skips reservation
5. kdump kernel fails with "Unable to handle kernel paging request"
   because elfcorehdr memory is not properly reserved

The boot log:
Before 8a6e02d0c00e:
  OF: fdt: Reserving 1 KiB of memory at 0xf4fff000 for elfcorehdr
  OF: reserved mem: 0xf3000000..0xf3ffffff bman-fbpr

After 8a6e02d0c00e:
  OF: reserved mem: 0xf4000000..0xf4ffffff bman-fbpr
  OF: fdt: elfcorehdr is overlapped

Fix this by ensuring elfcorehdr reservation occurs before dynamic
reserved memory allocation.

Fixes: 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory regions are processed")
Signed-off-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
Link: https://patch.msgid.link/20251205015934.700016-1-jianpeng.chang.cn@windriver.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 8c80f4dc8b3f..0940955d3701 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -501,8 +501,8 @@ void __init early_init_fdt_scan_reserved_mem(void)
 	if (!initial_boot_params)
 		return;
 
-	fdt_scan_reserved_mem();
 	fdt_reserve_elfcorehdr();
+	fdt_scan_reserved_mem();
 
 	/* Process header /memreserve/ fields */
 	for (n = 0; ; n++) {
-- 
2.51.0



