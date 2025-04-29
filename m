Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9952512D9;
	Tue, 29 Apr 2025 16:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945651; cv=none; b=DkbkUdjhy2jIIjaxTs1VeKF34ob9KV/lARjCzdaMBuFS4AvGnwmylvJ/Yh/oKiTlsT2MgqDBsTjfDFKgkZrrj+bID/cctpTDd0Sm+qBYOYEQ2ofraNyuLHCqYH2eRT27n4G2LzzXz7AiNEPjA1qB+AkqMieZCzI4a2d25h203is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945651; c=relaxed/simple;
	bh=VVyXOE5jYNS1UHKfgdM5KSR57vMQByxmsfA6yuBoAwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IU83unf3zmW+HEimmICYu3kdyOlsfdL1xl9jymU/u75F32d0KgIJUMAWkVni7sqPnnaNkv5yTLk9MZGwUMJRCGZJLKigLBqvRV8U5kn8K9zLf4f8kJz63yNVMLA7mIMR7rh98VjBSJkow7wbRI8OnFn0k8E/2Ak2wOj1wg8bHik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKM49Bb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKM49Bb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B81C4CEE3;
	Tue, 29 Apr 2025 16:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945651;
	bh=VVyXOE5jYNS1UHKfgdM5KSR57vMQByxmsfA6yuBoAwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKM49Bb0eH7O63S0rmCmNmIFT60eFb727IMRbdAzqkRluoUnx5mRYcZI9HaihZD1/
	 F5/oW+6wSvGLi7F5kyZRe7JD4rhG0McDsXRUlKEPn6e3ic/6V5kvPB+cZffG/Dl1bi
	 IL3SL7ydfRRJr2wcbnCcry5Ini+JdXmW8XVUNRgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frode Isaksen <frode@meta.com>,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.4 155/179] usb: dwc3: gadget: check that event count does not exceed event buffer length
Date: Tue, 29 Apr 2025 18:41:36 +0200
Message-ID: <20250429161055.651242786@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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
@@ -3652,6 +3652,12 @@ static irqreturn_t dwc3_check_event_buf(
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
 


