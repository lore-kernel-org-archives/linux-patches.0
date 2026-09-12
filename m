Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4D047CA85;
	Sat, 12 Sep 2026 13:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219569; cv=none; b=JpbrWS4q79uKqSCxbkbvY8CyeTrVd/a/4kYdnFwYmKLC28xoKkQ4UiLhysQdaQpVh4ykO2pQMuzFsdmMqpC/Nx1dQIsE2kN6MNGqXSN09uZ2CZ9DzTF3TiJVe11yESb5ZlCAUWidfmp0ittpGrIM2/6f8MXyjEP6IbSJtMnuTbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219569; c=relaxed/simple;
	bh=aH9VTsKS4OC/i3ZVi9Yml2+jW558E7v923WNnR1N3rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZC1a7OoSNI76OiS4Lhv0VbV9yTLAEPRQ3pyLFIB6+ocuGyQ1fqOB0lwuowEea+8MxlBceQRYOunxUc+wQRMs6e5AI1RCzhz8vjPIKSwJo1a4I8Hk5m3eG1c/fw4iBykT/7xOhKVpFw8UX0v++s75WXss+QN+eIDr6GXUv7z6F8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IO6whqtE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IO6whqtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD191F000FF;
	Sat, 12 Sep 2026 13:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219568;
	bh=/3i8bptB7XkOIELDzSrbK8G5AIcht1NSsDcRfy4U++U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IO6whqtECr39TT2fpM7WqhLH3I2Fkd2rpN6DeAoi5N6cGrcbQYxHkciNlsUyC1u2B
	 zlH0lwdI2BhqGIx75rFwO6Ok2ZNMyuUBmdDfgsbug67kXSsuZYPeb4mElXkeOGTRC3
	 5MAbxPNZtKIEsYNW3kxs46NrWm4njeTB+tVZsrcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 1376/1376] ACPI: processor: Add cpuidle driver check in acpi_processor_register_idle_driver()
Date: Sat, 12 Sep 2026 09:03:22 +0200
Message-ID: <20260912065638.201282590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>

commit 66c62e6773c54ce5233eb21c6d48999c3747bd13 upstream.

Commit 7a8c994cbb2d ("ACPI: processor: idle: Optimize ACPI idle
driver registration") moved the ACPI idle driver registration to
acpi_processor_driver_init(), but it didn't check whether a cpuidle
driver was already registered.

For example, on Intel platforms, if the intel_idle driver is already
loaded, the code would still evaluate the _CST object in the ACPI
table and attempt to register the acpi_idle driver. This registration
would fail with -EBUSY due to the existing check in cpuidle_register_driver.

Add a check at the beginning of acpi_processor_register_idle_driver()
to avoid unnecessary _CST evaluate and potential registration failures.

Fixes: 7a8c994cbb2d ("ACPI: processor: idle: Optimize ACPI idle driver registration")
Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Link: https://patch.msgid.link/20260608190359.3254-1-TonyWWang-oc@zhaoxin.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_idle.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1386,6 +1386,15 @@ void acpi_processor_register_idle_driver
 	int cpu;
 
 	/*
+	 * If a cpuidle driver is already registered, there is no need to
+	 * evaluate _CST or attempt to register the ACPI idle driver.
+	 */
+	if (cpuidle_get_driver()) {
+		pr_debug("cpuidle driver %pS already registered.\n", cpuidle_get_driver());
+		return;
+	}
+
+	/*
 	 * ACPI idle driver is used by all possible CPUs.
 	 * Use the processor power info of one in them to set up idle states.
 	 * Note that the existing idle handler will be used on platforms that


