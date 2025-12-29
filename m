Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75436319858;
	Mon, 29 Dec 2025 16:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025659; cv=none; b=DCoa4B0J/w72/PuFa1aLfBT2rdEyzJxniBQGvbCYxKml0LQq0VzNuY8DPRlJFl5g4Th7Z1v+kwKhAS856VB5aPT9/Qi5ijYhinMx1+YiNW37yvwAQyoJdA4v1AbgNC5rg6VyxtI2YPv5K417uJe9rchJpQ/sCpZMvRzSzmhjv08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025659; c=relaxed/simple;
	bh=KlWCkFySZZbISRc4YoUUR3Wv9YMiQVgW0GkhDomzQ1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erOaMiP07/JiXB0kGuTuEPlq9qye1XwZ3CjLBUERHPbGLUI002EgUi2GjO+WeHWNBeGC3C6Tmi1aWJq9M4A/fXcSbEsGKbTz+uRLDjX4Bw15LbqounUCiMg3dhO+io/AfULH+x2xAK/Ybg13tTVY0NAHDYN6rSjGeQzkAYFQDng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpOf/E75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpOf/E75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D28C116C6;
	Mon, 29 Dec 2025 16:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025659;
	bh=KlWCkFySZZbISRc4YoUUR3Wv9YMiQVgW0GkhDomzQ1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpOf/E75XhgINvGmJ9wM7lML1khROAz49WNBORBWasKMPOYsbIrjKDMclJ6V6Lgn8
	 WGdKHfQvcQOdLvj83o9gu0yjvMXjSaFFiX6bqhLAVB36rJK3Vqx5dmB6FKj0NG6Gzl
	 7XfeUvTtIgmbb6CgOIJOKZZKR/Gwk6w9QEBZ+O8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	James Clark <james.clark@linaro.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.18 274/430] dma-mapping: Fix DMA_BIT_MASK() macro being broken
Date: Mon, 29 Dec 2025 17:11:16 +0100
Message-ID: <20251229160734.434153239@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

commit 31b931bebd11a0f00967114f62c8c38952f483e5 upstream.

After commit a50f7456f853 ("dma-mapping: Allow use of DMA_BIT_MASK(64) in
global scope"), the DMA_BIT_MASK() macro is broken when passed non trivial
statements for the value of 'n'. This is caused by the new version missing
parenthesis around 'n' when evaluating 'n'.

One example of this breakage is the IPU6 driver now crashing due to
it getting DMA-addresses with address bit 32 set even though it has
tried to set a 32 bit DMA mask.

The IPU6 CSI2 engine has a DMA mask of either 31 or 32 bits depending
on if it is in secure mode or not and it sets this masks like this:

        mmu_info->aperture_end =
                (dma_addr_t)DMA_BIT_MASK(isp->secure_mode ?
                                         IPU6_MMU_ADDR_BITS :
                                         IPU6_MMU_ADDR_BITS_NON_SECURE);

So the 'n' argument here is "isp->secure_mode ? IPU6_MMU_ADDR_BITS :
IPU6_MMU_ADDR_BITS_NON_SECURE" which gets expanded into:

isp->secure_mode ? IPU6_MMU_ADDR_BITS : IPU6_MMU_ADDR_BITS_NON_SECURE - 1

With the -1 only being applied in the non secure case, causing
the secure mode mask to be one 1 bit too large.

Fixes: a50f7456f853 ("dma-mapping: Allow use of DMA_BIT_MASK(64) in global scope")
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20251207184756.97904-1-johannes.goede@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/dma-mapping.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 2ceda49c609f..aa36a0d1d9df 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -90,7 +90,7 @@
  */
 #define DMA_MAPPING_ERROR		(~(dma_addr_t)0)
 
-#define DMA_BIT_MASK(n)	GENMASK_ULL(n - 1, 0)
+#define DMA_BIT_MASK(n)	GENMASK_ULL((n) - 1, 0)
 
 struct dma_iova_state {
 	dma_addr_t addr;
-- 
2.52.0



