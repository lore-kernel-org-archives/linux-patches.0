Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636B11684AC;
	Tue, 11 Mar 2025 15:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706269; cv=none; b=Rdya+YwviGBtxB1Mv44wD2qp7AqxySB/gDUJNauP06cPzRjGeCD5T97q2cYeIb2dAow6ZtdpmThBEPrssXstJ5HaW7+XyvXAwgeL3Ihpqz9guiGwbenur/t2xP0Vgt1W5Q5rxA1bQ58E+oFFpR+Ig0ybA48l2Dzfz7DN0UXx7l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706269; c=relaxed/simple;
	bh=pPvubIf8rRulDpMR/CMycgTXjBmgamJJVoPciGMGTmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0aZ3NFyuo9CBgoEjDCLL+5B1cWRV07c+M66yGWITFwssGgGL9V/erJgC8cayyJ7cVTsE8OkMHky5/EvMuEO4wX2OqKEZoufsUxQjNiJATPzCJHQeeBBs4LCSGWfhYMjdL8F4w4DaGIS4UtLn7XtdIZ54fhPd6tEuhKW324khws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kaAgznrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kaAgznrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBDFC4CEE9;
	Tue, 11 Mar 2025 15:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706269;
	bh=pPvubIf8rRulDpMR/CMycgTXjBmgamJJVoPciGMGTmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaAgznrTpcQk3RUOST2utI3L+dDu7uNHIpqUdX+A7D/oRM4R/36iI0TSWVXlfN43l
	 lj7itY5p/VFavyub89NrNeAIlCxFX6z81BPnBwiNeW3sRG1e5a57ydcSzsS5EuxhVB
	 FV+3MbFDsemwQ0c63oXb8vdAVAwzEi6XAWzbwCYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 5.4 320/328] usb: gadget: Fix setting self-powered state on suspend
Date: Tue, 11 Mar 2025 16:01:30 +0100
Message-ID: <20250311145727.618575988@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit c783e1258f29c5caac9eea0aea6b172870f1baf8 upstream.

cdev->config might be NULL, so check it before dereferencing.

CC: stable <stable@kernel.org>
Fixes: 40e89ff5750f ("usb: gadget: Set self-powered based on MaxPower and bmAttributes")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20250220120314.3614330-1-m.szyprowski@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2366,7 +2366,8 @@ void composite_suspend(struct usb_gadget
 
 	cdev->suspended = 1;
 
-	if (cdev->config->bmAttributes & USB_CONFIG_ATT_SELFPOWER)
+	if (cdev->config &&
+	    cdev->config->bmAttributes & USB_CONFIG_ATT_SELFPOWER)
 		usb_gadget_set_selfpowered(gadget);
 
 	usb_gadget_vbus_draw(gadget, 2);


