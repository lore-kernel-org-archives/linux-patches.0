Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF08431488;
	Thu, 30 Jul 2026 14:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421496; cv=none; b=isDxlXT1sPouViIFKzMKSf9Deu7dkk2m7wh3hf87YVy5d3qkxKl1j2WCigGshNdUT1F/cjUFvLBshs4q5g9i4X1/8c1BTzCJNkL1e7VUwlrfbRzDWPKWPfH84MVhLdIkiOQ2YfZHxyGirnNiTPBqyUXfZbHewC+iBcvg9rc21gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421496; c=relaxed/simple;
	bh=L+UaJO/8WTqUEkMWv90+26GgYfs9dsdisC+CNzBgBu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e4I7ZGiyUsdeE0cxvKhY/agtX/pUXwshf1/4Dy2BeSfQhWd4f5DhrMcPGjVqZ0bCBTzj1hFx9Do3XKAyA3xsufGIkB/pNHrpieiPj9I2P3s/CR5rEm1WX4t8zayPw+a5vTkd212dw3kT8YfssxcsbszvuddZrdumsX9o1OVt7Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izjp2mxz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izjp2mxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAFD1F000E9;
	Thu, 30 Jul 2026 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421495;
	bh=hRkc+E0Wb1Xpv/o9xRSiqOdhDJ5iRTZdGJSl7zOKhuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izjp2mxz1L2KhDVLrl0Dpf5Q18xw2BLlCPbJrDSalQNRZD0Xq03ytPC11mhVoIAyH
	 oXYRDwghL78Ppr6CiHSA5QU4J75HxxbQ+TbZrnyuE2mt+Xa8r3VMhdrd/2PNZFOgKW
	 v5lpezhM0MO2IFel1B2Gzr4i7RWuuD1BpLwW6yC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 121/744] drm/xe/wopcm: fix WOPCM size for LNL+
Date: Thu, 30 Jul 2026 16:06:34 +0200
Message-ID: <20260730141446.853715686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit ad87e2476b3b246580f407afc8ffa91d621bc849 ]

Starting on LNL the WOPCM size is 8MB instead of 4, so we need to avoid
using the [0, 8MB) range of the GGTT as that can be unaccessible from
the microcontrollers.

Note that the proper long-term fix here is to read the WOPCM size from
the HW, but that is a more serious rework that would be difficult to
backport, so we can do that as a follow-up.

Fixes: 9c57bc08652a ("drm/xe/lnl: Drop force_probe requirement")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Shuicheng Lin <shuicheng.lin@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://patch.msgid.link/20260713221758.3285744-2-daniele.ceraolospurio@intel.com
(cherry picked from commit 3033b0b24ed0e2f5e56bdd4d9c183417c365a45b)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wopcm.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_wopcm.c b/drivers/gpu/drm/xe/xe_wopcm.c
index 900daf1d1b1bb5..fe65ed246775d9 100644
--- a/drivers/gpu/drm/xe/xe_wopcm.c
+++ b/drivers/gpu/drm/xe/xe_wopcm.c
@@ -49,9 +49,9 @@
  */
 
 /* Default WOPCM size is 2MB from Gen11, 1MB on previous platforms */
-/* FIXME: Larger size require for 2 tile PVC, do a proper probe sooner or later */
+/* FIXME: Larger size require for some platforms, do a proper probe sooner or later */
 #define DGFX_WOPCM_SIZE			SZ_4M
-/* FIXME: Larger size require for MTL, do a proper probe sooner or later */
+#define LNL_WOPCM_SIZE			SZ_8M
 #define MTL_WOPCM_SIZE			SZ_4M
 #define WOPCM_SIZE			SZ_2M
 
@@ -179,9 +179,14 @@ static int __wopcm_init_regs(struct xe_device *xe, struct xe_gt *gt,
 
 u32 xe_wopcm_size(struct xe_device *xe)
 {
-	return IS_DGFX(xe) ? DGFX_WOPCM_SIZE :
-		xe->info.platform == XE_METEORLAKE ? MTL_WOPCM_SIZE :
-		WOPCM_SIZE;
+	if (xe->info.platform >= XE_LUNARLAKE)
+		return LNL_WOPCM_SIZE;
+	else if (IS_DGFX(xe))
+		return DGFX_WOPCM_SIZE;
+	else if (xe->info.platform == XE_METEORLAKE)
+		return MTL_WOPCM_SIZE;
+	else
+		return WOPCM_SIZE;
 }
 
 static u32 max_wopcm_size(struct xe_device *xe)
-- 
2.53.0



