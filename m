Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB0F482EF;
	Mon,  1 Apr 2024 16:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989779; cv=none; b=hzvGwBTXD1QfEfH4iIk+ogVBZmcqn1gpDXeFLJx4LqAK1DZ+iSprjcDT6MCn6zh+JFLB6W+t6bzEy762lZYkXVhMcJDjQy/GvZNN02TaHzykyUYiHKdQ5aIHav0PLpM7qqAUGuhh4Wz1pZdOAlh//nc4c1ItxcdgUsbJMWn5Rg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989779; c=relaxed/simple;
	bh=8Im9oqvVvhcjZ8jnEgG3eTT7OLTTvxvzEarf8q67Mvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j/+4htgiQcSboK4CeDOMYvPcjy1wPWUQ02wn0E9KJxhNRnv9b/v2r7wf9GwP3q3go/NXFZfXkC9Qxz/ByXKrIIl4Zu2QXlQ5lXZ7PE3J0oDorAdHJTSE4hL2T+Wy9LhqDvTzRC1kV0OohzGwISNX4//nZlxLy/GaSWPzZG7R1Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZML0E6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZML0E6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C666C433C7;
	Mon,  1 Apr 2024 16:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989779;
	bh=8Im9oqvVvhcjZ8jnEgG3eTT7OLTTvxvzEarf8q67Mvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZML0E6EwNQz2BufJfoUvNUlEU13Wfph4eZm5fotm8NtoG+ie8xxxG67t6dJDwQoa
	 t2Rt0ymmotyqJ64ikbskAxCEYKZGzZlV0v0yElKKRArroo8NfyRY/3r/dadoLngj70
	 S2yKao7zs7jdV68p2B/trU6TrMq5yF2krovhChlw=
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
Subject: [PATCH 6.6 122/396] PCI: hv: Fix ring buffer size calculation
Date: Mon,  1 Apr 2024 17:42:51 +0200
Message-ID: <20240401152551.556826963@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bed3cefdaf198..5ab1a035c4969 100644
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



