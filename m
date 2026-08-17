Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68009429CEE;
	Mon, 17 Aug 2026 13:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975172; cv=none; b=oVBogMsXxHB3G0lUE2aaWk+cuE6lNlD1D6Y7sw/Y+HUFwQWRY7pwfw2fJAL8/t5dj0iuTl+5Z4fJn6x6AsLOKWzjR6cwl/T//Wq95M46Xsj1R/AdLQd1kjufIHDTbWaCb+uP32sikvvcqkDT+mnNYzfC6vfcypF1CZOeXlauUR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975172; c=relaxed/simple;
	bh=r8aLrFgMn/LnUDarnl6bdBnI587xGVxQq4UO9tmPGKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=km7UG27EAJdKEd3oZeJdcCJA3OQKE2XR9Nq0N51fVnFlozjkQ6Ao19zgo/8EvVLvQLnAoX0nHfBgXUiF3tCa+VxXcWrI+dzRTwjbXNJHwvHKCpH0+1Abcbkv6U0MYUE05c78jrPS6Sx2mHX+s79Ut1jSfSWRhsj6rZehxWzgHoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCRsBVhL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCRsBVhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12611F000E9;
	Mon, 17 Aug 2026 13:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975171;
	bh=XNl8eZD2lSWGkrqPqyRJSzsC/0Zal6p0M1kNV+uUIYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCRsBVhLlES9I8H6t4j+TT6GzrCJG+Afeclc2o1gv01P71v3mZSdprWtJzXkz1HOb
	 K/4Pf5XxpuC3HrZmVLs8qWTC73GjSSL4tG5VvkZZ/8UU7DM84na5Lf1k2v6Ovkz9Vv
	 znbjn9R2XuPfbmT8yhb/LuqXaNAMNdBCnM2uOsQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 186/250] ALSA: hda/tas2781: fix ACPI reference handling
Date: Mon, 17 Aug 2026 15:32:27 +0200
Message-ID: <20260817132544.182466788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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
@@ -347,6 +347,8 @@ static int tas2781_read_acpi(struct tas2
 	strscpy(p->dev_name, hid, sizeof(p->dev_name));
 	physdev = get_device(acpi_get_first_physical_node(adev));
 	acpi_dev_put(adev);
+	if (!physdev)
+		return -ENODEV;
 
 	property = "ti,dev-index";
 	ret = device_property_count_u32(physdev, property);
@@ -389,7 +391,6 @@ static int tas2781_read_acpi(struct tas2
 err:
 	dev_err(p->dev, "read acpi error, ret: %d\n", ret);
 	put_device(physdev);
-	acpi_dev_put(adev);
 
 	return ret;
 }


