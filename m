Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2C025A645;
	Tue, 20 May 2025 14:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750838; cv=none; b=aEADYQXsqQrpLColmFdeMtikIfHkf9yD3987M9eQfNWWUE30w/kuuq4Kutn4fHUAFqX3nU2tdIqQve+8l6U58/D0EvkcV7l0TjmK1Pckmbwh6GlyQwHhOqafbH6jEf8da6d78KRj+AeoqNSyBLGjUi1OQZeP4MnAWyhbGo7xdf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750838; c=relaxed/simple;
	bh=I0WkhPhgbWoU9udYPE6tJOksiPFaOW+yZ7XlLWYEbew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPEcGWNT6Q8aNX66aelGdgJsGcFwpC12KR4/xqBskZOtNloU2+u7vAs9sFoIZmnsAmhHZIQr34HznKdrT/zYEtt95dshpb3jERqdPqC5NRFmyfG8OK5YE5zexkGixVOt0fUQ56ZZ53MAX2HnxrCN6yTHnMwQsQe4wq8DempEwFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQy7lsoY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQy7lsoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14EEC4CEE9;
	Tue, 20 May 2025 14:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750838;
	bh=I0WkhPhgbWoU9udYPE6tJOksiPFaOW+yZ7XlLWYEbew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQy7lsoYQacO+On67fGvgHmKsBzVWPHnsDAOgDxuo1ilyUeARuVOT15wJHw6dJmuK
	 ZrxoXUTaaZrHdV65Zq8tIJzBtnAPwIxHaAD3a0oBDNLrPZMxGhOsczpy4gjCVLZUJn
	 nYQfslLQBM81Gk/iEoq1M5WxLLjasMK1NFNJhelk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.14 137/145] accel/ivpu: Dump only first MMU fault from single context
Date: Tue, 20 May 2025 15:51:47 +0200
Message-ID: <20250520125815.907462730@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@intel.com>

commit 0240fa18d247c99a1967f2fed025296a89a1c5f5 upstream.

Stop dumping consecutive faults from an already faulty context immediately,
instead of waiting for the context abort thread handler (IRQ handler bottom
half) to abort currently executing jobs.

Remove 'R' (record events) bit from context descriptor of a faulty
context to prevent future faults generation.

This change speeds up the IRQ handler by eliminating the need to print the
fault content repeatedly. Additionally, it prevents flooding dmesg with
errors, which was occurring due to the delay in the bottom half of the
handler stopping fault-generating jobs.

Signed-off-by: Karol Wachowski <karol.wachowski@intel.com>
Signed-off-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250107173238.381120-7-maciej.falkowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_mmu.c         |   51 ++++++++++++++++++++++++++++++----
 drivers/accel/ivpu/ivpu_mmu_context.c |   13 --------
 drivers/accel/ivpu/ivpu_mmu_context.h |    2 -
 3 files changed, 46 insertions(+), 20 deletions(-)

--- a/drivers/accel/ivpu/ivpu_mmu.c
+++ b/drivers/accel/ivpu/ivpu_mmu.c
@@ -870,23 +870,64 @@ static u32 *ivpu_mmu_get_event(struct iv
 	return evt;
 }
 
+static int ivpu_mmu_disable_events(struct ivpu_device *vdev, u32 ssid)
+{
+	struct ivpu_mmu_info *mmu = vdev->mmu;
+	struct ivpu_mmu_cdtab *cdtab = &mmu->cdtab;
+	u64 *entry;
+	u64 val;
+
+	if (ssid > IVPU_MMU_CDTAB_ENT_COUNT)
+		return -EINVAL;
+
+	entry = cdtab->base + (ssid * IVPU_MMU_CDTAB_ENT_SIZE);
+
+	val = READ_ONCE(entry[0]);
+	val &= ~IVPU_MMU_CD_0_R;
+	WRITE_ONCE(entry[0], val);
+
+	if (!ivpu_is_force_snoop_enabled(vdev))
+		clflush_cache_range(entry, IVPU_MMU_CDTAB_ENT_SIZE);
+
+	ivpu_mmu_cmdq_write_cfgi_all(vdev);
+
+	return 0;
+}
+
 void ivpu_mmu_irq_evtq_handler(struct ivpu_device *vdev)
 {
+	struct ivpu_file_priv *file_priv;
+	u32 last_ssid = -1;
 	u32 *event;
 	u32 ssid;
 
 	ivpu_dbg(vdev, IRQ, "MMU event queue\n");
 
-	while ((event = ivpu_mmu_get_event(vdev)) != NULL) {
-		ivpu_mmu_dump_event(vdev, event);
-
+	while ((event = ivpu_mmu_get_event(vdev))) {
 		ssid = FIELD_GET(IVPU_MMU_EVT_SSID_MASK, event[0]);
+
+		if (ssid == last_ssid)
+			continue;
+
+		xa_lock(&vdev->context_xa);
+		file_priv = xa_load(&vdev->context_xa, ssid);
+		if (file_priv) {
+			if (file_priv->has_mmu_faults) {
+				event = NULL;
+			} else {
+				ivpu_mmu_disable_events(vdev, ssid);
+				file_priv->has_mmu_faults = true;
+			}
+		}
+		xa_unlock(&vdev->context_xa);
+
+		if (event)
+			ivpu_mmu_dump_event(vdev, event);
+
 		if (ssid == IVPU_GLOBAL_CONTEXT_MMU_SSID) {
 			ivpu_pm_trigger_recovery(vdev, "MMU event");
 			return;
 		}
-
-		ivpu_mmu_user_context_mark_invalid(vdev, ssid);
 		REGV_WR32(IVPU_MMU_REG_EVTQ_CONS_SEC, vdev->mmu->evtq.cons);
 	}
 
--- a/drivers/accel/ivpu/ivpu_mmu_context.c
+++ b/drivers/accel/ivpu/ivpu_mmu_context.c
@@ -635,16 +635,3 @@ void ivpu_mmu_reserved_context_fini(stru
 	ivpu_mmu_cd_clear(vdev, vdev->rctx.id);
 	ivpu_mmu_context_fini(vdev, &vdev->rctx);
 }
-
-void ivpu_mmu_user_context_mark_invalid(struct ivpu_device *vdev, u32 ssid)
-{
-	struct ivpu_file_priv *file_priv;
-
-	xa_lock(&vdev->context_xa);
-
-	file_priv = xa_load(&vdev->context_xa, ssid);
-	if (file_priv)
-		file_priv->has_mmu_faults = true;
-
-	xa_unlock(&vdev->context_xa);
-}
--- a/drivers/accel/ivpu/ivpu_mmu_context.h
+++ b/drivers/accel/ivpu/ivpu_mmu_context.h
@@ -37,8 +37,6 @@ void ivpu_mmu_global_context_fini(struct
 int ivpu_mmu_reserved_context_init(struct ivpu_device *vdev);
 void ivpu_mmu_reserved_context_fini(struct ivpu_device *vdev);
 
-void ivpu_mmu_user_context_mark_invalid(struct ivpu_device *vdev, u32 ssid);
-
 int ivpu_mmu_context_insert_node(struct ivpu_mmu_context *ctx, const struct ivpu_addr_range *range,
 				 u64 size, struct drm_mm_node *node);
 void ivpu_mmu_context_remove_node(struct ivpu_mmu_context *ctx, struct drm_mm_node *node);


