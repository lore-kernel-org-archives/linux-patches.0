Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD36423EA3;
	Thu, 16 Jul 2026 13:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208980; cv=none; b=TWjwqxkC4i14NVdlKj0+i0rm1ELcmy4piEqBMXgxlpMSWCGHhaCBIPy+ICOG1KU89oxTvGG5+hVlMXLGcbB+2l6FTi6lXberMRhEpNhTUC9hviaU08OHWI6O4TpW/aVRuOyQmX0tCRnVkgvB9Y96+gzS+gCzOyek7WPc/faPOT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208980; c=relaxed/simple;
	bh=lSU1bnY0MUNcv1daTlokVRiHR4G8NqzCl/kmwzevrCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+JW6FstvxLN8uHbFf7HWTz8ui38SdkuuSI6t2tbII3Hjhz/fUweIaQy0w6PQwOdWPBunwFVcX59eyPxE3c8MAc9zjWT/Dig4x4EtUqb7rs+7+GbPl8MuvVX8f4g6TSRL0iuSuYVn6IqRUuWIRgawBGig+P04D2OKRyUWQtwKKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9HnSXP8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9HnSXP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880FC1F00A3A;
	Thu, 16 Jul 2026 13:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784208979;
	bh=B7dSPiFywS/MAkJgaR6IRQbNhqmRRJuKMKDbFRtr3CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k9HnSXP8eMHrtpZXEIjZPOQHtikbQEgr5K7ls78H2v8iSg2yA54XBqRZKAnqI0nvf
	 JgjvJzWFq+UD+GX+bbKSQ716Xmnoq4wD3NxwDLF0xVWmLr+G0yb+CTgHnuuCtBIMjO
	 EvRxCUKhKu8rKwidWb+sF1RPn9K4AB1hLN5/fdss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 7.1 012/518] ACPI: NFIT: core: Fix possible NULL pointer dereference
Date: Thu, 16 Jul 2026 15:24:40 +0200
Message-ID: <20260716133048.043565839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3460,6 +3460,9 @@ static void acpi_nfit_uc_error_notify(st
 {
 	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(dev);
 
+	if (!acpi_desc)
+		return;
+
 	if (acpi_desc->scrub_mode == HW_ERROR_SCRUB_ON)
 		acpi_nfit_ars_rescan(acpi_desc, ARS_REQ_LONG);
 	else


