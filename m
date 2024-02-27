Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BCC16423;
	Tue, 27 Feb 2024 14:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042679; cv=none; b=Ry17LX7oZaJLhnyVQ+x/woFyGcrn5MCBupcmBNIr3icNBWuLJQtLbQEhLRl19IOxIw9b/lweTADcQ3I1zuvyfivAV2WugwnvpletSLTMyDU3BBTRFZJA2E8OWCtYVhwicTG5JBpS9hT0aUiJX/bAGwtW87p8259FJGwRF5E/DPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042679; c=relaxed/simple;
	bh=Q76BX/l0BzaT3CslBq9O3wDl5FZHSu0oIJhFv2K6y1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfPACf2AEDbQQFCUUu5KkkU75CGolJqzuecNLXx/D3Z+hIYufXZ2QMRyqDKbZIWulWpM7FAFci3tSfQBd9roTxBDKpiXvxMBAN6kb32sFIn2qeiUxL7zZkA9gOR+fnoiKpH5ERGkbS7l4B1iR8y2xVdzGqC0Y4kCF1hORFtD+zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEQUL+0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEQUL+0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F44BC433F1;
	Tue, 27 Feb 2024 14:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042679;
	bh=Q76BX/l0BzaT3CslBq9O3wDl5FZHSu0oIJhFv2K6y1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEQUL+0l/4uyHl5TC75h5djxqQF5FwkseISxlXSlRqyY5Ji3CIOXBrNT1gqyNwQYg
	 27+GuBhcdn7wnJUU6X3y3Cc14wdbyb2YumttKFCqVHlVJt7RlkDsQkueV/xt1ii9hI
	 tLuLqeFH6aGNPzRmvD0weZr6qQDQr7flrITQfuUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 081/245] platform/x86: touchscreen_dmi: Allow partial (prefix) matches for ACPI names
Date: Tue, 27 Feb 2024 14:24:29 +0100
Message-ID: <20240227131617.871296840@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -50,7 +50,7 @@ static const struct property_entry chuwi
 };
 
 static const struct ts_dmi_data chuwi_hi8_air_data = {
-	.acpi_name	= "MSSL1680:00",
+	.acpi_name	= "MSSL1680",
 	.properties	= chuwi_hi8_air_props,
 };
 
@@ -1745,7 +1745,7 @@ static void ts_dmi_add_props(struct i2c_
 	int error;
 
 	if (has_acpi_companion(dev) &&
-	    !strncmp(ts_data->acpi_name, client->name, I2C_NAME_SIZE)) {
+	    strstarts(client->name, ts_data->acpi_name)) {
 		error = device_create_managed_software_node(dev, ts_data->properties, NULL);
 		if (error)
 			dev_err(dev, "failed to add properties: %d\n", error);


