Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACB01DF978;
	Tue,  8 Oct 2024 13:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393775; cv=none; b=ZYAMz6GRL//19t7/tesBHWNJy8FH5jRlqlDcg8DT3glExHGiWM9kPwgpYT6kJeCr4EIkyc0BOvcrYKc7b5l/PHbNxgBQKcgY7vhgeKpriunR2lM0M53zPc9t/9rQKkb5GP8RIFjTZgr0IeiLAe5/YKotBvbG3UO2by0KwsbEisI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393775; c=relaxed/simple;
	bh=U0X37XRIcQiCwV4V4yF+bcE8D5WMGjiW5+1+0VwsLgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jbetcgg2YSfDk3OSj47Ebr3mNvD2k9vSeuq74md3aIaDGsk767MtO8jsCUWi+88ZAW2hOP1El1hcSnfVDPL7U5JqV+M5tkuBlkp4zkQbIfXNhEKfdmzC+QqlONf9BJo26qamyXllHGZSSOzWkyzUo+I7fVXlfu1MkStrXhHoInQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ManZC34D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ManZC34D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD4BC4CEC7;
	Tue,  8 Oct 2024 13:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393775;
	bh=U0X37XRIcQiCwV4V4yF+bcE8D5WMGjiW5+1+0VwsLgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ManZC34DsJUvO+ucD90QH2wbsGOLKyC1CLU2Y3EOLNc02v0JClWzeApTHrFZP9d2A
	 Z+NVTGB03gVos1pXCPBZ4jJIYX0Cc6QFOsUpWEg/elYciLI943f5L2vnIz4am5DVoO
	 FVhLeKX/IxXc296ps1Kw5wMvjiPV10iFpMvnwlpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nam Cao <namcao@linutronix.de>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 252/386] of: address: Report error on resource bounds overflow
Date: Tue,  8 Oct 2024 14:08:17 +0200
Message-ID: <20241008115639.310922439@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 000f6d588a8f3d128f89351058dc04d38e54a327 upstream.

The members "start" and "end" of struct resource are of type
"resource_size_t" which can be 32bit wide.
Values read from OF however are always 64bit wide.
Avoid silently truncating the value and instead return an error value.

This can happen on real systems when the DT was created for a
PAE-enabled kernel and a non-PAE kernel is actually running.
For example with an arm defconfig and "qemu-system-arm -M virt".

Link: https://bugs.launchpad.net/qemu/+bug/1790975
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Nam Cao <namcao@linutronix.de>
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/r/20240905-of-resource-overflow-v1-1-0cd8bb92cc1f@linutronix.de
Cc: stable@vger.kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/address.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -8,6 +8,7 @@
 #include <linux/logic_pio.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
+#include <linux/overflow.h>
 #include <linux/pci.h>
 #include <linux/pci_regs.h>
 #include <linux/sizes.h>
@@ -1142,7 +1143,11 @@ static int __of_address_to_resource(stru
 	if (of_mmio_is_nonposted(dev))
 		flags |= IORESOURCE_MEM_NONPOSTED;
 
+	if (overflows_type(taddr, r->start))
+		return -EOVERFLOW;
 	r->start = taddr;
+	if (overflows_type(taddr + size - 1, r->end))
+		return -EOVERFLOW;
 	r->end = taddr + size - 1;
 	r->flags = flags;
 	r->name = name ? name : dev->full_name;


