Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8977E3FF8BA;
	Tue, 25 Aug 2026 13:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664770; cv=none; b=D981v9u8cZyshovfm+WXszwzEeNRirdz33rYVjGAFRpyCRAEFtzkIPrDgtUXZO/TmH9Hb7Jaz0FZBorP7IYsy9E/SGBeg/Axe0gbLtHf0M8RaxiCoeGjrZKzhny1XncJBVCLYxRLH4S1noHGcXI2XKgUxM+iWnB1kDef7QTMOE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664770; c=relaxed/simple;
	bh=NSjby5JSCwaKqARN3FRwUdTRBMOaZbzU6tX+EOxZyzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcJDFmmUtdcSTBYo41py0oqKKZuEp1H5KgkkjbIY6sKOitZbYfBFsglCLDSvMAQyp7NEce1j7awJBiM0w2VUTI+3HHLUiLs/i6FkA1ZWJWLTF32xnKgajMKhn28yL3PP6OyN8ah2sOcmLduaQajiANilL5ZlcgC8SlX97PZHwcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JRnfdpV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JRnfdpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0471F000E9;
	Tue, 25 Aug 2026 13:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664769;
	bh=WaQSncYZ821i2gg6QU+zjB3QPweyr3Y+1R/2/M/eEg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JRnfdpVsm6ZEb5Paviyyz8ppjSVlAfcEvuhUlyZmAqjtGWyYnZrToqZRLEMpvGFF
	 h2yi8lerY2CIVBJ9lHkdQBwMW9vJji4lQndHYVzlM05dXhSJX1GCRl8XK3lN7Mj5jB
	 jXF8bp+SPb5jo32Rq/u6sNHX+LoaMqY3bHeDYel0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Page <sam@bynar.io>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 7.2 43/82] nfc: nci: fix out-of-bounds write in nci_target_auto_activated()
Date: Tue, 25 Aug 2026 15:25:30 +0200
Message-ID: <20260825132543.196771899@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -619,6 +619,12 @@ static void nci_target_auto_activated(st
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


