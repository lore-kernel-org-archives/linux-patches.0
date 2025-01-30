Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671E21E8823;
	Thu, 30 Jan 2025 14:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246847; cv=none; b=BlkZnws46Jq5MYJAu9+58uGRQ46B2LXQOSBtAq6uNoTmLxVDJCVW1ipkNZSeLaN/BCLHPRvS8J7tGCtiOudQLWfIvwPN+MU4tmE6Kf5kQRH/nAS8P81BT5WKijjc1crhZBIpEJ5Ccfooh6+aFKJbFgEGFn39syq4LSeltK2c5cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246847; c=relaxed/simple;
	bh=C+eJW4eAhXsPacRT8YJ2tc4fGYuw43f/Sf+VhAe8rSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLiWqxV5MD2XnsMLDnSbrgZ7feG6bsojy8yxBqvUFC+LKLmCgu7RmNOoZrosRPG/57IR4UGWH0bGJUUj33wNVzejRx55lQHqFDKzVd/C/SC01a17iuUjOwGJzxKLD4WYVO9q/qurHF3QuaW6mMUP40Yge8F6mq9qxbWkoGvjaz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z86uyMrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z86uyMrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40E2C4CED2;
	Thu, 30 Jan 2025 14:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246847;
	bh=C+eJW4eAhXsPacRT8YJ2tc4fGYuw43f/Sf+VhAe8rSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z86uyMrNHc5YF1mnUPp9eFZry8r9Dg7S6Edu6StyRUpu4Acudwl1PQYDdBpvpMXNQ
	 imlPbJfreM0wHtKLyZsHJRMEXb5EZCmPYP4b+xKCZt3t+paBIsQQiFA0rvuffE++Ww
	 y0S8r+gT9bwluRt7UI8IQJsbaqb46cWNJ2snPT/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	stable <stable@kernel.org>,
	Lianqin Hu <hulianqin@vivo.com>
Subject: [PATCH 5.4 88/91] Revert "usb: gadget: u_serial: Disable ep before setting port to null to fix the crash caused by port being null"
Date: Thu, 30 Jan 2025 15:01:47 +0100
Message-ID: <20250130140137.224321640@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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
@@ -1369,10 +1369,6 @@ void gserial_disconnect(struct gserial *
 	/* REVISIT as above: how best to track this? */
 	port->port_line_coding = gser->port_line_coding;
 
-	/* disable endpoints, aborting down any active I/O */
-	usb_ep_disable(gser->out);
-	usb_ep_disable(gser->in);
-
 	port->port_usb = NULL;
 	gser->ioport = NULL;
 	if (port->port.count > 0 || port->openclose) {
@@ -1382,6 +1378,10 @@ void gserial_disconnect(struct gserial *
 	}
 	spin_unlock_irqrestore(&port->port_lock, flags);
 
+	/* disable endpoints, aborting down any active I/O */
+	usb_ep_disable(gser->out);
+	usb_ep_disable(gser->in);
+
 	/* finally, free any unused/unusable I/O buffers */
 	spin_lock_irqsave(&port->port_lock, flags);
 	if (port->port.count == 0 && !port->openclose)


