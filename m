Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B742FDC3E;
	Fri, 21 Nov 2025 13:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730878; cv=none; b=kpag6EbqWkEUvkAXrQMwUJnotgjdkfL2vlXcZcZgxS8cSbVmlUWoRtC6/8pbc8f2FJM8Y7C8qUdch9hGrlwvXZY3yFculVU+c1ugsEdQzuGSgowsXieuAvX1GXMwMxIt3TIbPL3LpI5gP270Hv/FJkL2s6dzXav1YgRUSmkss6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730878; c=relaxed/simple;
	bh=Rp8CunzxZkZZZ56gSTMaXX4vV/rzBK+n5pOiDpR4zS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dofu7np6hlh1fvd6M+iAAuZN1ys7Kn7WkVCkQY9sCfO5o0qRSoG7M4dfnMeHdfySt1z4Yd+2aLK1BhSJkkYR79cc0/usiBjAfSLdspov2w3M0E9MtY0RRTpSmJw/X/pjFc0tKthiQiyMyTLdWvm2NyJGtxUXEC8O7V036nUo3kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPLeLhI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPLeLhI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6695AC4CEF1;
	Fri, 21 Nov 2025 13:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730878;
	bh=Rp8CunzxZkZZZ56gSTMaXX4vV/rzBK+n5pOiDpR4zS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPLeLhI0e2tGM3m8h6asX4wOyrrUFgpummQ6n2u7xDHMWS7KWcQywUzaab1Uknszd
	 7RJwG12ZmhjjObyjQ6RnKX8Z/b4A/KNWC6AIsr2VSC5Qd5dW5A88b3H3R5ytk149Am
	 BhbeF5Vdb2ervuo4pZUecxRCWXSnNsicfGJAmXbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 006/247] drm/amd/display: Dont stretch non-native images by default in eDP
Date: Fri, 21 Nov 2025 14:09:13 +0100
Message-ID: <20251121130154.825677407@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 3362692fea915ce56345366364a501c629c9ff17 ]

commit 978fa2f6d0b12 ("drm/amd/display: Use scaling for non-native
resolutions on eDP") started using the GPU scaler hardware to scale
when a non-native resolution was picked on eDP. This scaling was done
to fill the screen instead of maintain aspect ratio.

The idea was supposed to be that if a different scaling behavior is
preferred then the compositor would request it.  The not following
aspect ratio behavior however isn't desirable, so adjust it to follow
aspect ratio and still try to fill screen.

Note: This will lead to black bars in some cases for non-native
resolutions. Compositors can request the previous behavior if desired.

Fixes: 978fa2f6d0b1 ("drm/amd/display: Use scaling for non-native resolutions on eDP")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4538
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 825df7ff4bb1a383ad4827545e09aec60d230770)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index b997718f624f8..f06c918f5a33a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8003,7 +8003,7 @@ static int dm_encoder_helper_atomic_check(struct drm_encoder *encoder,
 				       "mode %dx%d@%dHz is not native, enabling scaling\n",
 				       adjusted_mode->hdisplay, adjusted_mode->vdisplay,
 				       drm_mode_vrefresh(adjusted_mode));
-			dm_new_connector_state->scaling = RMX_FULL;
+			dm_new_connector_state->scaling = RMX_ASPECT;
 		}
 		return 0;
 	}
-- 
2.51.0



