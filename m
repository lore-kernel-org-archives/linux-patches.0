Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B31947141F;
	Tue, 21 Jul 2026 20:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664797; cv=none; b=N7lK1xd1nTWQvEZmkVJNIG6wzyh4hyw2THY/8STbOZ6oWn7ehAqCICUsUnDIP4zd4AQrhI4ckqrk6TjnS46cZkU4fEweUTjhNdrlVclGgLX+iJ9MuHz/8TttAAYzXBymoZX+O6LXdXMp0Wz6P4JegqiM66jypRpfKlk8qWCaPI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664797; c=relaxed/simple;
	bh=47ssRt/tHxGPxzAErY2/p5y8tJOM8Su6P3dRnpuLja8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4K71ufLcdHQc65qq4B4epjaCVetXLpYJN5qLM5L1iENa5/sZ7M/YtdAbRLUHU2Zl0byHJFMSO+Oax+gEf5q2aZiBnzWD2ZmJnKtVUf50Ucb0QDuciDP1cojgBCuEaNCVthpnP9Kvug1ywhDRTgwHxhNW62voIZSZNCg9t2VB4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sigPimQr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sigPimQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8671F000E9;
	Tue, 21 Jul 2026 20:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664796;
	bh=Xi6L6yp1LkSwqJLcYmnHqc2ODWFbIkHgmi242ko8Wac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sigPimQrOTlVqtl0L+b/3mc2QnYqAG/WyKDlUaIoZrqhIwnVPz5dkQkT1+FkImU8g
	 WRkvuiAbH6rYd6DLvxupA3nLxHGDT//esAR3bh/Ew8ZWcn/DxOpryxmkwfBunX2h7N
	 FlBHcLCpcZANkeX4R5tgcss7kzbOjMYETAAEr5PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.6 0062/1266] ACPI: NFIT: core: Fix possible NULL pointer dereference
Date: Tue, 21 Jul 2026 17:08:19 +0200
Message-ID: <20260721152443.190328131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3453,6 +3453,9 @@ static void acpi_nfit_uc_error_notify(st
 {
 	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(dev);
 
+	if (!acpi_desc)
+		return;
+
 	if (acpi_desc->scrub_mode == HW_ERROR_SCRUB_ON)
 		acpi_nfit_ars_rescan(acpi_desc, ARS_REQ_LONG);
 	else


