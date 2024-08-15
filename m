Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C25F7DA7D;
	Thu, 15 Aug 2024 14:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730487; cv=none; b=ORZbpbxYfr9OVJ5XulloENkQwcM7CeiU4CZmUYGJyez8luU6ZaGf3NpkjgPbO5CCxbVEx5Kjk+uTc+DKthGjqrc1p6whyOCJZ5XGM2YcJVwjRJ5jzhsakpQVNpR9lr9jIOUZPTplTDDwqs0KrY7PHhLulI00dNqMDfv0RfNd2DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730487; c=relaxed/simple;
	bh=304YaCIFg7/617YqhmgG1W9/UfbbOaO2319msiXLVY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWlFjuUvOd6gUp//Rb02YtEMYy9F7C0AjnHmjjcESw6zchsELi99+fc0mPYfPEdilt1jJODaCmlnmNdKKnJ2l/PBg2uk2JCRfxT2XuA87nY8NSbIZ7Xa++Uz5N0saNgfhXWqE6UmsVmOz5wS+IJ40e6Vc3HdGsvA8KhbyCzI+Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoALXQkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoALXQkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719ECC32786;
	Thu, 15 Aug 2024 14:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730486;
	bh=304YaCIFg7/617YqhmgG1W9/UfbbOaO2319msiXLVY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoALXQkHlbHbvalZ80qQ6DV0pASj2pus9I7MiOJ6aD9T8VYpfganzUYgU1g8N/KLd
	 LVfPyKNSER78og+PbwnLgRVJ3xohhFRBdi12pWiKXeCxomuHAh83apEVJsaUR6UEIN
	 C2ytr3xLb9mdBDfmTTmeBDHUKran4Ie+Tmixrr8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>
Subject: [PATCH 5.15 423/484] usb: gadget: u_serial: Set start_delayed during suspend
Date: Thu, 15 Aug 2024 15:24:41 +0200
Message-ID: <20240815131957.793190615@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


