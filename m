Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90B44C3A0;
	Mon,  8 Jan 2024 15:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RxErga8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7A9C433C8;
	Mon,  8 Jan 2024 15:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726907;
	bh=57FGAXk3zDXdG2gu/7e0xr3hPpVmVzAsLnWZvTzF/ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RxErga8aIwP1SjLDDZXcVJmI35CN63zGxFscVdFjWzuRd6N+bB0Q3mGAci+dv7CLm
	 80tgK3KUk2+jbu32Y1u7gUqAxpQrTFbT47HTQT4NReYe7XnfLeSW6eOmyzyYlNtPXs
	 Giv+ljQ78BllyQX4PA47B80Q53efxDfqutIJ8+pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/124] dmaengine: fsl-edma: Do not suspend and resume the masked dma channel when the system is sleeping
Date: Mon,  8 Jan 2024 16:08:33 +0100
Message-ID: <20240108150606.985032506@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit 2838a897654c4810153cc51646414ffa54fd23b0 ]

Some channels may be masked. When the system is suspended,
if these masked channels are not filtered out, this will
lead to null pointer operations and system crash:

Unable to handle kernel NULL pointer dereference at virtual address
Mem abort info:
ESR = 0x0000000096000004
EC = 0x25: DABT (current EL), IL = 32 bits
SET = 0, FnV = 0
EA = 0, S1PTW = 0
FSC = 0x04: level 0 translation fault
Data abort info:
ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
CM = 0, WnR = 0, TnD = 0, TagAccess = 0
GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=0000000894300000
[00000000000002a0] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 PID: 989 Comm: sh Tainted: G B 6.6.0-16203-g557fb7a3ec4c-dirty #70
Hardware name: Freescale i.MX8QM MEK (DT)
pstate: 400000c5 (nZcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc: fsl_edma_disable_request+0x3c/0x78
  lr: fsl_edma_disable_request+0x3c/0x78
  sp:ffff800089ae7690
  x29: ffff800089ae7690 x28: ffff000807ab5440 x27: ffff000807ab5830
  x26: 0000000000000008 x25: 0000000000000278 x24: 0000000000000001
  23: ffff000807ab4328 x22: 0000000000000000 x21: 0000000000000009
  x20: ffff800082616940 x19: 0000000000000000 x18: 0000000000000000
  x17: 3d3d3d3d3d3d3d3d x16: 3d3d3d3d3d3d3d3d x15: 3d3d3d3d3d3d3d3d
  x14: 3d3d3d3d3d3d3d3d x13: 3d3d3d3d3d3d3d3d x12: 1ffff00010d45724
  x11: ffff700010d45724 x10: dfff800000000000 x9: dfff800000000000
  x8: 00008fffef2ba8dc x7: 0000000000000001 x6: ffff800086a2b927
  x5: ffff800086a2b920 x4: ffff700010d45725 x3: ffff8000800d5bbc
  x2 : 0000000000000000 x1 : ffff000800c1d880 x0 : 0000000000000001
  Call trace:
   fsl_edma_disable_request+0x3c/0x78
   fsl_edma_suspend_late+0x128/0x12c
  dpm_run_callback+0xd4/0x304
   __device_suspend_late+0xd0/0x240
  dpm_suspend_late+0x174/0x59c
  suspend_devices_and_enter+0x194/0xd00
  pm_suspend+0x3c4/0x910

Fixes: 72f5801a4e2b ("dmaengine: fsl-edma: integrate v3 support")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Link: https://lore.kernel.org/r/20231113225713.1892643-2-xiaolei.wang@windriver.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-edma-main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/fsl-edma-main.c b/drivers/dma/fsl-edma-main.c
index 8c4ed7012e232..242a70cf85f4b 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -640,6 +640,8 @@ static int fsl_edma_suspend_late(struct device *dev)
 
 	for (i = 0; i < fsl_edma->n_chans; i++) {
 		fsl_chan = &fsl_edma->chans[i];
+		if (fsl_edma->chan_masked & BIT(i))
+			continue;
 		spin_lock_irqsave(&fsl_chan->vchan.lock, flags);
 		/* Make sure chan is idle or will force disable. */
 		if (unlikely(!fsl_chan->idle)) {
@@ -664,6 +666,8 @@ static int fsl_edma_resume_early(struct device *dev)
 
 	for (i = 0; i < fsl_edma->n_chans; i++) {
 		fsl_chan = &fsl_edma->chans[i];
+		if (fsl_edma->chan_masked & BIT(i))
+			continue;
 		fsl_chan->pm_state = RUNNING;
 		edma_write_tcdreg(fsl_chan, 0, csr);
 		if (fsl_chan->slave_id != 0)
-- 
2.43.0



