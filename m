Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26C03F9F26;
	Mon, 17 Aug 2026 13:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974435; cv=none; b=rZ1uSYbNT1tt4vmvUteLoR6I37oNydXDnPGJOykm/Ny5HBj/DN0omDtPONNZxlLzrnldkegEpHl8w88GR6nGmfn75WdHqhJjfS+ZFEmf6ToEjB3qOdnjceIwFrih126LXzr7sDkKyTlt0y1F6T3OtQQS26KKXHLvFT0oOWBlgq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974435; c=relaxed/simple;
	bh=DoIFfxb09H3s5Tf+TlLp+p7lRZJl0EkPT/9zFVen+qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4+pOrcdBpy5q0qto6vKvxVIrNJnFWLt4S7HVCYHN+Bwhvm7ZPJtdnPFPcH6CVfPJU/X/vIxqx9cuu5fNl5Ax9eCWSxTrKTATf8EC6nECFt+Kgv3hTtn+IaFgkPix4n1R7q+fqVSbIuif/WFGWvXl71ZNyt6UmwLf1HUOlh7Iak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HgiTottW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgiTottW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A75C1F000E9;
	Mon, 17 Aug 2026 13:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974428;
	bh=4E/JEImELwTvAHcbvcTQ6Ri31p3HH29A4wnqXdwVtQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgiTottWLEDJvrVmTt241RqqOcBYfOxWH+4v56bLcQn7Z3E/BAONiD6ej0b+InFXK
	 SvD+w0sCLSD1ujLp9c4cs3DiwgaNxX2jK6NvEKzcJUfJ6TiL08a4BL6WXP4sACm43c
	 iTvLgGED9Md/7mF97H5eKULTI7z81cpg6Gfxh+Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 201/271] ALSA: hda/tas2781: fix ACPI reference handling
Date: Mon, 17 Aug 2026 15:32:06 +0200
Message-ID: <20260817132545.095815716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit 8bec01c80e798eca1ae7863cf29bc6befd759db7 upstream.

tas2781_read_acpi() gets a reference to the matching ACPI device and then
looks up its first physical device node. After taking a reference to the
physical device, it immediately drops the ACPI device reference.

However, every later failure jumps to an error path that drops the ACPI
device reference a second time. This unbalances the reference count and
may prematurely release the ACPI device.

In addition, acpi_get_first_physical_node() may return NULL. Without a
check, the driver passes the NULL physical device to the property helper
calls and may dereference it.

Return -ENODEV when no physical device is associated with the ACPI node,
and remove the duplicate acpi_dev_put() from the common error path.

Fixes: bb5f86ea50ff ("ALSA: hda/tas2781: Add tas2781 hda SPI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/97EA8F29DA0D9AF7+20260731033554.949564-1-raoxu@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/side-codecs/tas2781_hda_spi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
@@ -344,6 +344,8 @@ static int tas2781_read_acpi(struct tas2
 	strscpy(p->dev_name, hid, sizeof(p->dev_name));
 	physdev = get_device(acpi_get_first_physical_node(adev));
 	acpi_dev_put(adev);
+	if (!physdev)
+		return -ENODEV;
 
 	property = "ti,dev-index";
 	ret = device_property_count_u32(physdev, property);
@@ -386,7 +388,6 @@ static int tas2781_read_acpi(struct tas2
 err:
 	dev_err(p->dev, "read acpi error, ret: %d\n", ret);
 	put_device(physdev);
-	acpi_dev_put(adev);
 
 	return ret;
 }


