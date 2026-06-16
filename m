Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332C62F12AE;
	Tue, 16 Jun 2026 18:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633275; cv=none; b=i8dQ4f/yB5h+B3EF4CzYpNHAZwtwh2KMq2SGUykRtQzLGIo8hWHKKzEjNc5xQEKQfgToM04xUeMftCDlAxbhJgXIVOkLfVYldbdzENmVd+sSaq2bvcYf0HbaeREe+EIxEGMCrF2NQrfFrjQuvdOYwa8yWrtItK31adNg8mbgj9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633275; c=relaxed/simple;
	bh=A6Fxox/NqZIVeSdCJ0b3gYg14DaAEA9yjHU4FktHg6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=En1/PgzR+14v8FG6tKPaAWPnHSE5a+VzJr64qHHqXoi9mfmZClRsVvXgnAKTDSunKk7Evo2ndMS00Roi37yAjBFC05nWd36WXkxkwGg1NMuu1eN0KSlUqY4wiwT2SoY91KU0oINgqw+uEW5DkMtkm/LZYBZc8cwnrX6MZypyv5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lApgwaGm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lApgwaGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33D41F000E9;
	Tue, 16 Jun 2026 18:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633273;
	bh=jMQJRcDpOIvQBVhTRw7+m1fe5snHMffgtENfv/SIJio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lApgwaGmuao6ylXdq3xWxoZZgGS34hqEOe0uKwK77ezeGazM1qofJ7ZTdWPyu1bsq
	 ylBMwiyywMcqrjU/R6v9ggQvG3Egjm2wBv+DX5hQIeEX+wxiOeEuVyVTSqMeRkWBPu
	 +pLfewrecwTlTd79zUB5qnFhjOeGwYQG94mADjto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/411] drm/i915/psr: Add defininitions for INTEL_WA_REGISTER_CAPS DPCD register
Date: Tue, 16 Jun 2026 20:24:44 +0530
Message-ID: <20260616145102.733760144@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit fbceb39b536e40c2f7cc47ab42037bb7c2b7ced9 upstream.

EDP specification says:

"If either VSC SDP is unable to be transmitted 100 ns before the SU region,
the Source device may optionally transmit the VSC SDP during the prior
video scan line’s HBlank period There is a Intel specific drm dp register
currently containing bits related how TCON can support PSR2 with SDP on
prior line."

Unfortunately many panels are having problems in implementing this. So
there is a custom Intel specific DPCD register (INTEL_WA_REGISTER_CAPS) to
figure out if this is properly implemented on a panel or if panel doesn't
require that 100 ns delay before the SU region. Here are the definitions in
this custom DPCD address:

0 = Panel doesn't support SDP on prior line
1 = Panel supports SDP on prior line
2 = Panel doesn't have 100ns requirement
3 = Reserved

Add definitions for this new register and it's values into new header
intel_dpcd.h.

v2: add INTEL_DPCD_ prefix to definitions

Bspec: 74741
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260515095756.2799483-2-jouni.hogander@intel.com
(cherry picked from commit 1da1c9294825f08f622c473480d185680c2a3b75)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dpcd.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 drivers/gpu/drm/i915/display/intel_dpcd.h

diff --git a/drivers/gpu/drm/i915/display/intel_dpcd.h b/drivers/gpu/drm/i915/display/intel_dpcd.h
new file mode 100644
index 00000000000000..4aea5326f2ed48
--- /dev/null
+++ b/drivers/gpu/drm/i915/display/intel_dpcd.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2026 Intel Corporation
+ */
+
+#ifndef __INTEL_DPCD_H__
+#define __INTEL_DPCD_H__
+
+#define INTEL_DPCD_INTEL_WA_REGISTER_CAPS					0x3f0
+# define INTEL_DPCD_INTEL_WA_REGISTER_CAPS_PSR2_EARLYSCANLINE_SDP_SUPPORT_MASK	REG_GENMASK(1, 0)
+# define INTEL_DPCD_INTEL_WA_REGISTER_CAPS_FALL_BACK_TO_PSR1			0
+# define INTEL_DPCD_INTEL_WA_REGISTER_CAPS_PSR2_WITH_EARLY_SCANLINE		1
+# define INTEL_DPCD_INTEL_WA_REGISTER_CAPS_PSR2_WITHOUT_EARLY_SCANLINE		2
+
+#endif /* __INTEL_DPCD_H__ */
-- 
2.53.0



