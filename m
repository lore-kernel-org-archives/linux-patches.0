Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB7C2F0E2A;
	Thu,  3 Jul 2025 15:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555758; cv=none; b=A0NqNMTLKipKaicxl7AHR5blZRCG0ORMFb2nZLM5LwaYfO8BHI5HyEDgTSBqi9H2djkOwVR0Zzwm2jnZsG2CVinPhtMAV/0BY84mFjYLYvHMRjRKOeb/CmXlw5b/U244L2ZVZPb2762RH0W6JSZS0yOiis8YYWF6pG7bcTQ81RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555758; c=relaxed/simple;
	bh=eb/bVKvalizXvFNqlOWD9+KK8Cuf0VIMZdGOFDSW2fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utSlx7TSBk5UMJ5lVB897sfUKvflwObPcXymiboGbEhqZEcaN6OHqBBVBy2aKIStdEqTf+A7Th0nzs3viWf40nK7+DvkGyl9XeKkTmBBIaw6oNma7pYRLDhfJoO1roqjkXM23Ckh3UO4rD5+/yhF76/pMTGvNfObDYmWKJmLuNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O749JW0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O749JW0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D91C4CEE3;
	Thu,  3 Jul 2025 15:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555757;
	bh=eb/bVKvalizXvFNqlOWD9+KK8Cuf0VIMZdGOFDSW2fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O749JW0CGpAykipNq6svzcOd4YiXy0nVtJZZ7zeQbVV5ORDX/CUDB0LI5PyDKYuPr
	 SNOtfvodMxCQX/Sc6gwcBTAdIbQTvMLm03hOE1XoF2pBSmuh4iMZnudS2VkbnP+bzf
	 NJ9fMx+m3H1QMMUB40+qqfw8Z/iXDGl1wSwMSm3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.6 113/139] drm/tegra: Fix a possible null pointer dereference
Date: Thu,  3 Jul 2025 16:42:56 +0200
Message-ID: <20250703143945.595461400@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Qiu-ji Chen <chenqiuji666@gmail.com>

commit 780351a5f61416ed2ba1199cc57e4a076fca644d upstream.

In tegra_crtc_reset(), new memory is allocated with kzalloc(), but
no check is performed. Before calling __drm_atomic_helper_crtc_reset,
state should be checked to prevent possible null pointer dereference.

Fixes: b7e0b04ae450 ("drm/tegra: Convert to using __drm_atomic_helper_crtc_reset() for reset.")
Cc: stable@vger.kernel.org
Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20241106095906.15247-1-chenqiuji666@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tegra/dc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1392,7 +1392,10 @@ static void tegra_crtc_reset(struct drm_
 	if (crtc->state)
 		tegra_crtc_atomic_destroy_state(crtc, crtc->state);
 
-	__drm_atomic_helper_crtc_reset(crtc, &state->base);
+	if (state)
+		__drm_atomic_helper_crtc_reset(crtc, &state->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
 }
 
 static struct drm_crtc_state *


