Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8567332604;
	Thu, 16 Jul 2026 14:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211672; cv=none; b=A1KFlZQPe5DtlAfhZqSVpYPTPCx1DL03gjwhOvS0yoTPWQIEG14V+8B19yntA4atIH7rWouOPSRSPHan2LCcEn+qdR7NB4xEYAxkefxeebkkk2D14dSi6EPhMpwVVdcDrpfqheIcuXmdfISG3AlEtt1noRfM85ysg8f9Xk6vuts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211672; c=relaxed/simple;
	bh=UCEgjnsdSQqs5qFEDuaAOpQbrTo931WKxUMbILOSTqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eG3xf3A/jVbcB2g1IDG2yWq4No3d/BZcg/hqjeFLRKOV+ACp0HR5encqbM29xHQuwBt97R40Qd6qFYskrVNB5rXIwM0wwp7iVNB9RdYa1qN4dwtG9ynieOoTnxPR+NOE2CL7iKARpzRpYMt9AzAwrb/uzP1Jdd5HEL/DnKVhgyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2+C3RCr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2+C3RCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F8F1F000E9;
	Thu, 16 Jul 2026 14:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211671;
	bh=yzy846CSZS6FOxRKpXc2TJSSSy9rjbCib3tywJYmmTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2+C3RCr8qi5JKR92HjWKE1ZqpkBL4NedA+2mUuwb+Fo3tLtrRR1xbaLDFJp5P53e
	 xbOjrs/DuInWfwyDXN9GjlWBxOsdi3mS6dPbsER1riHTK3fpUxlOUGWo1tl4hzu7IE
	 8RtwGFlaDv46WYzGmttkPgy+jxC27XFhfmoJH71g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.12 035/349] ACPI: NFIT: core: Fix possible NULL pointer dereference
Date: Thu, 16 Jul 2026 15:29:29 +0200
Message-ID: <20260716133034.095670512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

commit 027e128abb82788189d6d45b68e3e8e7329b67be upstream.

After commit 9b311b7313d6 ("ACPI: NFIT: Install Notify() handler before
getting NFIT table"), acpi_nfit_probe() installs an ACPI notify handler
for the NFIT device before checking the presence of the NFIT table.  If
that table is not there, 0 is returned without allocating the acpi_desc
object and setting the driver data pointer of the NFIT device.  If the
platform firmware triggers an NFIT_NOTIFY_UC_MEMORY_ERROR notification
on the NFIT device at that point, acpi_nfit_uc_error_notify() will
dereference a NULL pointer.

Prevent that from occurring by adding an acpi_desc check against NULL
to acpi_nfit_uc_error_notify().

Fixes: 9b311b7313d6 ("ACPI: NFIT: Install Notify() handler before getting NFIT table")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: All applicable <stable@vger.kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/2418508.ElGaqSPkdT@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/nfit/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3447,6 +3447,9 @@ static void acpi_nfit_uc_error_notify(st
 {
 	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(dev);
 
+	if (!acpi_desc)
+		return;
+
 	if (acpi_desc->scrub_mode == HW_ERROR_SCRUB_ON)
 		acpi_nfit_ars_rescan(acpi_desc, ARS_REQ_LONG);
 	else


