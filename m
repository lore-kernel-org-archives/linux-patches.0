Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767B282C60;
	Tue, 29 Apr 2025 17:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948033; cv=none; b=kegJIDZG1+LFvGX9+GaDBGiz0MwsdGdIILcpyJSm6QMWPxvIglCuMRw1X059FVvvrV3Dgm6MmWENtnAxE395gI84LDcbWW1WqEoDZUfk82uyt4kl/tGxyceZq5WWJDj5gW3jUOO0EKC+6c3OPpaQ/Kp7F5j2A6DdUesdg2wArMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948033; c=relaxed/simple;
	bh=2aH3gqOA7i7lbIMRCZ6tACvlOaJfJjdsUv6lxnhDewU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZU8RJBEUdkfPvnn1a8IRywcl2oYry/JBsq13B7SlDNJii2XrwYIYGfUxSdkZeh/M7jE6S3TRf0InPA6mEAfCT2gn2BptyYf8lCQWhz15CQ6r0jtxYcJ4ZvSDcdGPZVRkPOrFMA8MElY+2G/ICWOFElvr9xRrI/Csrq41DnYv7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J87OU4KK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J87OU4KK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4012C4CEE3;
	Tue, 29 Apr 2025 17:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948033;
	bh=2aH3gqOA7i7lbIMRCZ6tACvlOaJfJjdsUv6lxnhDewU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J87OU4KKELLC5GerHyKmZPPW6UvYJ3XcuXUL9DUvdiYRHp4z390joEi0n4oesE0Wl
	 bUL6b6MbcRfZ/RJPxMxBXXB6j1ne5BfYAKYXcTQTBXF1hRWXfGzHy4/gnbFeCzzgoa
	 k+3/xAdlpVpiacuPjNkfQ0G8afCDTMM4PynwWuJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frode Isaksen <frode@meta.com>,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 143/280] usb: dwc3: gadget: check that event count does not exceed event buffer length
Date: Tue, 29 Apr 2025 18:41:24 +0200
Message-ID: <20250429161120.976467449@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Frode Isaksen <frode@meta.com>

commit 63ccd26cd1f6600421795f6ca3e625076be06c9f upstream.

The event count is read from register DWC3_GEVNTCOUNT.
There is a check for the count being zero, but not for exceeding the
event buffer length.
Check that event count does not exceed event buffer length,
avoiding an out-of-bounds access when memcpy'ing the event.
Crash log:
Unable to handle kernel paging request at virtual address ffffffc0129be000
pc : __memcpy+0x114/0x180
lr : dwc3_check_event_buf+0xec/0x348
x3 : 0000000000000030 x2 : 000000000000dfc4
x1 : ffffffc0129be000 x0 : ffffff87aad60080
Call trace:
__memcpy+0x114/0x180
dwc3_interrupt+0x24/0x34

Signed-off-by: Frode Isaksen <frode@meta.com>
Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable <stable@kernel.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20250403072907.448524-1-fisaksen@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4570,6 +4570,12 @@ static irqreturn_t dwc3_check_event_buf(
 	if (!count)
 		return IRQ_NONE;
 
+	if (count > evt->length) {
+		dev_err_ratelimited(dwc->dev, "invalid count(%u) > evt->length(%u)\n",
+			count, evt->length);
+		return IRQ_NONE;
+	}
+
 	evt->count = count;
 	evt->flags |= DWC3_EVENT_PENDING;
 


