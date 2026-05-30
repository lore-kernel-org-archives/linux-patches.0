Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA0E2566E9;
	Sat, 30 May 2026 18:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167075; cv=none; b=HdJk92nu7k3QJo18NLSvV4Rwr2j/NXMHH+25ddpFrYDAcTR0NzZ1cqwCGz/ujunV0KbWw+9pMASR798Emjuk6Hc6JLybkAIgxbD0BgfFgGQCjum/5X9E9NZiQFG72jiZEr2kwUWnoOuWsxTTPqHRvqFJ7/GHApPwuBqLojml+nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167075; c=relaxed/simple;
	bh=LV4rVyo5OgRgqFBgwnXeVO8nAX/pLN/LXrVlDyUMNoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+w9CFtpwuw4tWuBP9ZBFwMJ1ddgnH8iZLHAyUwxw4b/790r5XS2oc02p5VQdTEc2+9jCO5adWUgg0Pfq2FUMUPhD0R3wzJUC78qoKay0BwGnkZ4gYADF8w4BNmolxeboEcTGFV/598ouiK8+9BDSc7uyUJtQpksb9+88U+jIXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfrMkAM6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfrMkAM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96E21F00893;
	Sat, 30 May 2026 18:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167074;
	bh=Tyk650q4bzcVL6ynTRTqbGgIsQ1E4CuzXPjQJW6af8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfrMkAM6hzSP7OnrNhP7JtPU+tQFgUf23GrsnqieU63t/G2fi369U8NJKS6MMt0Mp
	 9oXZkEHBOI2lYUZZlwz02X5a0zsIksiTVYmt585U+dCtLT0AOnC3FJfTpbqKS2i62w
	 DdPpdcIiCIn1hGPrhTIKmnyKxRPRUjGNtqT99XVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Farnung <kfarnung@gmail.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 5.10 539/589] wifi: ath11k: clear shared SRNG pointer state on restart
Date: Sat, 30 May 2026 18:07:00 +0200
Message-ID: <20260530160238.855730521@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1319,14 +1319,22 @@ EXPORT_SYMBOL(ath11k_hal_srng_deinit);
 
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


