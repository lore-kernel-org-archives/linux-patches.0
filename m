Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7F0533586;
	Wed, 30 Sep 2026 18:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793590; cv=none; b=DXvLuWcLAMizmfMRjekHDDXTgHNnmDPH2bphM0ewAU5NiNjPFny7DZdBGwSKMmCUyafixo/QVfDLzrOiEuw2luujri8dnl9k33kB56g5Vyw2+IX8wgtfHxWFxABkYPdD5IZ7Qo2EVGFsgka3NsAJ0bOyCK3xpqn30pG9ITHJLSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793590; c=relaxed/simple;
	bh=1jo9WYxnmnj6O5gvojtwn9PzM0UN9Ck3dToOVOKsexA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmGPq8CSyzIupVl6n3ymkzc/0MK07V5MpEDxFDSP5hIXJU8YeMHG6Dy/ypEDd8CWB0ZxEqsxd+SA3RwlGpIM1sQSK7Cak7qVEjtXzKgH747yGEv6t6Qg2kMR2xxWKqQzoJ4TNJK6pq2er3AvNZC6Bha8yV+Vb614VTdFaI6qLm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFgFiiUD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFgFiiUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FB01F000FF;
	Wed, 30 Sep 2026 18:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793588;
	bh=yfyaB+vCrH6zo/n0j0tp8qRs92av/DD5tv9c9cOOn8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SFgFiiUDPXuJd3t35c190zHIzT3yCoAt5EhwcFQf9zWMtuEe0VDzurgGjjQIrRteZ
	 Kr6tpDZeC0s2zbG87XMei6Yv6+g/Yx28O/PcNK/EDO4Sn/7FJtcEcj2YxXhWdoskNs
	 Hg6l5lnhDBn/avBaQu7GD2MdeXEXCw54mEOLiAVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.18 306/395] s390/pci: Fix missing device lock in zpci_report_status()
Date: Wed, 30 Sep 2026 17:29:28 +0200
Message-ID: <20260930152347.292657601@linuxfoundation.org>
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

commit 0261aef4b15efcee2860ab857e5cb05e9bfa47b0 upstream.

When pdev is non-NULL, zpci_report_status() accesses the device's driver.
To get a consistent state matching the recovery, the device lock needs to
be held. Do so by expanding the existing device lock critical section.

The lock only needs to be held when the pdev is non-NULL, so extract
the pdev-specific reporting into a helper function which also adds a
lockdep assertion to detect calls without the device lock held.

Cc: stable@vger.kernel.org
Fixes: 4ec6054e7321 ("s390/pci: Report PCI error recovery results via SCLP")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_event.c  |    2 +-
 arch/s390/pci/pci_report.c |   21 +++++++++++++++------
 2 files changed, 16 insertions(+), 7 deletions(-)

--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -257,8 +257,8 @@ static pci_ers_result_t zpci_event_attem
 		driver->err_handler->resume(pdev);
 	pci_uevent_ers(pdev, PCI_ERS_RESULT_RECOVERED);
 out_unlock:
-	device_unlock(&pdev->dev);
 	zpci_report_status(zdev, pdev, "recovery", status_str);
+	device_unlock(&pdev->dev);
 
 	return ers_res;
 }
--- a/arch/s390/pci/pci_report.c
+++ b/arch/s390/pci/pci_report.c
@@ -88,6 +88,19 @@ static struct debug_view debug_log_view
 	NULL
 };
 
+static ssize_t zpci_report_pdev(struct pci_dev *pdev, char *buf, size_t size)
+{
+	struct pci_driver *driver;
+	const char *start = buf;
+	char *end = buf + size;
+
+	device_lock_assert(&pdev->dev);
+	buf += scnprintf(buf, end - buf, "state: %s\n", zpci_state_str(pdev->error_state));
+	driver = to_pci_driver(pdev->dev.driver);
+	buf += scnprintf(buf, end - buf, "driver: %s\n", (driver) ? driver->name : "n/a");
+	return buf - start;
+}
+
 /**
  * zpci_report_status - Report the status of operations on a PCI device
  * @zdev:	The zPCI device for which to report status
@@ -109,7 +122,6 @@ int zpci_report_status(struct zpci_dev *
 		       const char *operation, const char *status)
 {
 	struct zpci_report_error *report;
-	struct pci_driver *driver = NULL;
 	char *buf, *end;
 	int ret;
 
@@ -123,16 +135,13 @@ int zpci_report_status(struct zpci_dev *
 	report = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!report)
 		return -ENOMEM;
-	if (pdev)
-		driver = to_pci_driver(pdev->dev.driver);
 
 	buf = report->data.log_data;
 	end = report->data.log_data + ZPCI_REPORT_DATA_SIZE;
 	buf += scnprintf(buf, end - buf, "report: %s\n", operation);
 	buf += scnprintf(buf, end - buf, "status: %s\n", status);
-	buf += scnprintf(buf, end - buf, "state: %s\n",
-			 (pdev) ? zpci_state_str(pdev->error_state) : "n/a");
-	buf += scnprintf(buf, end - buf, "driver: %s\n", (driver) ? driver->name : "n/a");
+	if (pdev)
+		buf += zpci_report_pdev(pdev, buf, end - buf);
 	ret = debug_dump(pci_debug_msg_id, &debug_log_view, buf, end - buf, true);
 	if (ret < 0)
 		pr_err("Reading PCI debug messages failed with code %d\n", ret);


