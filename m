Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9A21E5724;
	Wed,  8 Apr 2026 18:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672584; cv=none; b=kdE4RlSGlkEwNAgHsQYCPrUGDZmG+KVrHwYIz6CF2nHRv7iYvm+JtUo9J78NqPBo5WOvMHput+FqP31WuVJ55hBhlyVs69uHS6rQwNq+y70zZyjuHp3Yi5ycz3q1q5JJUn1/wVwFXpJlxst2g4XQmWmalbOCzxXe/HNrH76Nh48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672584; c=relaxed/simple;
	bh=oVzAFzzEBPhfTZYl0Y7AgcrLk3k1qgk94Siw5igu93E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dieyDVDPKe1LZeQITipxCoXEYaAYGBi8J0eqPa6cEE1W62ucSajTpl8jciXHcIws6qcio1wTV2NUeoMySr8HsAYGDRbznECHehhQUC/nhceDjUGPn7pETUuTz9DZWyni1IkHM4sEES95eqdL/1giJ4tV1rD5f3ZZO/5OFFj+nFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObJM8EwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObJM8EwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB83C19421;
	Wed,  8 Apr 2026 18:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672584;
	bh=oVzAFzzEBPhfTZYl0Y7AgcrLk3k1qgk94Siw5igu93E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObJM8EwFfv/KWCKkEs3XBITyM298CleX91LRCsYArgQO1uERk63+/Aq6aX+kxG1QA
	 GgRtY3Q5fD2d1BHwNGbTRpbMPmd8hgjqfMLO8YF0LTyhVJO+F7mX06mrKlvLHYOC+k
	 +oSISox17izIRkwyM8ihVdt7faY2b/fGd1vrRSe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Sean Anderson <sean.anderson@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/160] net: xilinx: axienet: Correct BD length masks to match AXIDMA IP spec
Date: Wed,  8 Apr 2026 20:01:58 +0200
Message-ID: <20260408175914.371771294@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Gupta <suraj.gupta2@amd.com>

[ Upstream commit 393e0b4f178ec7fce1141dacc3304e3607a92ee9 ]

The XAXIDMA_BD_CTRL_LENGTH_MASK and XAXIDMA_BD_STS_ACTUAL_LEN_MASK
macros were defined as 0x007FFFFF (23 bits), but the AXI DMA IP
product guide (PG021) specifies the buffer length field as bits 25:0
(26 bits). Update both masks to match the IP documentation.

In practice this had no functional impact, since Ethernet frames are
far smaller than 2^23 bytes and the extra bits were always zero, but
the masks should still reflect the hardware specification.

Fixes: 8a3b7a252dca ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Suraj Gupta <suraj.gupta2@amd.com>
Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Link: https://patch.msgid.link/20260327073238.134948-2-suraj.gupta2@amd.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 2facbdfbb319e..e6a1611b7aab2 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -103,7 +103,7 @@
 #define XAXIDMA_BD_HAS_DRE_MASK		0xF00 /* Whether has DRE mask */
 #define XAXIDMA_BD_WORDLEN_MASK		0xFF /* Whether has DRE mask */
 
-#define XAXIDMA_BD_CTRL_LENGTH_MASK	0x007FFFFF /* Requested len */
+#define XAXIDMA_BD_CTRL_LENGTH_MASK	GENMASK(25, 0) /* Requested len */
 #define XAXIDMA_BD_CTRL_TXSOF_MASK	0x08000000 /* First tx packet */
 #define XAXIDMA_BD_CTRL_TXEOF_MASK	0x04000000 /* Last tx packet */
 #define XAXIDMA_BD_CTRL_ALL_MASK	0x0C000000 /* All control bits */
@@ -129,7 +129,7 @@
 #define XAXIDMA_BD_CTRL_TXEOF_MASK	0x04000000 /* Last tx packet */
 #define XAXIDMA_BD_CTRL_ALL_MASK	0x0C000000 /* All control bits */
 
-#define XAXIDMA_BD_STS_ACTUAL_LEN_MASK	0x007FFFFF /* Actual len */
+#define XAXIDMA_BD_STS_ACTUAL_LEN_MASK	GENMASK(25, 0) /* Actual len */
 #define XAXIDMA_BD_STS_COMPLETE_MASK	0x80000000 /* Completed */
 #define XAXIDMA_BD_STS_DEC_ERR_MASK	0x40000000 /* Decode error */
 #define XAXIDMA_BD_STS_SLV_ERR_MASK	0x20000000 /* Slave error */
-- 
2.53.0



