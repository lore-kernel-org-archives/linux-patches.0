Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8418F233721;
	Mon, 10 Mar 2025 17:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628491; cv=none; b=Efzc5cyJnJh8CUrp9a7SKK6hE5KT1omKpcikIORoNQ2lQIULQuSaDyCUSRdKfeLhcyh9Zthe+8lfmLju7nWoCVt40BrL9Ypjzmn2Il987fqjW8vpKYhk1BjYzIbk4/CMc9Ax5dCNO8tT8yufveXaZw7RzCfeAqWELkamEPBZcDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628491; c=relaxed/simple;
	bh=fZPJ/dcaZkftXrlB863OovcVLqgoP0twzpB7jzUjgT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+aD3m2uQkTeJSEGzf0ttP0M9iLSRoDzzyVCav0z9QQZ7Q1AX7Nl50eopy4rcPALmXTp+1lP7jAiddnWHc60/XSbShUgrgfn2cx1Sw2BmPdZQKvoKYSJsEoouvJPTVHbHpruvc/KXBi9tadoG3kxY6JxH1FLfMXRkcGVJV6Qh2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkfAliVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkfAliVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D27DC4CEE5;
	Mon, 10 Mar 2025 17:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628491;
	bh=fZPJ/dcaZkftXrlB863OovcVLqgoP0twzpB7jzUjgT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkfAliVk11ID+Bwm3CE59Z2ft/p1FxQ9FOVmvMCpmw6/CXUGO2bWBODsKOBLi+Mac
	 8Fit6vuUf9xF09k8POTpr3PlKgx3Vm/Y2gSmU93o9z4POaBCCovEuhOx3+IIYY4qiP
	 xdiujC1Ao+k3idXY9bqff4eeaYGPBwwVaAkD3CJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 6.1 076/109] usb: gadget: Check bmAttributes only if configuration is valid
Date: Mon, 10 Mar 2025 18:07:00 +0100
Message-ID: <20250310170430.585115412@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

From: Prashanth K <prashanth.k@oss.qualcomm.com>

commit 8e812e9355a6f14dffd54a33d951ca403b9732f5 upstream.

If the USB configuration is not valid, then avoid checking for
bmAttributes to prevent null pointer deference.

Cc: stable <stable@kernel.org>
Fixes: 40e89ff5750f ("usb: gadget: Set self-powered based on MaxPower and bmAttributes")
Signed-off-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250224085604.417327-1-prashanth.k@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1019,7 +1019,7 @@ static int set_config(struct usb_composi
 		usb_gadget_set_remote_wakeup(gadget, 0);
 done:
 	if (power > USB_SELF_POWER_VBUS_MAX_DRAW ||
-	    !(c->bmAttributes & USB_CONFIG_ATT_SELFPOWER))
+	    (c && !(c->bmAttributes & USB_CONFIG_ATT_SELFPOWER)))
 		usb_gadget_clear_selfpowered(gadget);
 	else
 		usb_gadget_set_selfpowered(gadget);


