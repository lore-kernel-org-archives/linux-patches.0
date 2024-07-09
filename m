Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4A415884A;
	Tue,  9 Jul 2024 11:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524023; cv=none; b=g4UP7ZpDUv1D9oB/Sp/YuJaV4O5HgsGGc6ewzgBgG7XAG3CoOJdBI4mmnMaYM9PEOALeyPpuiZgtMCHvd6kYsqr0lGJ0Y3hRbci6VFL+YKNiIE/5RZdkktCWNmz9w940I3NZTjm48EZvyS7U2fh5mWNYnaFpdQMSQR/4hgHmyEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524023; c=relaxed/simple;
	bh=KDcb6QXehaTySbpErT7UBGtRZMF67jo0qaVQ1b2w/d8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqnAevcjy2FLWQ2y0MLxp4T5ZN8dJxLkiNOwH+X2wJkcx9VU6djLZb7kGWZAKL1UWKsTKRPRqEYD/YoJGsRVSA6SrOP0HtZW5r+P9vtYYjK545NeXV3UqLEeRhys0lG6s7PpJ385/j3VKSou/FknBu3WEzuEo4mStaErOk8R0gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osn9AR8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osn9AR8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D700AC3277B;
	Tue,  9 Jul 2024 11:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524023;
	bh=KDcb6QXehaTySbpErT7UBGtRZMF67jo0qaVQ1b2w/d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osn9AR8FoO1EV8wXUfd6JkC4lTuGBXuYalrsblM4moQvxz9S5EtUcPzslLPoBAN+q
	 vzaH4VG9pV4GGv9u8OoXAru95gMUQ90ujZXtMcwixjK7XfbQrcaaZBzsbscHyCYq/A
	 H5oPtk8msnKuR3e/vzqfKXpa8I3ErsBwpfnd3dRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 046/197] usb: xhci: prevent potential failure in handle_tx_event() for Transfer events without TRB
Date: Tue,  9 Jul 2024 13:08:20 +0200
Message-ID: <20240709110710.746776125@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Neronin <niklas.neronin@linux.intel.com>

[ Upstream commit 66cb618bf0bb82859875b00eeffaf223557cb416 ]

Some transfer events don't always point to a TRB, and consequently don't
have a endpoint ring. In these cases, function handle_tx_event() should
not proceed, because if 'ep->skip' is set, the pointer to the endpoint
ring is used.

To prevent a potential failure and make the code logical, return after
checking the completion code for a Transfer event without TRBs.

Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240429140245.3955523-11-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 48d745e9f9730..48028bab57e34 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2658,16 +2658,17 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 			else
 				xhci_handle_halted_endpoint(xhci, ep, NULL,
 							    EP_SOFT_RESET);
-			goto cleanup;
+			break;
 		case COMP_RING_UNDERRUN:
 		case COMP_RING_OVERRUN:
 		case COMP_STOPPED_LENGTH_INVALID:
-			goto cleanup;
+			break;
 		default:
 			xhci_err(xhci, "ERROR Transfer event for unknown stream ring slot %u ep %u\n",
 				 slot_id, ep_index);
 			goto err_out;
 		}
+		return 0;
 	}
 
 	/* Count current td numbers if ep->skip is set */
-- 
2.43.0



