Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF4942049;
	Thu, 15 Jan 2026 16:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495909; cv=none; b=IBwiBYxL7X+kk9aj7OjktlaVUVJ8PySVy2DZ4tgREZvfGW5erLpkjSHHBZv5VAt/e2AwbuDNxu6ZZhwdqzg0/baA13TtQbOs/5NZ2pznQGC1hm3fcXrGy31XMwP2282OxbIoKDtFa/SRKcvbc8NYDeiwVyCPHetGO3IGlrjrQ9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495909; c=relaxed/simple;
	bh=dMe/BEdaK7ZM9l+Ah4YNA9QhD2igyuWnL+5ya/4JWoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tY3cHmboq/p7xzMcoL2yIa1v3IfjK/Mt4o2SMFgl1k+shcl1zEyewCdFyMh7j82hUXoQOmgQAwnv42Ht5z9F1KxierbwlMz2gSs4Z5qNUF0dGqg9voAomzYV5K/OHeRzOe9lmL3SsSMPvwZNN30VL+jkupxdAWU0mmMwGBfQunM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHQh3uey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHQh3uey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4009C116D0;
	Thu, 15 Jan 2026 16:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495909;
	bh=dMe/BEdaK7ZM9l+Ah4YNA9QhD2igyuWnL+5ya/4JWoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHQh3ueyzxhioqEF3L0Xz5JEK2JZB7lqbeUk1s8BkLyqrB/wrfB5ye0EYay8z+vUa
	 4uUnnqnFckaujiMiZGriDCO7C2cgxcAUZD2XaFIAVoU0o0bV1yoaKcUizqv6NsmTkn
	 sP4Zn3eH8p40nZYFbGhQRFAczhmrtJxY56ftn0ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 011/181] bnxt_en: Fix NULL pointer crash in bnxt_ptp_enable during error cleanup
Date: Thu, 15 Jan 2026 17:45:48 +0100
Message-ID: <20260115164202.725716265@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit 3358995b1a7f9dcb52a56ec8251570d71024dad0 upstream.

When bnxt_init_one() fails during initialization (e.g.,
bnxt_init_int_mode returns -ENODEV), the error path calls
bnxt_free_hwrm_resources() which destroys the DMA pool and sets
bp->hwrm_dma_pool to NULL. Subsequently, bnxt_ptp_clear() is called,
which invokes ptp_clock_unregister().

Since commit a60fc3294a37 ("ptp: rework ptp_clock_unregister() to
disable events"), ptp_clock_unregister() now calls
ptp_disable_all_events(), which in turn invokes the driver's .enable()
callback (bnxt_ptp_enable()) to disable PTP events before completing the
unregistration.

bnxt_ptp_enable() attempts to send HWRM commands via bnxt_ptp_cfg_pin()
and bnxt_ptp_cfg_event(), both of which call hwrm_req_init(). This
function tries to allocate from bp->hwrm_dma_pool, causing a NULL
pointer dereference:

  bnxt_en 0000:01:00.0 (unnamed net_device) (uninitialized): bnxt_init_int_mode err: ffffffed
  KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
  Call Trace:
   __hwrm_req_init (drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c:72)
   bnxt_ptp_enable (drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:323 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:517)
   ptp_disable_all_events (drivers/ptp/ptp_chardev.c:66)
   ptp_clock_unregister (drivers/ptp/ptp_clock.c:518)
   bnxt_ptp_clear (drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:1134)
   bnxt_init_one (drivers/net/ethernet/broadcom/bnxt/bnxt.c:16889)

Lines are against commit f8f9c1f4d0c7 ("Linux 6.19-rc3")

Fix this by clearing and unregistering ptp (bnxt_ptp_clear()) before
freeing HWRM resources.

Suggested-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Fixes: a60fc3294a37 ("ptp: rework ptp_clock_unregister() to disable events")
Cc: stable@vger.kernel.org
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20260106-bnxt-v3-1-71f37e11446a@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16856,12 +16856,12 @@ init_err_dl:
 
 init_err_pci_clean:
 	bnxt_hwrm_func_drv_unrgtr(bp);
-	bnxt_free_hwrm_resources(bp);
-	bnxt_hwmon_uninit(bp);
-	bnxt_ethtool_free(bp);
 	bnxt_ptp_clear(bp);
 	kfree(bp->ptp_cfg);
 	bp->ptp_cfg = NULL;
+	bnxt_free_hwrm_resources(bp);
+	bnxt_hwmon_uninit(bp);
+	bnxt_ethtool_free(bp);
 	kfree(bp->fw_health);
 	bp->fw_health = NULL;
 	bnxt_cleanup_pci(bp);


