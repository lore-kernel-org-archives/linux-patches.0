Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590569;
	b=LaTRnmgdqOn2iO3qoQRCplJdvotQXuDMuJyBVpy0tXbfXcRL/gJwQRztxC6s0dwVzrUj
	 3bdu3WoZ9rb5yvr+yxnouNWPaxn2zIYvIgZufdP586ofwrWGaNbw4vqX0eSjlm6txrDnp
	 QgALZ+baKYpbkbPKlb1383nJSohegf3Zc7ooHAhLrGBzR5QBvqiPdUp+nBsiQtfu01dEc
	 UZSPNH3wkHfa0UoZFOqAgNs//2tsRhnWFBcdJax/XISI9pZ5OMiuy80TyV0UXS6Z8wLUN
	 vDgl5WeLmbw0wk9UCcFKnLWnqWBs8WyfoYd/G+uPO4kpXNlCEK8/rtK4Gfg4cxWO/gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LM+eGHA1ZkGJyIY2jKzschI8jXpv/31Jeir3ZR5Bt3I=;
	b=tbJjSAe/8CtEtzhvXkL0Xu3SxQ08+QVHK/kgwL/C+yAiLAczuRfLzQLbxh31TUDrJesv
	 RsYR2ON3s+IbZM7H3/hyyRF5z9ZEHMyGf4kKL4qbR3EfpliLS38r7VqZn4A0tb12FOGb8
	 6u6eKh620nOVYUluVqQQsFkVvodV0V5+O1D4UaMQWVDdXXGo8e580S3+nd+7W6Y+UK7Vq
	 bG9R6+hzZ2OrGQzbqzgmOkeQxAJ6HWJAPw0jGEj3PJkQLI6ASS2ACDMaL0tT2EBU215rf
	 rZ+mKQ25RBtyvaO3qH8S1X2sJGLOyOZjGLEnDeWFX++gtTipX6bpp/WuV5KMds29XEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jABE7diQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715BF606BD1A;
	Fri, 13 Nov 2026 17:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jABE7diQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0745D1F000C7;
	Fri, 13 Nov 2026 17:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590569;
	bh=LM+eGHA1ZkGJyIY2jKzschI8jXpv/31Jeir3ZR5Bt3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jABE7diQ+DLnH60Ahn9gI4pFtqZhfXB2RK3M5KFQvZQHuyyilVo/HG0+/62KPuYHm
	 TagRR18kxR0mGzWx1sTe0ANB98bdi6ZNUE0jn2Gsr+pwpYeWIHklH97wqvaxWbI60T
	 L09CATTQR1UV5bgLoYwWVit38I4qk8iXBpXsgRlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 502/686] media: iris: Fix iova allocation from restrict region
Date: Fri, 13 Nov 2026 10:50:35 -0500
Message-ID: <20261113153837.920458787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>

[ Upstream commit 200473c198b201c308dfb916fb3233074d9407fa ]

The VPU issues DMA through several SMMU streams, and the hardware does
not give every stream the same addressable range. The non-pixel stream
cannot address the low 600MB of IOVA space, while the pixel stream can
address the full range:
    +-----------------------------------------------------------+
    | non-pixel stream addressable range (600 MB - 3.5 GB)      |
    | 0x25800000 - 0xe0000000                                   |
    +-----------------------------------------------------------+
    | pixel stream addressable range (0 - 3.5 GB)               |
    | 0x00000000 - 0xe0000000                                   |
    +-----------------------------------------------------------+

A single "iommus" property on the video-codec node puts every stream
in one IOMMU domain sharing one IOVA space, so nothing stops a
non-pixel buffer from landing below 600MB. Once an allocation lands
below that boundary the hardware faults, which shows up as unhandled
SMMU page faults and spontaneous reboots.
https://gitlab.freedesktop.org/drm/msm/-/work_items/100

Fix this by reserving the 0-600MB range, below the boundary the
non-pixel stream cannot address, using dma_iova_try_alloc() so the
IOMMU-DMA core never hands that range out to a real DMA mapping. This
reserves only IOVA space, it does not allocate any physical memory.

Since sub-nodes for non-pixel, pixel, and secure streams do not exist
yet and only a single device is available, the restriction is applied
to both non-pixel and pixel stream IDs.

