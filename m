Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D9D633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E56C433D6;
	Wed,  2 Nov 2022 03:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360355;
	bh=12LgcmT017woH4tMBS7Fo2QQY14KAHEDk7TBgZCEe3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aaGVEQpl1ZIVv+Dlbp611WmDUKlHNIbnqM2m0khAuzV5uS23B2Pbv06eL7v+a6ZZA
	 b6f0vU8rxz9MyqmP0c0EsQU2tnkKnjm49/cL0HZ+SjsdMTURhKM94ZNMGnFMKZ63/p
	 tbUjsBuDErNuSbXDvWJ1bWtOR0OK7l3OWFmC9JII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.14 23/60] xhci: Remove device endpoints from bandwidth list when freeing the device
Date: Wed,  2 Nov 2022 03:34:44 +0100
Message-Id: <20221102022051.842739715@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
References: <20221102022051.081761052@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 5aed5b7c2430ce318a8e62f752f181e66f0d1053 upstream.

Endpoints are normally deleted from the bandwidth list when they are
dropped, before the virt device is freed.

If xHC host is dying or being removed then the endpoints aren't dropped
cleanly due to functions returning early to avoid interacting with a
non-accessible host controller.

So check and delete endpoints that are still on the bandwidth list when
freeing the virt device.

Solves a list_del corruption kernel crash when unbinding xhci-pci,
caused by xhci_mem_cleanup() when it later tried to delete already freed
endpoints from the bandwidth list.

This only affects hosts that use software bandwidth checking, which
currenty is only the xHC in intel Panther Point PCH (Ivy Bridge)

Cc: stable@vger.kernel.org
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20221024142720.4122053-5-mathias.nyman@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mem.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -911,15 +911,19 @@ void xhci_free_virt_device(struct xhci_h
 		if (dev->eps[i].stream_info)
 			xhci_free_stream_info(xhci,
 					dev->eps[i].stream_info);
-		/* Endpoints on the TT/root port lists should have been removed
-		 * when usb_disable_device() was called for the device.
-		 * We can't drop them anyway, because the udev might have gone
-		 * away by this point, and we can't tell what speed it was.
+		/*
+		 * Endpoints are normally deleted from the bandwidth list when
+		 * endpoints are dropped, before device is freed.
+		 * If host is dying or being removed then endpoints aren't
+		 * dropped cleanly, so delete the endpoint from list here.
+		 * Only applicable for hosts with software bandwidth checking.
 		 */
-		if (!list_empty(&dev->eps[i].bw_endpoint_list))
-			xhci_warn(xhci, "Slot %u endpoint %u "
-					"not removed from BW list!\n",
-					slot_id, i);
+
+		if (!list_empty(&dev->eps[i].bw_endpoint_list)) {
+			list_del_init(&dev->eps[i].bw_endpoint_list);
+			xhci_dbg(xhci, "Slot %u endpoint %u not removed from BW list!\n",
+				 slot_id, i);
+		}
 	}
 	/* If this is a hub, free the TT(s) from the TT list */
 	xhci_free_tt_info(xhci, dev, slot_id);


