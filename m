Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2637354781;
	Mon, 17 Aug 2026 14:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976627; cv=none; b=mtopMRjHlc3YumO3zZrVbMsHmBFyxbt5qbyJuMwyqGRoKBxXFeaBJkA4eH5IZriQFIleGdjIBiPH4Ko4OSuxQa6U8GHqIng7ba3sL/5T9RV/wMntG3Ql3iHXCABz041kphfykssFqnDUJuSViJfskbeiuyHcLptqXm63pCcnWmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976627; c=relaxed/simple;
	bh=fpZGg49NYMHT0VMgw0GofePf3aUHJYbGwbaPU2Jsppc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LX3+vY36h4taA/Cwx0RAO5bJQ7+5o+2DvuycryrDuGbO8Zsnw4+McSlIUM/jBsDR1fyMGbx6o8kwILW7FdK9rx2fe8cX14kB4US8P1qG4WOOUr4G4Ng8987druMbStdb/DcSc64GsID7BKrecsrHp1GZxjQqfSOiF+8ocQTjUzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mK0dKlbq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mK0dKlbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E961F000E9;
	Mon, 17 Aug 2026 14:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976625;
	bh=0WkbeagyZYQHvJCW96D6A+CAeV8QwV85B/FBDcUGvwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mK0dKlbqlCLo1eCVjZ0mOme5du20xloK2zZIOorXdDdOUZTM9duRjJQUaX9tynltc
	 25h35XxmlLm8cmU7y8dMUKHTmDcLUcqSoJ625OCmU1auVHZYg64ry9/TbRIJ2Glp8W
	 2Aq5UhFtWUE5qpjZMO1zp5legimecv4F0ajqmsrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/456] drm/i915/gt: use correct selftest config symbol
Date: Mon, 17 Aug 2026 15:27:17 +0200
Message-ID: <20260817132541.877767439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit a82f1bb8191aec98a971a2196136016ef70c0880 ]

intel_engine_user.c checks CONFIG_DRM_I915_SELFTESTS before running
the engine UABI isolation check. Kconfig defines DRM_I915_SELFTEST,
without the trailing "S", and the rest of i915 uses
CONFIG_DRM_I915_SELFTEST.

Because CONFIG_DRM_I915_SELFTESTS is not backed by any Kconfig symbol,
the IS_ENABLED() test is always false. Use the existing selftest symbol
so the debug/selftest guarded path can be reached when selftests are
enabled.

This is a source-level fix. It does not claim dynamic hardware
reproduction; the evidence is the Kconfig definition and the inconsistent
guard in intel_engine_user.c.

Fixes: 750e76b4f9f6 ("drm/i915/gt: Move the [class][inst] lookup for engines onto the GT")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Link: https://lore.kernel.org/r/20260705080225.436-1-pengpeng@iscas.ac.cn
(cherry picked from commit 14a2012a490258f3f93857bc4f1b203405964be7)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_user.c b/drivers/gpu/drm/i915/gt/intel_engine_user.c
index 8f8bea08e734d3..04fced8e9d367f 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_user.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_user.c
@@ -235,7 +235,7 @@ void intel_engines_driver_register(struct drm_i915_private *i915)
 		p = &prev->rb_right;
 	}
 
-	if (IS_ENABLED(CONFIG_DRM_I915_SELFTESTS) &&
+	if (IS_ENABLED(CONFIG_DRM_I915_SELFTEST) &&
 	    IS_ENABLED(CONFIG_DRM_I915_DEBUG_GEM)) {
 		struct intel_engine_cs *engine;
 		unsigned int isolation;
-- 
2.53.0



