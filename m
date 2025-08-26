Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BCF33EAF2;
	Tue, 26 Aug 2025 13:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214862; cv=none; b=LaDlv0Ef4EpFJGEYKtSEGzWTAksYhwbTWXZJ7CzpzZLbiLkVSIi8WElQTyUf+u5nMvtaGAHap274Aa1kT72kv4XWln0tlzP18YGeDxfIDsieoDIsRrgd5VLU/Iu2Vf28Qb18Nons2AdvxEVOdJuzcvRLLHJyvVNWNbXALzW7hlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214862; c=relaxed/simple;
	bh=NQLNQq/xM1fbZFIVukAxrznQ+aiH61wTu9TR54SOmK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxwJEGPuSXNgndqUXZdhkpPCIhFd68lFnPP8/0816pOrzZP3KX2bjuskBSG1FIrvItYYeKBSIE8pESpwUGqg+LGazvvQJRwg7RrKHcOdnF6sBVxDbuPPPObV+Ig8/3cm77oe3thwB3Z/jE488aUsClAtVtmxCyzG6sJz9ZT4VAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uufWbuj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uufWbuj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE75C113D0;
	Tue, 26 Aug 2025 13:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214862;
	bh=NQLNQq/xM1fbZFIVukAxrznQ+aiH61wTu9TR54SOmK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uufWbuj2ZfIaqXt0Ihi5FD6SCEGLT4n2JIgQwyorfoPqbuheEbahBgTYfvhspqOC+
	 zao4X1D16TzGWZe7pfIcxk8fbaeIimKw2CB/9TFl8K2c+eQbR0jg13WRffUOIllL2z
	 TzRrWBnF/g/tx7kKu5CAKw3PEDmO6AzTyBvuDHLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.1 298/482] wifi: ath11k: fix dest ring-buffer corruption when ring is full
Date: Tue, 26 Aug 2025 13:09:11 +0200
Message-ID: <20250826110938.158729910@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit aa6956150f820e6a6deba44be325ddfcb5b10f88 upstream.

Add the missing memory barriers to make sure that destination ring
descriptors are read before updating the tail pointer (and passing
ownership to the device) to avoid memory corruption on weakly ordered
architectures like aarch64 when the ring is full.

Tested-on: WCN6855 hw2.1 WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.41

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Cc: stable@vger.kernel.org      # 5.6
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://patch.msgid.link/20250604143457.26032-6-johan+linaro@kernel.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/hal.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/hal.c
+++ b/drivers/net/wireless/ath/ath11k/hal.c
@@ -827,7 +827,6 @@ void ath11k_hal_srng_access_end(struct a
 {
 	lockdep_assert_held(&srng->lock);
 
-	/* TODO: See if we need a write memory barrier here */
 	if (srng->flags & HAL_SRNG_FLAGS_LMAC_RING) {
 		/* For LMAC rings, ring pointer updates are done through FW and
 		 * hence written to a shared memory location that is read by FW
@@ -842,7 +841,11 @@ void ath11k_hal_srng_access_end(struct a
 			WRITE_ONCE(*srng->u.src_ring.hp_addr, srng->u.src_ring.hp);
 		} else {
 			srng->u.dst_ring.last_hp = *srng->u.dst_ring.hp_addr;
-			*srng->u.dst_ring.tp_addr = srng->u.dst_ring.tp;
+			/* Make sure descriptor is read before updating the
+			 * tail pointer.
+			 */
+			dma_mb();
+			WRITE_ONCE(*srng->u.dst_ring.tp_addr, srng->u.dst_ring.tp);
 		}
 	} else {
 		if (srng->ring_dir == HAL_SRNG_DIR_SRC) {
@@ -858,6 +861,10 @@ void ath11k_hal_srng_access_end(struct a
 					   srng->u.src_ring.hp);
 		} else {
 			srng->u.dst_ring.last_hp = *srng->u.dst_ring.hp_addr;
+			/* Make sure descriptor is read before updating the
+			 * tail pointer.
+			 */
+			mb();
 			ath11k_hif_write32(ab,
 					   (unsigned long)srng->u.dst_ring.tp_addr -
 					   (unsigned long)ab->mem,


