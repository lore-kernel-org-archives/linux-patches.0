Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01FC383BA;
	Mon,  1 Apr 2024 16:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987596; cv=none; b=q6cDHrb5Fs7gAcSHKttxz8Z5n0hf0ndM74SN6pWwfnOFL0TZHu2l7AwBJ/s+BA1RoO8P2WZZDbX1R6Bm8OmRbks+UHaOn4ZXqcYuelkerwf9BO4hHQLK2R9pTRNio7uA1TTWfur2P41VKoISYTtTQn1ZTgb/RNSq1e8PuBlvPhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987596; c=relaxed/simple;
	bh=m7bF+TRXNOfApdNrnwgV6iHCD04bvWuRpR96n0q1k4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dJGjhHh8tFI4NDc3EKFtGupEjbOC0EdRzAENj2xXLbig9Ky9pzRTAFO6EhW7ew1cMjTUfvq2soctTptgP0ufti5i/W1X3x4UtJQ3DiKBkQE5SjzZikao2gMWcLXuJiDdujrSBvW2WQ9bVgidvnUlVL6mpYNi8G0v709eMqnfyeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1aaGYE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1aaGYE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F537C433F1;
	Mon,  1 Apr 2024 16:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987596;
	bh=m7bF+TRXNOfApdNrnwgV6iHCD04bvWuRpR96n0q1k4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1aaGYE9sgLgOio+PfV/KbxlwgMtsjV1yJL/2f4n2wtfZk2aE6fXptQQX1E+F2wlk
	 WQOCnl/2wmWNeOzEUC/+LMz3JtUKv+8NbcyLjikvhqDw1cpaXQvGOinOSyzucZTioj
	 muqfiFdDD/4gmFq+cFkxBIIBxdcl5rP2+m8fjq50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Animesh Manna <animesh.manna@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.8 335/399] drm/i915/dsb: Fix DSB vblank waits when using VRR
Date: Mon,  1 Apr 2024 17:45:01 +0200
Message-ID: <20240401152559.176638482@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit f12751168f1a49ebb84b8056cf038973c53b284f upstream.

Looks like the undelayed vblank gets signalled exactly when
the active period ends. That is a problem for DSB+VRR when
we are already in vblank and expect DSB to start executing
as soon as we send the push. Instead of starting, the DSB
just keeps on waiting for the undelayed vblank which won't
signal until the end of the next frame's active period,
which is far too late.

The end result is that DSB won't have even started
executing by the time the flips/etc. have completed.
We then wait for an extra 1ms, after which we terminate
the DSB and report a timeout:
[drm] *ERROR* [CRTC:80:pipe A] DSB 0 timed out waiting for idle (current head=0xfedf4000, head=0x0, tail=0x1080)

To fix this let's configure DSB to use the so called VRR
"safe window" instead of the undelayed vblank to trigger
the DSB vblank logic, when VRR is enabled.

Cc: stable@vger.kernel.org
Fixes: 34d8311f4a1c ("drm/i915/dsb: Re-instate DSB for LUT updates")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/9927
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240306040806.21697-3-ville.syrjala@linux.intel.com
Reviewed-by: Animesh Manna <animesh.manna@intel.com>
(cherry picked from commit 41429d9b68367596eb3d6d5961e6295c284622a7)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dsb.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_dsb.c
+++ b/drivers/gpu/drm/i915/display/intel_dsb.c
@@ -340,6 +340,17 @@ static int intel_dsb_dewake_scanline(con
 	return max(0, vblank_start - intel_usecs_to_scanlines(adjusted_mode, latency));
 }
 
+static u32 dsb_chicken(struct intel_crtc *crtc)
+{
+	if (crtc->mode_flags & I915_MODE_FLAG_VRR)
+		return DSB_CTRL_WAIT_SAFE_WINDOW |
+			DSB_CTRL_NO_WAIT_VBLANK |
+			DSB_INST_WAIT_SAFE_WINDOW |
+			DSB_INST_NO_WAIT_VBLANK;
+	else
+		return 0;
+}
+
 static void _intel_dsb_commit(struct intel_dsb *dsb, u32 ctrl,
 			      int dewake_scanline)
 {
@@ -361,6 +372,9 @@ static void _intel_dsb_commit(struct int
 	intel_de_write_fw(dev_priv, DSB_CTRL(pipe, dsb->id),
 			  ctrl | DSB_ENABLE);
 
+	intel_de_write_fw(dev_priv, DSB_CHICKEN(pipe, dsb->id),
+			  dsb_chicken(crtc));
+
 	intel_de_write_fw(dev_priv, DSB_HEAD(pipe, dsb->id),
 			  intel_dsb_buffer_ggtt_offset(&dsb->dsb_buf));
 


