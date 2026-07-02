Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D694A2E1B;
	Thu,  2 Jul 2026 16:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009473; cv=none; b=oI/APdVfB7kJ+t0eBF/EbBXjz2sR2XJUQseqkMghxCjThZs91c4DEgiJF/FudiVy0qubkohy2kwlFCKF+3I6hXeUTGEFzLlYVU4vrk5JzmZpGeXMRhSCma3O9MHR6EfRP3t5j0sj5QPqPNGQ1Vmq+WZpxNeVCFM3ejxjltaySC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009473; c=relaxed/simple;
	bh=5oRa0vEp1u/tzLXTP46VJwpNL4D5zdrKsplzDAqtTeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIuVlsOaWSiTqp9ol7MtF3EGZgH0xJHcHf2Cf7u1/kgWKMMF/EvxQFdGcUQKN4Z+xXLT1r+JIpCj+kvQa6YoPdn9U/f+fb2pdc0Y+jg4Airbxuipczv8VJJLaQ/vNIRLwNECbgSmcktW8Q7C52USU1ekadVoUhaIgutG0CDnRBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wa2aC1p9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wa2aC1p9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6E41F00A3D;
	Thu,  2 Jul 2026 16:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009471;
	bh=v++3tARNA61aA8lK/VpltLkqpgKrIm2MK6tWTIfQw4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wa2aC1p9AUPRiqdNQh0FuAgPLeyvkIjAAra2kWrA6ZoqfQTWkhBrEZnISkSAGihfv
	 SstJkgb16ki5dCDPfpUeISHPI6xq+vpfeAVCpqO4m0RvHKjtahwk4vt091BklrMJG+
	 dt2A5eDXLn2h/qQ/BoIVsQXR4dfphMwljE4NQyMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 5.10 65/96] wifi: ath11k: fix warning when unbinding
Date: Thu,  2 Jul 2026 18:19:57 +0200
Message-ID: <20260702155110.350063500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

commit 8b7a26b6681922a38cd5a7829ace61f8e54df9b7 upstream.

If there is an error during some initialization related to firmware,
the buffers dp->tx_ring[i].tx_status are released.
However this is released again when the device is unbinded (ath11k_pci),
and we get:
WARNING: CPU: 0 PID: 6231 at mm/slub.c:4368 free_large_kmalloc+0x57/0x90
Call Trace:
free_large_kmalloc
ath11k_dp_free
ath11k_core_deinit
ath11k_pci_remove
...

The issue is always reproducible from a VM because the MSI addressing
initialization is failing.

In order to fix the issue, just set the buffers to NULL after releasing in
order to avoid the double free.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Cc: stable@vger.kernel.org
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260420110130.509670-1-jtornosm@redhat.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/dp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -1015,6 +1015,7 @@ void ath11k_dp_free(struct ath11k_base *
 		idr_destroy(&dp->tx_ring[i].txbuf_idr);
 		spin_unlock_bh(&dp->tx_ring[i].tx_idr_lock);
 		kfree(dp->tx_ring[i].tx_status);
+		dp->tx_ring[i].tx_status = NULL;
 	}
 
 	/* Deinit any SOC level resource */


