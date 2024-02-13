Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD0D5FF17;
	Tue, 13 Feb 2024 17:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845917; cv=none; b=e/vDQvyI2k/BDG5k+G2NaaWjbpyznonsINjZDEBDXTkG7LM600wR2M1LGUdCEYEVgOWnMOTS7Ui9kRXij7rbVmO5OAui1LUOj/pqWZTl27lubBBSi3+hhjp9RIQp3c8aSwqbJw4iwQXtLLSwyGjX5pjzdN7Gc9GdhUukLlo7uWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845917; c=relaxed/simple;
	bh=oGjyu6UfakIjYL8G120W4SQUDDh0YKxAscUQezdmKTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X70Axr2fkPP7XrV/w1/HPJqlrc/eDEFE9pruhy9XdwTvEv+yXOAjrzoQBEAhbdleVraUic/VZjhF6K6CY9nF+np5U8ioWhKe6QrYISPl2+pM3DW4WCQJTNRoF8X/9yYUxZoNnzhx4lUZGl+l6UbX7qz2dw2RiCtsJXrTflbXHsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u55ftIH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u55ftIH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9A7C433F1;
	Tue, 13 Feb 2024 17:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845917;
	bh=oGjyu6UfakIjYL8G120W4SQUDDh0YKxAscUQezdmKTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u55ftIH3FBJA74UTozla7hsdgS86Czfu8st0yeR5g2AjS5mgKx+xubO6HlDvsgTDo
	 x/veLTPtMCd1evh0GhYkXHEJbIxsbur9JkZL4JyGwrHU1cERe5SFQ6IjTZLNzI8Rkl
	 U3Pd3XeR9mfj/e7ws9eY0Yc2AogUn0K3wznGURA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.7 096/124] usb: dwc3: host: Set XHCI_SG_TRB_CACHE_SIZE_QUIRK
Date: Tue, 13 Feb 2024 18:21:58 +0100
Message-ID: <20240213171856.534377157@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <quic_prashk@quicinc.com>

commit 817349b6d26aadd8b38283a05ce0bab106b4c765 upstream.

Upstream commit bac1ec551434 ("usb: xhci: Set quirk for
XHCI_SG_TRB_CACHE_SIZE_QUIRK") introduced a new quirk in XHCI
which fixes XHC timeout, which was seen on synopsys XHCs while
using SG buffers. But the support for this quirk isn't present
in the DWC3 layer.

We will encounter this XHCI timeout/hung issue if we run iperf
loopback tests using RTL8156 ethernet adaptor on DWC3 targets
with scatter-gather enabled. This gets resolved after enabling
the XHCI_SG_TRB_CACHE_SIZE_QUIRK. This patch enables it using
the xhci device property since its needed for DWC3 controller.

In Synopsys DWC3 databook,
Table 9-3: xHCI Debug Capability Limitations
Chained TRBs greater than TRB cache size: The debug capability
driver must not create a multi-TRB TD that describes smaller
than a 1K packet that spreads across 8 or more TRBs on either
the IN TR or the OUT TR.

Cc: stable@vger.kernel.org #5.11
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240116055816.1169821-2-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/host.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -61,7 +61,7 @@ out:
 
 int dwc3_host_init(struct dwc3 *dwc)
 {
-	struct property_entry	props[4];
+	struct property_entry	props[5];
 	struct platform_device	*xhci;
 	int			ret, irq;
 	int			prop_idx = 0;
@@ -89,6 +89,8 @@ int dwc3_host_init(struct dwc3 *dwc)
 
 	memset(props, 0, sizeof(struct property_entry) * ARRAY_SIZE(props));
 
+	props[prop_idx++] = PROPERTY_ENTRY_BOOL("xhci-sg-trb-cache-size-quirk");
+
 	if (dwc->usb3_lpm_capable)
 		props[prop_idx++] = PROPERTY_ENTRY_BOOL("usb3-lpm-capable");
 


