Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741C0156F45;
	Tue,  9 Jul 2024 11:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523552; cv=none; b=k6DWH+MO/4UZd6bodXYzTNTaSsxYmJGUf5GeNXIx7WwXXbC7Rlx8tGHWSijm0GzThUiJ9P6rxS/Eubvq3cu7MLD3RZO6H8RNhXRL9UwB4P1Cjko3pUGZaIWUHGNSLAPUR2t5pQyqZfGEOhjCYpNQLlm3cyJz0YttFVj7P0+t4kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523552; c=relaxed/simple;
	bh=WrlZAf4i0bKN0ASVVUwoGv3K2ZAvUfCim3MUKsRfVkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhC29HMVCBz6UhseN4GTRNFffE1NsNcJtVdmHPA3okj3JnJPnYvg8SZLGWvrceLGDPTKznN9utqADIBUsoBTonMOZmGHzpmlyKUyXGfXPhmFIjmWVz4MscC5g/czOr6eQ8s0UrZH+OWXyXdAbQUH30prs92W5mgrpr20uU4+Bms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuXztWyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuXztWyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAC0C3277B;
	Tue,  9 Jul 2024 11:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523552;
	bh=WrlZAf4i0bKN0ASVVUwoGv3K2ZAvUfCim3MUKsRfVkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zuXztWyVk1ylCMR1ZiS4d0oqOh3D3pFbLSc6djWaSJPhneG988kzKsmIeM5f/dzE8
	 2NLVJr3kmTK2Xrkwg+tzYq85xNoED/TQu39o99rlPrmGuN4G+skHN5MVoBLzkaf0BO
	 WEcv/EbZo9X1ttkiMVg16dKEeVbFtTACm/kgWhxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/139] usb: xhci: prevent potential failure in handle_tx_event() for Transfer events without TRB
Date: Tue,  9 Jul 2024 13:08:51 +0200
Message-ID: <20240709110659.367695631@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8dd85221cd927..592dabc785152 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2649,16 +2649,17 @@ static int handle_tx_event(struct xhci_hcd *xhci,
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



