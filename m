Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0AE14D2B3;
	Mon, 16 Sep 2024 12:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488567; cv=none; b=Bmoi63QtgYtBvHzG4LKNPOKT8l9iKGBCeXB5vmtDBKUseZgAuDMZP+WEgqRLS2g30mfcSD4yMzypdrfnfy4OKVyC4EAL8u6t8ZeZqnsj03/QA+qPr0OGqMdvKfaxzyC+cL+SSbJMuQqan2g6Yrr4kbH0MV4dfjoF+49Ouqv+/rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488567; c=relaxed/simple;
	bh=ZoYQZkCdmGd8EW1fP0Vbkapg9WuWnQFZri4sPonDg9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LKmI/OH5y+Jvy2OzUnxnbXL2WYJ/uzICc72UXTwYi53aOtKVNlSndY3IlVVEMwyXzVhOP2yYEVrs1AHP7ol8rOm/go5SvfG6eltmEYlQZ5XS6PbB7OtDDop5dWmmiAhFqnynSVEkDvneJscHsqfVFWTmd8bafZSdAIDqNKaA2vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wq2ViYuO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wq2ViYuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533A8C4CEC4;
	Mon, 16 Sep 2024 12:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488567;
	bh=ZoYQZkCdmGd8EW1fP0Vbkapg9WuWnQFZri4sPonDg9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wq2ViYuO6PxNXUfIp6+h6tLlf7jE49igxmi8rhyQ1dAv7r+qdE/qAjrZKsZKt2Ugd
	 X/BNUXhNIzIKHl6f/csWuDpAHfpt6DYp1Qx9cLuEwhKxlxB2pAOtIUWm5DwFA5oFTa
	 qSMMckficYh6+Qk6asnlnkHmJKPYQc7ojqyHbY5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 36/91] platform/x86: panasonic-laptop: Fix SINF array out of bounds accesses
Date: Mon, 16 Sep 2024 13:44:12 +0200
Message-ID: <20240916114225.705174518@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit f52e98d16e9bd7dd2b3aef8e38db5cbc9899d6a4 upstream.

The panasonic laptop code in various places uses the SINF array with index
values of 0 - SINF_CUR_BRIGHT(0x0d) without checking that the SINF array
is big enough.

Not all panasonic laptops have this many SINF array entries, for example
the Toughbook CF-18 model only has 10 SINF array entries. So it only
supports the AC+DC brightness entries and mute.

Check that the SINF array has a minimum size which covers all AC+DC
brightness entries and refuse to load if the SINF array is smaller.

For higher SINF indexes hide the sysfs attributes when the SINF array
does not contain an entry for that attribute, avoiding show()/store()
accessing the array out of bounds and add bounds checking to the probe()
and resume() code accessing these.

Fixes: e424fb8cc4e6 ("panasonic-laptop: avoid overflow in acpi_pcc_hotkey_add()")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240909113227.254470-1-hdegoede@redhat.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/panasonic-laptop.c |   49 +++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 10 deletions(-)

--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -773,6 +773,24 @@ static DEVICE_ATTR_RW(dc_brightness);
 static DEVICE_ATTR_RW(current_brightness);
 static DEVICE_ATTR_RW(cdpower);
 
+static umode_t pcc_sysfs_is_visible(struct kobject *kobj, struct attribute *attr, int idx)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct acpi_device *acpi = to_acpi_device(dev);
+	struct pcc_acpi *pcc = acpi_driver_data(acpi);
+
+	if (attr == &dev_attr_mute.attr)
+		return (pcc->num_sifr > SINF_MUTE) ? attr->mode : 0;
+
+	if (attr == &dev_attr_eco_mode.attr)
+		return (pcc->num_sifr > SINF_ECO_MODE) ? attr->mode : 0;
+
+	if (attr == &dev_attr_current_brightness.attr)
+		return (pcc->num_sifr > SINF_CUR_BRIGHT) ? attr->mode : 0;
+
+	return attr->mode;
+}
+
 static struct attribute *pcc_sysfs_entries[] = {
 	&dev_attr_numbatt.attr,
 	&dev_attr_lcdtype.attr,
@@ -787,8 +805,9 @@ static struct attribute *pcc_sysfs_entri
 };
 
 static const struct attribute_group pcc_attr_group = {
-	.name	= NULL,		/* put in device directory */
-	.attrs	= pcc_sysfs_entries,
+	.name		= NULL,		/* put in device directory */
+	.attrs		= pcc_sysfs_entries,
+	.is_visible	= pcc_sysfs_is_visible,
 };
 
 
