Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE9C3B19BA;
	Sat, 17 Oct 2026 17:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259034; cv=none; b=bG/h04Awe2a6z4+7w2inyKfWgdKNsDOct46bn9x/jD1+mNoc+cRppU5cm8vnkQzQHXdilIIQV27Q7RMuFG3LtywK8ZWlmRTvP+m6Q7KGC13oXmYeaVhoqM6vqWSsvwCgpj0e/otvNcmIcxIZ09EXZxhKPVnXctNTMXzYpVSuBmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259034; c=relaxed/simple;
	bh=ghBNgyntiuuQXIkUjm9MAo4wgNhfkESSrmJbToSDMWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AdWKdK/fREyOhjR+ZRM19NkOfA0pjR0lnteHZBFZjdgnG2LWdNIJ7wW4c9fyNpXsAJV1ioU2qq91m0kcL0bpfVmaMhdMgl76UXNC1oZ8ZSClPUrCG9JRks/5bqs5cib5W3cpV0Gy+x1nmKi5CYTuF9mhwDc4byVRJGxFB/y3w54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRWA8MYj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRWA8MYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4921F000C4;
	Sat, 17 Oct 2026 17:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259033;
	bh=F64FnOYcEksUD4iReXqbDc+47W4RmfsnDPoqlz4aBNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kRWA8MYjNzZRw16z4Eir/HYtjdc8ZrVg00sP3mfqssG6X/VsSh8q2Dt8vcIKG6UjY
	 x4GRxHNVpuvWkXbLEic09XdsRogSxalbi0lfHhS5LEJUMuUcIJyIuCby5Vsa2/yoRX
	 6p3BMRv4gCjm5ir/wEsXmfbsTbxZ0/orpMahWOgI=
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
Subject: [PATCH 6.6 1080/1674] drm/i915/mst: limit DP MST ESI service loop
Date: Sat, 17 Oct 2026 17:55:52 +0200
Message-ID: <20261017160458.845393891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c3010c9e31c1a..d1b587f91caf0 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -4149,10 +4149,11 @@ intel_dp_check_mst_status(struct intel_dp *intel_dp)
 {
 	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
 	bool link_ok = true;
+	int tries = 33;
 
 	drm_WARN_ON_ONCE(&i915->drm, intel_dp->active_mst_links < 0);
 
-	for (;;) {
+	while (--tries) {
 		u8 esi[4] = {};
 		u8 ack[4] = {};
 
@@ -4185,6 +4186,11 @@ intel_dp_check_mst_status(struct intel_dp *intel_dp)
 			drm_dp_mst_hpd_irq_send_new_request(&intel_dp->mst_mgr);
 	}
 
+	if (!tries) {
+		drm_dbg_kms(&i915->drm, "DPRX ESI not clearing, device may be stuck\n");
+		link_ok = false;
+	}
+
 	return link_ok;
 }
 
-- 
2.53.0



