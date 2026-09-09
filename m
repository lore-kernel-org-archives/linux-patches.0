Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89A15678C1;
	Wed,  9 Sep 2026 14:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963726; cv=none; b=csZcLZTaScOJqjsVxwtQZdHDW0bYx8kITHimkpbTP76gdRoajMgF5jlOZyJWs1tnw+d+q1Meik5GT2vjp3ff31MhwrnpF8zn6d0onLIw1LPE3l1nTWLbRdiQrtMBX7uei0rIadJUxZ+jIvniMg7+CwbqLKfY10mteU6r85Oop/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963726; c=relaxed/simple;
	bh=awG+cwhIyCwR2e5QNqJrtE+GN4fKZYhp+QsYG4GZ4xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jh0NIsc/fmMUE37seuoAnYAeUhq/gGPWaFmpIg29tI29l+68hlyPUj4zOR4HKDuQwBD8pqUzRVcJPxRyTD+GrDiaM2Tp29wRh+O+1SOvpKUduEFwsrgOBQZMCToYr184RzLDwIZhjgV+EuV+MFcNYL28tGSW1pn8ibLHHBK7E60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypr3eyK/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypr3eyK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8AC1F00A3A;
	Wed,  9 Sep 2026 14:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963725;
	bh=cSqF3ii7yNPH8YWrM4dMF+aysYtmv3Qu1H+JJxOT0bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypr3eyK/JoJyQtaVVHmsKCcjKEQxUMcJenCtCVPJwkOhk1K0uUa8RYGy9t6js1mm0
	 ya86f19YmGvPq0E1Du8O8RjMFHEpv6qZWgx1qkUSMBdpGEArf0O8ddxzW8Rr/z3wnt
	 Spp4xkXAkYrDmZ7FmGJGJpKBINfwnb8o73Z4uzt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 171/583] ASoC: pm4125-sdw: sort the register default table
Date: Wed,  9 Sep 2026 15:37:36 +0200
Message-ID: <20260909134244.125112352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 8dd18d9956bfd74531bfd7088e59586e3e115789 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

PM4125_SWR_HPHPA_HD2 (0x3090) is listed before
PM4125_ANA_HPHPA_SPARE_CTL (0x308e), which makes the latter unreachable.
regcache_reg_needs_sync() then cannot compare it against its default and
reports that a sync is needed, so it is written to the device on every
regcache_sync() even when it was never touched.

Sort the table by register address.

Fixes: 8ad529484937 ("ASoC: codecs: add new pm4125 audio codec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805113911.21723-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/pm4125-sdw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/pm4125-sdw.c
+++ b/sound/soc/codecs/pm4125-sdw.c
@@ -154,8 +154,8 @@ static const struct reg_default pm4125_d
 	{ PM4125_ANA_HPHPA_FSM_CLK,              0x12 },
 	{ PM4125_ANA_HPHPA_L_GAIN,               0x00 },
 	{ PM4125_ANA_HPHPA_R_GAIN,               0x00 },
-	{ PM4125_SWR_HPHPA_HD2,                  0x1B },
 	{ PM4125_ANA_HPHPA_SPARE_CTL,            0x02 },
+	{ PM4125_SWR_HPHPA_HD2,                  0x1B },
 	{ PM4125_ANA_SURGE_EN,                   0x38 },
 	{ PM4125_ANA_COMBOPA_CTL,                0x35 },
 	{ PM4125_ANA_COMBOPA_CTL_4,              0x84 },


