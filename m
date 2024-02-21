Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC30A7F7D0;
	Wed, 21 Feb 2024 14:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524548; cv=none; b=Wk3zOlMQxc9P2gonQoMXAtYxwKIj8kY5a0Fsub1eYlLFTOlqubqpCeXr7DuPIC2/nj4OBxT2DXViNfK5hSzX3JFxmfTCJ3r6XxPRRrHTjYhrNjJEswYDguPVOcbvIrtQgV+iZDCb5qV+ZtCcUiiV0cK6XghmLgyncFnEPCXc6y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524548; c=relaxed/simple;
	bh=i1w0FNdiKWmtMLGER3PJaZxKt1ShPqsZ+1NwVAWaKGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8uZL3/NHvN69os1zE0RRMGGgLCFZjwKQcXFKr3XVbHP1qRMCA+4+sk4TLafUJTfVtOebvzRG8RYGOj8cQHMYx9t0SVdtGKzyBoIX4qMkSynvksP+JrNLROQIO3DCIxs8+19lfKwY6l7COwFC39YXjEumRfgl557Ech2ZC1igz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ij51gGIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ij51gGIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C3FC433C7;
	Wed, 21 Feb 2024 14:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524548;
	bh=i1w0FNdiKWmtMLGER3PJaZxKt1ShPqsZ+1NwVAWaKGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ij51gGIzVjDMEmThQwNjejTqWhGOILz6168TvOcteJyWJPzRj61rvdFrsRbNKeH+k
	 ZR1bUeTPYCa2T4p2dtjEebFeJcG2FP9nAkizYM+kxEJUTrf7OyoG+Crm1lnWixc8U/
	 Im7SbCgiQlWBIYFUGVAyX4xVZ9bPijp5M7UFFNYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>
Subject: [PATCH 5.10 277/379] usb: host: xhci-plat: Add support for XHCI_SG_TRB_CACHE_SIZE_QUIRK
Date: Wed, 21 Feb 2024 14:07:36 +0100
Message-ID: <20240221130003.099134030@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <quic_prashk@quicinc.com>

commit 520b391e3e813c1dd142d1eebb3ccfa6d08c3995 upstream.

Upstream commit bac1ec551434 ("usb: xhci: Set quirk for
XHCI_SG_TRB_CACHE_SIZE_QUIRK") introduced a new quirk in XHCI
which fixes XHC timeout, which was seen on synopsys XHCs while
using SG buffers. Currently this quirk can only be set using
xhci private data. But there are some drivers like dwc3/host.c
which adds adds quirks using software node for xhci device.
Hence set this xhci quirk by iterating over device properties.

Cc: stable@vger.kernel.org # 5.11
Fixes: bac1ec551434 ("usb: xhci: Set quirk for XHCI_SG_TRB_CACHE_SIZE_QUIRK")
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Link: https://lore.kernel.org/r/20240116055816.1169821-3-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -323,6 +323,9 @@ static int xhci_plat_probe(struct platfo
 		if (device_property_read_bool(tmpdev, "quirk-broken-port-ped"))
 			xhci->quirks |= XHCI_BROKEN_PORT_PED;
 
+		if (device_property_read_bool(tmpdev, "xhci-sg-trb-cache-size-quirk"))
+			xhci->quirks |= XHCI_SG_TRB_CACHE_SIZE_QUIRK;
+
 		device_property_read_u32(tmpdev, "imod-interval-ns",
 					 &xhci->imod_interval);
 	}


