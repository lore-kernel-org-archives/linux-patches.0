Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8885F54E;
	Tue, 13 Feb 2024 17:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845118; cv=none; b=ixN3kiWKNsWO1PuXZxukwImkCeb0G/8sJdb0Q8A07MX+2UFok1Kt4srqcfNNHV69HnyB4nyl+O3l5XVHYxdVxem8cxN6salMI0Eul294V2V9iOpYgN4WcHVwKU3yMm7AoMHmpAir7GrU6ERoQlMSI8mYViB11xFq6UMcxb+1YQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845118; c=relaxed/simple;
	bh=MuC3jRzOltyQPTUwSV9kkZSQ+XkaeMNshE+4nzBouns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNxLISbZv1WJXB5I3kU8tUZfYUeRZkNAkhGMX5n91Te+DIke9UtMnZ76RTG+epxvaPrpIkwgBkUP/J/CS2MI1knodgR/IJxNLodoYTL8PcGcDue95+jp/uBD20nI9O0YLxAkmN2WG1QAPQNmQ3XPl78THtYuU1RNKK+JYYCYVgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2u43duS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2u43duS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CE7C433C7;
	Tue, 13 Feb 2024 17:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845118;
	bh=MuC3jRzOltyQPTUwSV9kkZSQ+XkaeMNshE+4nzBouns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2u43duSHzOkniqhIW26cgFxtIrQ6QYCM8uzsPdTHFGDtcWDMl52nWC2ky8B/3N/E
	 wrYysswYGcm6QPTZhWIVbIpzIh2ilo7v+2CHaTA8+gTUyFauBPj2D0G1pnJFMfNElc
	 aexSJwmbN3LddpEK4Y7OMiTtE+WywX0IF2xUMy9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>
Subject: [PATCH 6.1 52/64] usb: host: xhci-plat: Add support for XHCI_SG_TRB_CACHE_SIZE_QUIRK
Date: Tue, 13 Feb 2024 18:21:38 +0100
Message-ID: <20240213171846.372244974@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -301,6 +301,9 @@ static int xhci_plat_probe(struct platfo
 		if (device_property_read_bool(tmpdev, "quirk-broken-port-ped"))
 			xhci->quirks |= XHCI_BROKEN_PORT_PED;
 
+		if (device_property_read_bool(tmpdev, "xhci-sg-trb-cache-size-quirk"))
+			xhci->quirks |= XHCI_SG_TRB_CACHE_SIZE_QUIRK;
+
 		device_property_read_u32(tmpdev, "imod-interval-ns",
 					 &xhci->imod_interval);
 	}


