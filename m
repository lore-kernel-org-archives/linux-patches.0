Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A872D739D;
	Mon, 27 Oct 2025 19:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593575; cv=none; b=rwNLKIOCY/LA8eSywnDSYatVIyWELtNLJg4wRuvk0fn23ijghAMM5l/MHtJ0FiA6F6rDRyVPN+5l48iIIpIu8pDBs0JrmE1I+y/73QcS+J1nWckuZ1/ef8hWXcKYGOeh9MoPRwOMOqoxj/CoadYqVY1Ysr28lYcTofpuakQOCcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593575; c=relaxed/simple;
	bh=XKbt5U/yJdrAEw+9Zlee+VZ9iXl3zxSqy2d7kQ3EGwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiHk9UoJGRzqM2WzQ4lxB7EPJQ1rWtk6aRoqM/dIcl0mtU5OWspcXLvVt/70ZxXbLW2Md11BCZETQNwYBU1ZUUDWKj0yCFt2LsOChGOqOMzPi4ICDI086zMD80dZKrrU9CcC0LUUW7LH8ALQdUT4xS9w+nTY+WXVaIwxHIx51Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BO734sOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BO734sOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A444C4CEFD;
	Mon, 27 Oct 2025 19:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593575;
	bh=XKbt5U/yJdrAEw+9Zlee+VZ9iXl3zxSqy2d7kQ3EGwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BO734sOQaxGaNGWOaoFTS/s8wrsTxPojIgAaInABjqJFSMqIvG+r2cDgQhLTX4ZJ4
	 /QhOKLot0qfe/2b5xe9+ywah3SdgDbnTj1nt/DUq483zk/Y0YEzsDn4NOqIqG0pHCp
	 1zU23mVJwjIh0hdOdCGc/3yykObsS9Z/XoyBNnkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 6.17 177/184] staging: gpib: Fix sending clear and trigger events
Date: Mon, 27 Oct 2025 19:37:39 +0100
Message-ID: <20251027183519.687643414@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

commit 92a2b74a6b5a5d9b076cd9aa75e63c6461cbd073 upstream.

This driver was not sending device clear or trigger events when the
board entered the DCAS or DTAS state respectively in device mode.

DCAS is the Device Clear Active State which is entered on receiving a
selective device clear message (SDC) or universal device clear message
(DCL) from the controller in charge.

DTAS is the Device Trigger Active State which is entered on receiving
a group execute trigger (GET) message from the controller.

In order for an application, implementing a particular device, to
detect when one of these states is entered the driver needs to send
the appropriate event.

Send the appropriate gpib_event when DCAS or DTAS is set in the
reported status word. This sets the DCAS or DTAS bits in the board's
status word which can be monitored by the application.

Fixes: 4e127de14fa7 ("staging: gpib: Add National Instruments USB GPIB driver")
Cc: stable <stable@kernel.org>
Tested-by: Dave Penkler <dpenkler@gmail.com>
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/gpib/ni_usb/ni_usb_gpib.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
+++ b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
@@ -327,7 +327,10 @@ static void ni_usb_soft_update_status(st
 	board->status &= ~clear_mask;
 	board->status &= ~ni_usb_ibsta_mask;
 	board->status |= ni_usb_ibsta & ni_usb_ibsta_mask;
-	//FIXME should generate events on DTAS and DCAS
+	if (ni_usb_ibsta & DCAS)
+		push_gpib_event(board, EVENT_DEV_CLR);
+	if (ni_usb_ibsta & DTAS)
+		push_gpib_event(board, EVENT_DEV_TRG);
 
 	spin_lock_irqsave(&board->spinlock, flags);
 /* remove set status bits from monitored set why ?***/


