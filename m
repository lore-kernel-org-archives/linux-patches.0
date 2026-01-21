Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107C8330678;
	Wed, 21 Jan 2026 18:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019687; cv=none; b=KuUifFKNW2QW73afYB13Cbze1HgSuEYtwhva2H3/wqrGVv4NEumoLOKHymBbGRUMfhyXjWVwypbVq6XycrAZEprzKt521jLF9MFBXu2ffhvfHuFragEUjN0QeMLkA63owCIUXtCbq4ME6qoaVLz+Ca4cuzy1xtfc+xgELK9m+Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019687; c=relaxed/simple;
	bh=MN8uCMr3/wcWkNc3prw0PYRanbmMEu6grlbiisQ0vyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsXaf8GCffBhfOqKOMukGn35wE/oplo/lZrio5+NGTDtzr3oh59liC7kLv8Fuvc/rosqAlzP8F+ymqkEzOk6WAfKCQRWcNI9wKUBQ0LbHGO7cIAV/cliL9IH8n8HemowJJfvhXDZxb80J9mxdD706kPzGynjFxZVjCSK0n4SDmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3KX8SlM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3KX8SlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A225C4CEF1;
	Wed, 21 Jan 2026 18:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019686;
	bh=MN8uCMr3/wcWkNc3prw0PYRanbmMEu6grlbiisQ0vyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3KX8SlMdXpY63SLINx9H2HiwOPcxBMT277Gv/l9H8Jffh437WAgBg629tOZaQSp7
	 6W1h5Tni0XgUjr4YbP7w8BV1iWKhWrJkxAtrmcAerVPngS6qP5EZFh+i6cIQMDoZk4
	 GgnOwvRiCP8VIlZOHYV5gs2j7gUYWKcaHSY2MFfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 078/139] usb: dwc3: Check for USB4 IP_NAME
Date: Wed, 21 Jan 2026 19:15:26 +0100
Message-ID: <20260121181414.260245661@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 0ed91d47959cb7573c17e06487f0fb891d59dfb3 upstream.

Synopsys renamed DWC_usb32 IP to DWC_usb4 as of IP version 1.30. No
functional change except checking for the IP_NAME here. The driver will
treat the new IP_NAME as if it's DWC_usb32. Additional features for USB4
will be introduced and checked separately.

Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/e6f1827754c7a7ddc5eb7382add20bfe3a9b312f.1767390747.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    2 ++
 drivers/usb/dwc3/core.h |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -988,6 +988,8 @@ static bool dwc3_core_is_valid(struct dw
 
 	reg = dwc3_readl(dwc->regs, DWC3_GSNPSID);
 	dwc->ip = DWC3_GSNPS_ID(reg);
+	if (dwc->ip == DWC4_IP)
+		dwc->ip = DWC32_IP;
 
 	/* This should read as U3 followed by revision number */
 	if (DWC3_IP_IS(DWC3)) {
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1254,6 +1254,7 @@ struct dwc3 {
 #define DWC3_IP			0x5533
 #define DWC31_IP		0x3331
 #define DWC32_IP		0x3332
+#define DWC4_IP			0x3430
 
 	u32			revision;
 


