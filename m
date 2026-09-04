Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBF141DEDF;
	Fri,  4 Sep 2026 06:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502708; cv=none; b=oH4F29iQRq0PLtqAYfMnrYUkw90ubMjZ3H3RbeycdYPgAtc36X6mOIkdLC6tLfFAKZLiTvrIfdRlHfR8TMJMeTXJxSVquZnh6vW7WWof+AzjWfILKs+nKR6D4A/ljEQlwQ+YokNm+33x656itDvpapr/xwlM8kDHl1yYfBUwfnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502708; c=relaxed/simple;
	bh=UhcgCvyhUs85HsD81tYzZOXpB29J7rJ57DUnlKIADvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WGwQpOlT4rTztVnwXY0lDq72kibMlBV2oMpcF5Gnc0grhKb3XU6TvjzmqYODCCA3vl5arrDvuKcVB2+vhQJtHjLVP32LcmCIQkKQZ0JazoVJr3ouwQla4XcGgCvRgVmdhnmc/UBDY6Fu3nUd+dELRYTfcGUPeXdoBGKHiwQ9Bv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csuede3C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csuede3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FE11F00A3D;
	Fri,  4 Sep 2026 06:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502707;
	bh=Ckp87feQ79YwSUKYmeZRLTSc633axVeSBEHMZ1wJDiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=csuede3CLILcE0ePbXt+VZSixMRDztQCTbO0LkuqcD35gfQAtAtCwk+pbMja512wU
	 uimrZam6Wb3S+KScYTI3gVc+5AhXz5ThX0t6ZojkbFU9rvVTIqVT8OIFjMZQ0wcGRJ
	 a26nHLBH6Sht/RxVqebOtt/5eAQgXLGoI1rQpy7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.12 301/403] PCI/proc: Warn on writes to kernel-exclusive config space regions
Date: Fri,  4 Sep 2026 07:01:44 +0200
Message-ID: <20260904045741.687247904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

commit 3359e044d597dd5344f17613e4be6b6e12067f60 upstream.

Currently, a driver can claim a region of a device's config space as
exclusive using pci_request_config_region_exclusive(), after which a write
to that region originating from user space is expected to emit a warning
and taint the kernel.  The check is advisory only, as the write itself is
still allowed to proceed.

Since commit 278294798ac9 ("PCI: Allow drivers to request exclusive config
regions"), the sysfs config space attribute performs this check in
pci_write_config(), but the procfs interface was never updated.  A write
performed through /proc/bus/pci/BB/DD.F therefore bypasses the detection
entirely, even though both interfaces offer the same level of access.

Add the same resource_is_exclusive() check to proc_bus_pci_write().

Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260729075413.1215821-1-kwilczynski@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/proc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -14,6 +14,8 @@
 #include <linux/capability.h>
 #include <linux/uaccess.h>
 #include <linux/security.h>
+#include <linux/panic.h>
+#include <linux/sched.h>
 #include <asm/byteorder.h>
 #include "pci.h"
 
@@ -127,6 +129,12 @@ static ssize_t proc_bus_pci_write(struct
 	if (!nbytes)
 		return 0;
 
+	if (resource_is_exclusive(&dev->driver_exclusive_resource, pos, nbytes)) {
+		pci_warn_once(dev, "%s: Unexpected write to kernel-exclusive config offset %x",
+			      current->comm, pos);
+		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+	}
+
 	if (pos >= size)
 		return 0;
 	if (nbytes >= size)


