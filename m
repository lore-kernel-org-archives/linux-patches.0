Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FAB1C687;
	Mon,  4 Mar 2024 21:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588068; cv=none; b=FOp48Sz+05+bXJWF+MviUDUobImnd9ixR+pZIYgUZTnuJqzjsqd4vOqP3Ht3EVA4Pi3zWqUQh2igxpVAED9Ee7SRJYcmgXzMAXXU7MCZ0Cug1ehvKrkXtg8zQY9I2dk9xNHm/Mw+aEcw4PvxAgNb+Pws5EHRXtmym1WYl5gDOQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588068; c=relaxed/simple;
	bh=971bjp9QehgN0+7BqILEz1RK8MKWg9Zv4XC3bUPi3Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1Rt7SMR3jRefoGv+Flp3F37enbr4iVMd3TU/0aKxHVPpcvIo7A/GmMAppsJzY2PD+rlj50U+OUJ6UTIxyaJEKWXqvNWzyGJwPWI9gA9gkp0rTAsIAHTKwpMXn6+OaN6CPpGGNVEdZk+uyMqeuq93OxQzGmK4Si6ck/x3DNojzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMn74fjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMn74fjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9164CC433F1;
	Mon,  4 Mar 2024 21:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588067;
	bh=971bjp9QehgN0+7BqILEz1RK8MKWg9Zv4XC3bUPi3Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMn74fjfC2pLKmdjWNaO7jhCtu+0D1/ODEzX1T8SqcYgODGNPQEoGRFGAajVAvw1o
	 iSkN4tCEmPe2v7Wa0pNlzKfKmFRGdejo62ZO0TzxPCCjAftYgk/rhBIszqLMZUGqKg
	 DvNJRQ63gD4+YF93fQO7lUPcjyC3jH/TGZBNc3Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/42] platform/x86: touchscreen_dmi: Allow partial (prefix) matches for ACPI names
Date: Mon,  4 Mar 2024 21:23:28 +0000
Message-ID: <20240304211537.679129630@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit dbcbfd662a725641d118fb3ae5ffb7be4e3d0fb0 ]

On some devices the ACPI name of the touchscreen is e.g. either
MSSL1680:00 or MSSL1680:01 depending on the BIOS version.

This happens for example on the "Chuwi Hi8 Air" tablet where the initial
commit's ts_data uses "MSSL1680:00" but the tablets from the github issue
and linux-hardware.org probe linked below both use "MSSL1680:01".

Replace the strcmp() match on ts_data->acpi_name with a strstarts()
check to allow using a partial match on just the ACPI HID of "MSSL1680"
and change the ts_data->acpi_name for the "Chuwi Hi8 Air" accordingly
to fix the touchscreen not working on models where it is "MSSL1680:01".

Note this drops the length check for I2C_NAME_SIZE. This never was
necessary since the ACPI names used are never more then 11 chars and
I2C_NAME_SIZE is 20 so the replaced strncmp() would always stop long
before reaching I2C_NAME_SIZE.

Link: https://linux-hardware.org/?computer=AC4301C0542A
Fixes: bbb97d728f77 ("platform/x86: touchscreen_dmi: Add info for the Chuwi Hi8 Air tablet")
Closes: https://github.com/onitake/gsl-firmware/issues/91
Cc: stable@vger.kernel.org
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240212120608.30469-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -50,7 +50,7 @@ static const struct property_entry chuwi
 };
 
 static const struct ts_dmi_data chuwi_hi8_air_data = {
-	.acpi_name	= "MSSL1680:00",
+	.acpi_name	= "MSSL1680",
 	.properties	= chuwi_hi8_air_props,
 };
 
@@ -1648,7 +1648,7 @@ static void ts_dmi_add_props(struct i2c_
 	int error;
 
 	if (has_acpi_companion(dev) &&
-	    !strncmp(ts_data->acpi_name, client->name, I2C_NAME_SIZE)) {
+	    strstarts(client->name, ts_data->acpi_name)) {
 		error = device_add_properties(dev, ts_data->properties);
 		if (error)
 			dev_err(dev, "failed to add properties: %d\n", error);


