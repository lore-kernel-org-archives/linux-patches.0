Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DEE54BFC;
	Thu, 30 Nov 2023 16:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2Kq72a8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C32C433C8;
	Thu, 30 Nov 2023 16:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361548;
	bh=ma7oukoRMv5WQ6kQvSQaRSEHbFJJOfmWguem/XMHnb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2Kq72a8xNNJVQF0JTnd0enRgog+xfAHHZ1mAhrkb2HRhZ39OWrATnk6MbjOAYY7s
	 SrsnXe/ErZJNI6fpLCjmlWu8vDkpibFS1jrSdfzzAs5OuqJqTEC0iACIOcIEHDlwSe
	 cox4CTsao4gWRkh+i5J2xKlCiCd0l2f7RIomfvds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 066/112] ACPI: PM: Add acpi_device_fix_up_power_children() function
Date: Thu, 30 Nov 2023 16:21:53 +0000
Message-ID: <20231130162142.416068942@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 37ba91a82e3b9de35f64348c62b5ec7d74e3a41c upstream.

In some cases it is necessary to fix-up the power-state of an ACPI
device's children without touching the ACPI device itself add
a new acpi_device_fix_up_power_children() function for this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: 6.6+ <stable@vger.kernel.org> # 6.6+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/device_pm.c |   13 +++++++++++++
 include/acpi/acpi_bus.h  |    1 +
 2 files changed, 14 insertions(+)

--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -397,6 +397,19 @@ void acpi_device_fix_up_power_extended(s
 }
 EXPORT_SYMBOL_GPL(acpi_device_fix_up_power_extended);
 
+/**
+ * acpi_device_fix_up_power_children - Force a device's children into D0.
+ * @adev: Parent device object whose children's power state is to be fixed up.
+ *
+ * Call acpi_device_fix_up_power() for @adev's children so long as they
+ * are reported as present and enabled.
+ */
+void acpi_device_fix_up_power_children(struct acpi_device *adev)
+{
+	acpi_dev_for_each_child(adev, fix_up_power_if_applicable, NULL);
+}
+EXPORT_SYMBOL_GPL(acpi_device_fix_up_power_children);
+
 int acpi_device_update_power(struct acpi_device *device, int *state_p)
 {
 	int state;
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -539,6 +539,7 @@ int acpi_device_set_power(struct acpi_de
 int acpi_bus_init_power(struct acpi_device *device);
 int acpi_device_fix_up_power(struct acpi_device *device);
 void acpi_device_fix_up_power_extended(struct acpi_device *adev);
+void acpi_device_fix_up_power_children(struct acpi_device *adev);
 int acpi_bus_update_power(acpi_handle handle, int *state_p);
 int acpi_device_update_power(struct acpi_device *device, int *state_p);
 bool acpi_bus_power_manageable(acpi_handle handle);


