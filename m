Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798571F7580;
	Mon, 23 Jun 2025 22:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716830; cv=none; b=BQmxkm3fCW61X+3VPw1jd3Tv1gW4oNIEBTCradD0PIT8x1X4kSKO9b6c8qgSptv0tLAInsPdZFtIrZM83YfBIM4TskHWSUt0OtT/3MZf3OwZ+GvG2V7JOckP6tytoDRt3kBqO4iL9YYBzPIXFrJFRK1ZC4AQ1m8hFERGaktNZwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716830; c=relaxed/simple;
	bh=LJCJTacA7TYWapd1/uk6+iLDP9HNq95QTDMTKn0HfyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2fS0DUrbmO/j22I+F2KuORbSaDuRFf4O25CEhMHVaPk/PLif+YJZzM7E9RBFEN589643IUp3l8feRkA+P3tRv6RTvIgfk+vM4FGRMOfzcCcUZv71gSZcnGLHhP0S2IU67UQQ4d79a+Ktin95c6uG9UCTNe0hIyubJxWFl0IJIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ce7e/Zan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ce7e/Zan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114E3C4CEEA;
	Mon, 23 Jun 2025 22:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716830;
	bh=LJCJTacA7TYWapd1/uk6+iLDP9HNq95QTDMTKn0HfyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ce7e/ZantNpNGbrYH1aQ9imQcJWDNxl8SeIY15T8yEaPt9ib60UO1ZIQRbsdKwJvQ
	 cQC41lo5rCUjmv16rwLSx9lDCgtidgF59+VC7tFa1E4RGw8HMPjJobCMWupUGdRPN7
	 OgywPusk9d4lMmBqhFnpT+ufU2fuH11AT3bZHZ3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 6.1 363/508] remoteproc: core: Cleanup acquired resources when rproc_handle_resources() fails in rproc_attach()
Date: Mon, 23 Jun 2025 15:06:48 +0200
Message-ID: <20250623130654.292796011@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

commit 7692c9fbedd9087dc9050903f58095915458d9b1 upstream.

When rproc->state = RPROC_DETACHED and rproc_attach() is used
to attach to the remote processor, if rproc_handle_resources()
returns a failure, the resources allocated by imx_rproc_prepare()
should be released, otherwise the following memory leak will occur.

Since almost the same thing is done in imx_rproc_prepare() and
rproc_resource_cleanup(), Function rproc_resource_cleanup() is able
to deal with empty lists so it is better to fix the "goto" statements
in rproc_attach(). replace the "unprepare_device" goto statement with
"clean_up_resources" and get rid of the "unprepare_device" label.

unreferenced object 0xffff0000861c5d00 (size 128):
comm "kworker/u12:3", pid 59, jiffies 4294893509 (age 149.220s)
hex dump (first 32 bytes):
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
00 00 02 88 00 00 00 00 00 00 10 00 00 00 00 00 ............
backtrace:
 [<00000000f949fe18>] slab_post_alloc_hook+0x98/0x37c
 [<00000000adbfb3e7>] __kmem_cache_alloc_node+0x138/0x2e0
 [<00000000521c0345>] kmalloc_trace+0x40/0x158
 [<000000004e330a49>] rproc_mem_entry_init+0x60/0xf8
 [<000000002815755e>] imx_rproc_prepare+0xe0/0x180
 [<0000000003f61b4e>] rproc_boot+0x2ec/0x528
 [<00000000e7e994ac>] rproc_add+0x124/0x17c
 [<0000000048594076>] imx_rproc_probe+0x4ec/0x5d4
 [<00000000efc298a1>] platform_probe+0x68/0xd8
 [<00000000110be6fe>] really_probe+0x110/0x27c
 [<00000000e245c0ae>] __driver_probe_device+0x78/0x12c
 [<00000000f61f6f5e>] driver_probe_device+0x3c/0x118
 [<00000000a7874938>] __device_attach_driver+0xb8/0xf8
 [<0000000065319e69>] bus_for_each_drv+0x84/0xe4
 [<00000000db3eb243>] __device_attach+0xfc/0x18c
 [<0000000072e4e1a4>] device_initial_probe+0x14/0x20

Fixes: 10a3d4079eae ("remoteproc: imx_rproc: move memory parsing to rproc_ops")
Suggested-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250430092043.1819308-2-xiaolei.wang@windriver.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/remoteproc_core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1615,7 +1615,7 @@ static int rproc_attach(struct rproc *rp
 	ret = rproc_set_rsc_table(rproc);
 	if (ret) {
 		dev_err(dev, "can't load resource table: %d\n", ret);
-		goto unprepare_device;
+		goto clean_up_resources;
 	}
 
 	/* reset max_notifyid */
@@ -1632,7 +1632,7 @@ static int rproc_attach(struct rproc *rp
 	ret = rproc_handle_resources(rproc, rproc_loading_handlers);
 	if (ret) {
 		dev_err(dev, "Failed to process resources: %d\n", ret);
-		goto unprepare_device;
+		goto clean_up_resources;
 	}
 
 	/* Allocate carveout resources associated to rproc */
@@ -1651,7 +1651,6 @@ static int rproc_attach(struct rproc *rp
 
 clean_up_resources:
 	rproc_resource_cleanup(rproc);
-unprepare_device:
 	/* release HW resources if needed */
 	rproc_unprepare_device(rproc);
 disable_iommu:


