Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B2D343218;
	Tue, 26 Aug 2025 13:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216579; cv=none; b=KdQqcRrDZ6fuISyUDpzW71qhQZ8TzlVGoCtzqNGh0HYEbLVLZTQY6ktlQcuPQTCPwmKKlyA2BQ0Ep8/09ZI+dsV+mky5u+FvDhwq3Yu4QUUf/X/Lf4kFzKFpyzzIwJ76lfZdpa1uXV9nufN1P+grE3Kfu19qbwL2BLqZXxlXlfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216579; c=relaxed/simple;
	bh=90kzF5uza1bYafg4IYyzGzUcuWeqDKrNLpI+h7eWgXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pR6hKj5vUsK6pBxFT9ocAh6mgjfXTQlY2XsiRRyRMa90LqGjeG9sakm157aqCaYUOvkNg08s4Sf234mQCVjwTWJzUG6TsaUb/g8XHvymiOIGS1+U+qXi3h6ut7gcvoGzEsiZuCiSpdk6Mqw3OUIP7QZGTdTX6qUmGp6rXAss6W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfhFMsTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfhFMsTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6781DC4CEF1;
	Tue, 26 Aug 2025 13:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216577;
	bh=90kzF5uza1bYafg4IYyzGzUcuWeqDKrNLpI+h7eWgXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfhFMsTLu5S42n9OQxo+TFuN16p/lMI+IAQcycIRAYpZM9bRYzjAQwIt5uP/aUAje
	 +vIvHpSsO60yV9y5YloFV7/ESZmikkNRMlkz473peTdH5PFN4NrwJwq9+1FsSdGxJO
	 LbafcNScCCuDrOvIBorMUweEHgxocL+g/zc50mNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wilhelm <alexander.wilhelm@westermo.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Subject: [PATCH 5.15 462/644] bus: mhi: host: Fix endianness of BHI vector table
Date: Tue, 26 Aug 2025 13:09:13 +0200
Message-ID: <20250826110957.927329921@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Wilhelm <alexander.wilhelm@westermo.com>

commit f471578e8b1a90623674433a01a8845110bc76ce upstream.

On big endian platform like PowerPC, the MHI bus (which is little endian)
does not start properly. The following example shows the error messages by
using QCN9274 WLAN device with ath12k driver:

    ath12k_pci 0001:01:00.0: BAR 0: assigned [mem 0xc00000000-0xc001fffff 64bit]
    ath12k_pci 0001:01:00.0: MSI vectors: 1
    ath12k_pci 0001:01:00.0: Hardware name: qcn9274 hw2.0
    ath12k_pci 0001:01:00.0: failed to set mhi state: POWER_ON(2)
    ath12k_pci 0001:01:00.0: failed to start mhi: -110
    ath12k_pci 0001:01:00.0: failed to power up :-110
    ath12k_pci 0001:01:00.0: failed to create soc core: -110
    ath12k_pci 0001:01:00.0: failed to init core: -110
    ath12k_pci: probe of 0001:01:00.0 failed with error -110

The issue seems to be with the incorrect DMA address/size used for
transferring the firmware image over BHI. So fix it by converting the DMA
address and size of the BHI vector table to little endian format before
sending them to the device.

Fixes: 6cd330ae76ff ("bus: mhi: core: Add support for ringing channel/event ring doorbells")
Signed-off-by: Alexander Wilhelm <alexander.wilhelm@westermo.com>
[mani: added stable tag and reworded commit message]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Reviewed-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250519145837.958153-1-alexander.wilhelm@westermo.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/boot.c     |    8 ++++----
 drivers/bus/mhi/host/internal.h |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/bus/mhi/host/boot.c
+++ b/drivers/bus/mhi/host/boot.c
@@ -30,8 +30,8 @@ void mhi_rddm_prepare(struct mhi_control
 	unsigned int i;
 
 	for (i = 0; i < img_info->entries - 1; i++, mhi_buf++, bhi_vec++) {
-		bhi_vec->dma_addr = mhi_buf->dma_addr;
-		bhi_vec->size = mhi_buf->len;
+		bhi_vec->dma_addr = cpu_to_le64(mhi_buf->dma_addr);
+		bhi_vec->size = cpu_to_le64(mhi_buf->len);
 	}
 
 	dev_dbg(dev, "BHIe programming for RDDM\n");
@@ -376,8 +376,8 @@ static void mhi_firmware_copy(struct mhi
 	while (remainder) {
 		to_cpy = min(remainder, mhi_buf->len);
 		memcpy(mhi_buf->buf, buf, to_cpy);
-		bhi_vec->dma_addr = mhi_buf->dma_addr;
-		bhi_vec->size = to_cpy;
+		bhi_vec->dma_addr = cpu_to_le64(mhi_buf->dma_addr);
+		bhi_vec->size = cpu_to_le64(to_cpy);
 
 		buf += to_cpy;
 		remainder -= to_cpy;
--- a/drivers/bus/mhi/host/internal.h
+++ b/drivers/bus/mhi/host/internal.h
@@ -263,8 +263,8 @@ struct mhi_ring_element {
 };
 
 struct bhi_vec_entry {
-	u64 dma_addr;
-	u64 size;
+	__le64 dma_addr;
+	__le64 size;
 };
 
 enum mhi_cmd_type {


