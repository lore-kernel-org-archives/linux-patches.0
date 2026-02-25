Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66742F7478;
	Wed, 25 Feb 2026 06:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002776; cv=none; b=pTWemRB9WT/Ai/ElmKDucsPkAi+jz8vcxlLjnT7thl1q3O/a7r47R4KdxsgTt5lzCHvGPRf4SxU+IWMJfENQupMwAdr3u0WXjvhCdNqfJ1/ggNzTBIH9zD6ONJk0dwXs+QVQqtGRWhuh9Nd8wbaeVV5OLnR5kQw6PMGkoC6AX5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002776; c=relaxed/simple;
	bh=2EBoK/etbV4FApRhnchvhAkq6JlJXYpw/M5IO/bhfj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPqOe7sG7PsTPzSkeJ6flhmQGDjAdZIVIUg+pTq92WUmOuVuUXnqLqAOyryc1Y1jQkSVNoReXsokoRmo/Qc8NSvKgBmCuOHqNqpdScXtiDewBF3ECOk5X5Xq+knL3aliosfNwy2wvUN57yGqob8N3SB8T5JLB8wUEYABIJFogwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w0aZ5/F5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w0aZ5/F5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5B4C116D0;
	Wed, 25 Feb 2026 06:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002776;
	bh=2EBoK/etbV4FApRhnchvhAkq6JlJXYpw/M5IO/bhfj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w0aZ5/F548S2dLCtLA18j4BAJS0Y9ZlSt6THp1UQQF8JC4uDjyr51kruHSvQUJ/cY
	 uuWr7R7fb6oDh02p79gfN8AvBBY2oVdI1ppAEfq5clZCkXMaGCWmeVH98rMPzRqMc+
	 lLiIq4U7G/MpL72QWO7dPfjCCu3Mitb8L48P+u/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shekhar Chauhan <shekhar.chauhan@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 597/641] drm/xe/xe2_hpg: Fix handling of Wa_14019988906 & Wa_14019877138
Date: Tue, 24 Feb 2026 17:25:23 -0800
Message-ID: <20260225012402.981252810@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit bc6387a2e0c1562faa56ce2a98cef50cab809e08 ]

The PSS_CHICKEN register has been part of the RCS engine's LRC since it
was first introduced in Xe_LP.  That means that any workarounds that
adjust its value (such as Wa_14019988906 and Wa_14019877138) need to be
implemented in the lrc_was[] table so that they become part of the
default LRC from which all subsequent LRCs are copied.  Although these
workarounds were implemented correctly on most platforms, they were
incorrectly placed on the engine_was[] table for Xe2_HPG.

Move the workarounds to the proper lrc_was[] table and switch the
'xe_rtp_match_first_render_or_compute' rule to specifically match the
RCS since that's the engine whose LRC manages the register.

Bspec: 65182
Fixes: 7f3ee7d88058 ("drm/xe/xe2hpg: Add initial GT workarounds")
Reviewed-by: Shekhar Chauhan <shekhar.chauhan@intel.com>
Link: https://patch.msgid.link/20260205220508.51905-2-matthew.d.roper@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit e04c609eedf4d6748ac0bcada4de1275b034fed6)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wa.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index d209434fd7fc2..2a2e9f2c09163 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -567,16 +567,6 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 		       FUNC(xe_rtp_match_first_render_or_compute)),
 	  XE_RTP_ACTIONS(SET(ROW_CHICKEN, EARLY_EOT_DIS))
 	},
-	{ XE_RTP_NAME("14019988906"),
-	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, 2002),
-		       FUNC(xe_rtp_match_first_render_or_compute)),
-	  XE_RTP_ACTIONS(SET(XEHP_PSS_CHICKEN, FLSH_IGNORES_PSD))
-	},
-	{ XE_RTP_NAME("14019877138"),
-	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, 2002),
-		       FUNC(xe_rtp_match_first_render_or_compute)),
-	  XE_RTP_ACTIONS(SET(XEHP_PSS_CHICKEN, FD_END_COLLECT))
-	},
 	{ XE_RTP_NAME("14020338487"),
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, 2002),
 		       FUNC(xe_rtp_match_first_render_or_compute)),
@@ -873,6 +863,14 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 	  XE_RTP_RULES(GRAPHICS_VERSION(2001), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(WM_CHICKEN3, HIZ_PLANE_COMPRESSION_DIS))
 	},
+	{ XE_RTP_NAME("14019988906"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, 2002), ENGINE_CLASS(RENDER)),
+	  XE_RTP_ACTIONS(SET(XEHP_PSS_CHICKEN, FLSH_IGNORES_PSD))
+	},
+	{ XE_RTP_NAME("14019877138"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, 2002), ENGINE_CLASS(RENDER)),
+	  XE_RTP_ACTIONS(SET(XEHP_PSS_CHICKEN, FD_END_COLLECT))
+	},
 	{ XE_RTP_NAME("14021490052"),
 	  XE_RTP_RULES(GRAPHICS_VERSION(2001), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(FF_MODE,
-- 
2.51.0



