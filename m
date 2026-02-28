Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D434047CC8B;
	Sat, 28 Feb 2026 17:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301368; cv=none; b=WRjBh0Czct1EWsSuEAx1sNX6H3hmmXyN/SagiL8HAmafdBhdrIAsALdACvhrn6Xfcji3aNO5FjPqpGHHDpPaNLeEc7fbnJ+ys+i6nCBlD1KsSG80z6zGLGVlnIDzSQ+ea7/JlgPQk6yba1UtoGBNwD4apa6dW8OgJ0tq3J5BUgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301368; c=relaxed/simple;
	bh=Cm3Acueks74K3t3lu0l9cCWxVbRtb9UfZ0hmO+LeLZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NJ0kYlrcTgHSYEZsTPUJI6sjhiOIrBnU2FKdNbQHi0ttN6ya8skMItipYt6zm8O94VisMOsxBvZoqfQkIYipl/f54uM5mQTs1b0bdK/APIWaCWatVZqhbFjp2vzPHSS3nSMWV8TDz491OY7zQqbNI8ht4OaOdbOiMT6WbCsXqnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ozC8pNhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ozC8pNhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96F3C116D0;
	Sat, 28 Feb 2026 17:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301368;
	bh=Cm3Acueks74K3t3lu0l9cCWxVbRtb9UfZ0hmO+LeLZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozC8pNhZqwageXQGDYz43uJ6Z6Gh+wAXI+UyfLmFojECdPLC5N+5tw8KRyQe0UszV
	 /QAqZvWqzR3NU32khzQ3yG5wpEoTY3d/l5ZAEFXvu8LqPw4siUxxq9jeftpZENMOkB
	 DIifi9bzbS/MKNtd3FTy6oN1ICZzb3D2gz6KzfkHUIGcBCxgms/IpNw/s90wdSM9pZ
	 tx1kmy0idvrb8my8FVIFfHVZLRsTFXjAxCcO2DEqVmbZnBi4aQo2zSe1q9N/LIlpyM
	 gcXlNC1ZQVmPIz9IsMtgQPtHCOFPrPjAP74eghU4WZieoyD87KqvynSRFhYMk4Aaxq
	 zS9rYmYXvevRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	stable@vger.kernel.org,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 557/752] drm/i915/psr: Don't enable Panel Replay on sink if globally disabled
Date: Sat, 28 Feb 2026 12:44:28 -0500
Message-ID: <20260228174750.1542406-557-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 69f83f167463bad26104af7fbc114ce1f80366b0 ]

With some panels informing support for Panel Replay we are observing
problems if having Panel Replay enable bit set on sink when forced to use
PSR instead of Panel Replay. Avoid these problems by not setting Panel
Replay enable bit in sink when Panel Replay is globally disabled during
link training. I.e. disabled by module parameter.

The enable bit is still set when disabling Panel Replay via debugfs
interface. Added note comment about this.

Fixes: 68f3a505b367 ("drm/i915/psr: Enable Panel Replay on sink always when it's supported")
Cc: Mika Kahola <mika.kahola@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: <stable@vger.kernel.org> # v6.15+
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patch.msgid.link/20260115070039.368965-1-jouni.hogander@intel.com
(cherry picked from commit c5a52cd04e24f0ae53fda26f74ab027b8c548e0e)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 6d9c95e5c0255..38d1df919d1ab 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -813,7 +813,12 @@ static void intel_psr_enable_sink(struct intel_dp *intel_dp,
 
 void intel_psr_panel_replay_enable_sink(struct intel_dp *intel_dp)
 {
-	if (CAN_PANEL_REPLAY(intel_dp))
+	/*
+	 * NOTE: We might want to trigger mode set when
+	 * disabling/enabling Panel Replay via debugfs interface to
+	 * ensure this bit is cleared/set accordingly.
+	 */
+	if (CAN_PANEL_REPLAY(intel_dp) && panel_replay_global_enabled(intel_dp))
 		drm_dp_dpcd_writeb(&intel_dp->aux, PANEL_REPLAY_CONFIG,
 				   DP_PANEL_REPLAY_ENABLE);
 }
-- 
2.51.0

