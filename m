Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0522F3626;
	Mon, 22 Sep 2025 19:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570307; cv=none; b=ftXutzhAoVxks2C1EXUvyXZ59SwafGnn2jZzYfF5HKBEIoabiQzjwqpxMnhN+5IPowjETswY923I5/fUf/8YYEXYjI6KCNK0VAaZ2i9hNhlx7j0gWUxKA+dN36ING0JYUdKtzBhgVO0EXLLvIuU+cHX8N6662VbUU6gGs0+s3Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570307; c=relaxed/simple;
	bh=+g6BC0aESKzJcRQ+AZqClLcm1SunYw1vVUq3IDcjJ9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzMercbQEgmL4tMR6v3ykXDvGNt/Nm0TsfiE1+8U0MZyulUk8scMNzMmwbxNFyUI2R1Fhjwh6138CwX2oNjdC4OQ1CG+Jom9JYW4JnA56nG/oIuWt+XRyge5Mr0H11d+KhSBsmW7LE8jIKSVDDCMhDyWsPZpTx7KH3JmAwRgia0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WA5fdqqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WA5fdqqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265F9C4CEF0;
	Mon, 22 Sep 2025 19:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570307;
	bh=+g6BC0aESKzJcRQ+AZqClLcm1SunYw1vVUq3IDcjJ9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WA5fdqqpiCLZVZNaw5ktpwva8X/z+bDoe+Jh2PeLaDC2SuZWLjFmYGIh1afGpLOJ0
	 ZXtsBp0uTSFBVGwu16lY8mRTu0CKMc4OUwxJ0PzEfH7lVf5XCNQqKQGGWup6P30N++
	 6qFbjqwn0Ba4i7N7me19wOpkveeX6cNhrtq9KhwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.16 084/149] ASoC: SDCA: Add quirk for incorrect function types for 3 systems
Date: Mon, 22 Sep 2025 21:29:44 +0200
Message-ID: <20250922192415.005928426@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

commit 28edfaa10ca1b370b1a27fde632000d35c43402c upstream.

Certain systems have CS42L43 DisCo that claims to conform to version 0.6.28
but uses the function types from the 1.0 spec. Add a quirk as a workaround.

Closes: https://github.com/thesofproject/linux/issues/5515
Cc: stable@vger.kernel.org
Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20250901151518.3197941-1-mstrozek@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/sound/sdca.h            |    1 +
 sound/soc/sdca/sdca_device.c    |   20 ++++++++++++++++++++
 sound/soc/sdca/sdca_functions.c |   13 ++++++++-----
 3 files changed, 29 insertions(+), 5 deletions(-)

--- a/include/sound/sdca.h
+++ b/include/sound/sdca.h
@@ -46,6 +46,7 @@ struct sdca_device_data {
 
 enum sdca_quirk {
 	SDCA_QUIRKS_RT712_VB,
+	SDCA_QUIRKS_SKIP_FUNC_TYPE_PATCHING,
 };
 
 #if IS_ENABLED(CONFIG_ACPI) && IS_ENABLED(CONFIG_SND_SOC_SDCA)
--- a/sound/soc/sdca/sdca_device.c
+++ b/sound/soc/sdca/sdca_device.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/property.h>
 #include <linux/soundwire/sdw.h>
@@ -55,11 +56,30 @@ static bool sdca_device_quirk_rt712_vb(s
 	return false;
 }
 
+static bool sdca_device_quirk_skip_func_type_patching(struct sdw_slave *slave)
+{
+	const char *vendor, *sku;
+
+	vendor = dmi_get_system_info(DMI_SYS_VENDOR);
+	sku = dmi_get_system_info(DMI_PRODUCT_SKU);
+
+	if (vendor && sku &&
+	    !strcmp(vendor, "Dell Inc.") &&
+	    (!strcmp(sku, "0C62") || !strcmp(sku, "0C63") || !strcmp(sku, "0C6B")) &&
+	    slave->sdca_data.interface_revision == 0x061c &&
+	    slave->id.mfg_id == 0x01fa && slave->id.part_id == 0x4243)
+		return true;
+
+	return false;
+}
+
 bool sdca_device_quirk_match(struct sdw_slave *slave, enum sdca_quirk quirk)
 {
 	switch (quirk) {
 	case SDCA_QUIRKS_RT712_VB:
 		return sdca_device_quirk_rt712_vb(slave);
+	case SDCA_QUIRKS_SKIP_FUNC_TYPE_PATCHING:
+		return sdca_device_quirk_skip_func_type_patching(slave);
 	default:
 		break;
 	}
--- a/sound/soc/sdca/sdca_functions.c
+++ b/sound/soc/sdca/sdca_functions.c
@@ -89,6 +89,7 @@ static int find_sdca_function(struct acp
 {
 	struct fwnode_handle *function_node = acpi_fwnode_handle(adev);
 	struct sdca_device_data *sdca_data = data;
+	struct sdw_slave *slave = container_of(sdca_data, struct sdw_slave, sdca_data);
 	struct device *dev = &adev->dev;
 	struct fwnode_handle *control5; /* used to identify function type */
 	const char *function_name;
@@ -136,11 +137,13 @@ static int find_sdca_function(struct acp
 		return ret;
 	}
 
-	ret = patch_sdca_function_type(sdca_data->interface_revision, &function_type);
-	if (ret < 0) {
-		dev_err(dev, "SDCA version %#x invalid function type %d\n",
-			sdca_data->interface_revision, function_type);
-		return ret;
+	if (!sdca_device_quirk_match(slave, SDCA_QUIRKS_SKIP_FUNC_TYPE_PATCHING)) {
+		ret = patch_sdca_function_type(sdca_data->interface_revision, &function_type);
+		if (ret < 0) {
+			dev_err(dev, "SDCA version %#x invalid function type %d\n",
+				sdca_data->interface_revision, function_type);
+			return ret;
+		}
 	}
 
 	function_name = get_sdca_function_name(function_type);


