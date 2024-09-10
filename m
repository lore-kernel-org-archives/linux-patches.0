Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092F718C90B;
	Tue, 10 Sep 2024 09:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961482; cv=none; b=PS8YQzUal8nLeH1FRWv8CdXWHyNUlgOo+aPodGLi0b7RKBFKDRAlA99JglYgWaBo4dL6m1FUR1AQes7V1vhIG9XHuOaAx/fwaZuGeG4nj8pp3BwpOyoNDnAbkbZc2hm4evjGdyjzdzEu/oWMnOE9t8csgv86DIfueHIAFD8FG08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961482; c=relaxed/simple;
	bh=COrtyaolfIEWo+/xsutKYO4oL8Qc8tO4F00soq1H4Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdeT4Mguot51x/Fy65kmPUn47RuN7/quo2ED3OA7Bl1raEaycfIeKVOGIpSq+DnkSup5Mh5uUwCk1W+ExmWZWm8M6YM6/EOBi5wO6qo1sdPpoi8G5ynIGSaqCsVH/5m34wPXl9WrYnomgkNTs5s3zVerUXcRlGdtINM2mWuxxzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFtFKhV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFtFKhV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BE4C4CEC3;
	Tue, 10 Sep 2024 09:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961481;
	bh=COrtyaolfIEWo+/xsutKYO4oL8Qc8tO4F00soq1H4Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFtFKhV9wQ7RM6CSzfOuOG5MIRRiVpKipNWNl4bR22ZqH5H7JBZtqqpByR7OG4wAv
	 8OphFwj9OzcB1+q8ZsL3senGSjoa2xXoOoBfjmktwJaDQgwbwJnxb39uVaqLJm+h9/
	 w5PTHsRhnWzc8d3K5cM/xJLv5XJI/HbWsUVfR8JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.10 085/375] drm/xe/gsc: Do not attempt to load the GSC multiple times
Date: Tue, 10 Sep 2024 11:28:02 +0200
Message-ID: <20240910092625.090546879@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

commit 529bf8d1118bbaa1aa835563a22b0b5c64ca9d68 upstream.

The GSC HW is only reset by driver FLR or D3cold entry. We don't support
the former at runtime, while the latter is only supported on DGFX, for
which we don't support GSC. Therefore, if GSC failed to load previously
there is no need to try again because the HW is stuck in the error state.

An assert has been added so that if we ever add DGFX support we'll know
we need to handle the D3 case.

v2: use "< 0" instead of "!= 0" in the FW state error check (Julia).

Fixes: dd0e89e5edc2 ("drm/xe/gsc: GSC FW load")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Julia Filipchuk <julia.filipchuk@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240828215158.2743994-2-daniele.ceraolospurio@intel.com
(cherry picked from commit 2160f6f6e3cf6893a83357c3b82ff8589bdc0f08)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_gsc.c   |   12 ++++++++++++
 drivers/gpu/drm/xe/xe_uc_fw.h |    9 +++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_gsc.c
+++ b/drivers/gpu/drm/xe/xe_gsc.c
@@ -511,10 +511,22 @@ out_bo:
 void xe_gsc_load_start(struct xe_gsc *gsc)
 {
 	struct xe_gt *gt = gsc_to_gt(gsc);
+	struct xe_device *xe = gt_to_xe(gt);
 
 	if (!xe_uc_fw_is_loadable(&gsc->fw) || !gsc->q)
 		return;
 
+	/*
+	 * The GSC HW is only reset by driver FLR or D3cold entry. We don't
+	 * support the former at runtime, while the latter is only supported on
+	 * DGFX, for which we don't support GSC. Therefore, if GSC failed to
+	 * load previously there is no need to try again because the HW is
+	 * stuck in the error state.
+	 */
+	xe_assert(xe, !IS_DGFX(xe));
+	if (xe_uc_fw_is_in_error_state(&gsc->fw))
+		return;
+
 	/* GSC FW survives GT reset and D3Hot */
 	if (gsc_fw_is_loaded(gt)) {
 		xe_uc_fw_change_status(&gsc->fw, XE_UC_FIRMWARE_TRANSFERRED);
--- a/drivers/gpu/drm/xe/xe_uc_fw.h
+++ b/drivers/gpu/drm/xe/xe_uc_fw.h
@@ -65,7 +65,7 @@ const char *xe_uc_fw_status_repr(enum xe
 	return "<invalid>";
 }
 
-static inline int xe_uc_fw_status_to_error(enum xe_uc_fw_status status)
+static inline int xe_uc_fw_status_to_error(const enum xe_uc_fw_status status)
 {
 	switch (status) {
 	case XE_UC_FIRMWARE_NOT_SUPPORTED:
@@ -108,7 +108,7 @@ static inline const char *xe_uc_fw_type_
 }
 
 static inline enum xe_uc_fw_status
-__xe_uc_fw_status(struct xe_uc_fw *uc_fw)
+__xe_uc_fw_status(const struct xe_uc_fw *uc_fw)
 {
 	/* shouldn't call this before checking hw/blob availability */
 	XE_WARN_ON(uc_fw->status == XE_UC_FIRMWARE_UNINITIALIZED);
@@ -156,6 +156,11 @@ static inline bool xe_uc_fw_is_overridde
 	return uc_fw->user_overridden;
 }
 
+static inline bool xe_uc_fw_is_in_error_state(const struct xe_uc_fw *uc_fw)
+{
+	return xe_uc_fw_status_to_error(__xe_uc_fw_status(uc_fw)) < 0;
+}
+
 static inline void xe_uc_fw_sanitize(struct xe_uc_fw *uc_fw)
 {
 	if (xe_uc_fw_is_loaded(uc_fw))


