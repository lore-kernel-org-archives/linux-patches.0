Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31833C3F4C;
	Thu, 30 Jul 2026 15:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423806; cv=none; b=YrzQZ2YYfWrm5P3DUO37N/v4DkS1yosvrAvMuGfIUIBIM702xd7kw96hwHauXHtr7OIgyMBZDo7U2d7SlxU60W5FnI5iQGc3ttB3rxWuKrQqNF+xPt47xz10OZn1TpYd1MN3+N3ZJa7H6o7fXSmeNNrJhBvipsoulGdzifUgSk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423806; c=relaxed/simple;
	bh=UEpYG0f0YU53PIbuMP66JfEY6E4Szy5KvYiGS/10gmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rzpUhEua52FImZcP4mSSOqtvZzWJVbrf27xQsMMqsCSz6iT+2Lkitj2dBv/Qnnf4yzPO1hGKLKcWX/RazQeWxYElddqm55yDpZWVZZ0clHBiA5QxIumkvYAQtn8OGINUutOfRvq0jmU0ZW0kbgrnJIfi9q8MvXRXLxMsM5ysfUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBGhUk0d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBGhUk0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404F71F000E9;
	Thu, 30 Jul 2026 15:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423804;
	bh=cz+CEjhbEWMhA2AvYBrvDXMnf4GEkNOd2bXWALDMeJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBGhUk0deLK2mw0EsqbdkLf1HqIL4GOn8ZsvWbHRF2HVroKjjberboLdqHg0j2si3
	 E3CU2YXM8ZYDSO85iu2IEQN505zukyRvTGmoLqw6M5wBtGbJScVDXKQrsS5bSte8lf
	 k67/TT3kHzkvSuPoUpqfPCV5103Onub/hz/JN2xc=
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
Subject: [PATCH 6.18 128/675] drm/xe/wopcm: fix WOPCM size for LNL+
Date: Thu, 30 Jul 2026 16:07:38 +0200
Message-ID: <20260730141447.865642200@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ada0d0aa6b7494..2fd2a82be89f87 100644
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
 
@@ -181,9 +181,14 @@ static int __wopcm_init_regs(struct xe_device *xe, struct xe_gt *gt,
 
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
 
 /**
-- 
2.53.0



