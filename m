Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D371A6166;
	Tue, 30 Jul 2024 16:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357915; cv=none; b=pDf+eHW3NBNtw3v1aQTxka4rmVrTMuEvXPr1VkaJA+aoQ3dGdVRT647T4F/g2a9iFcz+Zp6YQtgMjZt/G/J/qHWYdeXVjEftDY/tzxSQdFxmvfykLAQl72VRoGc+NmT8io+PyR3FVsuEEsCOaNE9VUEhOt+zZfrjC8NVKUTlYKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357915; c=relaxed/simple;
	bh=mv3yJ6cJOzAYePagrFevc159N2Z9N9GZwUj2Q95Naqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A8yUiVMWR9qlSyyuGKyv6ar7BAEfh6YSFThxgm1tyPa5WadLU7rurNQB+i+qL1MOspl1XEC+fB31YKjggb6M1vKFIOtkn6xwlAo9WSlESfWgsj0kLL7biKtzLt1imoCXKyo7IeYoblgewNfnQpoo1EmXuEAszT23k4kjtgkpMTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCzES58B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCzES58B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31B1C32782;
	Tue, 30 Jul 2024 16:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357915;
	bh=mv3yJ6cJOzAYePagrFevc159N2Z9N9GZwUj2Q95Naqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCzES58BexDMyUGfH9OoIVo+uPvFmzCoJIW3mTzadA6QU/2PL/wYLMz2MQ6ujmjOH
	 qYg6U5RQOM4bMwivuejqdEQVDpkVpQ3F7UN0nQUIXhPhysmGbhzGLlK7cAGl4FUjwL
	 F2yMOcAVJg9jtpePx3E61akK1uMLr+fXXYrMgNhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Animesh Manna <animesh.manna@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 304/809] drm/i915/display: Skip Panel Replay on pipe comparison if no active planes
Date: Tue, 30 Jul 2024 17:43:00 +0200
Message-ID: <20240730151736.599159645@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 955446ed6e822b86751993bd69022d347b43a99e ]

Panel Replay is not enabled if there are no active planes. Do not compare
it on pipe comparison. Otherwise we get pipe mismatch.

Fixes: ac9ef327327b ("drm/i915/psr: Panel replay has to be enabled before link training")
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Animesh Manna <animesh.manna@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240607134917.1327574-5-jouni.hogander@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 0ae18b07ac87d..e53d3e900b3e4 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -5318,7 +5318,9 @@ intel_pipe_config_compare(const struct intel_crtc_state *current_config,
 	 * Panel replay has to be enabled before link training. PSR doesn't have
 	 * this requirement -> check these only if using panel replay
 	 */
-	if (current_config->has_panel_replay || pipe_config->has_panel_replay) {
+	if (current_config->active_planes &&
+	    (current_config->has_panel_replay ||
+	     pipe_config->has_panel_replay)) {
 		PIPE_CONF_CHECK_BOOL(has_psr);
 		PIPE_CONF_CHECK_BOOL(has_sel_update);
 		PIPE_CONF_CHECK_BOOL(enable_psr2_sel_fetch);
-- 
2.43.0