@@ -941,12 +960,15 @@ static int acpi_pcc_hotkey_resume(struct
 	if (!pcc)
 		return -EINVAL;
 
-	acpi_pcc_write_sset(pcc, SINF_MUTE, pcc->mute);
-	acpi_pcc_write_sset(pcc, SINF_ECO_MODE, pcc->eco_mode);
+	if (pcc->num_sifr > SINF_MUTE)
+		acpi_pcc_write_sset(pcc, SINF_MUTE, pcc->mute);
+	if (pcc->num_sifr > SINF_ECO_MODE)
+		acpi_pcc_write_sset(pcc, SINF_ECO_MODE, pcc->eco_mode);
 	acpi_pcc_write_sset(pcc, SINF_STICKY_KEY, pcc->sticky_key);
 	acpi_pcc_write_sset(pcc, SINF_AC_CUR_BRIGHT, pcc->ac_brightness);
 	acpi_pcc_write_sset(pcc, SINF_DC_CUR_BRIGHT, pcc->dc_brightness);
-	acpi_pcc_write_sset(pcc, SINF_CUR_BRIGHT, pcc->current_brightness);
+	if (pcc->num_sifr > SINF_CUR_BRIGHT)
+		acpi_pcc_write_sset(pcc, SINF_CUR_BRIGHT, pcc->current_brightness);
 
 	return 0;
 }
@@ -963,8 +985,12 @@ static int acpi_pcc_hotkey_add(struct ac
 
 	num_sifr = acpi_pcc_get_sqty(device);
 
-	if (num_sifr < 0 || num_sifr > 255) {
-		pr_err("num_sifr out of range");
+	/*
+	 * pcc->sinf is expected to at least have the AC+DC brightness entries.
+	 * Accesses to higher SINF entries are checked against num_sifr.
+	 */
+	if (num_sifr <= SINF_DC_CUR_BRIGHT || num_sifr > 255) {
+		pr_err("num_sifr %d out of range %d - 255\n", num_sifr, SINF_DC_CUR_BRIGHT + 1);
 		return -ENODEV;
 	}
 
@@ -1020,11 +1046,14 @@ static int acpi_pcc_hotkey_add(struct ac
 	acpi_pcc_write_sset(pcc, SINF_STICKY_KEY, 0);
 	pcc->sticky_key = 0;
 
-	pcc->eco_mode = pcc->sinf[SINF_ECO_MODE];
-	pcc->mute = pcc->sinf[SINF_MUTE];
 	pcc->ac_brightness = pcc->sinf[SINF_AC_CUR_BRIGHT];
 	pcc->dc_brightness = pcc->sinf[SINF_DC_CUR_BRIGHT];
-	pcc->current_brightness = pcc->sinf[SINF_CUR_BRIGHT];
+	if (pcc->num_sifr > SINF_MUTE)
+		pcc->mute = pcc->sinf[SINF_MUTE];
+	if (pcc->num_sifr > SINF_ECO_MODE)
+		pcc->eco_mode = pcc->sinf[SINF_ECO_MODE];
+	if (pcc->num_sifr > SINF_CUR_BRIGHT)
+		pcc->current_brightness = pcc->sinf[SINF_CUR_BRIGHT];
 
 	/* add sysfs attributes */
 	result = sysfs_create_group(&device->dev.kobj, &pcc_attr_group);