Fixes: d7378f84e94e ("media: iris: introduce iris core state management with shared queues")
Cc: stable@vger.kernel.org
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
[ sashal: Adjusted iris_probe() context to retain iris_session_init_caps(core) immediately before the IOVA reservation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_core.h  |  6 ++
 drivers/media/platform/qcom/iris/iris_probe.c | 62 ++++++++++++++++++-
 2 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_core.h b/drivers/media/platform/qcom/iris/iris_core.h
index fb194c967ad4f..530fe14c3a477 100644
--- a/drivers/media/platform/qcom/iris/iris_core.h
+++ b/drivers/media/platform/qcom/iris/iris_core.h
@@ -7,6 +7,7 @@
 #define __IRIS_CORE_H__
 
 #include <linux/types.h>
+#include <linux/dma-mapping.h>
 #include <linux/pm_domain.h>
 #include <media/v4l2-device.h>
 
@@ -25,6 +26,9 @@ struct icc_info {
 #define IRIS_FW_VERSION_LENGTH		128
 #define IFACEQ_CORE_PKT_SIZE		(1024 * 4)
 
+#define IRIS_NP_RESERVE_IOVA_START	0x0
+#define IRIS_NP_RESERVE_IOVA_SIZE	0x25800000
+
 enum domain_type {
 	ENCODER	= BIT(0),
 	DECODER	= BIT(1),
@@ -73,6 +77,7 @@ enum domain_type {
  * @instances: a list_head of all instances
  * @inst_fw_caps_dec: an array of supported instance capabilities by decoder
  * @inst_fw_caps_enc: an array of supported instance capabilities by encoder
+ * @iova_state: a pointer to an array of dma_iova_state entries reserved for restricted IOVA region
  */
 
 struct iris_core {
@@ -117,6 +122,7 @@ struct iris_core {
 	/* encoder and decoder have overlapping caps, so two different arrays are required */
 	struct platform_inst_fw_cap		inst_fw_caps_dec[INST_FW_CAP_MAX];
 	struct platform_inst_fw_cap		inst_fw_caps_enc[INST_FW_CAP_MAX];
+	struct dma_iova_state			*iova_state;
 };
 
 int iris_core_init(struct iris_core *core);
diff --git a/drivers/media/platform/qcom/iris/iris_probe.c b/drivers/media/platform/qcom/iris/iris_probe.c
index cdeb78ba605ae..b6251493bd9cc 100644
--- a/drivers/media/platform/qcom/iris/iris_probe.c
+++ b/drivers/media/platform/qcom/iris/iris_probe.c
@@ -153,6 +153,57 @@ static int iris_init_resources(struct iris_core *core)
 	return iris_init_resets(core);
 }
 
+static void iris_unreserve_iova_region(struct device *dev, struct dma_iova_state *iova_state)
+{
+	unsigned int i;
+
+	for (i = 0; dma_iova_size(&iova_state[i]); i++)
+		dma_iova_free(dev, &iova_state[i]);
+}
+
+static int iris_reserve_iova_region(struct device *dev, struct dma_iova_state **iova_state,
+				    unsigned long start, unsigned long size)
+{
+	unsigned long dma_limit = dev->bus_dma_limit;
+	unsigned long end, rem, chunk;
+	struct dma_iova_state *state;
+	unsigned int count = 0;
+	int ret = -ENOMEM;
+
+	state = devm_kcalloc(dev, BITS_PER_TYPE(dma_addr_t) + 1, sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return ret;
+
+	end = start + size;
+	rem = end - max(start, PAGE_SIZE);
+	dev->bus_dma_limit = end - 1;
+
+	while (rem) {
+		chunk = min(end & -end, (u64)1 << (fls64(rem) - 1));
+
+		if (!dma_iova_try_alloc(dev, &state[count], 0, chunk))
+			goto err_free_iova;
+
+		if (state[count].addr != end - chunk || state[count].__size != chunk)
+			goto err_free_iova;
+
+		rem -= chunk;
+		end -= chunk;
+		count++;
+	}
+
+	*iova_state = state;
+	dev->bus_dma_limit = dma_limit;
+
+	return 0;
+
+err_free_iova:
+	iris_unreserve_iova_region(dev, state);
+	dev->bus_dma_limit = dma_limit;
+
+	return ret;
+}
+
 static int iris_register_video_device(struct iris_core *core, enum domain_type type)
 {
 	struct video_device *vdev;
@@ -210,6 +261,8 @@ static void iris_remove(struct platform_device *pdev)
 
 	v4l2_device_unregister(&core->v4l2_dev);
 
+	iris_unreserve_iova_region(core->dev, core->iova_state);
+
 	mutex_destroy(&core->lock);
 }
 
@@ -272,10 +325,15 @@ static int iris_probe(struct platform_device *pdev)
 
 	iris_session_init_caps(core);
 
-	ret = v4l2_device_register(dev, &core->v4l2_dev);
+	ret = iris_reserve_iova_region(dev, &core->iova_state, IRIS_NP_RESERVE_IOVA_START,
+				       IRIS_NP_RESERVE_IOVA_SIZE);
 	if (ret)
 		return ret;
 
+	ret = v4l2_device_register(dev, &core->v4l2_dev);
+	if (ret)
+		goto err_unresv_iova_region;
+
 	ret = iris_register_video_device(core, DECODER);
 	if (ret)
 		goto err_v4l2_unreg;
@@ -309,6 +367,8 @@ static int iris_probe(struct platform_device *pdev)
 	video_unregister_device(core->vdev_dec);
 err_v4l2_unreg:
 	v4l2_device_unregister(&core->v4l2_dev);
+err_unresv_iova_region:
+	iris_unreserve_iova_region(dev, core->iova_state);
 
 	return ret;
 }
-- 
2.53.0



