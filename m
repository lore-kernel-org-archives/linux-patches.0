Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12642C026C;
	Sat, 17 Oct 2026 16:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254380; cv=none; b=nWU9oQU0Lo8ll736MctvdVq8dNEvzpxR4QbKK+rlX+OdKX/ki8XxkAdmQutWR6Y+KUwUeeQwOTomV5DuNN57Uf6Rh94oY2nKFCcv0A7A4JyXS+uqvpHZMiySxgPb7z22AxP1EkppX5OSv4+dm6m6l8CP40X1rrS3m6e+nZAXQSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254380; c=relaxed/simple;
	bh=YGqVLHReC96/bCGWJWqF+bcMtWbw63tGgI/QnboYv1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CH9vNMbFeAWVvMqE/95B5zQgjGMT03YDYHHzV5xCqoXyrsv4ki6WEYN1aAn4yJZpXIErdjGRi4cHmkSqIllye7pQXYG2YGv75fPAkF09esdf30ayO3Je7YsWrXDBjcRZBB83JK0aXTdA1/IdhVYCvYSBuCY7HK4Vd8wn0GJgHnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQGvyMA4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQGvyMA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DCD1F000C4;
	Sat, 17 Oct 2026 16:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254379;
	bh=hrsHKoPWPQJ2njd4pCXkzS9Blpv/ZHK+TEt+vJVbb/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQGvyMA4c+00MtGzXL/yRMkYy0IJBBXR/z66dc/FEN/OO/NrdAB0CJ6LDJx1E8C0o
	 aqSvXSLGM1xLKyY0I+9JdX+FTQyF0Mt3QY9Kioop3SB6WQU5pp82meNovTmIYpfUY7
	 L6L1fu6c+ZpwTVh5TOzVbKCLCoYk9L+Df0QVGjac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 385/869] drm/i915/mst: limit DP MST ESI service loop
Date: Sat, 17 Oct 2026 17:53:46 +0200
Message-ID: <20261017160046.983557921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 005771c18c5b2c98cb4e7517661aea460990fd3f ]

The loop in intel_dp_check_mst_status() keeps servicing interrupts
originating from the sink without bound. Add an upper bound to the new
interrupts occurring during interrupt processing to not get stuck on
potentially stuck sink devices. Use arbitrary 32 tries to clear incoming
interrupts in one go.

Discovered using AI-assisted static analysis confirmed by Intel Product
Security.

Note: The condition likely pre-dates the commit in the Fixes: tag, but
this is about as far back as a backport has any chance of
succeeding. Before that, the retry had a goto.

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: 3c0ec2c2d594 ("drm/i915: Flatten intel_dp_check_mst_status() a bit")
Cc: stable@vger.kernel.org # v5.8+
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20260625142204.1078287-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit b4ea5272133059acb493cc36599071a9e852ec2e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 63c335d3d9ce8..b1ba117cfce86 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -5202,10 +5202,11 @@ intel_dp_check_mst_status(struct intel_dp *intel_dp)
 	struct intel_encoder *encoder = &dig_port->base;
 	bool link_ok = true;
 	bool reprobe_needed = false;
+	int tries = 33;
 
 	drm_WARN_ON_ONCE(&i915->drm, intel_dp->mst.active_links < 0);
 
-	for (;;) {
+	while (--tries) {
 		u8 esi[4] = {};
 		u8 ack[4] = {};
 
@@ -5248,6 +5249,11 @@ intel_dp_check_mst_status(struct intel_dp *intel_dp)
 	if (!link_ok || intel_dp->link.force_retrain)
 		intel_encoder_link_check_queue_work(encoder, 0);
 
+	if (!tries) {
+		drm_dbg_kms(&i915->drm, "DPRX ESI not clearing, device may be stuck\n");
+		reprobe_needed = true;
+	}
+
 	return !reprobe_needed;
 }
 
-- 
2.53.0



