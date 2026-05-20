Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA60F3E95A4;
	Wed, 20 May 2026 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300587; cv=none; b=p04x/aUHQ/VCpgVJf4FlwixIJ6r9ERFS2JI1Bp+gOLJEQE2dU2m83/CbL8oSGw3pLRCcoul3XJfUhzQAvlS8cNmfs1YpXaOWmb5opYtv12cN2LQ+Dq5YraJgqEn7b/sv0C7YDNRlSr25sVPKnTeUeJCIkLir2a6NkIiklY7ql5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300587; c=relaxed/simple;
	bh=axYXge8OCRiBbHPvOzRlrRmPgR4ZqOlMOtuBeMyhRkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H285sTMJOa5PQQD7HzIXGirHYTNhvDn6h6MCDDvkQtlmVpgqowZmLxeplCx0J8XzX1k971Bn3e8WvD5NXIm0GbT+va0UNbNnw6F6S8M2Dq7TuWO/1IcuoZUFsxe7+GggltxhX/ggMgxyKimedcLcFFrzBQhNf+gnct3m4GjYsxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lH3vaqGc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lH3vaqGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4117B1F000E9;
	Wed, 20 May 2026 18:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300585;
	bh=/E9/D1xjC3wHGHYm+OBgFZ46BEEdyqTdBpZ376+TLIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lH3vaqGcasle/3gXXnCfaGJCQaXodepFIE6B+hrvqHNe4HO2FMyle1eRt91xLiiun
	 NvnJBZJhyd9Ic8GVQ1k5AA4RUgmjdjnTTq/CG4gG1vbXrJRQgH705FgFzdzYclxS2F
	 6JkzdpllQgAPZKDvlRbOzD+f7CQdHqMYVmyJkooM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 231/666] PCI/NPEM: Set LED_HW_PLUGGABLE for hotplug-capable ports
Date: Wed, 20 May 2026 18:17:22 +0200
Message-ID: <20260520162116.220205631@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Cheng <icheng@nvidia.com>

[ Upstream commit 16d021c878dca22532c984668c9e8cf4722d6a49 ]

NPEM registers LED classdevs on PCI endpoint that may be behind
hotplug-capable ports. During hot-removal, led_classdev_unregister() calls
led_set_brightness(LED_OFF) which leads to a PCI config read to a
disconnected device, which fails and returns -ENODEV (topology details in
msgid.link below):

  leds 0003:01:00.0:enclosure:ok: Setting an LED's brightness failed (-19)

The LED core already suppresses this for devices with LED_HW_PLUGGABLE set,
but NPEM never sets it. Add the flag since NPEM LEDs are on hot-pluggable
hardware by nature.

Fixes: 4e893545ef87 ("PCI/NPEM: Add Native PCIe Enclosure Management support")
Signed-off-by: Richard Cheng <icheng@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Kai-Heng Feng <kaihengf@nvidia.com>
Link: https://patch.msgid.link/20260402093850.23075-1-icheng@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/npem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/npem.c b/drivers/pci/npem.c
index 97507e0df769b..b5d012edebf35 100644
--- a/drivers/pci/npem.c
+++ b/drivers/pci/npem.c
@@ -504,7 +504,7 @@ static int pci_npem_set_led_classdev(struct npem *npem, struct npem_led *nled)
 	led->brightness_get = brightness_get;
 	led->max_brightness = 1;
 	led->default_trigger = "none";
-	led->flags = 0;
+	led->flags = LED_HW_PLUGGABLE;
 
 	ret = led_classdev_register(&npem->dev->dev, led);
 	if (ret)
-- 
2.53.0



