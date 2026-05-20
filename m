Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F044C4F5E0;
	Wed, 20 May 2026 18:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300017; cv=none; b=cJ6fo7fQjywcXCNNHYWxw88x/5uhmlwWOH6/uDiaTORgxFCS9jS3VprZHi6zaZ5bzCNFGfzPUU5d+T3eQh32H7gLgQ1JG4NrUz/1ix1FsvVH+D91cuoV7Qhw416LPtoy7h+HW34d8pwTuENybS+3/mpzvl5HfzD8WOnjWUPtzHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300017; c=relaxed/simple;
	bh=Mc87MNPQCaGvthpwfQ+cKkPQlU3QwTkiF8aJOSoW1v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuoojkwxPbw1KuNO3eKGag63yYCsYZe+/bUpc/VpWx3gti7N0w8JF3GDaus1qOk93wsG0nlD7fCdKKtaDNcJcIJvI5lbpfDO67VfnF4BZY/IfxJt5JUROQuN2xp3X4q3B2QtuT6msjCh1NaXYc7mUfVCudjteeZqiiRl1dnUuKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYnhf8vU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYnhf8vU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AC51F00893;
	Wed, 20 May 2026 18:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300015;
	bh=gq0XQWlFnEK9LnEqHUX+MgUlUBKYLeH96C8/PKQSOL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GYnhf8vUvwHSPhCeDVLYiaE8e8f5mBVKrB/A04aS1bVU29c5xh+joGpZUH8Zqd/rl
	 LC0nrsTSoX6LbbNntgIrI7CdPtGle217xm8j3NwlJJiNNkdV/+0lE7jB5bo3E122U2
	 elNCcm61p+5CfEg2MvAJ/cWxqfOX/lze1Qoo2N6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/666] ACPI: x86: cmos_rtc: Improve coordination with ACPI TAD driver
Date: Wed, 20 May 2026 18:13:47 +0200
Message-ID: <20260520162111.583788519@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 6cee29ad9d7e400d39ae0b1a54447fedcb62eecd ]

If a CMOS RTC (PNP0B00/PNP0B01/PNP0B02) device coexists with an ACPI
TAD (timer and event alarm device, ACPI000E), the ACPI TAD driver will
attempt to install the CMOS RTC address space hanlder that has been
installed already and the TAD probing will fail.

Avoid that by changing acpi_install_cmos_rtc_space_handler() to return
zero and acpi_remove_cmos_rtc_space_handler() to do nothing if the CMOS
RTC address space handler has been installed already.

Fixes: 596ca52a56da ("ACPI: TAD: Install SystemCMOS address space handler for ACPI000E")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2415111.ElGaqSPkdT@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/cmos_rtc.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/x86/cmos_rtc.c b/drivers/acpi/x86/cmos_rtc.c
index 977234da9fc11..45db7e51cbe60 100644
--- a/drivers/acpi/x86/cmos_rtc.c
+++ b/drivers/acpi/x86/cmos_rtc.c
@@ -24,6 +24,8 @@ static const struct acpi_device_id acpi_cmos_rtc_ids[] = {
 	{}
 };
 
+static bool cmos_rtc_space_handler_present __read_mostly;
+
 static acpi_status acpi_cmos_rtc_space_handler(u32 function,
 					       acpi_physical_address address,
 					       u32 bits, u64 *value64,
@@ -59,6 +61,9 @@ int acpi_install_cmos_rtc_space_handler(acpi_handle handle)
 {
 	acpi_status status;
 
+	if (cmos_rtc_space_handler_present)
+		return 0;
+
 	status = acpi_install_address_space_handler(handle,
 						    ACPI_ADR_SPACE_CMOS,
 						    acpi_cmos_rtc_space_handler,
@@ -68,6 +73,8 @@ int acpi_install_cmos_rtc_space_handler(acpi_handle handle)
 		return -ENODEV;
 	}
 
+	cmos_rtc_space_handler_present = true;
+
 	return 1;
 }
 EXPORT_SYMBOL_GPL(acpi_install_cmos_rtc_space_handler);
@@ -76,6 +83,9 @@ void acpi_remove_cmos_rtc_space_handler(acpi_handle handle)
 {
 	acpi_status status;
 
+	if (cmos_rtc_space_handler_present)
+		return;
+
 	status = acpi_remove_address_space_handler(handle,
 						   ACPI_ADR_SPACE_CMOS,
 						   acpi_cmos_rtc_space_handler);
@@ -87,7 +97,13 @@ EXPORT_SYMBOL_GPL(acpi_remove_cmos_rtc_space_handler);
 static int acpi_cmos_rtc_attach(struct acpi_device *adev,
 				const struct acpi_device_id *id)
 {
-	return acpi_install_cmos_rtc_space_handler(adev->handle);
+	int ret;
+
+	ret = acpi_install_cmos_rtc_space_handler(adev->handle);
+	if (ret < 0)
+		return ret;
+
+	return 1;
 }
 
 static struct acpi_scan_handler cmos_rtc_handler = {
-- 
2.53.0



