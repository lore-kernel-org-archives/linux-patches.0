Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8084014A4E6;
	Tue, 20 Feb 2024 21:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464538; cv=none; b=K6e75QAluBVhkf7ZE+ayl2n0jV+Nu4UDrCIbMUxg6qsqaYqK2ScsYCVQPo0asTNkMGcLegu20zhYkNE+/Ew6y8v1f3p3J6KNzMq5e9OuoipsQYLbAqZnwZnt9AUsEAkm3xOhoY7+NzWGV175QqgxmSABqaTPPLslVCa9+70u5m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464538; c=relaxed/simple;
	bh=fECkOSrEq1NV33X6mY94/fIIBZTeKMMHSiQkNWwkTMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5Pj+iaAJz2Z3aBr2HIBOy2r7a13d4Gp0EEDkhO3violcuKOMnU453j9sE4Hn+zec728tcoqhNdUSuk0emnoWxbnmw7hjr084rd4lsZNTimQiEGj6nRg3CGEcE9GLyeFdjZa7yZvXuPOziKN4tl9b0/wogooTdE1q1Vm0OVGWq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVpH+KGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVpH+KGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA75C433F1;
	Tue, 20 Feb 2024 21:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464538;
	bh=fECkOSrEq1NV33X6mY94/fIIBZTeKMMHSiQkNWwkTMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVpH+KGL1NlLfGqhQA/D9nrivbML9l7tnhRSdDReaxKofQpfDY1Ebjy/4C0Arn0o5
	 5bGy41Aff4q2OhTKRbVRLxL5sgq747VKePY71bsHYK4BHc/dvhagpWWk2ULNNq/6qX
	 phYButLGQu0FFNlpK+dcuo3+1ganZvlVBRqJIENQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Animesh Manna <animesh.manna@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Sean Paul <sean@poorly.run>,
	Drew Davenport <ddavenport@chromium.org>,
	Manasi Navare <navaremanasi@chromium.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 055/309] drm/i915/dsc: Fix the macro that calculates DSCC_/DSCA_ PPS reg address
Date: Tue, 20 Feb 2024 21:53:34 +0100
Message-ID: <20240220205634.941538797@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manasi Navare <navaremanasi@chromium.org>

[ Upstream commit 962ac2dce56bb3aad1f82a4bbe3ada57a020287c ]

Commit bd077259d0a9 ("drm/i915/vdsc: Add function to read any PPS
register") defines a new macro to calculate the DSC PPS register
addresses with PPS number as an input. This macro correctly calculates
the addresses till PPS 11 since the addresses increment by 4. So in that
case the following macro works correctly to give correct register
address:

_MMIO(_DSCA_PPS_0 + (pps) * 4)

However after PPS 11, the register address for PPS 12 increments by 12
because of RC Buffer memory allocation in between. Because of this
discontinuity in the address space, the macro calculates wrong addresses
for PPS 12 - 16 resulting into incorrect DSC PPS parameter value
read/writes causing DSC corruption.

This fixes it by correcting this macro to add the offset of 12 for PPS
>=12.

v3: Add correct paranthesis for pps argument (Jani Nikula)

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/10172
Fixes: bd077259d0a9 ("drm/i915/vdsc: Add function to read any PPS register")
Cc: Suraj Kandpal <suraj.kandpal@intel.com>
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Animesh Manna <animesh.manna@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Sean Paul <sean@poorly.run>
Cc: Drew Davenport <ddavenport@chromium.org>
Signed-off-by: Manasi Navare <navaremanasi@chromium.org>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240205204619.1991673-1-navaremanasi@chromium.org
(cherry picked from commit 6074be620c31dc2ae11af96a1a5ea95580976fb5)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_vdsc_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_vdsc_regs.h b/drivers/gpu/drm/i915/display/intel_vdsc_regs.h
index 64f440fdc22b..8b21dc8e26d5 100644
--- a/drivers/gpu/drm/i915/display/intel_vdsc_regs.h
+++ b/drivers/gpu/drm/i915/display/intel_vdsc_regs.h
@@ -51,8 +51,8 @@
 #define DSCC_PICTURE_PARAMETER_SET_0		_MMIO(0x6BA00)
 #define _DSCA_PPS_0				0x6B200
 #define _DSCC_PPS_0				0x6BA00
-#define DSCA_PPS(pps)				_MMIO(_DSCA_PPS_0 + (pps) * 4)
-#define DSCC_PPS(pps)				_MMIO(_DSCC_PPS_0 + (pps) * 4)
+#define DSCA_PPS(pps)				_MMIO(_DSCA_PPS_0 + ((pps) < 12 ? (pps) : (pps) + 12) * 4)
+#define DSCC_PPS(pps)				_MMIO(_DSCC_PPS_0 + ((pps) < 12 ? (pps) : (pps) + 12) * 4)
 #define _ICL_DSC0_PICTURE_PARAMETER_SET_0_PB	0x78270
 #define _ICL_DSC1_PICTURE_PARAMETER_SET_0_PB	0x78370
 #define _ICL_DSC0_PICTURE_PARAMETER_SET_0_PC	0x78470
-- 
2.43.0



