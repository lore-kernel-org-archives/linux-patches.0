Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C478A3290D8;
	Sun,  7 Jun 2026 10:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829193; cv=none; b=YwgO6zW/i3qhGHbSmwm6kVFD2J/h7eumSZ0gZngOGtKA7bqf8RmisVJIAtS7Ga1y6m50VRtip26iYRPvU8mtXiDYWeCEazGOCqpyTyydaheoIpQruA70FllwEY3wX3JeOSXTAZncbeIq9EmZ2huT14UBDQ+gzqoyxeUZHyCZous=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829193; c=relaxed/simple;
	bh=kUgGcjDk8Ij8Qnx2mEixeJv7/OiBE0n6E/91n9+NP8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PcgIi6pfkB1LxhP9T1C/5aQbWAM8959yHtum6SAf8XJht5/nWX4Rk9Ahx8eGUoq7t33tqiquVONCxBj4h6ln9FtSEs93njVIm+Cs1DqV6Oe0KduJGg47dskaSeK4DkDBV0d366FdE8i2qCxV3i9vCakIcOXXagbRgNSUTc7LnXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vkip+qci; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vkip+qci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E711F00893;
	Sun,  7 Jun 2026 10:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829191;
	bh=LKgwGPH804JMOFQPUIRhyvmmP7bzxw7NZ7SFocLSXHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vkip+qciOKL0bHq3pT11xSgBpMySAI85669d2cIdQI9w3u5UMS1KphM+mCvsXdH5s
	 E4KNWO2fDmc3IIFmhjYvwBzBE2XtF1OD+P4tZhW6lC6+R5WDuZhUXRTxyfQ9qjm/Te
	 zkBTbaAv+IpvvMxr/PrKj4LSep5L67z0LqdyzOCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xiaolei Wang <xiaolei.wang@windriver.com>
Subject: [PATCH 7.0 240/332] misc: rp1: Send IACK on IRQ activate to fix kdump/kexec
Date: Sun,  7 Jun 2026 12:00:09 +0200
Message-ID: <20260607095736.866437043@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

commit 36770417153644bc88281c7284730ef1d14d8d3c upstream.

After a kexec/kdump reboot, the macb Ethernet controller fails to
receive any packets, causing DHCP to hang indefinitely and the network
interface to be unusable despite link being up.

The root cause is that RP1's level-triggered MSI-X interrupt sources
(such as macb on hwirq 6) may have their internal state machines stuck
in the "waiting for IACK" state. This happens because the previous
kernel crashed before sending the acknowledgment for a pending level
interrupt.

In this stuck state, RP1 will not generate new MSI-X writes even though
the interrupt source remains asserted. Since no new MSI-X is sent, the
GIC never sees a new edge, the chained IRQ handler is never invoked,
and the interrupt is permanently lost.

Fix this by sending MSIX_CFG_IACK in rp1_irq_activate(). This
unconditionally resets the MSI-X state machine back to idle when a
child device requests its interrupt. If the interrupt source is still
asserted, RP1 will immediately issue a new MSI-X with the freshly
configured msg_addr/msg_data, and normal interrupt delivery resumes.

Writing IACK when the state machine is already idle (i.e., on a normal
cold boot) is harmless — it has no effect.

Fixes: 49d63971f963 ("misc: rp1: RaspberryPi RP1 misc driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Link: https://patch.msgid.link/20260518073405.2115003-1-xiaolei.wang@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/rp1/rp1_pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/rp1/rp1_pci.c
+++ b/drivers/misc/rp1/rp1_pci.c
@@ -143,6 +143,7 @@ static int rp1_irq_activate(struct irq_d
 	struct rp1_dev *rp1 = d->host_data;
 
 	msix_cfg_set(rp1, (unsigned int)irqd->hwirq, MSIX_CFG_ENABLE);
+	msix_cfg_set(rp1, (unsigned int)irqd->hwirq, MSIX_CFG_IACK);
 
 	return 0;
 }


