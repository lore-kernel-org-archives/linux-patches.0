Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427FC34AB1E;
	Fri, 21 Nov 2025 13:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730985; cv=none; b=Yc/ttuwaU3NKIeqhJn6HGAenRX0GBcs/edcDrcSeL6wuViC4IkohEi+21oRxEcuCUAy8hfxm5G2oFwB+tLWhAr70mNbX/kwMsbCZ3JrEypHQwlEMB+TiTuC+os1dUfDcsWd8vPbO9eEFmkGt3zSI5iT6ySfs4nYul3KuLnKZ2Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730985; c=relaxed/simple;
	bh=kOqUhFb/5JNxUeHCyfCvUu3BkVKK44WtFkayOsgKNGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t+VIKxsVlcWcert3cS5SDItpogCW/TEb2DTgkIimDMoA3OCeEC4t5SzkrcUxfjqsTsPaRh/LvcegmMj1I1QHb02aasCxSXTLjlb0FNbYaA0PAd97J3b1gNdk6qPv9Asv5+jVVyRLapgWPnFRzpXkkqy6oTEnrXNLsTgc7kxQ2zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADWko4Om; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADWko4Om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4584C4CEF1;
	Fri, 21 Nov 2025 13:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730985;
	bh=kOqUhFb/5JNxUeHCyfCvUu3BkVKK44WtFkayOsgKNGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADWko4OmjiSekXwe1W0mDIkDo8AKRhdop/VKnpd6QMdI+Fuhj8JmJXboUeVXTp/fB
	 LvPk5AMLu96lXFkyyKy3VCMog/a+e2MznoqYspzQPMrDF3qXMqPwhm4Ul0cmQrk83m
	 6nxPovTc7cbhGRTLk0QwGG0QhMWrypOzV//dmU34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 017/247] drm/amd/pm: Disable MCLK switching on SI at high pixel clocks
Date: Fri, 21 Nov 2025 14:09:24 +0100
Message-ID: <20251121130155.219533173@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 70efa4dce3848..a2b411a93b0fe 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -3500,6 +3500,11 @@ static void si_apply_state_adjust_rules(struct amdgpu_device *adev,
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



