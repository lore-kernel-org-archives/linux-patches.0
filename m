Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2813F171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3E8C433D2;
	Mon, 22 May 2023 19:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785246;
	bh=EJ13Fx/DKWxbry0ap5oavVsMUnZHlbGjWxgrIBLgoko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZ1pUWl4MnAG6zJCEnO86/1vcjzNUO1nIO31dDnBqQAmr614ek2IluZSgncDOAxUa
	 CJYV3sRb8eLd2h8C8TbweTrYYBDDsERE1blEmcOVPeHDeZdywCpnHfEMLs2+CCP8Ov
	 Feu5G822VizSsveH1RwWjkzjGsuoIQpbMoPK3XGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 359/364] remoteproc: imx_dsp_rproc: Fix kernel test robot sparse warning
Date: Mon, 22 May 2023 20:11:04 +0100
Message-Id: <20230522190421.751479794@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathieu Poirier <mathieu.poirier@linaro.org>

[ Upstream commit 3c497f624d40171ebead1a6705793100d92ecb85 ]

This patch fixes the kernel test robot warning reported here:

https://lore.kernel.org/bpf/642f916b.pPIKZ%2Fl%2F%2Fbw8tvIH%25lkp@intel.com/T/

Fixes: 408ec1ff0caa ("remoteproc: imx_dsp_rproc: Add custom memory copy implementation for i.MX DSP Cores")
Link: https://lore.kernel.org/r/20230407161429.3973177-1-mathieu.poirier@linaro.org
Tested-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_dsp_rproc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/remoteproc/imx_dsp_rproc.c b/drivers/remoteproc/imx_dsp_rproc.c
index e8e23f6b85563..dcd07a6a5e945 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -727,12 +727,12 @@ static void imx_dsp_rproc_kick(struct rproc *rproc, int vqid)
  * The IRAM is part of the HiFi DSP.
  * According to hw specs only 32-bits writes are allowed.
  */
-static int imx_dsp_rproc_memcpy(void *dest, const void *src, size_t size)
+static int imx_dsp_rproc_memcpy(void *dst, const void *src, size_t size)
 {
+	void __iomem *dest = (void __iomem *)dst;
 	const u8 *src_byte = src;
 	const u32 *source = src;
 	u32 affected_mask;
-	u32 *dst = dest;
 	int i, q, r;
 	u32 tmp;
 
@@ -745,7 +745,7 @@ static int imx_dsp_rproc_memcpy(void *dest, const void *src, size_t size)
 
 	/* copy data in units of 32 bits at a time */
 	for (i = 0; i < q; i++)
-		writel(source[i], &dst[i]);
+		writel(source[i], dest + i * 4);
 
 	if (r) {
 		affected_mask = GENMASK(8 * r, 0);
@@ -776,8 +776,8 @@ static int imx_dsp_rproc_memcpy(void *dest, const void *src, size_t size)
  */
 static int imx_dsp_rproc_memset(void *addr, u8 value, size_t size)
 {
+	void __iomem *tmp_dst = (void __iomem *)addr;
 	u32 tmp_val = value;
-	u32 *tmp_dst = addr;
 	u32 affected_mask;
 	int q, r;
 	u32 tmp;
-- 
2.39.2



