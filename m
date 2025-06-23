Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E521E3DCD;
	Mon, 23 Jun 2025 22:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717214; cv=none; b=lujFvVj2qTjKH8gZ1CCbo5e8F3gXjohQyLsFWxTSdsdBui4pbsQoPYKqquOKavGFV3ejn5Z+h+cnYPyiA8+aOYUo9ZFiD9zVfiSAMe/ldtSnB7tvciGQ6jM4LZwRhCeYmuRpzIBbYI9RU26L2kNlUOqplU7JENJX5NralavFTYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717214; c=relaxed/simple;
	bh=ey1gsDPF6cok9Hv+VmQtRrl+g4XuXbAI2/JtRHOxyGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JtTUae2XUlZwMdyQxj+8qkT4xOt/g2XLvPYEdjfOp5ya/HdvwFOU9hkISo7rWzUQKY7t+kXwc67VfBGdFK2nb1X+7sUVo2LjceUldUx5BV1TSScv8Q1YgrVPb+X2UdraM0zkMTIY0cnYxWojZfOvzV5HC440+I5ZwV30bBdGsRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgzhmDl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgzhmDl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4914EC4CEEA;
	Mon, 23 Jun 2025 22:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717214;
	bh=ey1gsDPF6cok9Hv+VmQtRrl+g4XuXbAI2/JtRHOxyGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KgzhmDl3akURFEiM1EqdVVqAjAYxwcqk1vksxCIIhE5aVjV11IB4WiSKO2RVaytaQ
	 I3CvmbbW3r0QapVgZcxlcX1G9ThoXGhQ0jetX/FKl3Wmz9dcrVNK2PNBObB7DmjZiY
	 DuHqus0VDZjvjX8F+Urjq9sdnvtdswQ2482bWm9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?L=C6=B0=C6=A1ng=20Vi=E1=BB=87t=20Ho=C3=A0ng?= <tcm4095@gmail.com>,
	Joel Mathew Thomas <proxy0@tutamail.com>,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 589/592] PCI: pciehp: Ignore belated Presence Detect Changed caused by DPC
Date: Mon, 23 Jun 2025 15:09:07 +0200
Message-ID: <20250623130714.444311003@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit bbf10cd686835d5a4b8566dc73a3b00b4cd7932a ]

Commit c3be50f7547c ("PCI: pciehp: Ignore Presence Detect Changed caused by
DPC") sought to ignore Presence Detect Changed events occurring as a side
effect of Downstream Port Containment.

The commit awaits recovery from DPC and then clears events which occurred
in the meantime.  However if the first event seen after DPC is Data Link
Layer State Changed, only that event is cleared and not Presence Detect
Changed.  The object of the commit is thus defeated.

That's because pciehp_ist() computes the events to clear based on the local
"events" variable instead of "ctrl->pending_events".  The former contains
the events that had occurred when pciehp_ist() was entered, whereas the
latter also contains events that have accumulated while awaiting DPC
recovery.

In practice, the order of PDC and DLLSC events is arbitrary and the delay
in-between can be several milliseconds.

So change the logic to always clear PDC events, even if they come after an
initial DLLSC event.

Fixes: c3be50f7547c ("PCI: pciehp: Ignore Presence Detect Changed caused by DPC")
Reported-by: Lương Việt Hoàng <tcm4095@gmail.com>
Reported-by: Joel Mathew Thomas <proxy0@tutamail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219765#c165
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Lương Việt Hoàng <tcm4095@gmail.com>
Tested-by: Joel Mathew Thomas <proxy0@tutamail.com>
Link: https://patch.msgid.link/d9c4286a16253af7e93eaf12e076e3ef3546367a.1750257164.git.lukas@wunner.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pciehp_hpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index ebd342bda235d..91d2d92717d98 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -771,7 +771,7 @@ static irqreturn_t pciehp_ist(int irq, void *dev_id)
 		u16 ignored_events = PCI_EXP_SLTSTA_DLLSC;
 
 		if (!ctrl->inband_presence_disabled)
-			ignored_events |= events & PCI_EXP_SLTSTA_PDC;
+			ignored_events |= PCI_EXP_SLTSTA_PDC;
 
 		events &= ~ignored_events;
 		pciehp_ignore_link_change(ctrl, pdev, irq, ignored_events);
-- 
2.39.5



