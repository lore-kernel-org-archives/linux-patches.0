Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453402AE96;
	Tue, 29 Apr 2025 18:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949891; cv=none; b=jlvXODWK4+m4VC8AuSFiYWDriUmTWy6dPXUDq+osDmL7IWG7LwFHlCSrE/SP6RjfES8F/1tB1pnRbkdRSJ5Wp4HzZBDx11LEgOSYQzbWW70WN/f5S56jY8cCdp1fAMP3mZnj01afxsCwPY/xpdFc8gqrd4Wm+eSrwGqZpNOBH4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949891; c=relaxed/simple;
	bh=Ipai51g7IyPyaZusXK5fQqwUq8LFc/w2DNauzjHeYaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHK3bArI/gpQh87/pm2zt5qhAz4aUVJWk2XUewH4N+CmYu9lh9zfzmyLN4uPL1udln4onS+Wdbxmy/mnJGsSWYS++IVOH00+76cCjNAzIDkwij7nCPKTbMjk0czYmrEvs6H7lVC3IbEph2dTgyK3FynAkFdwKBkRs5lb2/ZiQAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oZssgSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oZssgSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EDFC4CEE3;
	Tue, 29 Apr 2025 18:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949891;
	bh=Ipai51g7IyPyaZusXK5fQqwUq8LFc/w2DNauzjHeYaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0oZssgSEsscrECWk9mGlpeiBLFaZy/gJYVmle2AtVOk2NUYenckaEEPIk316z6Z7x
	 DwNmAhf3tCXWvHib0jTYiYdm/NG1Cz4aCCn4pgZrWar09d+brADJ8XlARTudUGUZP/
	 Aw90WgtElg4//xjpjUbypk9QgmCOrFy+5Hbj/aq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frode Isaksen <frode@meta.com>,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 088/167] usb: dwc3: gadget: check that event count does not exceed event buffer length
Date: Tue, 29 Apr 2025 18:43:16 +0200
Message-ID: <20250429161055.314454903@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4409,6 +4409,12 @@ static irqreturn_t dwc3_check_event_buf(
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
 


