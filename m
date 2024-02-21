Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414CD55E5E;
	Wed, 21 Feb 2024 13:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523188; cv=none; b=W7crS4beEj0avlmo4XV+dtc6PaCSMLtj22tNHRdRm8Lnihe+MFEWnwWOE1CeIJGa1MEyTaP01kNSwOAQ+42A7TE1S9mXJuO0UWeG5YrUJPZs/ff+CkaptZGwusR5SHlzmMTNJYNsV1e0u1rqHYMrrMikyskMUWMiFCW+YbPthNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523188; c=relaxed/simple;
	bh=VXFmQ1PPQDsQh3+JYT1wWzYQpTeLBMteiUg5J/6mFgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghNDTPdpayZ3ItRWVmuna3+FKqcLrwl211kXLsmFTiDgwGtIQUiLWvhiXUEny6ZqTHOV+DKYlQbJlmxnxWUche/z3cdivMQGHqxvF8BuYoJkkoGNmPqWTIZP7hwlYMQlr4P65nHJEjRZ2HUz+F408MMla4dwk/lmkTXZPh9CkXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECJeLfz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECJeLfz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBE6C433C7;
	Wed, 21 Feb 2024 13:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523187;
	bh=VXFmQ1PPQDsQh3+JYT1wWzYQpTeLBMteiUg5J/6mFgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECJeLfz4/55NUBEl0kiFk2Qb5UmHdzkgxmMbolHfuXGDTVvOm/QsyHHLaEKiGSSBc
	 FcFXFFH64gWLtxAGlp3vonkP9GW6En9kcnf/ReMXWcZHVh1MyUbsWriUVZipnjBr0I
	 ocUYqtDO9uJ8eOfD855cmjl326ueui9e5pZtpBI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>
Subject: [PATCH 5.15 335/476] usb: host: xhci-plat: Add support for XHCI_SG_TRB_CACHE_SIZE_QUIRK
Date: Wed, 21 Feb 2024 14:06:26 +0100
Message-ID: <20240221130020.400552874@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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


