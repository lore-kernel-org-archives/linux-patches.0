Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F5A7482;
	Thu, 30 Jan 2025 14:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247452; cv=none; b=qF8dQDWAxmvrYkyFYOL7YAnohOTpaxrOidd8cIHxhJ4KmQ6NkCUqQMLBYWJzNvyBjvLsu6lL6vM6ikq15sBE1bCOY8kowRxLtms23BlW0duG8GpP5EcxMHrrizKOy50dLio173TLD6luGCkrqfMIrRT1l+HnWv7uDzmb39t6jZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247452; c=relaxed/simple;
	bh=0wt3bwN778Gq4oDJ/QrLM1rOAhxKGm+uC9XtIHW5zi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qgzme+zURHhE67E9Yfz5FPTUrUhxi9JMrYHJJzds72uab8cEDG4FjMGSS8becEyzl1Q5zh2mJCJ4wAiU9xz2rFfLobPqD8s8RtKSvJLXigAv703BCDEDGLcghM5HvgAY9IPVFg+5pBahZ1dm3x7dYpSvRXj2Mv6TdItshW/5JV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xa/8sPdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xa/8sPdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A49C4CED2;
	Thu, 30 Jan 2025 14:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247452;
	bh=0wt3bwN778Gq4oDJ/QrLM1rOAhxKGm+uC9XtIHW5zi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xa/8sPdvubVJ4P8szdsAaHTqNCU+1AIwp0OEgXjtvtZmQRUn8nztSviQ+Fn630RHA
	 pDkSVShoNtodRsSeV9+uJKf1PskxJpdsZUtaI9/EYnPih9NQahpSGlKDDB95hnOHDW
	 ZpQqUhqGjBU5d81DwpGr8JHFx9aYcKlfZAq/F0l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	stable <stable@kernel.org>,
	Lianqin Hu <hulianqin@vivo.com>
Subject: [PATCH 6.1 43/49] Revert "usb: gadget: u_serial: Disable ep before setting port to null to fix the crash caused by port being null"
Date: Thu, 30 Jan 2025 15:02:19 +0100
Message-ID: <20250130140135.554906737@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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
@@ -1393,10 +1393,6 @@ void gserial_disconnect(struct gserial *
 	/* REVISIT as above: how best to track this? */
 	port->port_line_coding = gser->port_line_coding;
 
-	/* disable endpoints, aborting down any active I/O */
-	usb_ep_disable(gser->out);
-	usb_ep_disable(gser->in);
-
 	port->port_usb = NULL;
 	gser->ioport = NULL;
 	if (port->port.count > 0) {
@@ -1408,6 +1404,10 @@ void gserial_disconnect(struct gserial *
 	spin_unlock(&port->port_lock);
 	spin_unlock_irqrestore(&serial_port_lock, flags);
 
+	/* disable endpoints, aborting down any active I/O */
+	usb_ep_disable(gser->out);
+	usb_ep_disable(gser->in);
+
 	/* finally, free any unused/unusable I/O buffers */
 	spin_lock_irqsave(&port->port_lock, flags);
 	if (port->port.count == 0)


