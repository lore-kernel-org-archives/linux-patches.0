Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B2F3016E0;
	Thu, 28 May 2026 20:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999496; cv=none; b=Pb2jponT2oDJ8p08ZHkextiAP6MYv/lthA0DFJM5KPgOVy1HSdC13YFML7WLL02Snkj43gbAvnnF4RLUtjNJ4jAlLuLVTdyOEPz3CsZNNtBHVNlz+HAfkZHXpdsLwIogwjWA4c2tmr0iV9I0Jcl9qX/LdDyX9C0OUWViyXwT/eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999496; c=relaxed/simple;
	bh=c+IjFtWZhyGNAVdNQXeN6bkMz2RvrnTZn7t7CCEdBiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODXWvzYrEF4C9n23WpJgxeMMDbBvgjH8auI72+ABI3iKoi893rIlds7aPS3h0hjqg8FZeFZJx55aYKJqKv1j42ZpKWZIBQYl8V1F7XlEDYhLZx08+JS+RpCyWrnxQG0jo1+JOFFR5f397lwNyeAHkrRDM7a46/N4j0Yctl1t2FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVMjbUCn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVMjbUCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37091F000E9;
	Thu, 28 May 2026 20:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999494;
	bh=7Z0re0WzfsHyntmPfnMr60GFeF/LRfBa8yo1NjeBUmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVMjbUCn5M8cqMysxJFCAUyevOJEpNHFfRm8W/XPO72LbzXFnWmhEEK0l+PSs9cl2
	 ZRKabEAAyxE4Jxdn/cT9GxQ96xoLp8W6OFEZBAiUC5VNaImQjiOHD2uvNFMMolEtoz
	 JVOIAujP5SVe9eTU/Z8iMAxh1V4yZ8XMnZ3aM/+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Farnung <kfarnung@gmail.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.18 088/377] wifi: ath11k: clear shared SRNG pointer state on restart
Date: Thu, 28 May 2026 21:45:26 +0200
Message-ID: <20260528194640.914702294@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Kyle Farnung <kfarnung@gmail.com>

commit f51e4b3b5574ad8cb5b16b11f8a1452147ece87a upstream.

LMAC rings reuse the shared rdp/wrp pointer buffers without going
through the normal SRNG hw-init path that zeros non-LMAC ring
pointers. After restart, ath11k_hal_srng_clear() can therefore hand
stale hp/tp state from the previous firmware instance back to the new
one.

Clear the shared pointer buffers while keeping the allocations in
place so restart still avoids reallocating SRNG DMA memory, but starts
with fresh ring-pointer state.

Fixes: 32be3ca4cf78b ("wifi: ath11k: HAL SRNG: don't deinitialize and re-initialize again")
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/all/CAOPSVF04q6uvVdq8GTRLHBrVMdpt9=o9wVcFMc6f-yhmSBcZqQ@mail.gmail.com/
Signed-off-by: Kyle Farnung <kfarnung@gmail.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260513-kfarnung-ath11k-srng-clear-pointer-state-v1-1-bc700dd8b333@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/hal.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/hal.c
+++ b/drivers/net/wireless/ath/ath11k/hal.c
@@ -1388,14 +1388,22 @@ EXPORT_SYMBOL(ath11k_hal_srng_deinit);
 
 void ath11k_hal_srng_clear(struct ath11k_base *ab)
 {
-	/* No need to memset rdp and wrp memory since each individual
-	 * segment would get cleared in ath11k_hal_srng_src_hw_init()
-	 * and ath11k_hal_srng_dst_hw_init().
+	/*
+	 * Preserve the shared pointer buffers, but clear the previous
+	 * firmware instance's hp/tp state before handing them back to FW.
+	 * LMAC rings reuse this shared memory without going through the
+	 * normal SRNG hw-init path that zeros non-LMAC ring pointers.
 	 */
 	memset(ab->hal.srng_list, 0,
 	       sizeof(ab->hal.srng_list));
 	memset(ab->hal.shadow_reg_addr, 0,
 	       sizeof(ab->hal.shadow_reg_addr));
+	if (ab->hal.rdp.vaddr)
+		memset(ab->hal.rdp.vaddr, 0,
+		       sizeof(*ab->hal.rdp.vaddr) * HAL_SRNG_RING_ID_MAX);
+	if (ab->hal.wrp.vaddr)
+		memset(ab->hal.wrp.vaddr, 0,
+		       sizeof(*ab->hal.wrp.vaddr) * HAL_SRNG_NUM_LMAC_RINGS);
 	ab->hal.avail_blk_resource = 0;
 	ab->hal.current_blk_index = 0;
 	ab->hal.num_shadow_reg_configured = 0;


