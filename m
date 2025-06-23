Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777C71E5B71;
	Mon, 23 Jun 2025 21:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714123; cv=none; b=UgHq6QzMb1a9Zxl6H+ae97ydV16CNxTI9yxHlj9BV+A0wFHicJ59hdNXdYnqfBxwvlOaOkIl7yvoJa8v4bvHX2DGPz+cuttOGNSZIoK4iX6fVmcv66itWM9T5tvAfShoVV2P1sfTSzGSDNngA87YV60HcAN8ntCZzQn9ym3ygzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714123; c=relaxed/simple;
	bh=PkpM/9q6dalWyVivmzOmbHNuA1oTrTPC2DaC7M8iDfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkQerCG8QDRAjtG3zJ8AV5Zac77lv/1y2z1lqjnACGsyyzgxCwlvbkVbOAd2o3aopK+hVMubGBFFv2+78cpY0IN6S1dLhdM2Ffex1aASP/eHVrOocMfc0nF3rsRfOq/QErCKqLVRKXAhCwa2f2REnJ2MxxUChFu4Oc4pFq40Nuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTbPPSOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTbPPSOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF3DC4CEEA;
	Mon, 23 Jun 2025 21:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714123;
	bh=PkpM/9q6dalWyVivmzOmbHNuA1oTrTPC2DaC7M8iDfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTbPPSOMDblW0HTQbK+r12p11VKsXGg6RbhS10jND3r66P2tB0vCkCqj5lUlRQOl7
	 ZkjkCqEzfb7KhGrEHnUJgzX41+q83O2nPBZBzHFb+gnmA/QdD9SNeZAG9zEe6/DzL7
	 6py8pSpyK+S0RHi+tcotNJW3psDvq8ZNx3QOuDxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.10 207/355] uio_hv_generic: Use correct size for interrupt and monitor pages
Date: Mon, 23 Jun 2025 15:06:48 +0200
Message-ID: <20250623130632.970169137@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

commit c951ab8fd3589cf6991ed4111d2130816f2e3ac2 upstream.

Interrupt and monitor pages should be in Hyper-V page size (4k bytes).
This can be different from the system page size.

This size is read and used by the user-mode program to determine the
mapped data region. An example of such user-mode program is the VMBus
driver in DPDK.

Cc: stable@vger.kernel.org
Fixes: 95096f2fbd10 ("uio-hv-generic: new userspace i/o driver for VMBus")
Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/1746492997-4599-3-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <1746492997-4599-3-git-send-email-longli@linuxonhyperv.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio_hv_generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -288,13 +288,13 @@ hv_uio_probe(struct hv_device *dev,
 	pdata->info.mem[INT_PAGE_MAP].name = "int_page";
 	pdata->info.mem[INT_PAGE_MAP].addr
 		= (uintptr_t)vmbus_connection.int_page;
-	pdata->info.mem[INT_PAGE_MAP].size = PAGE_SIZE;
+	pdata->info.mem[INT_PAGE_MAP].size = HV_HYP_PAGE_SIZE;
 	pdata->info.mem[INT_PAGE_MAP].memtype = UIO_MEM_LOGICAL;
 
 	pdata->info.mem[MON_PAGE_MAP].name = "monitor_page";
 	pdata->info.mem[MON_PAGE_MAP].addr
 		= (uintptr_t)vmbus_connection.monitor_pages[1];
-	pdata->info.mem[MON_PAGE_MAP].size = PAGE_SIZE;
+	pdata->info.mem[MON_PAGE_MAP].size = HV_HYP_PAGE_SIZE;
 	pdata->info.mem[MON_PAGE_MAP].memtype = UIO_MEM_LOGICAL;
 
 	pdata->recv_buf = vzalloc(RECV_BUFFER_SIZE);


