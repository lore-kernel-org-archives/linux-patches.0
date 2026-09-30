Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1367B4D956D;
	Wed, 30 Sep 2026 15:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783699; cv=none; b=epEXlnslphC1a51wMCtarOqcY2DaJ2eMCCEtZhrvrZotAWmif/J+Uy0bIBruP8Twx8z9jHG8bbNibPKSkwmbZ6Mycg+QQJ00ZCBC6uHmu7Vf3vtzRQKzwWmVgIT/RPX3JB64ABrNwdbQC9sjv6KUVwBhkfT9DkEV4jXL7graN2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783699; c=relaxed/simple;
	bh=U1Wn+6icathEQTDV8w6Y2Iq1DKSb3LjVk3yCFgVWeGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hG+lv/sAGdfyNuLC4C/4z0dpzo9OtNZ2uzaxZgRL+vW/07FExgiX50ipyMOFtnBSqYrCb5c5N2paonY9NFne/B1rBvorYJIIKZNQkLKsS2kzDOWH4LoVQaGGuBGwlYT3yoH2qNVCko3l34rAovHriaCMcAqjbO2QXwR/c5WEp4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=utHUXXEc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utHUXXEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88991F000FF;
	Wed, 30 Sep 2026 15:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783693;
	bh=ZqA1c9cORBOEorcrTH29YI/BBS0m2unAAymIHPaqTqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=utHUXXEcz6fgPgcIXgHskAk3caPtmDqqD6YFjaBfvBFQcWPyPL1SYr8zun1Dr9ePG
	 CS0PHj/DHzIjl2nerI3lSaN5LshBquaJI8Xwf/FN70M+dbDFyC/N971LTUi/M3VjZs
	 tPzgFC/bEuJCgLNOvD7nkN1szGoxSX2EkNv6/jmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Viktor Mihajlovski <mihajlov@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 487/595] s390/pci: expose UID uniqueness guarantee
Date: Wed, 30 Sep 2026 17:26:20 +0200
Message-ID: <20260930152358.161397324@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 408f2c9c15682fc21b645fdec1f726492e235c4b ]

On s390 each PCI device has a user-defined ID (UID) exposed under
/sys/bus/pci/devices/<dev>/uid. This ID was designed to serve as the PCI
device's primary index and to match the device within Linux to the
device configured in the hypervisor. To serve as a primary identifier
the UID must be unique within the Linux instance, this is guaranteed by
the platform if and only if the UID Uniqueness Checking flag is set
within the CLP List PCI Functions response.

While the UID has been exposed to userspace since commit ac4995b9d570
("s390/pci: add some new arch specific pci attributes") whether or not
the platform guarantees its uniqueness for the lifetime of the Linux
instance while defined is not visible from userspace. Remedy this by
exposing this as a per device attribute at

/sys/bus/pci/devices/<dev>/uid_is_unique

Keeping this a per device attribute allows for maximum flexibility if we
ever end up with some devices not having a UID or not enjoying the
guaranteed uniqueness.

Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 4525a9110495 ("s390/pci/docs: Fix sriov_numvfs attribute name")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/s390/pci.rst | 14 +++++++++++---
 arch/s390/pci/pci_sysfs.c  |  9 +++++++++
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/Documentation/s390/pci.rst b/Documentation/s390/pci.rst
index 492850bff3168..8157f0cddbc24 100644
--- a/Documentation/s390/pci.rst
+++ b/Documentation/s390/pci.rst
@@ -50,7 +50,8 @@ Entries specific to zPCI functions and entries that hold zPCI information.
 * /sys/bus/pci/slots/XXXXXXXX
 
   The slot entries are set up using the function identifier (FID) of the
-  PCI function.
+  PCI function. The format depicted as XXXXXXXX above is 8 hexadecimal digits
+  with 0 padding and lower case hexadecimal digitis.
 
   - /sys/bus/pci/slots/XXXXXXXX/power
 
@@ -88,8 +89,15 @@ Entries specific to zPCI functions and entries that hold zPCI information.
     is attached to.
 
   - uid
-    The unique identifier (UID) is defined when configuring an LPAR and is
-    unique in the LPAR.
+    The user identifier (UID) may be defined as part of the machine
+    configuration or the z/VM or KVM guest configuration. If the accompanying
+    uid_is_unique attribute is 1 the platform guarantees that the UID is unique
+    within that instance and no devices with the same UID can be attached
+    during the lifetime of the system.
+
+  - uid_is_unique
+    Indicates whether the user identifier (UID) is guaranteed to be and remain
+    unique within this Linux instance.
 
   - pfip/segmentX
     The segments determine the isolation of a function.
diff --git a/arch/s390/pci/pci_sysfs.c b/arch/s390/pci/pci_sysfs.c
index 5c028bee91b90..e14d346dafd60 100644
--- a/arch/s390/pci/pci_sysfs.c
+++ b/arch/s390/pci/pci_sysfs.c
@@ -131,6 +131,13 @@ static ssize_t report_error_write(struct file *filp, struct kobject *kobj,
 }
 static BIN_ATTR(report_error, S_IWUSR, NULL, report_error_write, PAGE_SIZE);
 
+static ssize_t uid_is_unique_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", zpci_unique_uid ? 1 : 0);
+}
+static DEVICE_ATTR_RO(uid_is_unique);
+
 static struct bin_attribute *zpci_bin_attrs[] = {
 	&bin_attr_util_string,
 	&bin_attr_report_error,
@@ -148,8 +155,10 @@ static struct attribute *zpci_dev_attrs[] = {
 	&dev_attr_uid.attr,
 	&dev_attr_recover.attr,
 	&dev_attr_mio_enabled.attr,
+	&dev_attr_uid_is_unique.attr,
 	NULL,
 };
+
 static struct attribute_group zpci_attr_group = {
 	.attrs = zpci_dev_attrs,
 	.bin_attrs = zpci_bin_attrs,
-- 
2.53.0



