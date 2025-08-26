Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5B41D47B4;
	Tue, 26 Aug 2025 13:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213501; cv=none; b=DG+GugTmMK8Qvo0mHuaTHBQDCENUCpfaNqofrDOeMmVJwqWbGCHKrRknxn494xJHcQytyZ8L/4rbUWsWENkRT3Js7ouu/G6c/f9nmvkt9B7dPkFRnWglbOSOo1HXbY0vRfJgs+PgWHk4fs5+jGVrmzB626O3O/fWOs8ZusoCtBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213501; c=relaxed/simple;
	bh=O4riEdGRCyZZtOeNWaORi9vZiWJI9uqNaF+MSNsEhqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eM3nFV+M1v2p5zoEC8VZsXB7T6trEe/t9KSjRHCPKxTsFmzim3GEbiYtC0NafUCvssyEYYEJBgP5IRFAbH6ljfQuw1PdioBVoiG8DuJDkLCHsJAEuQWJlT00MZQJRVdjH6b5iBPJfOKHaJUMGKavTS6drzzqlfJjD7NIiRlSSTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9YzQQHy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9YzQQHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F33C4CEF4;
	Tue, 26 Aug 2025 13:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213501;
	bh=O4riEdGRCyZZtOeNWaORi9vZiWJI9uqNaF+MSNsEhqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9YzQQHyr+uKOf8T3RN/ovYhadxINITGpySmEJ2x+YovhKuYKcVlm9K2Xkdzv0wWu
	 w5llbW8pekQFrSjR1skiQI52pu0oTnXvz4uEgV5G3B6Z11PulnZmQqIokp3Gar1OpY
	 m4qDNnBwUPYOY0PSWgp3CDLUROoPgAb3TDo6Jmj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.6 370/587] wifi: ath12k: fix dest ring-buffer corruption
Date: Tue, 26 Aug 2025 13:08:39 +0200
Message-ID: <20250826111002.321279209@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 8157ce533a60521f21d466eb4de45d9735b19484 upstream.

Add the missing memory barrier to make sure that destination ring
descriptors are read after the head pointers to avoid using stale data
on weakly ordered architectures like aarch64.

The barrier is added to the ath12k_hal_srng_access_begin() helper for
symmetry with follow-on fixes for source ring buffer corruption which
will add barriers to ath12k_hal_srng_access_end().

Tested-on: WCN7850 hw2.0 WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Cc: stable@vger.kernel.org	# 6.3
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://patch.msgid.link/20250617084402.14475-2-johan+linaro@kernel.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/ce.c  |    3 ---
 drivers/net/wireless/ath/ath12k/hal.c |   17 ++++++++++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/ath/ath12k/ce.c
+++ b/drivers/net/wireless/ath/ath12k/ce.c
@@ -343,9 +343,6 @@ static int ath12k_ce_completed_recv_next
 		goto err;
 	}
 
-	/* Make sure descriptor is read after the head pointer. */
-	dma_rmb();
-
 	*nbytes = ath12k_hal_ce_dst_status_get_length(desc);
 
 	*skb = pipe->dest_ring->skb[sw_index];
--- a/drivers/net/wireless/ath/ath12k/hal.c
+++ b/drivers/net/wireless/ath/ath12k/hal.c
@@ -1728,13 +1728,24 @@ void *ath12k_hal_srng_src_get_next_reape
 
 void ath12k_hal_srng_access_begin(struct ath12k_base *ab, struct hal_srng *srng)
 {
+	u32 hp;
+
 	lockdep_assert_held(&srng->lock);
 
-	if (srng->ring_dir == HAL_SRNG_DIR_SRC)
+	if (srng->ring_dir == HAL_SRNG_DIR_SRC) {
 		srng->u.src_ring.cached_tp =
 			*(volatile u32 *)srng->u.src_ring.tp_addr;
-	else
-		srng->u.dst_ring.cached_hp = READ_ONCE(*srng->u.dst_ring.hp_addr);
+	} else {
+		hp = READ_ONCE(*srng->u.dst_ring.hp_addr);
+
+		if (hp != srng->u.dst_ring.cached_hp) {
+			srng->u.dst_ring.cached_hp = hp;
+			/* Make sure descriptor is read after the head
+			 * pointer.
+			 */
+			dma_rmb();
+		}
+	}
 }
 
 /* Update cached ring head/tail pointers to HW. ath12k_hal_srng_access_begin()


