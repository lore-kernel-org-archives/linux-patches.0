Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591604;
	b=YY8JHb92IbxazB3aS4vZyzJt47P1BKH7v78iAX1ZuZ7qqJzS/mp3p+7FxyXt0ZUNKSLk
	 B3oII50p9UxzXfjAQhFAPuD9WNKxl4mLBEYuHPUXpPeAJQF0jmEafd7GeyTGbBDZ5irfo
	 5t5Jib6VlwAO5Z+iBrNITZqW4r21Zc5dMWlppP0Q0P5WhGekR/8RzG0AA5siNb/zc5hNX
	 OhS+D/xqIRZOBZq2tb0HQi/zJFiwzQvmWXBpX7ZCsM+OzNuTc+2IPX8BxDzhrhbtiesJ9
	 u/PIoMGYB0ZAkPUAKZgy2y2+uIU/wa49yUJdU4O5jZS4yQa7u+OUOuDPl0tF7lS0FCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D/Y0tU54QMdrH+tJdnciEO/iJujmKJyFAQWx1G85bFo=;
	b=GxHGLRg7xkvJGNgIgp053NhMPF7AUMbvfWMMgZuo8BcjjJusw+XZK5iYh3AzWHkuqkyY
	 ttArYg4r/uviXugOsuRptaHkJbiqV1qymOTi0KJSXl05xXB055HYA1/Ahb5LrBBye4/VH
	 0TiV8IrnYD31Q4KAGgKn2IPAE+aTARyXsvy0xmel+Py2TTl6U23BA6tRU0BHD/r/aA91S
	 3DyliuXRmsiWG6mHg1XUqlKlQ1E3pBfMdba3UaYODeAJ66nNWjic6LNN2HpKcHeH0iet7
	 fbtG0PvJg7bSAciZLNOa7j9iyMqqEpxjv73D9PtctJslPUWkzlTWT9UX7zeRjoYCiuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CFLDR0bl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAF2606B449;
	Fri, 13 Nov 2026 17:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CFLDR0bl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2683E1F000C4;
	Fri, 13 Nov 2026 17:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591604;
	bh=D/Y0tU54QMdrH+tJdnciEO/iJujmKJyFAQWx1G85bFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CFLDR0bllxLN6qI2Hh9lSG8BrTwceMGmDkds0HMBPdDK56hgSSRWmDGdhpDll6MaK
	 QY6ssr11c1T/3cqig4Yco+KKDHPByr5T+U+RsykfibfqGKhgVKISWVhLaaSBGwNc3o
	 ZHGN9ExmL+zoQrxQ/hi4CCYggWyFGiaG6QKfveOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 645/670] media: ipu6: Fix firmware config leak on stream start
Date: Fri, 13 Nov 2026 10:53:29 -0500
Message-ID: <20261113153833.663288209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit d3d9bc694fe087c672c3ad5871984dc45cd9f425 ]

ipu6_isys_fwcom_cfg_init() runs on every first stream start and allocates
the firmware config and queue configs with devm, so each STREAMON/STREAMOFF
cycle leaks them. They are only needed until ipu6_fw_com_prepare() has
copied them, so free them right after. Also check the return value, an
allocation failure would otherwise make ipu6_fw_com_prepare() dereference
a NULL queue config.

