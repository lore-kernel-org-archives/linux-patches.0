Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEDD18A6B9;
	Tue, 10 Sep 2024 10:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964158; cv=none; b=rsu0HcdNr6UwXLsBTGg90j0bbjfawKO8oQG3fxuWLQbD1gWuVliMFDF+A1lBUnAIbQRFmUcyrVN83XHXyv8txVbJn07VCj5AuTiMxQvsGHlR83DUzuTuMHmOAYNYM/UWT6VovlEVbrW/G+P95D2NQmHFioMQD04ombq4B90IJtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964158; c=relaxed/simple;
	bh=38P6p5QSr/IVGHipU3lSmKGEn+0SyLpy/+Ex5TCQWqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMwYKYQ9xJOYgf/UFqU2bMDJs8B4PBIXFKNoO68lSZxF+ixSxYNFMzvnC2658t45zTZXoxDPraq/hyZsjyOaQZQ5ymI3LEiSOg39ibHmqp4zRt9XDWqdOLEYUsY+l4GZ6viRy3nX2zdnvxyt8kCEfOuPg/3QdczS9rZIzLNBvZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0agtqKqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0agtqKqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24773C4CEC3;
	Tue, 10 Sep 2024 10:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964158;
	bh=38P6p5QSr/IVGHipU3lSmKGEn+0SyLpy/+Ex5TCQWqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0agtqKqaCFRVoe/4XARogU+86hn6kYD1F+zj8swSBz6k/Pkdb1Tge2xutBSBGQHWM
	 Dqjb+nauVcDz9IeyuxqahRPqavGTb9FFZlAEUbtnLQmhy1dILLno2zjYWGFr/jWrhG
	 ONJ7NXJoFCZnWqJddazBxmYlsj6QKcYhfwNx9VIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.6 060/269] drm/i915: Do not attempt to load the GSC multiple times
Date: Tue, 10 Sep 2024 11:30:47 +0200
Message-ID: <20240910092610.347593550@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

commit 59d3cfdd7f9655a0400ac453bf92199204f8b2a1 upstream.

If the GSC FW fails to load the GSC HW hangs permanently; the only ways
to recover it are FLR or D3cold entry, with the former only being
supported on driver unload and the latter only on DGFX, for which we
don't need to load the GSC. Therefore, if GSC fails to load there is no
need to try again because the HW is stuck in the error state and the
submission to load the FW would just hang the GSCCS.

Note that, due to wa_14015076503, on MTL the GuC escalates all GSCCS
hangs to full GT resets, which would trigger a new attempt to load the
GSC FW in the post-reset HW re-init; this issue is also fixed by not
attempting to load the GSC FW after an error.

Fixes: 15bd4a67e914 ("drm/i915/gsc: GSC firmware loading")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: <stable@vger.kernel.org> # v6.3+
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240820215952.2290807-1-daniele.ceraolospurio@intel.com
(cherry picked from commit 03ded4d432a1fb7bb6c44c5856d14115f6f6c3b9)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_gsc_uc.c |    2 +-
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h  |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/uc/intel_gsc_uc.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_gsc_uc.c
@@ -304,7 +304,7 @@ void intel_gsc_uc_load_start(struct inte
 {
 	struct intel_gt *gt = gsc_uc_to_gt(gsc);
 
-	if (!intel_uc_fw_is_loadable(&gsc->fw))
+	if (!intel_uc_fw_is_loadable(&gsc->fw) || intel_uc_fw_is_in_error(&gsc->fw))
 		return;
 
 	if (intel_gsc_uc_fw_init_done(gsc))
--- a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h
+++ b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h
@@ -258,6 +258,11 @@ static inline bool intel_uc_fw_is_runnin
 	return __intel_uc_fw_status(uc_fw) == INTEL_UC_FIRMWARE_RUNNING;
 }
 
+static inline bool intel_uc_fw_is_in_error(struct intel_uc_fw *uc_fw)
+{
+	return intel_uc_fw_status_to_error(__intel_uc_fw_status(uc_fw)) != 0;
+}
+
 static inline bool intel_uc_fw_is_overridden(const struct intel_uc_fw *uc_fw)
 {
 	return uc_fw->user_overridden;


