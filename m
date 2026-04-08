Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3413D75AF;
	Wed,  8 Apr 2026 18:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673560; cv=none; b=JkiJLki9FMdrbrvvuO+Qn6Ttc24b8n8j7O6NCD0ES2VV3fOJq1Q2TPZxUX8vpUMMT2Cgh2Ct0T+3z07iTXjjLPPV8e/9hRavI2BksEwe275Gv1G3ZaloVdaxm9ANXKj1IS8aRx9vnxaLZTR9VvirvDlBXpbKPvXx+69lNEGmQtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673560; c=relaxed/simple;
	bh=s67T6pENCQm5vPsiByc3heG0a5lAfwNFErsBcQ+kfwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFvHyucyeXohosDIvt5AJ7pQGsJAIPtZpQADK0gpzSeRKyjoPJDTsa8uhh2SBV60DtYslbw96GcjMQsmQVGTFq+4s7lPL1hVQsoP/fQqJgqiaFSiBzl/wW2jwKWOZf8bzJeqKEGgclqyo9+R0B51vNvqFy3xCSRqtElGpYUPL+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gKYKpgjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gKYKpgjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C18C19421;
	Wed,  8 Apr 2026 18:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673560;
	bh=s67T6pENCQm5vPsiByc3heG0a5lAfwNFErsBcQ+kfwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gKYKpgjZgeK3B+foWA2+EfFAn31twQT5mGHdqf34p06uMqHG6/DlXxmrdyRyWanRS
	 jCT/6oB7nSsDisgaUFqL+y4kdrlNlQuTe9p44cfdkQpF19VxXIPTI7jljBCtDd10Ou
	 HVYVPCeAxGCG7p0iq+56xUBuiKAZRgTgeEje6CYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	stable <stable@kernel.org>,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.18 253/277] usb: gadget: u_ether: Fix NULL pointer deref in eth_get_drvinfo
Date: Wed,  8 Apr 2026 20:03:58 +0200
Message-ID: <20260408175943.306017928@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuen-Han Tsai <khtsai@google.com>

commit e002e92e88e12457373ed096b18716d97e7bbb20 upstream.

Commit ec35c1969650 ("usb: gadget: f_ncm: Fix net_device lifecycle with
device_move") reparents the gadget device to /sys/devices/virtual during
unbind, clearing the gadget pointer. If the userspace tool queries on
the surviving interface during this detached window, this leads to a
NULL pointer dereference.

Unable to handle kernel NULL pointer dereference
Call trace:
 eth_get_drvinfo+0x50/0x90
 ethtool_get_drvinfo+0x5c/0x1f0
 __dev_ethtool+0xaec/0x1fe0
 dev_ethtool+0x134/0x2e0
 dev_ioctl+0x338/0x560

Add a NULL check for dev->gadget in eth_get_drvinfo(). When detached,
skip copying the fw_version and bus_info strings, which is natively
handled by ethtool_get_drvinfo for empty strings.

Suggested-by: Val Packett <val@packett.cool>
Reported-by: Val Packett <val@packett.cool>
Closes: https://lore.kernel.org/linux-usb/10890524-cf83-4a71-b879-93e2b2cc1fcc@packett.cool/
Fixes: ec35c1969650 ("usb: gadget: f_ncm: Fix net_device lifecycle with device_move")
Cc: stable <stable@kernel.org>
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260316-eth-null-deref-v1-1-07005f33be85@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_ether.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -112,8 +112,10 @@ static void eth_get_drvinfo(struct net_d
 
 	strscpy(p->driver, "g_ether", sizeof(p->driver));
 	strscpy(p->version, UETH__VERSION, sizeof(p->version));
-	strscpy(p->fw_version, dev->gadget->name, sizeof(p->fw_version));
-	strscpy(p->bus_info, dev_name(&dev->gadget->dev), sizeof(p->bus_info));
+	if (dev->gadget) {
+		strscpy(p->fw_version, dev->gadget->name, sizeof(p->fw_version));
+		strscpy(p->bus_info, dev_name(&dev->gadget->dev), sizeof(p->bus_info));
+	}
 }
 
 /* REVISIT can also support:


