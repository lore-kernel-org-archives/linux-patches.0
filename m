Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53DF1C1AAA;
	Tue, 12 Aug 2025 19:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025307; cv=none; b=ENFk7TauywuMYYactD+u2SS/o+Lg9lRbpAl/EnbxxFn5pOAVsvTlP4Xrne7xbDB6KTKh33jcEZVliQERRCVJroz4MDFSLWDPHNbhyjgx3DQF4mtCJZHASaKGLVXDhgSJ0s+q3ozFQ/KjNjsyYN+VzhjseoB/SeLplFqSU6MgMew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025307; c=relaxed/simple;
	bh=Iuv5ouvp/ZfipgLvlMU+oSNT1/NLj8Su7WawJCEdqvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=swfWuk0N2ZRVSJ6lXxhMSufOyJ7NAjM9+lGaRMlLLoqt/gYR5ubijmdfSa8uda7u9i7+oKT6VZ/ucEPusuSALGeHsj6ABHaJjvucJMsPoE7H8iLjagR96I6G5scnHdera5iOS98CtUu1QyoDeh9ipsnsAYdMKduKQFx6EPzhcRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oj6atMSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oj6atMSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DBFC4CEF0;
	Tue, 12 Aug 2025 19:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025307;
	bh=Iuv5ouvp/ZfipgLvlMU+oSNT1/NLj8Su7WawJCEdqvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oj6atMSIOaJIV+G2ua2B4EcZdElug9OisRCq+jqqMTHk4XTlSO4z5emLGp7eI8Wt6
	 w8U9EWLUWYG2PuWU2LIZYULykUZDM1Vsfs44qHqucOU0vJ2geXsAFPUwrbcqfhfoRQ
	 drEwahpoZpikiJfZqHtQnyzf1HM7A2Dqg+k/6/yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.16 602/627] platform/x86/intel/pmt: fix a crashlog NULL pointer access
Date: Tue, 12 Aug 2025 19:34:57 +0200
Message-ID: <20250812173454.773811649@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


