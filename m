Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC1639FCCD;
	Fri,  9 Oct 2026 14:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556394; cv=none; b=nnFN80FFn9drh0GDOfvmiu04/O6mHfzTHhxGLQ/tjpLS6dmW3JJcHyRyA7Nssnt1zk5c1XGfj2mtDYspCpDnaGelFWElZREdD0diosZe/6AGKUbaYkq4wJnqhUysNVOdmyqRDOd3ba7epMKDS25Zu54kOsjZ5zEDFQS6IKR5C3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556394; c=relaxed/simple;
	bh=PRL5/wLOX78DWgdTE6zNuvyrz/V0aU14LiSdtd9YT5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcepQZf1Y9RjzP397uJ0BAzfd2to2YEYVuG8pYFnUKG63S8wGrxGpIXvG5hjliTXvJiR31kzQ2wt8On19j5qLO5/rJ42QABGvPPpISXIOOw9nDhZ6PEi3IJb8yJNSGFdKhLnkQxVNXxLj1HfCBmMyWrfckH9kO3L7dAjEmjFHNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Le1T3OES; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Le1T3OES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE101F000FF;
	Fri,  9 Oct 2026 14:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556393;
	bh=curMv0jiW6i1ULNWKzJjr6FthjST99UJJO4PfFO8WCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Le1T3OEScDpc/p83CBv6y6fBRLIfm8x1bjGgGUTQVR4vuzwbLF01A4430GnuXCC3K
	 PJiCxaVqTITNxUBdnwXJ2Qx8RuM2P/xJnhxVcl8XSvQYW03Ki3y2ARss26KC8OFYYH
	 q0uyIJkvDszLYiBPdv/3PeEYaQV22TisBWnQAZCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Zhang <george.zhang@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Arthur Heymans <arthur@aheymans.xyz>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 169/428] drm/amd/display: Preserve eDP mode on initial ASSR failure
Date: Fri,  9 Oct 2026 16:08:26 +0200
Message-ID: <20261009140949.866366101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arthur Heymans <arthur@aheymans.xyz>

commit 5e08102d1d336593160d1434261d50b0c0f6cbe6 upstream.

Commit 56d8ce9d8c17 ("drm/amd/display: Apply correct panel mode when
reinitializing hardware") made ASSR failure fall back to the default panel
mode unless eDP mode had previously been applied.

However, dc_link is zero-initialized and DP_PANEL_MODE_DEFAULT is zero.
Before the first call to dp_set_panel_mode(), panel_mode therefore looks
like a previously applied default mode. If ASSR setup fails during the
first link training attempt, the driver incorrectly trains the eDP link
using the default scrambling mode.

On a Google Vilboz Chromebook running self-built coreboot firmware and
PSP verstage, this leaves the panel mostly black with corrupted output
along the top edge.

Track whether panel_mode has actually been initialized, and only consult
the saved mode after it has been applied. This retains the recovery
behavior while preserving eDP mode during initial link training.

Fixes: 56d8ce9d8c17 ("drm/amd/display: Apply correct panel mode when reinitializing hardware")
Assisted-by: Pi:gpt-5.6-sol
Reviewed-by: George Zhang <george.zhang@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Arthur Heymans <arthur@aheymans.xyz>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ccb6c2702033f1002b45807fb3cc938760f26f78)
Cc: stable@vger.kernel.org # 6.4.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h                                    |    1 +
 drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -1763,6 +1763,7 @@ struct dc_scratch_space {
 	struct ddc_service *ddc;
 
 	enum dp_panel_mode panel_mode;
+	bool panel_mode_initialized;
 	bool aux_mode;
 
 	/* Private to DC core */
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
@@ -92,6 +92,7 @@ void dp_set_panel_mode(struct dc_link *l
 	}
 
 	link->panel_mode = panel_mode;
+	link->panel_mode_initialized = true;
 	DC_LOG_DETECTION_DP_CAPS("%d eDP panel mode supported: %d, enabled: %d\n",
 				 link->link_index,
 				 link->dpcd_caps.panel_mode_edp,
@@ -1300,7 +1301,8 @@ void edp_set_panel_assr(struct dc_link *
 
 		result = cp_psp->funcs.enable_assr(cp_psp->handle, link);
 
-		if (!result && link->panel_mode != DP_PANEL_MODE_EDP)
+		if (!result && link->panel_mode_initialized &&
+		    link->panel_mode != DP_PANEL_MODE_EDP)
 			*panel_mode = DP_PANEL_MODE_DEFAULT;
 	}
 }


