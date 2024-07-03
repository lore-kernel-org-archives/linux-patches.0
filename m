Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DA31DFC7;
	Wed,  3 Jul 2024 10:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003866; cv=none; b=QQxxmKl6MMPPnt8vUdgvW3maWkz6312XSGR8KavJHEI6OVIVP4JfK3bY63seRbd88dQ+As+6YBMj1VMShOWF6b40nziDnUvJq6IAhVKm6Zvrq+/D0T1w63mlXNN3yvlP/HV/x+GHx24eypRfRaQXCZlyDTiUOA54vhW9shHXHvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003866; c=relaxed/simple;
	bh=4q8Hq8s2bZSXASQOQU0IB/KFf2FDbGRuzQJw9/6vn0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNSRtjU7RHjyn5OQca52Pk8x8IONQoSIReMbgkDZuP9i+M8YxcMbHvGG9C18Y2pfRKzY3CwEJ5xDIlN9qU+REA53w3sf2T7BcW/0Nhps5oY0bYzKphppleGxxs3U5svgIQDALIVyuEiuZlvr04aSkidcl82vntyZfWOen2b7JiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+DqT9Sn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+DqT9Sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3096C2BD10;
	Wed,  3 Jul 2024 10:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003866;
	bh=4q8Hq8s2bZSXASQOQU0IB/KFf2FDbGRuzQJw9/6vn0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+DqT9Sn/hsDehEpvsRm7xpku+gxEICwe4GCTkMkdCG2hxCAd8MRR2ucijgkajUPL
	 T6m6fAIlAlGzGnDXyeNfyx7xuRxPdoSsIi2tGF2ScrcbEONfSZXP/GPFO8LrNimJ4f
	 Xbau5SXZjSbDX+YkYDkDXh59kFA3/nkCOx70F4/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Tomon <pierretom+12@ik.me>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 046/189] xhci: Set correct transferred length for cancelled bulk transfers
Date: Wed,  3 Jul 2024 12:38:27 +0200
Message-ID: <20240703102843.251251436@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2343,9 +2343,8 @@ static int process_bulk_intr_td(struct x
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
 		    (ep_ring->err_count++ > MAX_SOFT_RETRY) ||


