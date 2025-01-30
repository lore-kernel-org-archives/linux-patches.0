Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AACE1E9B17;
	Thu, 30 Jan 2025 14:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245746; cv=none; b=mxEO2djvd3c8FfJsilSmKqM6BboX1rqJdr6eV+VUJs/Cfg1dHagLRFS8LRaPtJqc8f9Jscis56RjjtmXYOHs/LRzfm74AoOWfLYHoOdXvmIRdhc3nnX4STgpDGhxP+rD53SFIXsWbPSsIsEuHsM8w1dH4iOq5806ge+msIUuCTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245746; c=relaxed/simple;
	bh=JWsTQt3+uQ2F9RjC/J4JVm44tX+alLUKcmJnw5DMTno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWFCTC9sSSB82KeQr5p4fPKDs/7BE2nmCH9tVzVNxR+/SLPFMXOiEuf0u8AhSkN9aVOgUCJeOlN/hl2y5QoFg4VUC/XXkn4tGqMUalaQ4TRCMr8NSPP2y/scgKOnAEZLsVK6erE9rauGusi5ywcSv/S0JTLT0cHNONQFU5mNZRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bpn+XHMI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bpn+XHMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4FEC4CEE5;
	Thu, 30 Jan 2025 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245746;
	bh=JWsTQt3+uQ2F9RjC/J4JVm44tX+alLUKcmJnw5DMTno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bpn+XHMICzCxUcy5VoanJLn9Pw4sfUN1OsNiXucsPu3CRGgqNgcNceD8xey73qPgL
	 CcWGfH6NuAwTc/Vehlrb0WKJ3gLnAXSlPIL57On5vH6sBRp7OCljxgL7fZkJFsSbzm
	 mWmsBNCoujyBZ3WPrz1zhcv+kbnSH8aO6soHoW4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	stable <stable@kernel.org>,
	Lianqin Hu <hulianqin@vivo.com>
Subject: [PATCH 6.12 30/40] Revert "usb: gadget: u_serial: Disable ep before setting port to null to fix the crash caused by port being null"
Date: Thu, 30 Jan 2025 14:59:30 +0100
Message-ID: <20250130133500.913155753@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 086fd062bc3883ae1ce4166cff5355db315ad879 upstream.

This reverts commit 13014969cbf07f18d62ceea40bd8ca8ec9d36cec.

It is reported to cause crashes on Tegra systems, so revert it for now.

Link: https://lore.kernel.org/r/1037c1ad-9230-4181-b9c3-167dbaa47644@nvidia.com
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Cc: stable <stable@kernel.org>
Cc: Lianqin Hu <hulianqin@vivo.com>
Link: https://lore.kernel.org/r/2025011711-yippee-fever-a737@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_serial.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -1420,10 +1420,6 @@ void gserial_disconnect(struct gserial *
 	/* REVISIT as above: how best to track this? */
 	port->port_line_coding = gser->port_line_coding;
 
-	/* disable endpoints, aborting down any active I/O */
-	usb_ep_disable(gser->out);
-	usb_ep_disable(gser->in);
-
 	port->port_usb = NULL;
 	gser->ioport = NULL;
 	if (port->port.count > 0) {
@@ -1435,6 +1431,10 @@ void gserial_disconnect(struct gserial *
 	spin_unlock(&port->port_lock);
 	spin_unlock_irqrestore(&serial_port_lock, flags);
 
+	/* disable endpoints, aborting down any active I/O */
+	usb_ep_disable(gser->out);
+	usb_ep_disable(gser->in);
+
 	/* finally, free any unused/unusable I/O buffers */
 	spin_lock_irqsave(&port->port_lock, flags);
 	if (port->port.count == 0)


