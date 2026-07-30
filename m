Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4741B43F097;
	Thu, 30 Jul 2026 14:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422891; cv=none; b=N5cxlJeYx0YuLk631H9tpxRrswrTq2MKK3MWcpDYHwGovOxpGZwovkl9HlzfWyOvg43ugudrTr9NTnhdNsbjHD9zHe3ZisK+Ac4zQkm9DAy31+QtRrkOTD1qkPz/TKp4y+aXtxphI1ij2UBBY8jEC4YALbS4rfiKBTk3GsJA9KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422891; c=relaxed/simple;
	bh=FbIvoiDZ8LbY/V17US1R1cEHrXWD7qXGUO4lYdQoS3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLcOGYKdXh7S8Xv3zhRCkyO75yELAt8TIs8yKxCTUuDuiYqTdRxB9biIHQoNwFx07+wX7Mcumn2kxXWEkiK8nm4Qk1BvZYNUOIZBJ/0GeyLccz3M+jAmnNLn5AKXKSv7JKkGICNm2gnqgjxrkWjv8iNsNi1vJ/iyDPdQb7g0Y1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNaLSdw3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNaLSdw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24971F000E9;
	Thu, 30 Jul 2026 14:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422890;
	bh=Sg/l21WIM/LNwr9A4Dj+DHAbcEL/pxt07nFDBvSzoDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pNaLSdw3cd9OLblLgi3tXYcTRqMKpAD4btQDf2MN1dVfnis3fIuMirDfs9O49xWmD
	 leg5jjQ4vJ0UKINyBxl8JGuFkLux388janKx3tTpBgGyWPoydoI4ZVPHdaZf/WM5ej
	 xIn78027p7URC0w4KbIAMS92BOH9DpGQO+FFebg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 7.1 555/744] wifi: ath12k: fix NULL pointer dereference in rhash table destroy
Date: Thu, 30 Jul 2026 16:13:48 +0200
Message-ID: <20260730141456.076914069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

commit 70231dcd782201579990ded73e0435d18bb524ca upstream.

When unbinding the ath12k driver, kernel NULL pointer dereferences
occur in irq_work_sync() called from rhashtable_destroy().

Two hash tables are affected:
1. ath12k_link_sta hash table in ath12k_base
2. ath12k_dp_link_peer hash table in ath12k_dp

The issue happens because the destroy functions are called unconditionally
in cleanup paths, but the hash tables are only initialized late in their
respective init functions. If the device was never fully started or if the
init functions failed before initializing the hash tables, the pointers
will be NULL. The issues are always reproducible from a VM because the MSI
addressing initialization is failing.

Call trace for ath12k_link_sta_rhash_tbl_destroy:
 RIP: irq_work_sync+0x1e/0x70
 rhashtable_destroy+0x12/0x60
 ath12k_link_sta_rhash_tbl_destroy+0x19/0x40 [ath12k]
 ath12k_core_stop+0xe/0x80 [ath12k]
 ath12k_core_hw_group_cleanup+0x6b/0xb0 [ath12k]
 ath12k_pci_remove+0x60/0x110 [ath12k]

Call trace for ath12k_dp_link_peer_rhash_tbl_destroy:
 RIP: irq_work_sync+0x1e/0x70
 rhashtable_destroy+0x12/0x60
 ath12k_dp_link_peer_rhash_tbl_destroy+0x29/0x50 [ath12k]
 ath12k_dp_cmn_device_deinit+0x21/0x140 [ath12k]
 ath12k_core_hw_group_cleanup+0x6b/0xb0 [ath12k]
 ath12k_pci_remove+0x60/0x110 [ath12k]

Fix this by adding NULL checks before calling rhashtable_destroy() in
both destroy functions.

The NULL check approach was chosen because the rhashtable pointer
serves as the initialization state indicator. The init can fail at
various points, leaving some components uninitialized. Checking the
pointer directly is simpler than adding separate state flags that
would need synchronization.

Fixes: 57ccca410237 ("wifi: ath12k: Add hash table for ath12k_link_sta in ath12k_base")
Fixes: a88cf5f71adf ("wifi: ath12k: Add hash table for ath12k_dp_link_peer")
Cc: stable@vger.kernel.org
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260615112103.601982-1-jtornosm@redhat.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/dp_peer.c |    7 +++++--
 drivers/net/wireless/ath/ath12k/peer.c    |    3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath12k/dp_peer.c
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.c
@@ -274,11 +274,14 @@ int ath12k_dp_link_peer_rhash_tbl_init(s
 
 void ath12k_dp_link_peer_rhash_tbl_destroy(struct ath12k_dp *dp)
 {
-	mutex_lock(&dp->link_peer_rhash_tbl_lock);
+	guard(mutex)(&dp->link_peer_rhash_tbl_lock);
+
+	if (!dp->rhead_peer_addr)
+		return;
+
 	rhashtable_destroy(dp->rhead_peer_addr);
 	kfree(dp->rhead_peer_addr);
 	dp->rhead_peer_addr = NULL;
-	mutex_unlock(&dp->link_peer_rhash_tbl_lock);
 }
 
 static int ath12k_dp_link_peer_rhash_insert(struct ath12k_dp *dp,
--- a/drivers/net/wireless/ath/ath12k/peer.c
+++ b/drivers/net/wireless/ath/ath12k/peer.c
@@ -444,6 +444,9 @@ err_free:
 
 void ath12k_link_sta_rhash_tbl_destroy(struct ath12k_base *ab)
 {
+	if (!ab->rhead_sta_addr)
+		return;
+
 	rhashtable_destroy(ab->rhead_sta_addr);
 	kfree(ab->rhead_sta_addr);
 	ab->rhead_sta_addr = NULL;


