Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C378231B83D;
	Mon, 27 Oct 2025 18:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590607; cv=none; b=djt+tQvN533cw0lQ3ciJVvdHc6BmUnVisbY0nIb2e1GuQmWMVbF09dhngKIbp5FqAV5ee8aWs8EDlUABwPsL4gsBmP26JFbqWwNdjnwV/GGTBFFriUnV6J/PgS6OWJAjPkRNxYNhiMo151Ob08et4uueGU631WFtz5pbVaOj7rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590607; c=relaxed/simple;
	bh=q5tP2H+XT5FzTQdcHmFD0ApD1gM/u+RchKZPuFVP2QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ah8gHrZm/ZbKXYS82cmsRIEs5P9AMNPGwGFcjn7xZwj/G4bLJ3jIMyB6uGGBPbirEa/YaL96Sfd8f1gXQjl6vw/3d2qmYwr6JsWT7pssTih3BQor7OoGRiWLB/WHKO2dpz2NVdCoTUhFELHlZMEJTg+M2COfEmptikwvCf40CLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQYcYgoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQYcYgoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58838C116B1;
	Mon, 27 Oct 2025 18:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590607;
	bh=q5tP2H+XT5FzTQdcHmFD0ApD1gM/u+RchKZPuFVP2QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQYcYgoHiBsbTTHvqX7CMpm4tfjDoIX8gtq5ywjDemeDccHYoC/Lcu2OPvPfACUXc
	 Z0Lhfur7HIrYqnkRNQpiEIJGlRAUSnj0gYLwO6xNPNNmDVIz1Ttv+h1SGuaGvN7uGT
	 d5P8jsqW8lRGmWP92NDewudPuTV+5XYtRMyCB5u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 101/224] ACPI: debug: fix signedness issues in read/write helpers
Date: Mon, 27 Oct 2025 19:34:07 +0100
Message-ID: <20251027183511.692374444@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>

commit 496f9372eae14775e0524e83e952814691fe850a upstream.

In the ACPI debugger interface, the helper functions for read and write
operations use "int" as the length parameter data type. When a large
"size_t count" is passed from the file operations, this cast to "int"
results in truncation and a negative value due to signed integer
representation.

Logically, this negative number propagates to the min() calculation,
where it is selected over the positive buffer space value, leading to
unexpected behavior. Subsequently, when this negative value is used in
copy_to_user() or copy_from_user(), it is interpreted as a large positive
value due to the unsigned nature of the size parameter in these functions,
causing the copy operations to attempt handling sizes far beyond the
intended buffer limits.

Address the issue by:
 - Changing the length parameters in acpi_aml_read_user() and
   acpi_aml_write_user() from "int" to "size_t", aligning with the
   expected unsigned size semantics.
 - Updating return types and local variables in acpi_aml_read() and
   acpi_aml_write() to "ssize_t" for consistency with kernel file
   operation conventions.
 - Using "size_t" for the "n" variable to ensure calculations remain
   unsigned.
 - Using min_t() for circ_count_to_end() and circ_space_to_end() to
   ensure type-safe comparisons and prevent integer overflow.

Signed-off-by: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
Link: https://patch.msgid.link/20250923013113.20615-1-a.jahangirzad@gmail.com
[ rjw: Changelog tweaks, local variable definitions ordering adjustments ]
Fixes: 8cfb0cdf07e2 ("ACPI / debugger: Add IO interface to access debugger functionalities")
Cc: 4.5+ <stable@vger.kernel.org> # 4.5+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_dbg.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/acpi/acpi_dbg.c
+++ b/drivers/acpi/acpi_dbg.c
@@ -576,11 +576,11 @@ static int acpi_aml_release(struct inode
 	return 0;
 }
 
-static int acpi_aml_read_user(char __user *buf, int len)
+static ssize_t acpi_aml_read_user(char __user *buf, size_t len)
 {
-	int ret;
 	struct circ_buf *crc = &acpi_aml_io.out_crc;
-	int n;
+	ssize_t ret;
+	size_t n;
 	char *p;
 
 	ret = acpi_aml_lock_read(crc, ACPI_AML_OUT_USER);
@@ -589,7 +589,7 @@ static int acpi_aml_read_user(char __use
 	/* sync head before removing logs */
 	smp_rmb();
 	p = &crc->buf[crc->tail];
-	n = min(len, circ_count_to_end(crc));
+	n = min_t(size_t, len, circ_count_to_end(crc));
 	if (copy_to_user(buf, p, n)) {
 		ret = -EFAULT;
 		goto out;
@@ -606,8 +606,8 @@ out:
 static ssize_t acpi_aml_read(struct file *file, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
-	int ret = 0;
-	int size = 0;
+	ssize_t ret = 0;
+	ssize_t size = 0;
 
 	if (!count)
 		return 0;
@@ -646,11 +646,11 @@ again:
 	return size > 0 ? size : ret;
 }
 
-static int acpi_aml_write_user(const char __user *buf, int len)
+static ssize_t acpi_aml_write_user(const char __user *buf, size_t len)
 {
-	int ret;
 	struct circ_buf *crc = &acpi_aml_io.in_crc;
-	int n;
+	ssize_t ret;
+	size_t n;
 	char *p;
 
 	ret = acpi_aml_lock_write(crc, ACPI_AML_IN_USER);
@@ -659,7 +659,7 @@ static int acpi_aml_write_user(const cha
 	/* sync tail before inserting cmds */
 	smp_mb();
 	p = &crc->buf[crc->head];
-	n = min(len, circ_space_to_end(crc));
+	n = min_t(size_t, len, circ_space_to_end(crc));
 	if (copy_from_user(p, buf, n)) {
 		ret = -EFAULT;
 		goto out;
@@ -670,14 +670,14 @@ static int acpi_aml_write_user(const cha
 	ret = n;
 out:
 	acpi_aml_unlock_fifo(ACPI_AML_IN_USER, ret >= 0);
-	return n;
+	return ret;
 }
 
 static ssize_t acpi_aml_write(struct file *file, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	int ret = 0;
-	int size = 0;
+	ssize_t ret = 0;
+	ssize_t size = 0;
 
 	if (!count)
 		return 0;


