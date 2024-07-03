Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CC7181B9A;
	Wed,  3 Jul 2024 11:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005511; cv=none; b=VpUy1Rxc2XWzVCdsri5kDoGT7sNveFwE5sD5hD5jPq9Rq+vfOgFiAEy49cdbgzt8G+CIcXyjLplbR5RdrwTuzzfW7Yt7kAcxDImuBB85wl7AnvUmQ2/iNRlKEgao6aa0J2ydnm4Eq1XwcIeu94YnXYtvdeeSrUR/VfgcmPFqZps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005511; c=relaxed/simple;
	bh=vccb+btgH162YNSprVbU7NBk7EhMzFfvaDUMB5UEAnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqaTowB1JEnVkiwIqsxqTRXPG8TitPI07AIXEuGqCT0Rt7xCtekQtWqIDXZlUqxl1fLqofRXQI58Pnf4cNPh+4W+LbLpZpsL4X+7FN2Wxj8yY+H7xYObgQ09uXIwXPDuK2Q49GRA5PQHX5Ssi/AOlOhGhk7vXw0bRTez1YmneUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmyjG0HR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmyjG0HR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89EBC2BD10;
	Wed,  3 Jul 2024 11:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005511;
	bh=vccb+btgH162YNSprVbU7NBk7EhMzFfvaDUMB5UEAnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmyjG0HRaCaYM6kni2ysPzAwKf+GyXPiDZEJS9yZY8TveA3ue0O9pnPl+FQmbLnLg
	 7uGZM2u35V7f3WFsI+x5DAEk3hPnZleQdxiAvXPpZuzoiLIj8dYZ41plAEAr0/yjmS
	 TnDRXr+x9Jvthcsfo8xe1HEmVJT0xdS7t7FSTv9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Tomon <pierretom+12@ik.me>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 078/356] xhci: Set correct transferred length for cancelled bulk transfers
Date: Wed,  3 Jul 2024 12:36:54 +0200
Message-ID: <20240703102916.054181703@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit f0260589b439e2637ad54a2b25f00a516ef28a57 upstream.

The transferred length is set incorrectly for cancelled bulk
transfer TDs in case the bulk transfer ring stops on the last transfer
block with a 'Stop - Length Invalid' completion code.

length essentially ends up being set to the requested length:
urb->actual_length = urb->transfer_buffer_length

Length for 'Stop - Length Invalid' cases should be the sum of all
TRB transfer block lengths up to the one the ring stopped on,
_excluding_ the one stopped on.

Fix this by always summing up TRB lengths for 'Stop - Length Invalid'
bulk cases.

This issue was discovered by Alan Stern while debugging
https://bugzilla.kernel.org/show_bug.cgi?id=218890, but does not
solve that bug. Issue is older than 4.10 kernel but fix won't apply
to those due to major reworks in that area.

Tested-by: Pierre Tomon <pierretom+12@ik.me>
Cc: stable@vger.kernel.org # v4.10+
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240611120610.3264502-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2570,9 +2570,8 @@ static int process_bulk_intr_td(struct x
 		goto finish_td;
 	case COMP_STOPPED_LENGTH_INVALID:
 		/* stopped on ep trb with invalid length, exclude it */
-		ep_trb_len	= 0;
-		remaining	= 0;
-		break;
+		td->urb->actual_length = sum_trb_lengths(xhci, ep_ring, ep_trb);
+		goto finish_td;
 	case COMP_USB_TRANSACTION_ERROR:
 		if (xhci->quirks & XHCI_NO_SOFT_RETRY ||
 		    (ep->err_count++ > MAX_SOFT_RETRY) ||


