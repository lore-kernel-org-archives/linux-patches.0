Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E36724B34;
	Tue, 25 Jun 2024 09:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309151; cv=none; b=latNmL2JFOl2cy5qZfVfWg9mLyRxTNupqXmpDG15VFwdHVjpitzKrDssdFeJdIy17Dw5goE8HN+wBl+3R9LGeqanlJ+FAPnn+GWtfROQPO37FLKWMKKwG6Inam6oFF4AFW0zDFWY152YjU/tz5gC/mxcbycaYm/Gd4nVbCIAbrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309151; c=relaxed/simple;
	bh=hK4aErf32Xdypy/tpmSxVmCAI0gugfzWu9nZu8dqdsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgF7GApU9ZkZTZ3L7OY90eUHTNeAbx60VQ5vIjMMr5HSh+LlPFCHow4rYvf6eeuRo2CxSbYNmbYqjaLgXxqs58Y7e5ZTexxRALUqBBs8eBSszPl7VYwni6EHDA9iB/3GRpuLQm8Hl2HZIhRyw6XV7DdOV1+N6LOAcCp/eZiW0Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Evwpdgkz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Evwpdgkz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D3AC32781;
	Tue, 25 Jun 2024 09:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309151;
	bh=hK4aErf32Xdypy/tpmSxVmCAI0gugfzWu9nZu8dqdsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvwpdgkzzVMG9DE0ZeqWS450vCeXgYaJmruonUyiovFRUdjFIBpt73coUgdl0KL9E
	 tBoeGukgHCGXNzs0o3eBCt+/bbi8+BeQ6d3TFdgJi436VjhTKoQ7BprUhW5cFM+Fd7
	 OQynJvAzeXmSvwwsKqDzr9iV2edeh0ooE8IZ8neY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/192] dmaengine: ioatdma: Fix kmemleak in ioat_pci_probe()
Date: Tue, 25 Jun 2024 11:33:03 +0200
Message-ID: <20240625085541.432687045@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Nikita Shubin <n.shubin@yadro.com>

[ Upstream commit 29b7cd255f3628e0d65be33a939d8b5bba10aa62 ]

If probing fails we end up with leaking ioatdma_device and each
allocated channel.

Following kmemleak easy to reproduce by injecting an error in
ioat_alloc_chan_resources() when doing ioat_dma_self_test().

unreferenced object 0xffff888014ad5800 (size 1024): [..]
    [<ffffffff827692ca>] kmemleak_alloc+0x4a/0x80
    [<ffffffff81430600>] kmalloc_trace+0x270/0x2f0
    [<ffffffffa000b7d1>] ioat_pci_probe+0xc1/0x1c0 [ioatdma]
[..]

repeated for each ioatdma channel:

unreferenced object 0xffff8880148e5c00 (size 512): [..]
    [<ffffffff827692ca>] kmemleak_alloc+0x4a/0x80
    [<ffffffff81430600>] kmalloc_trace+0x270/0x2f0
    [<ffffffffa0009641>] ioat_enumerate_channels+0x101/0x2d0 [ioatdma]
    [<ffffffffa000b266>] ioat3_dma_probe+0x4d6/0x970 [ioatdma]
    [<ffffffffa000b891>] ioat_pci_probe+0x181/0x1c0 [ioatdma]
[..]

Fixes: bf453a0a18b2 ("dmaengine: ioat: Support in-use unbind")
Signed-off-by: Nikita Shubin <n.shubin@yadro.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20240528-ioatdma-fixes-v2-3-a9f2fbe26ab1@yadro.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index 26964b7c8cf14..cf688b0c8444c 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -1347,6 +1347,7 @@ static int ioat_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	void __iomem * const *iomap;
 	struct device *dev = &pdev->dev;
 	struct ioatdma_device *device;
+	unsigned int i;
 	u8 version;
 	int err;
 
@@ -1384,6 +1385,9 @@ static int ioat_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	err = ioat3_dma_probe(device, ioat_dca_enabled);
 	if (err) {
+		for (i = 0; i < IOAT_MAX_CHANS; i++)
+			kfree(device->idx[i]);
+		kfree(device);
 		dev_err(dev, "Intel(R) I/OAT DMA Engine init failed\n");
 		return -ENODEV;
 	}
-- 
2.43.0



