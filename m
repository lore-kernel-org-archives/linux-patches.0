Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA051CA8F;
	Mon,  1 Apr 2024 16:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988376; cv=none; b=RE0fasXIRaVVsDJCyJ5cF83XTQUToi02AJv7axjsclPEQGlWDUSCbGBt5GmiRRQU/jCPE94+bXWbh4veOhY2P67If9DN2Ak12LpicuONriw9+NozkK4rwGcjkNv8vuA79N3Mn8+8vr1/N1MU6id951ozTKli6E6S7gG17pxnanU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988376; c=relaxed/simple;
	bh=7dNYYEx/y5FKBGW07MNeFcFHaTXmFtQ8IwfXPzLrMbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ArS0mVikPMAshDc02jBhLZH5JGlYE/KwzHuvb4r0HHJSXiAPtmz7QrvdNzjVlCiHvSBmmutdrg+fZG7RsLJOHlolJcKKsF8xdpAto487Gtd4rTA8eRfcqwu0J8hnvJiaFZzw8NKQrTa7hHdRiwtrYxmHojDMXMdz4zw0+5t/q4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hI/df0Vy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hI/df0Vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4885DC433F1;
	Mon,  1 Apr 2024 16:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988376;
	bh=7dNYYEx/y5FKBGW07MNeFcFHaTXmFtQ8IwfXPzLrMbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hI/df0VyLWhOqdTt0/zl4m2pJncpVHY4O27ba4CtrIK7p0dCxvdBI6lMWrDnIg0pT
	 v3ggwkd2OGsoglBHthab9llJ6/PdBNeJjMIQc4Gokjhl6r98gZhc6f1v1foZequ8JX
	 YkuprSdgqaEeJkXsRsL6+m/Md30/ZQC+olkAKKNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>,
	Long Li <longli@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 138/432] PCI: hv: Fix ring buffer size calculation
Date: Mon,  1 Apr 2024 17:42:05 +0200
Message-ID: <20240401152557.248817636@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhklinux@outlook.com>

[ Upstream commit b5ff74c1ef50fe08e384026875fec660fadfaedd ]

For a physical PCI device that is passed through to a Hyper-V guest VM,
current code specifies the VMBus ring buffer size as 4 pages.  But this
is an inappropriate dependency, since the amount of ring buffer space
needed is unrelated to PAGE_SIZE. For example, on x86 the ring buffer
size ends up as 16 Kbytes, while on ARM64 with 64 Kbyte pages, the ring
size bloats to 256 Kbytes. The ring buffer for PCI pass-thru devices
is used for only a few messages during device setup and removal, so any
space above a few Kbytes is wasted.

Fix this by declaring the ring buffer size to be a fixed 16 Kbytes.
Furthermore, use the VMBUS_RING_SIZE() macro so that the ring buffer
header is properly accounted for, and so the size is rounded up to a
page boundary, using the page size for which the kernel is built. While
w/64 Kbyte pages this results in a 64 Kbyte ring buffer header plus a
64 Kbyte ring buffer, that's the smallest possible with that page size.
It's still 128 Kbytes better than the current code.

Link: https://lore.kernel.org/linux-pci/20240216202240.251818-1-mhklinux@outlook.com
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Long Li <longli@microsoft.com>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-hyperv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 30c7dfeccb16f..11cc354a30ea5 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -49,6 +49,7 @@
 #include <linux/refcount.h>
 #include <linux/irqdomain.h>
 #include <linux/acpi.h>
+#include <linux/sizes.h>
 #include <asm/mshyperv.h>
 
 /*
@@ -465,7 +466,7 @@ struct pci_eject_response {
 	u32 status;
 } __packed;
 
-static int pci_ring_size = (4 * PAGE_SIZE);
+static int pci_ring_size = VMBUS_RING_SIZE(SZ_16K);
 
 /*
  * Driver specific state.
-- 
2.43.0