Fixes: f625e8d7ffc1 ("media: intel/ipu6: input system ABI between firmware and driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
[ sashal: Adapted fwcom_cfg and isys->fwctx to existing fwcom and isys->fwcom names with cleanup inlined in the caller. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu6/ipu6-fw-isys.c | 29 ++++++++++++++-------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/intel/ipu6/ipu6-fw-isys.c b/drivers/media/pci/intel/ipu6/ipu6-fw-isys.c
index 62ed92ff1d303..51d02649d7a74 100644
--- a/drivers/media/pci/intel/ipu6/ipu6-fw-isys.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-fw-isys.c
@@ -218,7 +218,6 @@ static int ipu6_isys_fwcom_cfg_init(struct ipu6_isys *isys,
 	unsigned int max_send_queues, max_sram_blocks, max_devq_size;
 	struct ipu6_fw_syscom_queue_config *input_queue_cfg;
 	struct ipu6_fw_syscom_queue_config *output_queue_cfg;
-	struct device *dev = &isys->adev->auxdev.dev;
 	int type_proxy = IPU6_FW_ISYS_QUEUE_TYPE_PROXY;
 	int type_dev = IPU6_FW_ISYS_QUEUE_TYPE_DEV;
 	int type_msg = IPU6_FW_ISYS_QUEUE_TYPE_MSG;
@@ -228,7 +227,6 @@ static int ipu6_isys_fwcom_cfg_init(struct ipu6_isys *isys,
 	struct ipu6_fw_isys_fw_config *isys_fw_cfg;
 	u32 num_in_message_queues;
 	unsigned int max_streams;
-	unsigned int size;
 	unsigned int i;
 
 	max_streams = isys->pdata->ipdata->max_streams;
@@ -236,7 +234,7 @@ static int ipu6_isys_fwcom_cfg_init(struct ipu6_isys *isys,
 	max_sram_blocks = isys->pdata->ipdata->max_sram_blocks;
 	max_devq_size = isys->pdata->ipdata->max_devq_size;
 	num_in_message_queues = clamp(num_streams, 1U, max_streams);
-	isys_fw_cfg = devm_kzalloc(dev, sizeof(*isys_fw_cfg), GFP_KERNEL);
+	isys_fw_cfg = kzalloc_obj(*isys_fw_cfg);
 	if (!isys_fw_cfg)
 		return -ENOMEM;
 
@@ -248,15 +246,14 @@ static int ipu6_isys_fwcom_cfg_init(struct ipu6_isys *isys,
 	isys_fw_cfg->num_recv_queues[type_dev] = 0;
 	isys_fw_cfg->num_recv_queues[type_msg] = 1;
 
-	size = sizeof(*input_queue_cfg) * max_send_queues;
-	input_queue_cfg = devm_kzalloc(dev, size, GFP_KERNEL);
+	input_queue_cfg = kzalloc_objs(*input_queue_cfg, max_send_queues);
 	if (!input_queue_cfg)
-		return -ENOMEM;
+		goto err_free_fw_cfg;
 
-	size = sizeof(*output_queue_cfg) * IPU6_N_MAX_RECV_QUEUES;
-	output_queue_cfg = devm_kzalloc(dev, size, GFP_KERNEL);
+	output_queue_cfg = kzalloc_objs(*output_queue_cfg,
+					IPU6_N_MAX_RECV_QUEUES);
 	if (!output_queue_cfg)
-		return -ENOMEM;
+		goto err_free_input_queue_cfg;
 
 	fwcom->input = input_queue_cfg;
 	fwcom->output = output_queue_cfg;
@@ -319,6 +316,13 @@ static int ipu6_isys_fwcom_cfg_init(struct ipu6_isys *isys,
 	fwcom->specific_size = sizeof(*isys_fw_cfg);
 
 	return 0;
+
+err_free_input_queue_cfg:
+	kfree(input_queue_cfg);
+err_free_fw_cfg:
+	kfree(isys_fw_cfg);
+
+	return -ENOMEM;
 }
 
 int ipu6_fw_isys_init(struct ipu6_isys *isys, unsigned int num_streams)
@@ -332,10 +336,15 @@ int ipu6_fw_isys_init(struct ipu6_isys *isys, unsigned int num_streams)
 	};
 	int ret;
 
-	ipu6_isys_fwcom_cfg_init(isys, &fwcom, num_streams);
+	ret = ipu6_isys_fwcom_cfg_init(isys, &fwcom, num_streams);
+	if (ret)
+		return ret;
 
 	isys->fwcom = ipu6_fw_com_prepare(&fwcom, isys->adev,
 					  isys->pdata->base);
+	kfree(fwcom.specific_addr);
+	kfree(fwcom.output);
+	kfree(fwcom.input);
 	if (!isys->fwcom) {
 		dev_err(dev, "isys fw com prepare failed\n");
 		return -EIO;
-- 
2.53.0



