Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA73527596;
	Wed, 30 Sep 2026 18:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793584; cv=none; b=bGiEbKJS3OxQmAr1bF3Y79fNoLYyOhabAIcBBVobW+sZZvcDXn3l8jOuZHuHXKe7AFNoDob9icbGpdQ6dDLmZyKThevrb6HuHDtF0x+amEQegzlVAIjsY7EY6d4as/rVX6sZrHk/gLZqdUPAzoS/a+pKYWPwXyBKDUiwZ2ZEUTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793584; c=relaxed/simple;
	bh=+qY0iCI/W+RSP5UnnPPCEvA9RvDictdLxwfh93iSYmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hr7zySnQF1oDhbPsrK2RvaCX6DmdZ0xRN4fM6pVJqEL4eK/+D81iqdowNREKxzSr53XebNnsb+zmdNz8u024r1/EdT/8X39o9zu31RNRsfVfYTzKtnBaIpwFogLAibvSLtAGG8WLs0yjhTMIJUxecy1Pq7tyKnkIITLe3AUdVEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPmTYBJ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPmTYBJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B28A1F0089A;
	Wed, 30 Sep 2026 18:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793582;
	bh=NlY7/i+6aSRbs4uD8N9kAaGk+FT2PGogS13lybiCbVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mPmTYBJ5u3d3O3cmi1soeai2/LvgYJ4iL7dR11yeCP2NYOMCqjj356j5NfAYsRA/X
	 Ze9/6egYI/FFYz9k8OSEm2j1OEqTMkDam9dlWbRJpFnHSfSl9FNQEAeVrTk7cxDelw
	 ulbuAKiJ/RMYdUHWKbRIhijcCR3GWsmOR37mFNLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.18 305/395] s390/pci: Fix leak of struct pci_dev reference in zpci_report_status()
Date: Wed, 30 Sep 2026 17:29:27 +0200
Message-ID: <20260930152347.271880003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 09b7040a1b79f4f61cdad6d9af972e045bb7c498 upstream.

In zpci_report_status(), a reference to the pdev associated with the
zdev being reported about is acquired using pci_get_slot(). This
reference needs to be dropped with pci_dev_put(), but this call is
missing, thus leaking the reference. On subsequent hot unplug, this will
cause the struct pci_dev to not be released, leaking memory and
preventing reattach.

At the same time, the only existing caller already holds a pdev
reference. So instead of reacquiring and then dropping another reference,
simply pass the existing pdev pointer to zpci_report_status(). This gets
rid of the need for pci_get_slot() as well as the zdev->zbus check.

Cc: stable@vger.kernel.org
Fixes: 4ec6054e7321 ("s390/pci: Report PCI error recovery results via SCLP")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_event.c  |    2 +-
 arch/s390/pci/pci_report.c |   11 +++++------
 arch/s390/pci/pci_report.h |    4 +++-
 3 files changed, 9 insertions(+), 8 deletions(-)

--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -258,7 +258,7 @@ static pci_ers_result_t zpci_event_attem
 	pci_uevent_ers(pdev, PCI_ERS_RESULT_RECOVERED);
 out_unlock:
 	device_unlock(&pdev->dev);
-	zpci_report_status(zdev, "recovery", status_str);
+	zpci_report_status(zdev, pdev, "recovery", status_str);
 
 	return ers_res;
 }
--- a/arch/s390/pci/pci_report.c
+++ b/arch/s390/pci/pci_report.c
@@ -90,7 +90,8 @@ static struct debug_view debug_log_view
 
 /**
  * zpci_report_status - Report the status of operations on a PCI device
- * @zdev:	The PCI device for which to report status
+ * @zdev:	The zPCI device for which to report status
+ * @pdev:	The PCI device associated with the zdev if any, NULL otherwise
  * @operation:	A string representing the operation reported
  * @status:	A string representing the status of the operation
  *
@@ -104,15 +105,15 @@ static struct debug_view debug_log_view
  *
  * Return: 0 on success an error code < 0 otherwise.
  */
-int zpci_report_status(struct zpci_dev *zdev, const char *operation, const char *status)
+int zpci_report_status(struct zpci_dev *zdev, struct pci_dev *pdev,
+		       const char *operation, const char *status)
 {
 	struct zpci_report_error *report;
 	struct pci_driver *driver = NULL;
-	struct pci_dev *pdev = NULL;
 	char *buf, *end;
 	int ret;
 
-	if (!zdev || !zdev->zbus)
+	if (!zdev)
 		return -ENODEV;
 
 	/* Protected virtualization hosts get nothing from us */
@@ -122,8 +123,6 @@ int zpci_report_status(struct zpci_dev *
 	report = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!report)
 		return -ENOMEM;
-	if (zdev->zbus->bus)
-		pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);
 	if (pdev)
 		driver = to_pci_driver(pdev->dev.driver);
 
--- a/arch/s390/pci/pci_report.h
+++ b/arch/s390/pci/pci_report.h
@@ -8,9 +8,11 @@
  */
 #ifndef __S390_PCI_REPORT_H
 #define __S390_PCI_REPORT_H
+#include <linux/pci.h>
 
 struct zpci_dev;
 
-int zpci_report_status(struct zpci_dev *zdev, const char *operation, const char *status);
+int zpci_report_status(struct zpci_dev *zdev, struct pci_dev *pdev,
+		       const char *operation, const char *status);
 
 #endif /* __S390_PCI_REPORT_H */


