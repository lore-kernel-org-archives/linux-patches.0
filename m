Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CF33F23D1;
	Thu, 16 Jul 2026 14:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210406; cv=none; b=o7N8qQbu49AJPg2Ci70YaZ81Gea7RLYiBJ2lrYvzMdAm3ddaSTj1GXYGfQ5FHhXVPPyWmZyZIgsUW0ol9VnZrpr3GMMbfZzCoYfmvJcKY6+ysqrXNynIDGyi8ttqjtZ1+pyazrR+xjWM6dGoNBsKcRzYRnQQcsSveYJlnGaos+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210406; c=relaxed/simple;
	bh=4v6wBKVCxOPL35hfneuzQ2r94zZu++sq4Ez8ONSjQ7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dd4CIA1FhBtNDqP/kRG1WFs7KNhIV+aYbBVcx25c61AUCvbJ2aSFpjVnfWKiCPqC+vu1/QHO/kgroTTxQd6imVbbslYoiTgnSKyM9vBnHUahDtgALK9DnY16Epz/YpXM1X3tl+m4xO1GBriYtPJLji522wMzviaYnOhtu2PNLdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKPkHsUC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKPkHsUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252081F000E9;
	Thu, 16 Jul 2026 14:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210405;
	bh=6IUSII6vH3UQpMv830IoikYi8hL1wSMAwBmIjNCpzbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dKPkHsUC6iz/FRYYenZykZtr7ivRR7VbecwjhulWKQ2aiQ9EmJL57iQjxITzXHNNB
	 Z0k1Qdi4j6pRfiGhzokT3WrPCiFrVmvmEQfeHkpMGKphByzOfzoek78WfSr0dTiVp/
	 AJeJlNbG76PCuTH4O6cmCerR52xaMm4mFd0eyeWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.18 034/480] ACPI: NFIT: core: Fix possible NULL pointer dereference
Date: Thu, 16 Jul 2026 15:26:21 +0200
Message-ID: <20260716133045.437930853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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


