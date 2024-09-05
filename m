Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51405635;
	Thu,  5 Sep 2024 09:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529791; cv=none; b=pv8jx6ENOQZZHWw2jceUGh7qc2+ftCaR08K/g+4KJS3DeJUcYZtI7yi/nxEdBmGCGmnlVAU7asEPANQJ/A92VD3ok2aofz1xmmm1iTQHGKUf2f7c39dKVCdmXBKe+3z5b5NZyQx8vFRIhXq2L1QO+TgCLqyZFDND4MGBzPO4Nk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529791; c=relaxed/simple;
	bh=lI62fiuUvY3QSp1V7v/zAWdS2uFIs3XulJAKrz7uI7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uf4heWTg6LijoDBkpEIPpvIMgUehKy1PSBxK4BY874vA3eOc9NOR14A+kA5DZBkLnIZMl8FSYnISQaNX8vd2iG7xak7JDqV26EX3eo5jCk8+rEmSscHsgEDMp2doEBQGv3EJcBfHzrxOwnEsSW/e0g07bjDGRykZFOCeEUaubQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKq7VuMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKq7VuMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C171CC4CEC7;
	Thu,  5 Sep 2024 09:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529791;
	bh=lI62fiuUvY3QSp1V7v/zAWdS2uFIs3XulJAKrz7uI7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKq7VuMBnqyOJ1aO0iRu43/aak6gOGnabud25+lq/A8iqq4IprJ8LY+3R1aPpMcxL
	 9WqBnkv9ymTCj3d2vUsXdeOXox7ICaWeU+cnKRTO3e/hU+IEzcoZWssr1sQghQGmOV
	 Eg+Azkaw8EyZ1jJm0bAfxadqv7/pFz9qdAgfcguQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dustin L. Howett" <dustin@howett.net>,
	Ben Walsh <ben@jubnut.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 143/184] platform/chrome: cros_ec_lpc: MEC access can use an AML mutex
Date: Thu,  5 Sep 2024 11:40:56 +0200
Message-ID: <20240905093737.921335491@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Walsh <ben@jubnut.com>

[ Upstream commit 60c7df66450e3a7821a8d68496c20c95de6a15c5 ]

Framework Laptops have ACPI code which accesses the MEC memory. It
uses an AML mutex to prevent concurrent access. But the cros_ec_lpc
driver was not aware of this mutex. The ACPI code and LPC driver both
attempted to talk to the EC at the same time, messing up communication
with the EC.

Allow the LPC driver MEC code to find and use the AML mutex.

Tested-by: Dustin L. Howett <dustin@howett.net>
Signed-off-by: Ben Walsh <ben@jubnut.com>
Link: https://lore.kernel.org/r/20240605063351.14836-3-ben@jubnut.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_lpc_mec.c | 76 ++++++++++++++++++++++-
 drivers/platform/chrome/cros_ec_lpc_mec.h | 11 ++++
 2 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_lpc_mec.c b/drivers/platform/chrome/cros_ec_lpc_mec.c
index 0d9c79b270ce..63b6b261b8e5 100644
--- a/drivers/platform/chrome/cros_ec_lpc_mec.c
+++ b/drivers/platform/chrome/cros_ec_lpc_mec.c
@@ -10,13 +10,65 @@
 
 #include "cros_ec_lpc_mec.h"
 
+#define ACPI_LOCK_DELAY_MS 500
+
 /*
  * This mutex must be held while accessing the EMI unit. We can't rely on the
  * EC mutex because memmap data may be accessed without it being held.
  */
 static DEFINE_MUTEX(io_mutex);
+/*
+ * An alternative mutex to be used when the ACPI AML code may also
+ * access memmap data.  When set, this mutex is used in preference to
+ * io_mutex.
+ */
+static acpi_handle aml_mutex;
+
 static u16 mec_emi_base, mec_emi_end;
 
