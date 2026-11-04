Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827136;
	b=nQ/7HF7+qv51PEj6MQuWDs+Bq8dv+SzvKyUZjB+++tKI9oGLtl8qWObQLnm+6qgD3Ag8
	 2/f0mPOysrCNQoSS4lQLNIAZpacel5HzKfCfSFsUElsG6A/H9e+2H45YkmzAjjWtKPFZf
	 DBwmQ0N/R2flHv5DRlkTIvbSwuT69rYTOHtKib6wBEu+P3sb+iNfnLZpmTHRKckNsyb/D
	 Zm6lrYWffkrbVtWLFFG7NEHBFZ089xqcCQkNG9FKo7V4dRdknL4xN4f7Swvxu0HDfk6Ef
	 qFjvlg7z/aZnjUZx6JvWZHWdD8sBK5Mi4CRyRm2NWoLoZBcvCjZyTa3BqHma9Sw3Vsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GIoNT6mVO+d+pHB2BJpHimM6pAB2MRbnCyFa4ZbE9Y0=;
	b=szAsTDLKJ9d7XQEV5pbwvq0X51Ppr4aq754NKdoMdvm3YGJfxIwalf03cKGMThQxZJfv
	 aRw63pLlGdzAfPplGavDyEevpIfLHuz3OrP4IPs42EsbCeV609nzWk3JkrJKd0xX1vhLa
	 islV6+JvrJBk47GKpefTYigGQTrHlIpkcHyXK0OQM7KUDZ5yQxu2v9zSiToIKrXA12YID
	 xLjXn/yjSoqLYtM4Lf0BbMueWglEq8/Wik6RQY24E1eIqkFuXozY2bq2gO41QznT0OCqO
	 NkRnA1SHZPZPKVktAiiIx8m3YH1TSeBSA0fUBF9A+2oUzn2pYQDh6Mu9h0vNbKojk7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GIvkp5xB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BB0606A334;
	Wed,  4 Nov 2026 21:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GIvkp5xB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3F11F000C1;
	Wed,  4 Nov 2026 21:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827135;
	bh=GIoNT6mVO+d+pHB2BJpHimM6pAB2MRbnCyFa4ZbE9Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GIvkp5xB5BnglbQWgMN06JLvMAxmP6E/WmxR3Bla/T+d/Eo1PgIgc5abQQC82tDYf
	 BEtxE/h5RZ9wMaipEs2sNrQpocBxcfZy4VHw01Xn0G99ms7qeAc44wH3j4/ORhfhs3
	 WS1ZqGu1iXFL0ywMdeGOZif/ULL/LNU/vQX63Ne4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.3 208/547] ASoC: amd: ps: fix snd_acp63_remove() teardown ordering
Date: Wed,  4 Nov 2026 16:06:32 -0500
Message-ID: <20261104211044.054612703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit c53791d673ed4da6759d276078627ec4d0c6536b upstream.

The ACP IRQ handlers dereference the SoundWire, SoundWire DMA, and PDM
child platform devices, but snd_acp63_remove() unregisters them while
the interrupt is still held by devres, which frees it only after remove
returns. An interrupt in this window is a use-after-free.

Mask the ACP interrupt sources and call devm_free_irq() before the
first child device is unregistered. The masking goes through the new
acp_hw_ops->disable_interrupts callback, keeping the remove path
platform-agnostic. The interrupt line is shared, and acp_hw_deinit()
clears the sources only after the children are gone, which would
leave the line raised with no handler left to ack it. The window
predates the tagged refactor, which only reshaped the dereferences.

devm_free_irq() waits for in-flight handlers, but not for work the
hardirq has already queued: acp63_irq_handler() schedules
amd_sdw_irq_thread on the SoundWire manager. Draining that work in
the manager's remove path is a soundwire-side change and follows
separately.

This issue was found by an in-house static analysis tool.

Fixes: eaf825037d6d ("ASoC: amd: ps: refactor acp child platform device creation code")
Cc: stable@vger.kernel.org
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260929061349.3879-1-fanwu01@zju.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/ps/acp63.h     |    8 ++++++++
 sound/soc/amd/ps/pci-ps.c    |    2 ++
 sound/soc/amd/ps/ps-common.c |    2 ++
 3 files changed, 12 insertions(+)

--- a/sound/soc/amd/ps/acp63.h
+++ b/sound/soc/amd/ps/acp63.h
@@ -294,6 +294,7 @@ struct acp63_dev_data;
  * struct acp_hw_ops - ACP PCI driver platform specific ops
  * @acp_init: ACP initialization
  * @acp_deinit: ACP de-initialization
+ * @disable_interrupts: disable ACP interrupt sources
  * @acp_get_config: function to read the acp pin configuration
  * @acp_sdw_dma_irq_thread: ACP SoundWire DMA interrupt thread
  * acp_suspend: ACP system level suspend callback
@@ -304,6 +305,7 @@ struct acp63_dev_data;
 struct acp_hw_ops {
 	int (*acp_init)(void __iomem *acp_base, struct device *dev);
 	int (*acp_deinit)(void __iomem *acp_base, struct device *dev);
+	void (*disable_interrupts)(void __iomem *acp_base);
 	void (*acp_get_config)(struct pci_dev *pci, struct acp63_dev_data *acp_data);
 	void (*acp_sdw_dma_irq_thread)(struct acp63_dev_data *acp_data);
 	int (*acp_suspend)(struct device *dev);
@@ -397,6 +399,12 @@ static inline int acp_hw_deinit(struct a
 	return -EOPNOTSUPP;
 }
 
+static inline void acp_hw_disable_interrupts(struct acp63_dev_data *adata)
+{
+	if (adata && adata->hw_ops && adata->hw_ops->disable_interrupts)
+		ACP_HW_OPS(adata, disable_interrupts)(adata->acp63_base);
+}
+
 static inline void acp_hw_get_config(struct pci_dev *pci, struct acp63_dev_data *adata)
 {
 	if (adata && adata->hw_ops && adata->hw_ops->acp_get_config)
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -738,6 +738,8 @@ static void snd_acp63_remove(struct pci_
 	int ret;
 
 	adata = pci_get_drvdata(pci);
+	acp_hw_disable_interrupts(adata);
+	devm_free_irq(&pci->dev, pci->irq, adata);
 	if (adata->sdw) {
 		amd_sdw_exit(adata);
 		platform_device_unregister(adata->sdw_dma_dev);
--- a/sound/soc/amd/ps/ps-common.c
+++ b/sound/soc/amd/ps/ps-common.c
@@ -248,6 +248,7 @@ void acp63_hw_init_ops(struct acp_hw_ops
 {
 	hw_ops->acp_init = acp63_init;
 	hw_ops->acp_deinit = acp63_deinit;
+	hw_ops->disable_interrupts = acp63_disable_interrupts;
 	hw_ops->acp_get_config = acp63_get_config;
 	hw_ops->acp_sdw_dma_irq_thread = acp63_sdw_dma_irq_thread;
 	hw_ops->acp_suspend = snd_acp63_suspend;
@@ -484,6 +485,7 @@ void acp70_hw_init_ops(struct acp_hw_ops
 {
 	hw_ops->acp_init = acp70_init;
 	hw_ops->acp_deinit = acp70_deinit;
+	hw_ops->disable_interrupts = acp70_disable_interrupts;
 	hw_ops->acp_get_config = acp70_get_config;
 	hw_ops->acp_sdw_dma_irq_thread = acp70_sdw_dma_irq_thread;
 	hw_ops->acp_suspend = snd_acp70_suspend;


