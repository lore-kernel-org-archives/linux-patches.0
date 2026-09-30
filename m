Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A83515961;
	Wed, 30 Sep 2026 17:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787867; cv=none; b=GPTN7wK7oR6Yi7jDapbYjKa0IIbz9AFP+MJ6UsD6GaCfaeALOj0dMMc1q7ETEEf2Wk8gIZ1g+bYo/N/V7/1Lf82rErFn3aFVijWpSi6ZyIW2WDj/FbhSN5GRlvbePwNW4U3PIZl4FYLMhXhLollsJf7yQp+6iTspIOvDZRGt6DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787867; c=relaxed/simple;
	bh=pAbYbpZ3I7+hSzRbVvCzuwVDoxCOPrQ1+CSELiTHrug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXX8ryx/S3jytpr1nuIDAjRfekwuJAcPk9gAZ7v43lZ5w5qBDxAcwDOIAioRELrnJj5nGfcE7UUpWH/PsDcvBiAvJJc8FtcjYGj+e/H3aPpmn5tNnzrMmLme/JxyU/yBjMpLXab7FkVe/ufo0X3FQcsoINbeJ/kpWdUTVi1wdB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D234rAfF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D234rAfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF26E1F000FF;
	Wed, 30 Sep 2026 17:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787862;
	bh=DCBxP+4sC1W00ovxxxjZnAreQYAzKq/GC24zGe0rgrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D234rAfFDZNBDvIv/heOXETZq6nWZZsewucrY4/swzGYiYRd8N+2ANeWIcPEYZNrG
	 9mDUrKpkG9yuwj/wAfKhzt/eeN0hTqK0PGZfOL+sYS7i02qkwh6s4Rwbj/5l0fcSq4
	 5eDCgSyCHlgfT9epk90JO/Qn275tFCpwVmgQu5os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.2 379/457] s390/pci: Fix missing device lock in zpci_report_status()
Date: Wed, 30 Sep 2026 17:28:04 +0200
Message-ID: <20260930152354.180476563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -256,8 +256,8 @@ static pci_ers_result_t zpci_event_attem
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
@@ -87,6 +87,19 @@ static struct debug_view debug_log_view
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
@@ -108,7 +121,6 @@ int zpci_report_status(struct zpci_dev *
 		       const char *operation, const char *status)
 {
 	struct zpci_report_error *report;
-	struct pci_driver *driver = NULL;
 	char *buf, *end;
 	int ret;
 
@@ -122,16 +134,13 @@ int zpci_report_status(struct zpci_dev *
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


