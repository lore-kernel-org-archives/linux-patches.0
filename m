Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE56C1A6822;
	Sun,  7 Jun 2026 10:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829305; cv=none; b=HRv/ugOuPqrs0xfPNk27RKGg8rPsvmo3dl0XylSPdYsjQimcOVfm5io5yFTYgdw0MA6JeHaNVaut92lwYAbmtwKhLxzQsfV19drv+izFBNYV9C5bol/BdBJMUGsGFsCIBclO88JnP2dVNOr+YVFPMfslkT2VzdtBkAhLyAf3lBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829305; c=relaxed/simple;
	bh=KLCWGKW4zajk7CptpCHBNvDMn+WhkNAVyYt4d+aHOZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zguu/zS+mae6pg2RKMhdXyZDQfpEZXEIdcu+Gc7msWWYuican+K/WpOr1p4pONRchVIWzhKcWC2prDE9INaC1mYCzmA6q6puSMTfof6Ix0vVXIikebPobsBsTGFkAu3sa0LGb030SvQNvkMGRUL/tVEo5gqkVoMOcUzI/5Rxem4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AY0fce3o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AY0fce3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0161F00893;
	Sun,  7 Jun 2026 10:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829304;
	bh=ZGsAA2wL2Zfw2LhiJZsut7pnOA55s2xuTu985kY3LU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AY0fce3ooJTdpaIWntSznbyT2ZRiQYJpwxIohS8Ri4WFtNJc/n6UEYnIm34z/GhYD
	 cysbpkej62O2ksy8MMhSjabdThZF270UmXVWcP5eksVS5PUbVBDo7wOSu7wLCKzd2O
	 fhMSM1UHzu1g2Lsxfmhl9CVlah02r+ahsd0Y3SV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xiaolei Wang <xiaolei.wang@windriver.com>
Subject: [PATCH 6.18 213/315] misc: rp1: Send IACK on IRQ activate to fix kdump/kexec
Date: Sun,  7 Jun 2026 12:00:00 +0200
Message-ID: <20260607095735.381826639@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -148,6 +148,7 @@ static int rp1_irq_activate(struct irq_d
 	struct rp1_dev *rp1 = d->host_data;
 
 	msix_cfg_set(rp1, (unsigned int)irqd->hwirq, MSIX_CFG_ENABLE);
+	msix_cfg_set(rp1, (unsigned int)irqd->hwirq, MSIX_CFG_IACK);
 
 	return 0;
 }


