Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B8E350D5D;
	Tue, 26 Aug 2025 14:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218007; cv=none; b=mtn6rhW2UhMGu1d7FzzA0eD98KGMEYPoZzwhtg7G8+0jb/kHykIZEbmifNhzqaCPqJQWk5qDzW3J8JKKpJYyuyTR9/wWNZ1qzVtWvGy1u5TM6w0CMvFO9rPljbg9D9KEDEW8RRjhw6HVHG5agvlbjVIdJtCoLWW3Ho1huedgNfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218007; c=relaxed/simple;
	bh=nphWbvN0NLsMHuOVuikvhsCzk+sp0iCGGginj5u3j9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVAOV04fuJHgX+F8gX61hqgms3BeKocoEFURFzS5eHtNeSJUBxt0mz6Ua4FCuw2irpgtmYIQXvvogqdHYLaI8tKVgo6mpPpoidCrHmrPThwV98pTIST0fHpslO2TvqNAsXKlZBS6a0/kpNluMqVt8QHm/nd+8ib/Z1zwyuRfUvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMpoZvrY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMpoZvrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128EAC4CEF1;
	Tue, 26 Aug 2025 14:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218007;
	bh=nphWbvN0NLsMHuOVuikvhsCzk+sp0iCGGginj5u3j9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMpoZvrYziGtai0VMDI5rRby2VebZ2NDzzpewry4qn8ss8yYn00Foijiq+XTIatab
	 4EVBvjiWy8N13u3uh2lvfEsUpzxFQdWfe5vXjV9fGHK33fDEwk/MKaKnTlinzkcmDq
	 aw67kvPe4+5b2K44iVZ2r9po+FsR/egeU31PbNQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wilhelm <alexander.wilhelm@westermo.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Subject: [PATCH 5.10 358/523] bus: mhi: host: Fix endianness of BHI vector table
Date: Tue, 26 Aug 2025 13:09:28 +0200
Message-ID: <20250826110933.301029495@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -372,8 +372,8 @@ static void mhi_firmware_copy(struct mhi
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
@@ -263,8 +263,8 @@ struct mhi_tre {
 };
 
 struct bhi_vec_entry {
-	u64 dma_addr;
-	u64 size;
+	__le64 dma_addr;
+	__le64 size;
 };
 
 enum mhi_cmd_type {


