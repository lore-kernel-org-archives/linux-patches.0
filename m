Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3768715CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4C2C433C1;
	Tue,  8 Nov 2022 14:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916389;
	bh=92KJyVK9/5po0Z0AHzGKLIo8xL8/8M6wddmlviBELRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hsZjTCSTIDY3VrQdxiNya5f1+NnUkfSEhswLpY+RTliTj0Ti4Q3QFLQpnaUzCAWM
	 X6lrZ3+tlMOl6E9fp7JeCsSagrWTQBdzHg9maBhoTaVlSPb1f4PYAPXnfhynAo+CUq
	 KG80xXtqXWG98pXrG7Mil9m1NpBbvAPlITpB9CV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.15 142/144] drm/i915/sdvo: Filter out invalid outputs more sensibly
Date: Tue,  8 Nov 2022 14:40:19 +0100
Message-Id: <20221108133351.299187515@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

commit 3e206b6aa6df7eed4297577e0cf8403169b800a2 upstream.

We try to filter out the corresponding xxx1 output
if the xxx0 output is not present. But the way that is
being done is pretty awkward. Make it less so.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221026101134.20865-2-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit cc1e66394daaa7e9f005e2487a84e34a39f9308b)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_sdvo.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -2939,16 +2939,33 @@ err:
 	return false;
 }
 
+static u16 intel_sdvo_filter_output_flags(u16 flags)
+{
+	flags &= SDVO_OUTPUT_MASK;
+
+	/* SDVO requires XXX1 function may not exist unless it has XXX0 function.*/
+	if (!(flags & SDVO_OUTPUT_TMDS0))
+		flags &= ~SDVO_OUTPUT_TMDS1;
+
+	if (!(flags & SDVO_OUTPUT_RGB0))
+		flags &= ~SDVO_OUTPUT_RGB1;
+
+	if (!(flags & SDVO_OUTPUT_LVDS0))
+		flags &= ~SDVO_OUTPUT_LVDS1;
+
+	return flags;
+}
+
 static bool
 intel_sdvo_output_setup(struct intel_sdvo *intel_sdvo, u16 flags)
 {
-	/* SDVO requires XXX1 function may not exist unless it has XXX0 function.*/
+	flags = intel_sdvo_filter_output_flags(flags);
 
 	if (flags & SDVO_OUTPUT_TMDS0)
 		if (!intel_sdvo_dvi_init(intel_sdvo, 0))
 			return false;
 
-	if ((flags & SDVO_TMDS_MASK) == SDVO_TMDS_MASK)
+	if (flags & SDVO_OUTPUT_TMDS1)
 		if (!intel_sdvo_dvi_init(intel_sdvo, 1))
 			return false;
 
@@ -2969,7 +2986,7 @@ intel_sdvo_output_setup(struct intel_sdv
 		if (!intel_sdvo_analog_init(intel_sdvo, 0))
 			return false;
 
-	if ((flags & SDVO_RGB_MASK) == SDVO_RGB_MASK)
+	if (flags & SDVO_OUTPUT_RGB1)
 		if (!intel_sdvo_analog_init(intel_sdvo, 1))
 			return false;
 
@@ -2977,11 +2994,11 @@ intel_sdvo_output_setup(struct intel_sdv
 		if (!intel_sdvo_lvds_init(intel_sdvo, 0))
 			return false;
 
-	if ((flags & SDVO_LVDS_MASK) == SDVO_LVDS_MASK)
+	if (flags & SDVO_OUTPUT_LVDS1)
 		if (!intel_sdvo_lvds_init(intel_sdvo, 1))
 			return false;
 
-	if ((flags & SDVO_OUTPUT_MASK) == 0) {
+	if (flags == 0) {
 		unsigned char bytes[2];
 
 		intel_sdvo->controlled_output = 0;


