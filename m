Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0771E8824;
	Thu, 30 Jan 2025 13:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245577; cv=none; b=FvQmZUVqxP3Jj5K7Os/nPe7Ao+RkmUkhAFaTI5ie1Zm9jyE4bXuQWn63zEzltvqOUlgAhaNTgYd3e7QadhCB2zg1+jzk7Lvs6asd4csBSq/NHM0uzuACOAIvz76DczRRopvi1DmqwcTiSar6x6bn5yvoXEGaQoVkvLK4QUoP55c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245577; c=relaxed/simple;
	bh=6NiRXj4Qjeg2NRpQkQcuKHO2JOilkRS541soDKs2Zxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEUyQGm8hZvAQSYz9xH/cfynYMN7c4+sf6sGgM296a4s6DptN3K0P69f0kw/pgCktffmYd760VFxZkDOhP0vqTRPFsR1omC2fts5ydMsQVwN3dx7leOzxEZ0Xo0Aa/XGGayI2USRl+qJ7tp+XyS+R7Ba5jGE9RWKr/a7noxZe6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umTQG78O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umTQG78O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D95FC4CEE0;
	Thu, 30 Jan 2025 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245576;
	bh=6NiRXj4Qjeg2NRpQkQcuKHO2JOilkRS541soDKs2Zxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umTQG78OP5VxM02wraHO/5VSS6Ej10uYIuP/khLGAMHfw+qYfmYNYEsp6S36r3Pfw
	 43XInj4VGDcNZthOiQTZAP/zMB7mEJqZdCjySlYhk2T3ngJ+d1RHgd0cegRFOe3l2x
	 cBT0ihRowzBIkE0juQ62FFHm4FNi3hUPk/9P/FuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	stable <stable@kernel.org>,
	Lianqin Hu <hulianqin@vivo.com>
Subject: [PATCH 6.13 14/25] Revert "usb: gadget: u_serial: Disable ep before setting port to null to fix the crash caused by port being null"
Date: Thu, 30 Jan 2025 14:59:00 +0100
Message-ID: <20250130133457.513024240@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
References: <20250130133456.914329400@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


