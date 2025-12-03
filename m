Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C0F35029B;
	Wed,  3 Dec 2025 16:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779715; cv=none; b=lybfuupslcPRb4s7dpKcLjinY2MFRz1ebBbCWjad1AYCnO+GTh0eC4reKB6yD5uM2rLLXtppDi9mS417n90TWh/GYlsry472AaTwBBMFpEGt4or2zPmI52ciFuAzyKcEVyszZJ1nk7xcy9ozPZsE9Qd8AwkM9gz5e8FHDDlv5g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779715; c=relaxed/simple;
	bh=1rBGl3g4VZAecrHczVxETIBnw++ZztUtZkImfxOg+hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mlr3/SBpDodFVB53k5W6K9jh4CdXWpoJIbccD2knEUFpUsgeUFjDYzj3uBEnOm218nysWHrvMHVhN7yFJNSFkTbEx4LnmXK7ndFFi7pZe69LSye+W8If+vPjuPol8Vx3sKeeLkt5rfRv+Odmu0krQE+GjyGs+6OEWFEammh0dH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiF2Zeui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiF2Zeui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41688C4CEF5;
	Wed,  3 Dec 2025 16:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779715;
	bh=1rBGl3g4VZAecrHczVxETIBnw++ZztUtZkImfxOg+hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiF2Zeui3wGg0eim/bjEiHi89mldm5l4vz9hbvUZM1xo+4Qm6k3p0xFGZWx6q9ZcI
	 eMBxrgrpPhw6UMNUMl8Ms2g9262eGwJyMwVOV4OfALKXBUFpi2mjZZB4UI89v0rLcO
	 h55l+7XYjoZnzqwKkbyhIWMawwlfjEGFMgWj6f3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 339/568] drm/amd/pm: Disable MCLK switching on SI at high pixel clocks
Date: Wed,  3 Dec 2025 16:25:41 +0100
Message-ID: <20251203152453.124146718@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 5c05bcf6ae7732da1bd4dc1958d527b5f07f216a ]

On various SI GPUs, a flickering can be observed near the bottom
edge of the screen when using a single 4K 60Hz monitor over DP.
Disabling MCLK switching works around this problem.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index 7a85c042a6db9..2395d0a831846 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -3485,6 +3485,11 @@ static void si_apply_state_adjust_rules(struct amdgpu_device *adev,
 	 * for these GPUs to calculate bandwidth requirements.
 	 */
 	if (high_pixelclock_count) {
+		/* Work around flickering lines at the bottom edge
+		 * of the screen when using a single 4K 60Hz monitor.
+		 */
+		disable_mclk_switching = true;
+
 		/* On Oland, we observe some flickering when two 4K 60Hz
 		 * displays are connected, possibly because voltage is too low.
 		 * Raise the voltage by requiring a higher SCLK.
-- 
2.51.0



