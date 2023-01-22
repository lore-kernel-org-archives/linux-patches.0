Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C172590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA37C433D2;
	Sun, 22 Jan 2023 15:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401133;
	bh=UDmxb29nCKHSuDtAKTDZk4lsaZeg4DFpzrigXWJCUy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Il6ZwgnY/QCUDrSXVxpv/hVjzBFeLYC1THbE6yPh5h1XOvsvsSx2lbu4+Z+Y4RmUd
	 GJ9y7cra4hcbN+nTu/lgTCjbFuEH62QCrqoDPoBO7c8nJ1YWfaeHWT8WgWo2tsKJqR
	 eviMQ9iSw9Q6GLCOkDh10T/llabEoJuEGoRMx3xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 122/193] dmaengine: idxd: Let probe fail when workqueue cannot be enabled
Date: Sun, 22 Jan 2023 16:04:11 +0100
Message-Id: <20230122150251.906874432@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Reinette Chatre <reinette.chatre@intel.com>

commit b51b75f0604f17c0f6f3b6f68f1a521a5cc6b04f upstream.

The workqueue is enabled when the appropriate driver is loaded and
disabled when the driver is removed. When the driver is removed it
assumes that the workqueue was enabled successfully and proceeds to
free allocations made during workqueue enabling.

Failure during workqueue enabling does not prevent the driver from
being loaded. This is because the error path within drv_enable_wq()
returns success unless a second failure is encountered
during the error path. By returning success it is possible to load
the driver even if the workqueue cannot be enabled and
allocations that do not exist are attempted to be freed during
driver remove.

Some examples of problematic flows:
(a)

 idxd_dmaengine_drv_probe() -> drv_enable_wq() -> idxd_wq_request_irq():
 In above flow, if idxd_wq_request_irq() fails then
 idxd_wq_unmap_portal() is called on error exit path, but
 drv_enable_wq() returns 0 because idxd_wq_disable() succeeds. The
 driver is thus loaded successfully.

 idxd_dmaengine_drv_remove()->drv_disable_wq()->idxd_wq_unmap_portal()
 Above flow on driver unload triggers the WARN in devm_iounmap() because
 the device resource has already been removed during error path of
 drv_enable_wq().

(b)

 idxd_dmaengine_drv_probe() -> drv_enable_wq() -> idxd_wq_request_irq():
 In above flow, if idxd_wq_request_irq() fails then
 idxd_wq_init_percpu_ref() is never called to initialize the percpu
 counter, yet the driver loads successfully because drv_enable_wq()
 returns 0.

 idxd_dmaengine_drv_remove()->__idxd_wq_quiesce()->percpu_ref_kill():
 Above flow on driver unload triggers a BUG when attempting to drop the
 initial ref of the uninitialized percpu ref:
 BUG: kernel NULL pointer dereference, address: 0000000000000010

Fix the drv_enable_wq() error path by returning the original error that
indicates failure of workqueue enabling. This ensures that the probe
fails when an error is encountered and the driver remove paths are only
attempted when the workqueue was enabled successfully.

Fixes: 1f2bb40337f0 ("dmaengine: idxd: move wq_enable() to device.c")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/e8d8116e5efa0fd14fadc5adae6ffd319f0e5ff1.1670452419.git.reinette.chatre@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/device.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -1391,8 +1391,7 @@ err_res_alloc:
 err_irq:
 	idxd_wq_unmap_portal(wq);
 err_map_portal:
-	rc = idxd_wq_disable(wq, false);
-	if (rc < 0)
+	if (idxd_wq_disable(wq, false))
 		dev_dbg(dev, "wq %s disable failed\n", dev_name(wq_confdev(wq)));
 err:
 	return rc;


