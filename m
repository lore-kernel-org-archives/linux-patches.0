Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEF63FE357;
	Thu, 16 Jul 2026 13:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209834; cv=none; b=kz+5qkoRA9PVpDgxuixdHHOrwGg3Xd+q5yYLWTxNsFDg50rfc/Cp/bvWTPNVhx3i7S9xCRZ9JomEO032cstTRu2K1vGTeDtm2UCTCPqpGftRhnOkzN1zFZEbrjvXPWpqq2LeRCyAzYFcX6iTJtx2fvnxtHEp+QQXvS7Ka78aXZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209834; c=relaxed/simple;
	bh=rcaL5E4QOrJ7FJmLY/SG3B3MWOumsJooEXBr6AMi6NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h13496io4UqvZzsqTZy2b5n41nu1QTsNfaWQOvf4vrSTjgQeXzXFNDb/OYW8L3gGWACPBmDYO70bv2Gk7Es8nxVGnH7jiPE/bkWDVoiGr1NQdr/B9c1RiZKizkUCltGxnsBiH3gAZeVlp/1kFzPbzKBC+QKS8NRXZh+bteIiivM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UjuXXQa2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UjuXXQa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFC61F00A3A;
	Thu, 16 Jul 2026 13:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209833;
	bh=Tm9xbnQowW+BMgjvXCSQSq5GL+AQoxwAHvDq+X5Mb2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UjuXXQa2CAaVMs8est52G/8mcKgZDW6exRMqbi6UhPHDgeaGotOlmFBxibVyIpAG5
	 UinVu8nyEyLnFzMCVeuyoI8zZmY4h40A2XY99MB0+/BrOE3OREm3m+hkb1BNFJUjW+
	 RetOBufRqaXi+aibWIOxtt0YlOicrbh9lqvruwYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.1 335/518] usb: typec: ucsi: cancel pending work on system suspend
Date: Thu, 16 Jul 2026 15:30:03 +0200
Message-ID: <20260716133055.141221361@linuxfoundation.org>
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

From: Paul Menzel <pmenzel@molgen.mpg.de>

commit 7c4a234bd31a64a8dbd0140dc812da592c5e0787 upstream.

On a Dell XPS 13 9360 (BIOS 2.21.0), entering system suspend (deep/S3)
races a pending UCSI connector-change worker against the ACPI EC teardown.
The worker evaluates the UCSI _DSM (GET_CONNECTOR_STATUS), whose AML
accesses the Embedded Controller. By that point the ACPI EC has already
been stopped for suspend, so the EC address space handler rejects the
access with AE_BAD_PARAMETER, aborting the AML and failing the connector
query:

    [22314.689495] ACPI: EC: interrupt blocked
    [22314.711981] ACPI: PM: Preparing to enter system sleep state S3
    [22314.743260] ACPI: EC: event blocked
    [22314.743265] ACPI: EC: EC stopped
    [22314.743267] ACPI: PM: Saving platform NVS memory
    [22314.744241] ACPI Error: AE_BAD_PARAMETER, Returned by Handler for [EmbeddedControl] (20260408/evregion-303)
    [22314.744432] ACPI Error: Aborting method \_SB.PCI0.LPCB.ECDV.ECW1 due to previous error (AE_BAD_PARAMETER) (20260408/psparse-543)
    [22314.744673] ACPI Error: Aborting method \ECWB due to previous error (AE_BAD_PARAMETER) (20260408/psparse-543)
    [22314.745201] ACPI Error: Aborting method \_SB.UBTC._DSM due to previous error (AE_BAD_PARAMETER) (20260408/psparse-543)
    [22314.745394] ACPI: \_SB_.UBTC: failed to evaluate _DSM c298836f-a47c-e411-ad36-631042b5008f rev:1 func:1 (0x1001)
    [22314.745414] ucsi_acpi USBC000:00: ucsi_acpi_dsm: failed to evaluate _DSM 1
    [22314.745424] ucsi_acpi USBC000:00: ucsi_handle_connector_change: GET_CONNECTOR_STATUS failed (-5)

ucsi_acpi implements a resume callback but no suspend callback, so nothing
cancels the connector-change work before the firmware/EC is torn down.

Add a `ucsi_suspend()` core helper that cancels the pending init and
connector-change work, and wire it into ucsi_acpi's PM ops. The connector
state is re-read on resume by `ucsi_resume()`, so cancelling the work loses
nothing.

Fixes: 4e3a50293c2b ("usb: typec: ucsi: acpi: Implement resume callback")
Cc: stable <stable@kernel.org>
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Assisted-by: Claude Opus 4.8
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260703110738.8457-2-pmenzel@molgen.mpg.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c      |   20 ++++++++++++++++++++
 drivers/usb/typec/ucsi/ucsi.h      |    1 +
 drivers/usb/typec/ucsi/ucsi_acpi.c |   10 +++++++++-
 3 files changed, 30 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1978,6 +1978,26 @@ static void ucsi_resume_work(struct work
 	}
 }
 
+int ucsi_suspend(struct ucsi *ucsi)
+{
+	int i;
+
+	/*
+	 * Cancel pending work so it cannot access the firmware after the ACPI
+	 * EC is stopped for suspend; state is re-read on resume.
+	 */
+	cancel_delayed_work_sync(&ucsi->work);
+
+	if (!ucsi->connector)
+		return 0;
+
+	for (i = 0; i < ucsi->cap.num_connectors; i++)
+		cancel_work_sync(&ucsi->connector[i].work);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ucsi_suspend);
+
 int ucsi_resume(struct ucsi *ucsi)
 {
 	if (ucsi->connector)
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -566,6 +566,7 @@ int ucsi_send_command(struct ucsi *ucsi,
 		      void *retval, size_t size);
 
 void ucsi_altmode_update_active(struct ucsi_connector *con);
+int ucsi_suspend(struct ucsi *ucsi);
 int ucsi_resume(struct ucsi *ucsi);
 
 void ucsi_notify_common(struct ucsi *ucsi, u32 cci);
--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -245,6 +245,13 @@ static void ucsi_acpi_remove(struct plat
 				   ucsi_acpi_notify);
 }
 
+static int ucsi_acpi_suspend(struct device *dev)
+{
+	struct ucsi_acpi *ua = dev_get_drvdata(dev);
+
+	return ucsi_suspend(ua->ucsi);
+}
+
 static int ucsi_acpi_resume(struct device *dev)
 {
 	struct ucsi_acpi *ua = dev_get_drvdata(dev);
@@ -252,7 +259,8 @@ static int ucsi_acpi_resume(struct devic
 	return ucsi_resume(ua->ucsi);
 }
 
-static DEFINE_SIMPLE_DEV_PM_OPS(ucsi_acpi_pm_ops, NULL, ucsi_acpi_resume);
+static DEFINE_SIMPLE_DEV_PM_OPS(ucsi_acpi_pm_ops, ucsi_acpi_suspend,
+				ucsi_acpi_resume);
 
 static const struct acpi_device_id ucsi_acpi_match[] = {
 	{ "PNP0CA0", 0 },


