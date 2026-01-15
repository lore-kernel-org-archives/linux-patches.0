Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5938C394487;
	Thu, 15 Jan 2026 16:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496182; cv=none; b=hbo0n9+naj1NwJcRiWiUdZMgKdPRGUZQfFIxqNIx65UHoMAkVP8pjOR5wPlpTtnbPBEE14F5cRsHkmj7C98wypzconb2aGVN6Jv7mJ5tvc85/RT0NeAdhwNH/Rn/IalK5PHX44FU77ek13ZTCHKwXMJ9+Pyz6zUp6l8x6ezX4bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496182; c=relaxed/simple;
	bh=WQdL9SjsMGvVqpQaOCGEC+UHc5zg/EH0KTOkawcnI5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEST/3uTXyvdPsY42XjazEw3312IOTYkAwAmfQXyty6giR6TvsXxUdT7acGomlFbqm63geMGPP3iicFHPXCQA/NQtoS45sHTKqNFQhXhQCxYgTtnQZSDlJacObw4S6N8+QPhHd81SH2y9L9kFYtsxYbOsGPUiU7oUtVJU0wQQjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/v68POQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/v68POQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98508C116D0;
	Thu, 15 Jan 2026 16:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496182;
	bh=WQdL9SjsMGvVqpQaOCGEC+UHc5zg/EH0KTOkawcnI5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/v68POQKufGWRAHJnCV985M5GVrxhsSC5AN0Wnml60gEwHS9ySmY1N40KWiYPpVn
	 KA/6TL3no5jnekhBVcwq0H0W8A6kgLWCQKEyIgT3j6+JhaOg7PTeIJFxqUcsdMyXz0
	 B8ez9xrUkpQukelQzp2aogTOsdDKXamveSbobVOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Even Xu <even.xu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 074/181] HID: Intel-thc-hid: Intel-thc: fix dma_unmap_sg() nents value
Date: Thu, 15 Jan 2026 17:46:51 +0100
Message-ID: <20260115164204.995033570@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 0e13150c1a13a3a3d6184c24bfd080d5999945d1 ]

The `dma_unmap_sg()` functions should be called with the same nents as the
`dma_map_sg()`, not the value the map function returned.

Save the number of entries in struct thc_dma_configuration.

Fixes: a688404b2e20 ("HID: intel-thc-hid: intel-thc: Add THC DMA interfaces")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Even Xu <even.xu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-thc-hid/intel-thc/intel-thc-dma.c | 4 +++-
 drivers/hid/intel-thc-hid/intel-thc/intel-thc-dma.h | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dma.c b/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dma.c
index 82b8854843e05..a0c368aa7979c 100644
--- a/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dma.c
+++ b/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dma.c
@@ -232,6 +232,7 @@ static int setup_dma_buffers(struct thc_device *dev,
 		return 0;
 
 	memset(config->sgls, 0, sizeof(config->sgls));
+	memset(config->sgls_nent_pages, 0, sizeof(config->sgls_nent_pages));
 	memset(config->sgls_nent, 0, sizeof(config->sgls_nent));
 
 	cpu_addr = dma_alloc_coherent(dev->dev, prd_tbls_size,
@@ -254,6 +255,7 @@ static int setup_dma_buffers(struct thc_device *dev,
 		}
 		count = dma_map_sg(dev->dev, config->sgls[i], nent, dir);
 
+		config->sgls_nent_pages[i] = nent;
 		config->sgls_nent[i] = count;
 	}
 
@@ -299,7 +301,7 @@ static void release_dma_buffers(struct thc_device *dev,
 			continue;
 
 		dma_unmap_sg(dev->dev, config->sgls[i],
-			     config->sgls_nent[i],
+			     config->sgls_nent_pages[i],
 			     config->dir);
 
 		sgl_free(config->sgls[i]);
diff --git a/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dma.h b/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dma.h
index 78917400492ca..541d33995baf3 100644
--- a/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dma.h
+++ b/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dma.h
@@ -91,6 +91,7 @@ struct thc_prd_table {
  * @dir: Direction of DMA for this config
  * @prd_tbls: PRD tables for current DMA
  * @sgls: Array of pointers to scatter-gather lists
+ * @sgls_nent_pages: Number of pages per scatter-gather list
  * @sgls_nent: Actual number of entries per scatter-gather list
  * @prd_tbl_num: Actual number of PRD tables
  * @max_packet_size: Size of the buffer needed for 1 DMA message (1 PRD table)
@@ -107,6 +108,7 @@ struct thc_dma_configuration {
 
 	struct thc_prd_table *prd_tbls;
 	struct scatterlist *sgls[PRD_TABLES_NUM];
+	u8 sgls_nent_pages[PRD_TABLES_NUM];
 	u8 sgls_nent[PRD_TABLES_NUM];
 	u8 prd_tbl_num;
 
-- 
2.51.0



