Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859332F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D969C433A0;
	Wed, 12 Apr 2023 08:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289192;
	bh=zPD0J1sUNFxWudAzYLfB64mzTrEKEMBfra5zYw+2sbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4mNkFEsOOqKH5oTzWw9uiUJCfekMsoYt0UQ/vxzG852uAyRr1mAAdV7MLTBLH78D
	 lFFWn/pIr8jRnizyg8PMxAMWJI2abVcK0xOH9FeHiY7wknuMFf3r6YUQH3Ht4VTfkJ
	 6iUjZp+Q4q4HWbrqS1Xq8EQ3VMxlGvv07hbK803I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manasi Navare <navaremanasi@google.com>,
	Drew Davenport <ddavenport@chromium.org>,
	Imre Deak <imre.deak@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.1 150/164] drm/i915: Split icl_color_commit_noarm() from skl_color_commit_noarm()
Date: Wed, 12 Apr 2023 10:34:32 +0200
Message-Id: <20230412082843.006173696@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
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

commit 76b767d4d1cd052e455cf18e06929e8b2b70101d upstream.

We're going to want different behavior for skl/glk vs. icl
in .color_commit_noarm(), so split the hook into two. Arguably
we already had slightly different behaviour since
csc_enable/gamma_enable are never set on icl+, so the old
code was perhaps a bit confusing as well.

Cc: <stable@vger.kernel.org> #v5.19+
Cc: Manasi Navare <navaremanasi@google.com>
Cc: Drew Davenport <ddavenport@chromium.org>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230320095438.17328-2-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit f161eb01f50ab31f2084975b43bce54b7b671e17)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_color.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_color.c
+++ b/drivers/gpu/drm/i915/display/intel_color.c
@@ -2098,6 +2098,25 @@ static void glk_read_luts(struct intel_c
 	}
 }
 
+static void icl_color_commit_arm(const struct intel_crtc_state *crtc_state)
+{
+	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
+	struct drm_i915_private *i915 = to_i915(crtc->base.dev);
+	enum pipe pipe = crtc->pipe;
+
+	/*
+	 * We don't (yet) allow userspace to control the pipe background color,
+	 * so force it to black.
+	 */
+	intel_de_write(i915, SKL_BOTTOM_COLOR(pipe), 0);
+
+	intel_de_write(i915, GAMMA_MODE(crtc->pipe),
+		       crtc_state->gamma_mode);
+
+	intel_de_write_fw(i915, PIPE_CSC_MODE(crtc->pipe),
+			  crtc_state->csc_mode);
+}
+
 static struct drm_property_blob *
 icl_read_lut_multi_segment(struct intel_crtc *crtc)
 {
@@ -2183,7 +2202,7 @@ static const struct intel_color_funcs i9
 static const struct intel_color_funcs icl_color_funcs = {
 	.color_check = icl_color_check,
 	.color_commit_noarm = icl_color_commit_noarm,
-	.color_commit_arm = skl_color_commit_arm,
+	.color_commit_arm = icl_color_commit_arm,
 	.load_luts = icl_load_luts,
 	.read_luts = icl_read_luts,
 };


