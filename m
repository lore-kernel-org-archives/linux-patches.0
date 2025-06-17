Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4D42F2C41;
	Tue, 17 Jun 2025 15:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175423; cv=none; b=CE6vQVLQuFZcmmyG+OCy0U6LnwXcF3PEjXlRSH2g3qClJav0D0K3mUMGaTcmI1VGzwnnwvYmX0phnASIk/bEP4+l2FoRlymAnBmRb+DoxoSxQfRvzYX3eLkoZ1fPDkAjNb7TtyNZZKCvJiTamwzysNy/REb5pHN0Cvsl+QYqAD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175423; c=relaxed/simple;
	bh=hUN0BFYMjwI1svQL+RBOemtKZHRTdJ7o27yMzfneW+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHuw+BSiTrjzVIyaJtOTU9OFDfwUZz2h+IEI1rCbK2+Nxn+LqDDauku4lkpWnh+m/QgoRTrmESaYHU2zmp2/jCm+kmEMctbt2DoqzoNWevdw821OVhwiSeDgJAT4GlixYC5BQlepKECVj+qJdjGcyOhJuGtwGP5wqQuHEvV4Zrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPkKCEQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPkKCEQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0475C4CEE3;
	Tue, 17 Jun 2025 15:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175423;
	bh=hUN0BFYMjwI1svQL+RBOemtKZHRTdJ7o27yMzfneW+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPkKCEQq1L9EyEbpIBrALkyI7RJfQOLxo3HqDqMXMZXUO2FNJ1AgvxK2aT+MThOKt
	 apxpr6SXYxGZwzaEmXLnjO8FhOKeSbGzULr4z9ayInx1MlZR1ZUw5OhTftbLG/fZ3v
	 wpyBGm3v3IivvTVld1cesN6FkOaGRV0uhAlHZ9ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 086/780] ALSA: core: fix up bus match const issues.
Date: Tue, 17 Jun 2025 17:16:34 +0200
Message-ID: <20250617152455.017708106@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 62f134ab190c5fd5c9f68fe638ad8e13bb8a4cb4 ]

In commit d69d80484598 ("driver core: have match() callback in struct
bus_type take a const *"), the match bus callback was changed to have
the driver be a const pointer.  Unfortunately that const attribute was
thrown away when container_of() is called, which is not correct and was
not caught by the compiler due to how container_of() is implemented.
Fix this up by correctly preserving the const attribute of the driver
passed to the bus match function which requires the hdac_driver match
function to also take a const pointer for the driver structure.

Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Fixes: d69d80484598 ("driver core: have match() callback in struct bus_type take a const *")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2025052204-hyphen-thermal-3e72@gregkh
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hdaudio.h  | 4 ++--
 sound/core/seq_device.c  | 2 +-
 sound/hda/hda_bus_type.c | 6 +++---
 sound/pci/hda/hda_bind.c | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/sound/hdaudio.h b/include/sound/hdaudio.h
index b098ceadbe74b..9a70048adbc06 100644
--- a/include/sound/hdaudio.h
+++ b/include/sound/hdaudio.h
@@ -223,7 +223,7 @@ struct hdac_driver {
 	struct device_driver driver;
 	int type;
 	const struct hda_device_id *id_table;
-	int (*match)(struct hdac_device *dev, struct hdac_driver *drv);
+	int (*match)(struct hdac_device *dev, const struct hdac_driver *drv);
 	void (*unsol_event)(struct hdac_device *dev, unsigned int event);
 
 	/* fields used by ext bus APIs */
@@ -235,7 +235,7 @@ struct hdac_driver {
 #define drv_to_hdac_driver(_drv) container_of(_drv, struct hdac_driver, driver)
 
 const struct hda_device_id *
-hdac_get_device_id(struct hdac_device *hdev, struct hdac_driver *drv);
+hdac_get_device_id(struct hdac_device *hdev, const struct hdac_driver *drv);
 
 /*
  * Bus verb operators
diff --git a/sound/core/seq_device.c b/sound/core/seq_device.c
index 4492be5d2317c..bac9f86037342 100644
--- a/sound/core/seq_device.c
+++ b/sound/core/seq_device.c
@@ -43,7 +43,7 @@ MODULE_LICENSE("GPL");
 static int snd_seq_bus_match(struct device *dev, const struct device_driver *drv)
 {
 	struct snd_seq_device *sdev = to_seq_dev(dev);
-	struct snd_seq_driver *sdrv = to_seq_drv(drv);
+	const struct snd_seq_driver *sdrv = to_seq_drv(drv);
 
 	return strcmp(sdrv->id, sdev->id) == 0 &&
 		sdrv->argsize == sdev->argsize;
diff --git a/sound/hda/hda_bus_type.c b/sound/hda/hda_bus_type.c
index 7545ace7b0ee4..eb72a7af2e56e 100644
--- a/sound/hda/hda_bus_type.c
+++ b/sound/hda/hda_bus_type.c
@@ -21,7 +21,7 @@ MODULE_LICENSE("GPL");
  * driver id_table and returns the matching device id entry.
  */
 const struct hda_device_id *
-hdac_get_device_id(struct hdac_device *hdev, struct hdac_driver *drv)
+hdac_get_device_id(struct hdac_device *hdev, const struct hdac_driver *drv)
 {
 	if (drv->id_table) {
 		const struct hda_device_id *id  = drv->id_table;
@@ -38,7 +38,7 @@ hdac_get_device_id(struct hdac_device *hdev, struct hdac_driver *drv)
 }
 EXPORT_SYMBOL_GPL(hdac_get_device_id);
 
-static int hdac_codec_match(struct hdac_device *dev, struct hdac_driver *drv)
+static int hdac_codec_match(struct hdac_device *dev, const struct hdac_driver *drv)
 {
 	if (hdac_get_device_id(dev, drv))
 		return 1;
@@ -49,7 +49,7 @@ static int hdac_codec_match(struct hdac_device *dev, struct hdac_driver *drv)
 static int hda_bus_match(struct device *dev, const struct device_driver *drv)
 {
 	struct hdac_device *hdev = dev_to_hdac_dev(dev);
-	struct hdac_driver *hdrv = drv_to_hdac_driver(drv);
+	const struct hdac_driver *hdrv = drv_to_hdac_driver(drv);
 
 	if (hdev->type != hdrv->type)
 		return 0;
diff --git a/sound/pci/hda/hda_bind.c b/sound/pci/hda/hda_bind.c
index 9521e5e0e6e6f..1fef350d821ef 100644
--- a/sound/pci/hda/hda_bind.c
+++ b/sound/pci/hda/hda_bind.c
@@ -18,10 +18,10 @@
 /*
  * find a matching codec id
  */
-static int hda_codec_match(struct hdac_device *dev, struct hdac_driver *drv)
+static int hda_codec_match(struct hdac_device *dev, const struct hdac_driver *drv)
 {
 	struct hda_codec *codec = container_of(dev, struct hda_codec, core);
-	struct hda_codec_driver *driver =
+	const struct hda_codec_driver *driver =
 		container_of(drv, struct hda_codec_driver, core);
 	const struct hda_device_id *list;
 	/* check probe_id instead of vendor_id if set */
-- 
2.39.5