+/**
+ * cros_ec_lpc_mec_lock() - Acquire mutex for EMI
+ *
+ * @return: Negative error code, or zero for success
+ */
+static int cros_ec_lpc_mec_lock(void)
+{
+	bool success;
+
+	if (!aml_mutex) {
+		mutex_lock(&io_mutex);
+		return 0;
+	}
+
+	success = ACPI_SUCCESS(acpi_acquire_mutex(aml_mutex,
+						  NULL, ACPI_LOCK_DELAY_MS));
+	if (!success)
+		return -EBUSY;
+
+	return 0;
+}
+
+/**
+ * cros_ec_lpc_mec_unlock() - Release mutex for EMI
+ *
+ * @return: Negative error code, or zero for success
+ */
+static int cros_ec_lpc_mec_unlock(void)
+{
+	bool success;
+
+	if (!aml_mutex) {
+		mutex_unlock(&io_mutex);
+		return 0;
+	}
+
+	success = ACPI_SUCCESS(acpi_release_mutex(aml_mutex, NULL));
+	if (!success)
+		return -EBUSY;
+
+	return 0;
+}
+
 /**
  * cros_ec_lpc_mec_emi_write_address() - Initialize EMI at a given address.
  *
@@ -77,6 +129,7 @@ u8 cros_ec_lpc_io_bytes_mec(enum cros_ec_lpc_mec_io_type io_type,
 	int io_addr;
 	u8 sum = 0;
 	enum cros_ec_lpc_mec_emi_access_mode access, new_access;
+	int ret;
 
 	/* Return checksum of 0 if window is not initialized */
 	WARN_ON(mec_emi_base == 0 || mec_emi_end == 0);
@@ -92,7 +145,9 @@ u8 cros_ec_lpc_io_bytes_mec(enum cros_ec_lpc_mec_io_type io_type,
 	else
 		access = ACCESS_TYPE_LONG_AUTO_INCREMENT;
 
-	mutex_lock(&io_mutex);
+	ret = cros_ec_lpc_mec_lock();
+	if (ret)
+		return ret;
 
 	/* Initialize I/O at desired address */
 	cros_ec_lpc_mec_emi_write_address(offset, access);
@@ -134,7 +189,9 @@ u8 cros_ec_lpc_io_bytes_mec(enum cros_ec_lpc_mec_io_type io_type,
 	}
 
 done:
-	mutex_unlock(&io_mutex);
+	ret = cros_ec_lpc_mec_unlock();
+	if (ret)
+		return ret;
 
 	return sum;
 }
@@ -146,3 +203,18 @@ void cros_ec_lpc_mec_init(unsigned int base, unsigned int end)
 	mec_emi_end = end;
 }
 EXPORT_SYMBOL(cros_ec_lpc_mec_init);
+
+int cros_ec_lpc_mec_acpi_mutex(struct acpi_device *adev, const char *pathname)
+{
+	int status;
+
+	if (!adev)
+		return -ENOENT;
+
+	status = acpi_get_handle(adev->handle, pathname, &aml_mutex);
+	if (ACPI_FAILURE(status))
+		return -ENOENT;
+
+	return 0;
+}
+EXPORT_SYMBOL(cros_ec_lpc_mec_acpi_mutex);
diff --git a/drivers/platform/chrome/cros_ec_lpc_mec.h b/drivers/platform/chrome/cros_ec_lpc_mec.h
index 9d0521b23e8a..3f3af37e58a5 100644
--- a/drivers/platform/chrome/cros_ec_lpc_mec.h
+++ b/drivers/platform/chrome/cros_ec_lpc_mec.h
@@ -8,6 +8,8 @@
 #ifndef __CROS_EC_LPC_MEC_H
 #define __CROS_EC_LPC_MEC_H
 
+#include <linux/acpi.h>
+
 enum cros_ec_lpc_mec_emi_access_mode {
 	/* 8-bit access */
 	ACCESS_TYPE_BYTE = 0x0,
@@ -45,6 +47,15 @@ enum cros_ec_lpc_mec_io_type {
  */
 void cros_ec_lpc_mec_init(unsigned int base, unsigned int end);
 
+/**
+ * cros_ec_lpc_mec_acpi_mutex() - Find and set ACPI mutex for MEC
+ *
+ * @adev:     Parent ACPI device
+ * @pathname: Name of AML mutex
+ * @return:   Negative error code, or zero for success
+ */
+int cros_ec_lpc_mec_acpi_mutex(struct acpi_device *adev, const char *pathname);
+
 /**
  * cros_ec_lpc_mec_in_range() - Determine if addresses are in MEC EMI range.
  *
-- 
2.43.0



