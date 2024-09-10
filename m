Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1991118C003;
	Tue, 10 Sep 2024 09:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962346; cv=none; b=vAsJH2W8nFu5Ve9z8VGUar9Rl1olkAyw/8zAlvVcAX08+t5eLh2qvCaIJP6c/wZwnYJVFBFz4LUzLS1o0rVGm0y0mnGtyUY60/bfBTzHnRnYMyAtWSZTy+GLqOxTcrvhIIpI7uZkaMCApdyxvMy1YIwpjEMlt1CmoCGFVAukyaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962346; c=relaxed/simple;
	bh=+3uaeVXRA6nKbBS2d8vT+wzacX3Hlku9HR26ToVdoZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I1uV9NiXSHasX3tN5HIRVMZr1rfTlpfDiYOKQIRsI8pWLdYdZ0kblZvMXYTwMlK3Xxkrrzx6fzxcjPkV8ATCRyeJ58CaOdylcejXV4ckiF5XT+qJmHffV/44IekrPlpuPmQij3W3XjamhHlNFb9DNUo02+LGUs4N0vPRmedsXw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WuDdls9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WuDdls9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486A2C4CEC6;
	Tue, 10 Sep 2024 09:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962345;
	bh=+3uaeVXRA6nKbBS2d8vT+wzacX3Hlku9HR26ToVdoZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WuDdls9OBLR4lF5P8lAzbT7RUIfTkwLsfIPK7xlID0SmiX6l+6kwGMsOF6RnnLQMZ
	 aYcjkBl7S8jEhN8Bt3vc+Z6xCJ0Yjx6FqVJd9wYWp2ZD8mHa3pORIEZtH0Ko9Hx+g7
	 4LHXrY/JDoGcV4P93spYYrHMTXJ+fQfrpyP1Rrf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.10 371/375] drm/i915/display: Add mechanism to use sink model when applying quirk
Date: Tue, 10 Sep 2024 11:32:48 +0200
Message-ID: <20240910092635.087218969@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit 43cf50eb1408ccb99cab01521263e8cb4cfdc023 upstream.

Currently there is no way to apply quirk on device only if certain panel
model is installed. This patch implements such mechanism by adding new
quirk type intel_dpcd_quirk which contains also sink_oui and sink_device_id
fields and using also them to figure out if applying quirk is needed.

New intel_init_dpcd_quirks is added and called after drm_dp_read_desc with
proper sink device identity read from dpcdc.

v3:
  - !mem_is_zero fixed to mem_is_zero
