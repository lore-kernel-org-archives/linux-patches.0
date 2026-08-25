Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3579469851;
	Tue, 25 Aug 2026 13:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666093; cv=none; b=L5bjcsm5aDOD6Ee5RkKpd0txbTiN4fWJnNcc166+mH96nMkw73Vt3gD6G/0R1VQeaFVCz9sosywxup3vDOjq7UL8jNhGTbCWq0HmGPKusL3RMWRErEHKhn1/40zo6J6+2vpy6gr/kCBjDfh5KV4dpoej8uzI13p8Qx2N8vByEQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666093; c=relaxed/simple;
	bh=VRKqYDza5XNGDdA+XT0WizEVVltCNulICmzsm4IZpww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRUWMHtL2hBU7pnv8pe8MRwbldjoTCBbjSmwe3jmG3kXgAwVfgilhRowrv6w76MuGnMahc2/FfmlWcMKQIL+6UZDUesI2Cf3txB5JvTJBgVqeL1oOAQeWu2FfejmqBVB3RnswfFTp9Oa/bvPHNYcRkUVqPY3SDCL67msT4TO13w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbC9jEGJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbC9jEGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CBD1F000E9;
	Tue, 25 Aug 2026 13:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666091;
	bh=iRreexE3gUfUjl6F2+qHxO3/+/m3DGAE2mLxOnAUNpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TbC9jEGJC32BQ7KGIBl7+EMZgsM0KnCEl/yJyMAfOT5l0vu1pBWZi+FuCn5JKi5je
	 mDsW6UE8ZTOGIgGxPWRu6K7y/78/su8iEkhRqtJ3rG6utUXQj7ce0P9d9XlAJIQYtz
	 5ZIoxK2EqmHtbGZKCxzLclCpcsER/MNv0OpuIF2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Page <sam@bynar.io>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.1 50/79] nfc: nci: fix out-of-bounds write in nci_target_auto_activated()
Date: Tue, 25 Aug 2026 15:26:30 +0200
Message-ID: <20260825132543.666493347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Page <sam@bynar.io>

commit ac200079db50af81e6b04d058b33ec92901d8edd upstream.

nci_target_auto_activated() appends a target to the fixed-size array
ndev->targets[NCI_MAX_DISCOVERED_TARGETS] and increments ndev->n_targets
without first checking the array is full; unlike its sibling
nci_add_new_target(), which bails out when n_targets already equals
NCI_MAX_DISCOVERED_TARGETS.

ndev->n_targets is only cleared by nci_clear_target_list(), so an NFCC
that repeatedly re-runs discovery (RF_DISCOVER_RSP, which re-enters
NCI_DISCOVERY without clearing the target list) and reports an
auto-activated target (RF_INTF_ACTIVATED_NTF) drives n_targets past the
limit. The append then writes a struct nfc_target past the end of the
array (a slab out-of-bounds write), and nfc_targets_found() goes on to
walk the array with the inflated count:

  BUG: KASAN: slab-out-of-bounds in nci_add_new_protocol+0x94/0x2ac [nci]
  Write of size 2 at addr ffff0000c7299a18 by task kworker/u8:0/12
  Workqueue: nfc0_nci_rx_wq nci_rx_work [nci]
  Call trace:
   nci_add_new_protocol+0x94/0x2ac [nci]
   nci_ntf_packet+0xddc/0x11a0 [nci]
   nci_rx_work+0x15c/0x1e0 [nci]
   process_one_work+0x2dc/0x500
   worker_thread+0x240/0x460
   kthread+0x1c0/0x1d0
   ret_from_fork+0x10/0x20

  The buggy address belongs to the cache kmalloc-2k of size 2048
  The buggy address is located 1024 bytes to the right of
  allocated 1560-byte region [ffff0000c7299000, ffff0000c7299618)

Guard nci_target_auto_activated() with the same check used by
nci_add_new_target().

Fixes: 019c4fbaa790 ("NFC: Add NCI multiple targets support")
Cc: stable@vger.kernel.org
Assisted-by: Bynario AI
Signed-off-by: Samuel Page <sam@bynar.io>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260622145243.3167276-1-sam@bynar.io
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/nci/ntf.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -603,6 +603,12 @@ static void nci_target_auto_activated(st
 	struct nfc_target *target;
 	int rc;
 
+	/* This is a new target, check if we've enough room */
+	if (ndev->n_targets == NCI_MAX_DISCOVERED_TARGETS) {
+		pr_debug("not enough room, ignoring new target...\n");
+		return;
+	}
+
 	target = &ndev->targets[ndev->n_targets];
 
 	rc = nci_add_new_protocol(ndev, target, ntf->rf_protocol,


