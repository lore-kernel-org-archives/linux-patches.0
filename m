Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCDA1DFD90;
	Wed,  6 Nov 2024 12:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896522; cv=none; b=OIi8Df0LF3ABc+NOa+JuR8ZqjiNhcUALOzyMrCdHZC5dxkfjPSk5kmEQA3QExCLQ4FKfgG3xeXqwoXHfI6gt4sk476bU1Y0R0WSVRtJxeXrK1xRO348MijSxqdkaZkI0ZC92KoZY27adQUZkwV0yJS05QlPumq7xAtIAzcktn0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896522; c=relaxed/simple;
	bh=LNuVtLGG5UrrJzMwg9oboIzxnuUlTgBNzHHrqnmz+c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4xU1AFpiAqyIf3f/JKv7pE29yVedf0GvCfAwZ9WRpqkf7KwnhCgv8wVY+qpsHitlhn3OA6zksBfIX8tzLbma9jgsUv8Ijk+IhWNRliWDNC4mlikmOwd1fHDd4rdsdHF6vVV/dpSjVzF3QqR/m+oIO2Ax8EiPRPBL0iFTEC3qZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/lWuJ5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/lWuJ5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96ADC4CED3;
	Wed,  6 Nov 2024 12:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896522;
	bh=LNuVtLGG5UrrJzMwg9oboIzxnuUlTgBNzHHrqnmz+c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/lWuJ5JqKE2FCwKodhpViCvS7iR84oBTzj92VgVn/O7KB4AXO3hMs8V/7DjDaMLa
	 n9FNS1ODf6scXS12QLmP1+ZOqXOtplpzTAeREdXdhNRcPXN3IrrQQBNPoyJO6LDSfP
	 lHL7aYUZQ3lXqnyJtF/Xiehf+mLRUSd1LLs7cFkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 229/245] drm/i915/pps: Disable DPLS_GATING around pps sequence
Date: Wed,  6 Nov 2024 13:04:42 +0100
Message-ID: <20241106120324.898844971@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Kandpal <suraj.kandpal@intel.com>

commit c7085d08c7e53d9aef0cdd4b20798356f6f5d469 upstream.

Disable bit 29 of SCLKGATE_DIS register around pps sequence
when we turn panel power on.

--v2
-Squash two commit together [Jani]
-Use IS_DISPLAY_VER [Jani]
-Fix multiline comment [Jani]

--v3
-Define register in a more appropriate place [Mitul]

--v4
-Register is already defined no need to define it again [Ville]
-Use correct WA number (lineage no.) [Dnyaneshwar]
-Fix the range on which this WA is applied [Dnyaneshwar]

Bspec: 49304
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240813042807.4015214-1-suraj.kandpal@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_pps.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_pps.c
+++ b/drivers/gpu/drm/i915/display/intel_pps.c
@@ -951,6 +951,14 @@ void intel_pps_on_unlocked(struct intel_
 		intel_de_posting_read(dev_priv, pp_ctrl_reg);
 	}
 
+	/*
+	 * WA: 22019252566
+	 * Disable DPLS gating around power sequence.
+	 */
+	if (IS_DISPLAY_VER(dev_priv, 13, 14))
+		intel_de_rmw(dev_priv, SOUTH_DSPCLK_GATE_D,
+			     0, PCH_DPLSUNIT_CLOCK_GATE_DISABLE);
+
 	pp |= PANEL_POWER_ON;
 	if (!IS_IRONLAKE(dev_priv))
 		pp |= PANEL_POWER_RESET;
@@ -961,6 +969,10 @@ void intel_pps_on_unlocked(struct intel_
 	wait_panel_on(intel_dp);
 	intel_dp->pps.last_power_on = jiffies;
 
+	if (IS_DISPLAY_VER(dev_priv, 13, 14))
+		intel_de_rmw(dev_priv, SOUTH_DSPCLK_GATE_D,
+			     PCH_DPLSUNIT_CLOCK_GATE_DISABLE, 0);
+
 	if (IS_IRONLAKE(dev_priv)) {
 		pp |= PANEL_POWER_RESET; /* restore panel reset bit */
 		intel_de_write(dev_priv, pp_ctrl_reg, pp);


