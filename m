Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5081E3431F5;
	Tue, 26 Aug 2025 11:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207086; cv=none; b=juAfpLBtFA9bhkYE6W7uec80cbJQUfZoyVr/kE/AckEjWy9kwTpe6C/8vrhr+PVOYs5HYHc735jwqZqhuYfQyJnTjGBuHzlo07vpFSQPzVsha8eGQNuTtELuH7WC56PsfoZTMPamWhGnjPeQDo348ffWkHTLxFuRUsUMEG1uWDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207086; c=relaxed/simple;
	bh=e66bVIWDX0se20iTh0LXCvnmU3ho3VTIda+FXWjhH6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxeQ2PMA7MPMod2R8FfscYCNkqwSdh9BcxrVAGKXgwVXCVtdpJT7zX/mc6ejXfKRpGiKRmn4ei2LBcwyWDtJMppGyNJ60oUBbU3XVPoOqgFnR/aUIDDKVI9SiIZizUVCyNlThdzMANv+oKnzT8esp+ktI13wonVM6Xku977JmQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bePoTgH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bePoTgH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD45EC19421;
	Tue, 26 Aug 2025 11:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207086;
	bh=e66bVIWDX0se20iTh0LXCvnmU3ho3VTIda+FXWjhH6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bePoTgH3WC/7FIRyi05ZQRIVjOLUlO1ViyHvwbJusQ91MeJnuQnXZxN4kXFxtYsWM
	 xNnQ1uHL0FX5ngUdk3ZvvxkraqnYfwAkS7NYkf1IlGtOmYvqeYChKCg0fT2rf+Ccyw
	 k21R4P+pdPL0N621QedAbqHdSrRhraS0uXwcokqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wilhelm <alexander.wilhelm@westermo.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Subject: [PATCH 6.16 015/457] bus: mhi: host: Fix endianness of BHI vector table
Date: Tue, 26 Aug 2025 13:04:59 +0200
Message-ID: <20250826110937.699949552@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -31,8 +31,8 @@ int mhi_rddm_prepare(struct mhi_controll
 	int ret;
 
 	for (i = 0; i < img_info->entries - 1; i++, mhi_buf++, bhi_vec++) {
-		bhi_vec->dma_addr = mhi_buf->dma_addr;
-		bhi_vec->size = mhi_buf->len;
+		bhi_vec->dma_addr = cpu_to_le64(mhi_buf->dma_addr);
+		bhi_vec->size = cpu_to_le64(mhi_buf->len);
 	}
 
 	dev_dbg(dev, "BHIe programming for RDDM\n");
@@ -431,8 +431,8 @@ static void mhi_firmware_copy_bhie(struc
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
@@ -25,8 +25,8 @@ struct mhi_ctxt {
 };
 
 struct bhi_vec_entry {
-	u64 dma_addr;
-	u64 size;
+	__le64 dma_addr;
+	__le64 size;
 };
 
 enum mhi_fw_load_type {


