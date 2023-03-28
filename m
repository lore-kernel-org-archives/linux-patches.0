Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2088476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9335FC433D2;
	Tue, 28 Mar 2023 14:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015255;
	bh=qPoy1A96xjfHN3P/ZnDvmOBfKw8qFYSaNRqWTvgKpTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOpxAIo+6bv9K96C/fYQTwhGFc8p3PUbComoSBX6R1AIPxouaAG+Nq5pT0YNv8Mr3
	 MVb4DIAvcIFOdGC0YxaDL3sKccCDjGYjL3DzBcugRCz3ZsFh3RF7c2gvkWlP1ak0VM
	 N+RPb1LubuUgu5N8N2bxlxReehbBydNL1JFZQtp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Shawn C <shawn.c.lee@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.2 222/240] drm/i915: Preserve crtc_state->inherited during state clearing
Date: Tue, 28 Mar 2023 16:43:05 +0200
Message-Id: <20230328142628.970848080@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 3a84f2c6c9558c554a90ec26ad25df92fc5e05b7 upstream.

intel_crtc_prepare_cleared_state() is unintentionally losing
the "inherited" flag. This will happen if intel_initial_commit()
is forced to go through the full modeset calculations for
whatever reason.

Afterwards the first real commit from userspace will not get
forced to the full modeset path, and thus eg. audio state may
not get recomputed properly. So if the monitor was already
enabled during boot audio will not work until userspace itself
does an explicit full modeset.

Cc: stable@vger.kernel.org
Tested-by: Lee Shawn C <shawn.c.lee@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230223152048.20878-1-ville.syrjala@linux.intel.com
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
(cherry picked from commit 2553bacaf953b48c59357f5a622282bc0c45adae)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -5195,6 +5195,7 @@ intel_crtc_prepare_cleared_state(struct
 	 * only fields that are know to not cause problems are preserved. */
 
 	saved_state->uapi = crtc_state->uapi;
+	saved_state->inherited = crtc_state->inherited;
 	saved_state->scaler_state = crtc_state->scaler_state;
 	saved_state->shared_dpll = crtc_state->shared_dpll;
 	saved_state->dpll_hw_state = crtc_state->dpll_hw_state;


