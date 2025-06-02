Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BA2221297;
	Mon,  2 Jun 2025 14:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876034; cv=none; b=eZXQYnpMLvn6VhbZWKtZCOmI4Y2YR9zwfMto0jRiEE8ACqLRAa/iWnvBPt9atoedM5IccD4Eriyq4dUXfT8Sn2gZh6PXCqWE3vxzqxttbbu10gbVWRjq92UnzYG/7lpqFdEKQ5hYmUMY8lETxX+QW8He2VRlx6o1ZXinZJ0P2Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876034; c=relaxed/simple;
	bh=McwbOLGR+TOMn3ZJKByQjVnw9qNEsSiOLHB//t1aakA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpHX/HS0IYKhhJj50oGRZKXTArSLmpzz43iRKwI7r8sneGmT/gLM5oFU+cVQMPh7w4rPjxJZ1FGyJJyJmNJvMHQDhWNTOKmxnAUfMpIz6MhcUyk+tv1rf6lZwddZNOAy+Sb/fNySorC3/ZyClgUeJmMk5T0PHRLdimABTMbmKlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKlYk2I+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKlYk2I+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89146C4CEEB;
	Mon,  2 Jun 2025 14:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876034;
	bh=McwbOLGR+TOMn3ZJKByQjVnw9qNEsSiOLHB//t1aakA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKlYk2I+jPyIXs12AR2owTgbn1cJ57vHcQuuF/x3wnFuhJwkQkwCs++ze3Xb38Yon
	 B9sCycJJLPxAve/pJhvbtXc+XVMim4RRFpPtt3XfO2g4uILNUqMoqlhbri1LPaSL1z
	 +SKC7ZtuV/KQrK3Sfnt5odBj+L5V64IhNIkyU9RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frediano Ziglio <frediano.ziglio@cloud.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/207] xen: Add support for XenServer 6.1 platform device
Date: Mon,  2 Jun 2025 15:47:01 +0200
Message-ID: <20250602134300.675966615@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frediano Ziglio <frediano.ziglio@cloud.com>

[ Upstream commit 2356f15caefc0cc63d9cc5122641754f76ef9b25 ]

On XenServer on Windows machine a platform device with ID 2 instead of
1 is used.

This device is mainly identical to device 1 but due to some Windows
update behaviour it was decided to use a device with a different ID.

This causes compatibility issues with Linux which expects, if Xen
is detected, to find a Xen platform device (5853:0001) otherwise code
will crash due to some missing initialization (specifically grant
tables). Specifically from dmesg

    RIP: 0010:gnttab_expand+0x29/0x210
    Code: 90 0f 1f 44 00 00 55 31 d2 48 89 e5 41 57 41 56 41 55 41 89 fd
          41 54 53 48 83 ec 10 48 8b 05 7e 9a 49 02 44 8b 35 a7 9a 49 02
          <8b> 48 04 8d 44 39 ff f7 f1 45 8d 24 06 89 c3 e8 43 fe ff ff
          44 39
    RSP: 0000:ffffba34c01fbc88 EFLAGS: 00010086
    ...

The device 2 is presented by Xapi adding device specification to
Qemu command line.

Signed-off-by: Frediano Ziglio <frediano.ziglio@cloud.com>
Acked-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250227145016.25350-1-frediano.ziglio@cloud.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/platform-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index 6ebd819338ecb..2c77cac5594ba 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -26,6 +26,8 @@
 
 #define DRV_NAME    "xen-platform-pci"
 
+#define PCI_DEVICE_ID_XEN_PLATFORM_XS61	0x0002
+
 static unsigned long platform_mmio;
 static unsigned long platform_mmio_alloc;
 static unsigned long platform_mmiolen;
@@ -174,6 +176,8 @@ static int platform_pci_probe(struct pci_dev *pdev,
 static const struct pci_device_id platform_pci_tbl[] = {
 	{PCI_VENDOR_ID_XEN, PCI_DEVICE_ID_XEN_PLATFORM,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_XEN, PCI_DEVICE_ID_XEN_PLATFORM_XS61,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0,}
 };
 
-- 
2.39.5



