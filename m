Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECCD1F09B3;
	Fri, 21 Nov 2025 13:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731698; cv=none; b=Xn56VxPO9/ECs4aNqyePXUvlmqZhnWi9wFKRiV4wilu9rY/cIy5Ejma5Oieus1dD2Ofpgg6Qe2nLxIOIA2j0RWj9Rg0vE0lr8g6YvojPwyEKj0kuqwfUw360bi+7R9aNhHlvvLZ2SbdMrgp7s7JOy5VQxvz/t7QtXTa42pTXKZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731698; c=relaxed/simple;
	bh=zfW6Koo3q0nOkSprw4Xpkey024Eq9FdN5HD/z3lKpZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S08T2GBPJdyOGq5YZ8XZh6EJO4cx3Q+6g6lv5Kjj240THfHBFPwB+gUFUQcjap1EaP0z/43IKksvqGXfIG7/T+AZDeUWma3GqmDeARycJqiULWjat8IDsLZp6Ua1FeIF55hBQoUODT1L/R23TFVkWK4wu7gzp8mN+OR3kLRM76o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzMNQegf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzMNQegf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A83C4CEF1;
	Fri, 21 Nov 2025 13:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731698;
	bh=zfW6Koo3q0nOkSprw4Xpkey024Eq9FdN5HD/z3lKpZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fzMNQegfAKoWzS8Gi9zFc4LDno1maugh+QiK/MLuThKzcAWc3D6F8ymx1hnKtgNNS
	 9raCZe4qY7DO53vfIcWxSTfpeSytbHdT+o0dBbA3HMUnKfsMP2OVYDWHPd+OFkZuQn
	 cbnvs8PyqWTHV7wierJF2QuXHd09uoPIyRAVj5E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/185] drm/amd/pm: Disable MCLK switching on SI at high pixel clocks
Date: Fri, 21 Nov 2025 14:10:43 +0100
Message-ID: <20251121130144.462178571@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 82167eca26683..f6ba54cf701e7 100644
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



