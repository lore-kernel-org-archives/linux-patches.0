Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2146E1A76CC;
	Thu, 15 Aug 2024 14:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732861; cv=none; b=W+0pyIERNMBfhebWvCtPPsT1T6lV4+XhI9u/ppg5wFsGqEGhX6YBdtSz8SnLcMxSvOcLDTLr9yLfVFpGqHjSfXotL4Gx7f0tpG8g5UZz3TuKa2ImlK9s69S/eH4eQ8QglYe5fLkEqxSykG+uf/fXKz1KTBpT5YiWmcPSKajqNPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732861; c=relaxed/simple;
	bh=uTJGnqYSxdMFQk/d8di0jq52bxwB4XjO2QPUK2DH718=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKyqRjb5zT9lqdj+YQ2P1BzlP8ipLYpNBAdA04hW2nZGXP6k2Cc4lFLrOfP6t+wBWFrnFw7kOr5w72UTwnoHnTgLmOZWNMb0tpDw9apPcIoSksDWjrMzOr3XwxhpO4/1/dwS0kD9YKTHhxZrJN+7d+LyZjHyTKJdCr1fQe+wbhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXUKbo9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXUKbo9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AED8C4AF0E;
	Thu, 15 Aug 2024 14:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732861;
	bh=uTJGnqYSxdMFQk/d8di0jq52bxwB4XjO2QPUK2DH718=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXUKbo9cyTa/A9Iqcz0Vc+RMlLgf/ufBK7eghd1G/7i4H92KQYkizWnfcX/Gb5QGd
	 atMmdgAjNes8Wz1Y5zRLRRNHcTBlqTiH8qI3U9AbkikyWZLxc+hHW84aFyfIwgUY9M
	 qR/T0CWaEMYRhun3D0L18ON2QlKWUH6gyComp8FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>
Subject: [PATCH 5.10 308/352] usb: gadget: u_serial: Set start_delayed during suspend
Date: Thu, 15 Aug 2024 15:26:14 +0200
Message-ID: <20240815131931.361973751@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1438,6 +1438,7 @@ void gserial_suspend(struct gserial *gse
 	spin_lock(&port->port_lock);
 	spin_unlock(&serial_port_lock);
 	port->suspended = true;
+	port->start_delayed = true;
 	spin_unlock_irqrestore(&port->port_lock, flags);
 }
 EXPORT_SYMBOL_GPL(gserial_suspend);


