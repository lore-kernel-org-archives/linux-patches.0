Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F50146A94;
	Tue, 23 Apr 2024 21:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908679; cv=none; b=XLRddXtQ/IO2PbwmHYhqKF4IREF5gCtcWMqCThQXbNxF9AVdpa3H3ebZ7SNEZ6M3venqUXajUiG+KZ+cNuR3GGbCqf5r4INDBE4kn05oNe0yYZx4m1AJ7O+Fkfu2Po94wYZDk8+PRr9TSF2AuX4kUajehcHvrPmDZuYRcyBqo80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908679; c=relaxed/simple;
	bh=y9H9xjFq/7vEVrSQtqiXtFaGPltpxauAQ7n6Nqv24U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSVpOPTVDn+aa28gef9wbuewylptVTQsZp8ok9GPuphw1T9hvqntJC4CUchq1zRzfoq78ZGHDdBfVPo6j23AxSTgAYz7LqKQcfUlr0KFzU1cMc9eMsQ8acbzA1dITlIYJMr5jrMB66g9yIkHcjKZleHh4eFNiLRuOMwoUR1h+H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWU1mQrv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWU1mQrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E354C116B1;
	Tue, 23 Apr 2024 21:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908679;
	bh=y9H9xjFq/7vEVrSQtqiXtFaGPltpxauAQ7n6Nqv24U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWU1mQrvdRUeyMqyVRDKAru86onkhj3EIS8sg154lx/1uTCVA3Nvi8jhsB3OgJftw
	 nv9UWmqQaqvhN2IrRTjIUGDQwhZDeAbtWLutW9LK5C55Q07svrMNALZuLTxbV/FgJQ
	 kUCApnYYJ6tSZo3IP+srXrLmaclVRU3lC38sGzv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/141] drm/amd/display: Do not recursively call manual trigger programming
Date: Tue, 23 Apr 2024 14:37:52 -0700
Message-ID: <20240423213853.503693461@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dillon Varone <dillon.varone@amd.com>

[ Upstream commit 953927587f37b731abdeabe46ad44a3b3ec67a52 ]

[WHY&HOW]
We should not be recursively calling the manual trigger programming function when
FAMS is not in use.

Cc: stable@vger.kernel.org
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
index a974f86e718a8..37c645a882dd8 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
@@ -216,9 +216,6 @@ static void optc32_setup_manual_trigger(struct timing_generator *optc)
 				OTG_V_TOTAL_MAX_SEL, 1,
 				OTG_FORCE_LOCK_ON_EVENT, 0,
 				OTG_SET_V_TOTAL_MIN_MASK, (1 << 1)); /* TRIGA */
-
-		// Setup manual flow control for EOF via TRIG_A
-		optc->funcs->setup_manual_trigger(optc);
 	}
 }
 
-- 
2.43.0



