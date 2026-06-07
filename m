Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C984071DD;
	Sun,  7 Jun 2026 10:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829575; cv=none; b=ryvjgmb/9LovSK4Uag4iWrOlZGbMCS28lHusXYNdjqcs8pyAe62mItPlFBf1ZU7gGXHaBzcA8JPxlDsa8H3h4BmJESHi8jAkpTbtr9+PVyeRGZYBXgAisIrk+J1SXMCvRL4Kk7Ee0sE0tCLtF/SGMXFCeRUnyI9VPC6Ps8RiWJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829575; c=relaxed/simple;
	bh=Ng/BSM1M0b2qV8HSLf5jLt5n8HT4wItl/xFjirA1jPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R21Wf4k7YrTRBeh7zUUS1hwBf5ONaj/yLYdlZ9kpN0hGIXJAzokMBYnYnD8uAzgIYEo0D3PxohPfJ04R6KzvLgIUVd9vFx2ahog7EipyGlJ45EolEW1Rcvz+XagSAAw+oCaO/glu8eP88LazRvjWlb47OwhoKkx3PyBs16uI9PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNHph5vz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNHph5vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5879D1F00893;
	Sun,  7 Jun 2026 10:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829574;
	bh=uwdSMhxYFaAWTlSS9x37sJaShDbNFTuPOpLPOrjrbX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNHph5vzl90PFfHyNDtzjgiw0gfY7+8yPeEtEJL6+lqd3rgxukflir/v3i9J5YSVz
	 4hZDzoU8Cq8/CNstPNgIXrQE8thWGAEFL3kFooa0joN/QjrbnWyiBsN68fM/WRpVb3
	 NLY06S7aNzCCmMUkg/u8x+VNvkmo8A1oH5XXptNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.0 270/332] USB: serial: mxuport: fix memory corruption with small endpoint
Date: Sun,  7 Jun 2026 12:00:39 +0200
Message-ID: <20260607095737.957454547@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 4085f0dbb1ce2251c9a5938d693de6593f0ab2bd upstream.

Make sure that the bulk-out endpoint max packet size is at least eight
bytes to avoid user-controlled slab corruption should a malicious device
report a smaller size.

Fixes: ee467a1f2066 ("USB: serial: add Moxa UPORT 12XX/14XX/16XX driver")
Cc: stable@vger.kernel.org	# 3.14
Cc: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/mxuport.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/mxuport.c
+++ b/drivers/usb/serial/mxuport.c
@@ -962,6 +962,14 @@ static int mxuport_calc_num_ports(struct
 	 */
 	BUILD_BUG_ON(ARRAY_SIZE(epds->bulk_out) < 16);
 
+	/*
+	 * The bulk-out buffers must be large enough for the four-byte header
+	 * (and following data), but assume anything smaller than eight bytes
+	 * is broken.
+	 */
+	if (usb_endpoint_maxp(epds->bulk_out[0]) < 8)
+		return -EINVAL;
+
 	for (i = 1; i < num_ports; ++i)
 		epds->bulk_out[i] = epds->bulk_out[0];
 


