Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BF6309EF9;
	Mon, 13 Oct 2025 14:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367144; cv=none; b=iOloCydGOsyz2Otj1DJsFxYklOknF8ib2T2KIzQJTrH2NdC5tJkHIzRmRHxr12kmQ3IMnHRUdv3OsdeNtsTQ67Amk/U1UUrApYgLpW/kMhyOwknd8ToDsj/JG1p+U4NfHNMdxQJZXbuSL2V/Njgu8pCFfTvLgvbzNuRdfr8rK1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367144; c=relaxed/simple;
	bh=gqXG975p1Yrkl1hEr5Wzn+OxhsQMMhMPUY/Qh308FN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kozCx1SQvXjUoX+yxQc42ZrZweAXLEhTDppBmCvkz0KyPSPXb9sBPANmH/3BMr5bW7k75v7Z/KRkrSCIweQuBZuINQ5fyijWiRbOc9nQijUcxfLJbNMT0pGs5pfZsRI1JK+n2laqFu7KoI07esh6rAWvQNc03Lv976dkWm0Br8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wbfd1Iqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wbfd1Iqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76E1C4CEE7;
	Mon, 13 Oct 2025 14:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367144;
	bh=gqXG975p1Yrkl1hEr5Wzn+OxhsQMMhMPUY/Qh308FN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wbfd1Iqqx+W4yxdMmCRBZy/dERCj/Kpld3PnUjrQ/a8gGwy8RBuCz7FwhJ/RxnEl3
	 2syDywcwue0V1zzA/EkWX4Q1kzMQ/se7E3plYvJ8LvSDCT3pyV/VBD1uZgGQOR8w/2
	 /A5Oh1fTAaW6nno8YLl+QUpiyG8yvXtcIIK/uH1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/196] drm/amd/pm: Treat zero vblank time as too short in si_dpm (v3)
Date: Mon, 13 Oct 2025 16:44:40 +0200
Message-ID: <20251013144318.570208941@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

[ Upstream commit 9003a0746864f39a0ef72bd45f8e1ad85d930d67 ]

Some parts of the code base expect that MCLK switching is turned
off when the vblank time is set to zero.

According to pp_pm_compute_clocks the non-DC code has issues
with MCLK switching with refresh rates over 120 Hz.

v3:
Add code comment to explain this better.
Add an if statement instead of changing the switch_limit.

Fixes: 841686df9f7d ("drm/amdgpu: add SI DPM support (v4)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index 267aa96edc890..b3c011542daf7 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -3066,7 +3066,13 @@ static bool si_dpm_vblank_too_short(void *handle)
 	/* we never hit the non-gddr5 limit so disable it */
 	u32 switch_limit = adev->gmc.vram_type == AMDGPU_VRAM_TYPE_GDDR5 ? 450 : 0;
 
-	if (vblank_time < switch_limit)
+	/* Consider zero vblank time too short and disable MCLK switching.
+	 * Note that the vblank time is set to maximum when no displays are attached,
+	 * so we'll still enable MCLK switching in that case.
+	 */
+	if (vblank_time == 0)
+		return true;
+	else if (vblank_time < switch_limit)
 		return true;
 	else
 		return false;
-- 
2.51.0