v2:
  - instead of using struct intel_quirk add new struct intel_dpcd_quirk

Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240902064241.1020965-2-jouni.hogander@intel.com
(cherry picked from commit b3b91369908ac63be6f64905448b8ba5cd151875)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_types.h |    4 +
 drivers/gpu/drm/i915/display/intel_dp.c            |    4 +
 drivers/gpu/drm/i915/display/intel_quirks.c        |   51 +++++++++++++++++++++
 drivers/gpu/drm/i915/display/intel_quirks.h        |    5 ++
 4 files changed, 64 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1840,6 +1840,10 @@ struct intel_dp {
 	unsigned long last_oui_write;
 
 	bool colorimetry_support;
+
+	struct {
+		unsigned long mask;
+	} quirks;
 };
 
 enum lspcon_vendor {
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -79,6 +79,7 @@
 #include "intel_pch_display.h"
 #include "intel_pps.h"
 #include "intel_psr.h"
+#include "intel_quirks.h"
 #include "intel_tc.h"
 #include "intel_vdsc.h"
 #include "intel_vrr.h"
@@ -3941,6 +3942,7 @@ intel_edp_init_dpcd(struct intel_dp *int
 
 	drm_dp_read_desc(&intel_dp->aux, &intel_dp->desc,
 			 drm_dp_is_branch(intel_dp->dpcd));
+	intel_init_dpcd_quirks(intel_dp, &intel_dp->desc.ident);
 
 	/*
 	 * Read the eDP display control registers.
@@ -4053,6 +4055,8 @@ intel_dp_get_dpcd(struct intel_dp *intel
 		drm_dp_read_desc(&intel_dp->aux, &intel_dp->desc,
 				 drm_dp_is_branch(intel_dp->dpcd));
 
+		intel_init_dpcd_quirks(intel_dp, &intel_dp->desc.ident);
+
 		intel_dp_update_sink_caps(intel_dp);
 	}
 
--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -14,6 +14,11 @@ static void intel_set_quirk(struct intel
 	display->quirks.mask |= BIT(quirk);
 }
 
+static void intel_set_dpcd_quirk(struct intel_dp *intel_dp, enum intel_quirk_id quirk)
+{
+	intel_dp->quirks.mask |= BIT(quirk);
+}
+
 /*
  * Some machines (Lenovo U160) do not work with SSC on LVDS for some reason
  */
@@ -72,6 +77,21 @@ struct intel_quirk {
 	void (*hook)(struct intel_display *display);
 };
 
+struct intel_dpcd_quirk {
+	int device;
+	int subsystem_vendor;
+	int subsystem_device;
+	u8 sink_oui[3];
+	u8 sink_device_id[6];
+	void (*hook)(struct intel_dp *intel_dp);
+};
+
+#define SINK_OUI(first, second, third) { (first), (second), (third) }
+#define SINK_DEVICE_ID(first, second, third, fourth, fifth, sixth) \
+	{ (first), (second), (third), (fourth), (fifth), (sixth) }
+
+#define SINK_DEVICE_ID_ANY	SINK_DEVICE_ID(0, 0, 0, 0, 0, 0)
+
 /* For systems that don't have a meaningful PCI subdevice/subvendor ID */
 struct intel_dmi_quirk {
 	void (*hook)(struct intel_display *display);
@@ -203,6 +223,9 @@ static struct intel_quirk intel_quirks[]
 	{ 0x0f31, 0x103c, 0x220f, quirk_invert_brightness },
 };
 
+static struct intel_dpcd_quirk intel_dpcd_quirks[] = {
+};
+
 void intel_init_quirks(struct intel_display *display)
 {
 	struct pci_dev *d = to_pci_dev(display->drm->dev);
@@ -224,7 +247,35 @@ void intel_init_quirks(struct intel_disp
 	}
 }
 
+void intel_init_dpcd_quirks(struct intel_dp *intel_dp,
+			    const struct drm_dp_dpcd_ident *ident)
+{
+	struct intel_display *display = to_intel_display(intel_dp);
+	struct pci_dev *d = to_pci_dev(display->drm->dev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(intel_dpcd_quirks); i++) {
+		struct intel_dpcd_quirk *q = &intel_dpcd_quirks[i];
+
+		if (d->device == q->device &&
+		    (d->subsystem_vendor == q->subsystem_vendor ||
+		     q->subsystem_vendor == PCI_ANY_ID) &&
+		    (d->subsystem_device == q->subsystem_device ||
+		     q->subsystem_device == PCI_ANY_ID) &&
+		    !memcmp(q->sink_oui, ident->oui, sizeof(ident->oui)) &&
+		    (!memcmp(q->sink_device_id, ident->device_id,
+			    sizeof(ident->device_id)) ||
+		     mem_is_zero(q->sink_device_id, sizeof(q->sink_device_id))))
+			q->hook(intel_dp);
+	}
+}
+
 bool intel_has_quirk(struct intel_display *display, enum intel_quirk_id quirk)
 {
 	return display->quirks.mask & BIT(quirk);
 }
+
+bool intel_has_dpcd_quirk(struct intel_dp *intel_dp, enum intel_quirk_id quirk)
+{
+	return intel_dp->quirks.mask & BIT(quirk);
+}
--- a/drivers/gpu/drm/i915/display/intel_quirks.h
+++ b/drivers/gpu/drm/i915/display/intel_quirks.h
@@ -9,6 +9,8 @@
 #include <linux/types.h>
 
 struct intel_display;
+struct intel_dp;
+struct drm_dp_dpcd_ident;
 
 enum intel_quirk_id {
 	QUIRK_BACKLIGHT_PRESENT,
@@ -20,6 +22,9 @@ enum intel_quirk_id {
 };
 
 void intel_init_quirks(struct intel_display *display);
+void intel_init_dpcd_quirks(struct intel_dp *intel_dp,
+			    const struct drm_dp_dpcd_ident *ident);
 bool intel_has_quirk(struct intel_display *display, enum intel_quirk_id quirk);
+bool intel_has_dpcd_quirk(struct intel_dp *intel_dp, enum intel_quirk_id quirk);
 
 #endif /* __INTEL_QUIRKS_H__ */


