Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B23E1891A3;
	Mon, 12 Aug 2024 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479083; cv=none; b=AUf+p6Gg0gSQOxPSQQWzuQUG7/ec9jcUvW+2Lb4fd//9lPwy2bCu+44EX3wq7pr8Vc4wB5/OkyXJR/OctWrmMUNh8HaqccDZRwWCDG47ogFZgJIjg2Sh+CfP7PL5OOkFTY898nIsWvK5gBVsooEujDpJ8FVkYJgDvZlPGWCwn0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479083; c=relaxed/simple;
	bh=tF9MJoWQD6oV96SPMnBMOLetErAVoRBOZnVzP5DGCBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dirxUpSvDzBv3oN+c94OYMFOIvhhrV7ZzRzE7B1xB548hwYqaPT4hs6eddoKK+u1uMjRBi8eiVLiWqCe1XmMZeIidSP2SF91y6WK8ick3Op4K9N5kfwIzPkN3AC507Epxp0vlIXc0z3GIHQToBaVz4vhcHSfvDIT7Wwp8Wv8t68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ac3Om4RV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ac3Om4RV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAE6C4AF0D;
	Mon, 12 Aug 2024 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479082;
	bh=tF9MJoWQD6oV96SPMnBMOLetErAVoRBOZnVzP5DGCBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ac3Om4RV0BtQa1vNqYik6+X1sH8qB6Y/FlLVwtFcZF6fwgbM/AUiVEUjENEEFDe1G
	 njRlXGpcvQreUbHCm4gWmEU2zYXpGiTCteSyO2qdk6NpYWePjIPhn09MNLcQFOOL12
	 CsZEXir+zxxkwjo8b4hjMnhMwQ0c0n2yikNjDkb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>
Subject: [PATCH 6.1 096/150] usb: gadget: u_serial: Set start_delayed during suspend
Date: Mon, 12 Aug 2024 18:02:57 +0200
Message-ID: <20240812160128.867429946@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Prashanth K <quic_prashk@quicinc.com>

commit 5a444bea37e2759549ef72bfe83d1c8712e76b3d upstream.

Upstream commit aba3a8d01d62 ("usb: gadget: u_serial: add suspend
resume callbacks") added started_delayed flag, so that new ports
which are opened after USB suspend can start IO while resuming.
But if the port was already opened, and gadget suspend kicks in
afterwards, start_delayed will never be set. This causes resume
to bail out before calling gs_start_io(). Fix this by setting
start_delayed during suspend.

Fixes: aba3a8d01d62 ("usb: gadget: u_serial: add suspend resume callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Link: https://lore.kernel.org/r/20240730125754.576326-1-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_serial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -1436,6 +1436,7 @@ void gserial_suspend(struct gserial *gse
 	spin_lock(&port->port_lock);
 	spin_unlock(&serial_port_lock);
 	port->suspended = true;
+	port->start_delayed = true;
 	spin_unlock_irqrestore(&port->port_lock, flags);
 }
 EXPORT_SYMBOL_GPL(gserial_suspend);


