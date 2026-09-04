Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD5F37C106;
	Fri,  4 Sep 2026 05:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501539; cv=none; b=qUQZ7XGootnjqh9eCbImO+Vefe9seiArbdEbNRCwqcnXi+1ISdFlsG+Ddqi+wJI8JYyUyDRSCjznBfQgjWbFUkl16JhMSxfQ0eUlxzaLSvGJ2KQsl/7eGWXXwe3F7AbukeJ/BGYBSVu/cuxGHA/3cpTHQr5psfJ/4h50aZ/jKcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501539; c=relaxed/simple;
	bh=naBT/zdpf+uU6FVAOoQgUGUTMzFc5KJ98Aq5oMIJukA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mm509sd5sHDrABDrIOv3dmW9oRGthyoaFDKCnZsb6e1D+GCpC3YmVVeeCSV1Zpy/NT3x3xITsY3/zYBXEUax9QNg+woP5PZ+B9MEwPLt98LYkzeikSCdXnXO4HfWaodpvPa+XjCBIFd6XWBAPwFf01LFBU7+X+U3byFcM4e0lns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dY/y9iFR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dY/y9iFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974991F00A3D;
	Fri,  4 Sep 2026 05:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501538;
	bh=JqgWy1Fc80uojvphZznI+JxjvZI+H9kGruc/gulUeTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dY/y9iFRgtF/mT7/Z8nf+DqROZqAIA1JGHMwcKPkVLjZ2gZ55t9v89wViE9SyCEQv
	 Nt6rrr+Cf+uQXCTRkDe5n7tTqHQUSzWX7TC/d37Ui4qlRhTHWz8253XZWClwCxPdGs
	 hlqiW35Msl3zk+BlNzkW7LqIeWN5rngAX/eXCdb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.18 401/552] PCI/proc: Warn on writes to kernel-exclusive config space regions
Date: Fri,  4 Sep 2026 06:59:18 +0200
Message-ID: <20260904045759.539351207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


