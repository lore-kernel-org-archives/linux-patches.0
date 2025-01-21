Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4348A1F540C;
	Tue, 21 Jan 2025 18:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482898; cv=none; b=Xtq88LCYTGbMVu4XjrbZJgKoRrsNW4h8dhyH42kzrM0b5kSivPfUtBsDx22jVf+Z42uc6wNFViejvrJdi2TUCINp1JNC7wzRYeRc7AOQO8LCUrCJ3sUFCEuwbnOIGqWogIFk1yTUMxpPEqWnEB8KriFOJ5AuBipJPc4mi2NEfPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482898; c=relaxed/simple;
	bh=Oxi9uy4X8QG1gOxgWW46xt8HFSV+b6GWglzDU14QjPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ct3AXi7iNOlqAdYmfJi4VXwsDV8UW/j1IYQz3Trlcm9rGQcN7qjwhaLkHxNv47UvPBhEQPgM0wwZQjmdvioSQrFSx0zjLKWkPJu2VJwohtIgygNcMy8joJBO4tN0VeW3/UApPT4B3xJkVZ6CriHm8SV4h4LDTwwklMfCqjfxxg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKp3B3H5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKp3B3H5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC639C4CEDF;
	Tue, 21 Jan 2025 18:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482898;
	bh=Oxi9uy4X8QG1gOxgWW46xt8HFSV+b6GWglzDU14QjPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKp3B3H53gkHMd1JFLcYuD+/mB9tarDjBg88D0ZA5gIGuF+0SbXiVy6sE7Hr+1aNS
	 xBskAsquoi/AoC06ZbA1x4swLnzma/zToUfoUP5XZOwpoDLK5/BpkKB/21E4sp4/vU
	 0ya3QK8Kau5Tf2FloFOUO8xf4F6E/n+fkLnb6i44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Lianqin Hu <hulianqin@vivo.com>
Subject: [PATCH 5.15 047/127] usb: gadget: u_serial: Disable ep before setting port to null to fix the crash caused by port being null
Date: Tue, 21 Jan 2025 18:51:59 +0100
Message-ID: <20250121174531.487803436@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lianqin Hu <hulianqin@vivo.com>

commit 13014969cbf07f18d62ceea40bd8ca8ec9d36cec upstream.

Considering that in some extreme cases, when performing the
unbinding operation, gserial_disconnect has cleared gser->ioport,
which triggers gadget reconfiguration, and then calls gs_read_complete,
resulting in access to a null pointer. Therefore, ep is disabled before
gserial_disconnect sets port to null to prevent this from happening.

Call trace:
 gs_read_complete+0x58/0x240
 usb_gadget_giveback_request+0x40/0x160
 dwc3_remove_requests+0x170/0x484
 dwc3_ep0_out_start+0xb0/0x1d4
 __dwc3_gadget_start+0x25c/0x720
 kretprobe_trampoline.cfi_jt+0x0/0x8
 kretprobe_trampoline.cfi_jt+0x0/0x8
 udc_bind_to_driver+0x1d8/0x300
 usb_gadget_probe_driver+0xa8/0x1dc
 gadget_dev_desc_UDC_store+0x13c/0x188
 configfs_write_iter+0x160/0x1f4
 vfs_write+0x2d0/0x40c
 ksys_write+0x7c/0xf0
 __arm64_sys_write+0x20/0x30
 invoke_syscall+0x60/0x150
 el0_svc_common+0x8c/0xf8
 do_el0_svc+0x28/0xa0
 el0_svc+0x24/0x84

Fixes: c1dca562be8a ("usb gadget: split out serial core")
Cc: stable <stable@kernel.org>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Link: https://lore.kernel.org/r/TYUPR06MB621733B5AC690DBDF80A0DCCD2042@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_serial.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -1393,6 +1393,10 @@ void gserial_disconnect(struct gserial *
 	/* REVISIT as above: how best to track this? */
 	port->port_line_coding = gser->port_line_coding;
 
+	/* disable endpoints, aborting down any active I/O */
+	usb_ep_disable(gser->out);
+	usb_ep_disable(gser->in);
+
 	port->port_usb = NULL;
 	gser->ioport = NULL;
 	if (port->port.count > 0) {
@@ -1404,10 +1408,6 @@ void gserial_disconnect(struct gserial *
 	spin_unlock(&port->port_lock);
 	spin_unlock_irqrestore(&serial_port_lock, flags);
 
-	/* disable endpoints, aborting down any active I/O */
-	usb_ep_disable(gser->out);
-	usb_ep_disable(gser->in);
-
 	/* finally, free any unused/unusable I/O buffers */
 	spin_lock_irqsave(&port->port_lock, flags);
 	if (port->port.count == 0)


