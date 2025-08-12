Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4802EE5E8;
	Tue, 12 Aug 2025 18:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023176; cv=none; b=b/o2bHhl+xqN8VqdZSdPAWKHjiOyMprYu3Qeg5iiyPSRxZ/DbpU57+ewLREn8bXRCQ9CWcQ/ESzu+5UyAbVCsbbVuMhfBAUM3QJQNpiRK9XUWwnB36pB9o5rDeAB0xxB0MMe+gJ8ubMlGJpFRvUEmV6h+QdJawWs8aUZbiHcAC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023176; c=relaxed/simple;
	bh=9T+blBjNtIqK//m2viQYYKF84iKzWWwiVFoZsqn4SCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jyhKBc18InEup3ocv/4X2mEIHD3ayPvbVIC4dS1ZZm6woywdg+t5lpE0TAgOGMU8A40iL1/TM9m1bEOXhQI1HcbeeSvQ25/2a124gAt0mo+xIKsQDrkXjVxu/kDyRDHyD8vlqUwkbWtwcQDJfxF5S0amCOJ64mGzdpUFJLdbTI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/MEw9KU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/MEw9KU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2738DC4CEF0;
	Tue, 12 Aug 2025 18:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023176;
	bh=9T+blBjNtIqK//m2viQYYKF84iKzWWwiVFoZsqn4SCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/MEw9KUVXdiUHh2CmR4WO2tf2wKx2Z/SveJqom4FdpV2dthDGgScCAOaWyZ5Pa7d
	 TTScAuDybwgZE+TBKZW9w6VkxstDxoa9VtdGC0jSVdXPag3TJ8tag6qUtnjSVZEW6l
	 bS687cZVByx4jCCJbI98y9J/Z30P+bB5dJ/aHAJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 358/369] platform/x86/intel/pmt: fix a crashlog NULL pointer access
Date: Tue, 12 Aug 2025 19:30:55 +0200
Message-ID: <20250812173030.156847095@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

commit 54d5cd4719c5e87f33d271c9ac2e393147d934f8 upstream.

Usage of the intel_pmt_read() for binary sysfs, requires a pcidev. The
current use of the endpoint value is only valid for telemetry endpoint
usage.

Without the ep, the crashlog usage causes the following NULL pointer
exception:

BUG: kernel NULL pointer dereference, address: 0000000000000000
Oops: Oops: 0000 [#1] SMP NOPTI
RIP: 0010:intel_pmt_read+0x3b/0x70 [pmt_class]
Code:
Call Trace:
 <TASK>
 ? sysfs_kf_bin_read+0xc0/0xe0
 kernfs_fop_read_iter+0xac/0x1a0
 vfs_read+0x26d/0x350
 ksys_read+0x6b/0xe0
 __x64_sys_read+0x1d/0x30
 x64_sys_call+0x1bc8/0x1d70
 do_syscall_64+0x6d/0x110

Augment struct intel_pmt_entry with a pointer to the pcidev to avoid
the NULL pointer exception.

Fixes: 045a513040cc ("platform/x86/intel/pmt: Use PMT callbacks")
Cc: stable@vger.kernel.org
Reviewed-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Link: https://lore.kernel.org/r/20250713172943.7335-2-michael.j.ruhl@intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/pmt/class.c |    3 ++-
 drivers/platform/x86/intel/pmt/class.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/intel/pmt/class.c
+++ b/drivers/platform/x86/intel/pmt/class.c
@@ -97,7 +97,7 @@ intel_pmt_read(struct file *filp, struct
 	if (count > entry->size - off)
 		count = entry->size - off;
 
-	count = pmt_telem_read_mmio(entry->ep->pcidev, entry->cb, entry->header.guid, buf,
+	count = pmt_telem_read_mmio(entry->pcidev, entry->cb, entry->header.guid, buf,
 				    entry->base, off, count);
 
 	return count;
@@ -252,6 +252,7 @@ static int intel_pmt_populate_entry(stru
 		return -EINVAL;
 	}
 
+	entry->pcidev = pci_dev;
 	entry->guid = header->guid;
 	entry->size = header->size;
 	entry->cb = ivdev->priv_data;
--- a/drivers/platform/x86/intel/pmt/class.h
+++ b/drivers/platform/x86/intel/pmt/class.h
@@ -39,6 +39,7 @@ struct intel_pmt_header {
 
 struct intel_pmt_entry {
 	struct telem_endpoint	*ep;
+	struct pci_dev		*pcidev;
 	struct intel_pmt_header	header;
 	struct bin_attribute	pmt_bin_attr;
 	struct kobject		*kobj;


