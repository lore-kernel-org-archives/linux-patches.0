Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D3A33BBAF;
	Wed, 20 May 2026 17:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297411; cv=none; b=ctGWRKbOQf07ISB3wtX/0SujbJ2Ma8gBW9MFZMrJCtntSAGJwKP8XYCIgINRABVri+c9xQEy0SEeL4FQWiiht7wshIoofKN6UA6NO+w8FA68KOeEUtK6QlIuWdpoV6c+QnDqGYwSA+G419aiKC9gR0cLRuhRLd8XQEBqXuqTsMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297411; c=relaxed/simple;
	bh=CZOkBlEZ+t83UzAjJZ+4p6xdPxM1yxccaFWoIgq5K6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fnq5Ig7COS3NB05bzrpyWv73+ll+Wr1+RDry1iHqseghlQo16zGs5ldnzjoQQN2o0aaZXITRilvFnLtbp2NwNy+GTgO6mAWuPimcqTRSb0SEKZtWd3AMAjV2xnus64yX6FW4eC9uAAQOyaWJz/02gUuWAqPhrI8+U/+VjBwJdSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkehaRDD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkehaRDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF161F000E9;
	Wed, 20 May 2026 17:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297409;
	bh=iM5ibgReYXZMqFscwiAhRZw50BRWLZcFr1qE3E8ojeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PkehaRDDMhqiGz0wE5zAyxNxSA+SparI5MMjAzQ1PcL6kGulJmMj3wltXf8fc1wht
	 LUscggj5M9lWm68cOM744sNdtshbToLqS4Z0dbNeZHY8RG9Fu5kvnUw8Dmh06tZvWa
	 37AcmH61IZRbWsMCKffeamvtgqA7tpsDnuN9Ow4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 021/957] ACPI: x86: cmos_rtc: Improve coordination with ACPI TAD driver
Date: Wed, 20 May 2026 18:08:24 +0200
Message-ID: <20260520162135.020433195@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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



