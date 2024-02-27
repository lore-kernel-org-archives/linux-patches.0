Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2820513B78F;
	Tue, 27 Feb 2024 13:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041008; cv=none; b=DMLrlZzk7H4cwmwib3TYXzNiyLWeO+Be+kFQOgTaA92HTwmmkXCJaFCye20r+watCoAlO2Owz8K7pGWhWAEfNMy1tUgTZZ0nOWLK19ged+H51v6ZPumMMWfoSoo81Kiyj7Indx9+nC2OPQaDvS1fgf3gmKqYzi58adY157EfYNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041008; c=relaxed/simple;
	bh=RxcInxed/5NTzzpVkrYXgQAo47oZXBqOOH8K8AhXp+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HB9iOBlit2iTm5yJVgLFfGIfaBno5yBC6tbXHbaUfujYMKz53TZqBzc2Fh1wSDvP2w3Wo0nm6Er81VxfpVLRJ5emna1AiacgaqGYeHApTEMS8lRYDFG68vmKYG/3nJnA9UtpAk97zgHtjIOahYVI79hpPSxftcRc+rcyzvoiwO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPgXnS6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPgXnS6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02A3C433C7;
	Tue, 27 Feb 2024 13:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041008;
	bh=RxcInxed/5NTzzpVkrYXgQAo47oZXBqOOH8K8AhXp+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPgXnS6QwEOmCPmBal05FdEi38/aeMcH7iU7BZcstiO88NFBXnA+UBGhKHuMLIN1q
	 Ic/vNyh4S1fDdNWgsV/wWFs0OyTxmuhNpgUbkW4xC8HqWYruQYcVYcJR+FazQX0iFf
	 vml8ML/aSshGdHmauwQhIdW7xn5UEp3d0NIHq8HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.7 179/334] platform/x86: touchscreen_dmi: Allow partial (prefix) matches for ACPI names
Date: Tue, 27 Feb 2024 14:20:37 +0100
Message-ID: <20240227131636.365738434@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit dbcbfd662a725641d118fb3ae5ffb7be4e3d0fb0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/touchscreen_dmi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -81,7 +81,7 @@ static const struct property_entry chuwi
 };
 
 static const struct ts_dmi_data chuwi_hi8_air_data = {
-	.acpi_name	= "MSSL1680:00",
+	.acpi_name	= "MSSL1680",
 	.properties	= chuwi_hi8_air_props,
 };
 
@@ -1821,7 +1821,7 @@ static void ts_dmi_add_props(struct i2c_
 	int error;
 
 	if (has_acpi_companion(dev) &&
-	    !strncmp(ts_data->acpi_name, client->name, I2C_NAME_SIZE)) {
+	    strstarts(client->name, ts_data->acpi_name)) {
 		error = device_create_managed_software_node(dev, ts_data->properties, NULL);
 		if (error)
 			dev_err(dev, "failed to add properties: %d\n", error);


