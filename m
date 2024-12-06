Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB38149C69;
	Fri,  6 Dec 2024 14:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496992; cv=none; b=REPPLSumC303R8V22Q6wHnQXTM8ya4OhD7lURjaOkMcxLnQPJsU5k6udeFYs1PYDtB++Tqu07SyVY2N9+JtnnfoRLcX67kDDEqgqM4ZBzTC3A7pT99e/tNI7/swGlehxBTrPpsk5LME8p08a5XesPkWRD0Xug7He5mv9u5cwP5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496992; c=relaxed/simple;
	bh=o5Psgt+zgbgvBW11pgxQgvGUyH8ISEW5Y9JoZAbiGo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHA89/LtyRTafsj5slZ7akqXozl6LELkhWdXSB0BDfzv60HEKW74jNoz25dohSCfWMmI3FEjNxHu7lQGezGOswRf/n9QcZVbHvA648cusLtlDhVH+5WggW7xh76RlaDHShpaD0TWT/qlZOlpLIUfegEjqccw62hsL5JHe6t3xR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTLQClIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTLQClIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7860BC4CED1;
	Fri,  6 Dec 2024 14:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496991;
	bh=o5Psgt+zgbgvBW11pgxQgvGUyH8ISEW5Y9JoZAbiGo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTLQClIh0kty3o21matI4XEpIb0TwjqItnFBpRcOW0iup9Rh1vTYZ5If8ifHHuEAZ
	 BzTmKipq2SY3/QbpB+OL7KK1250SL5cxG/n0x8n3o7jnKfw6Mm560qcAR3TuP5X7nK
	 kW3epiXgishcsGra42FdaG9zI1eu+EMPQYhhZ0M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/676] drm/vc4: hvs: Dont write gamma luts on 2711
Date: Fri,  6 Dec 2024 15:29:44 +0100
Message-ID: <20241206143659.797967480@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 52efe364d1968ee3e3ed45eb44eb924b63635315 ]

The gamma block has changed in 2711, therefore writing the lut
in vc4_hvs_lut_load is incorrect.

Whilst the gamma property isn't created for 2711, it is called
from vc4_hvs_init_channel, so abort if attempted.

Fixes: c54619b0bfb3 ("drm/vc4: Add support for the BCM2711 HVS5")
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621152055.4180873-15-dave.stevenson@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 04af672caacb1..1ac55c19197cb 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -222,6 +222,9 @@ static void vc4_hvs_lut_load(struct vc4_hvs *hvs,
 	if (!drm_dev_enter(drm, &idx))
 		return;
 
+	if (hvs->vc4->is_vc5)
+		return;
+
 	/* The LUT memory is laid out with each HVS channel in order,
 	 * each of which takes 256 writes for R, 256 for G, then 256
 	 * for B.
-- 
2.43.0



