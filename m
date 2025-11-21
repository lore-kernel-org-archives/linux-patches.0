Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF94351FDB;
	Fri, 21 Nov 2025 13:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733247; cv=none; b=ZiEOWzLb/R4DUWAHvPQ0tEG0yD2MzsB9fdXWMp/pwUDkSC21cRcvRS3QG0yZLdcxCB/kPlXqUGFu0z4KbfDcJPr31+7+VoLligGFM/oiz1lIxfZ0wg49ABDrnPaZFvGDmaNJq1qzqST1GW/rmrLK2gq9eStqPHlDR1SPYm4s7VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733247; c=relaxed/simple;
	bh=r6GTFkaPzG/m00rGu5V6cKZUrMhyEX4H9BYVy3E38ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dn+5c7OzdXcNMUa3g8StetOWuPiOoe3gr2qQMqvGpWSNAI11hVnAHTTzqLNwLeHz7f8SfSVvzN3dYTEzFToHogTX1NJ2PqbfKoLuz4xHEAHqWWcC4d64dWeJ8B0QEIVOivPIA9GluKb8r6i/RjngBJ6grP8BiaNV+y4UjIg5Src=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3ZPqAm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3ZPqAm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9D3C4CEF1;
	Fri, 21 Nov 2025 13:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733247;
	bh=r6GTFkaPzG/m00rGu5V6cKZUrMhyEX4H9BYVy3E38ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3ZPqAm6IOLCBtnCW05TRWzftKQgJtXsJeAFOoWHtNK11dyhL4paDrKsTbQ8I3Kva
	 XDVZXCfX+Ss8VpEybrTCyFZqmjyuOfoppJQ1xjBQ+UuONMeeC0d3DV7yWndogN/6aO
	 9mROpZlQcHzbd8k3mDTQXMfqRstwlFlKL/tDhHEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 385/529] drm/amd/pm: Disable MCLK switching on SI at high pixel clocks
Date: Fri, 21 Nov 2025 14:11:24 +0100
Message-ID: <20251121130244.723301797@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index 2863dc65ffc6f..e5f68b2b8def3 100644
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



